--  SPDX-License-Identifier: BSD-3-Clause
-----------------------------------------------------------------------------
--  Copyright (c) 2024 John Serock
--
--  Redistribution and use in source and binary forms, with or without
--  modification, are permitted provided that the following conditions are
--  met:
--
--  1. Redistributions of source code must retain the above copyright notice,
--     this list of conditions and the following disclaimer.
--
--  2. Redistributions in binary form must reproduce the above copyright
--     notice, this list of conditions and the following disclaimer in the
--     documentation and/or other materials provided with the distribution.
--
--  3. Neither the name of the copyright holder nor the names of its
--     contributors may be used to endorse or promote products derived from
--     this software without specific prior written permission.
--
--  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
--  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
--  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
--  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
--  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
--  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
--  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
--  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
--  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
--  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-----------------------------------------------------------------------------
with Interfaces.C;
with Interfaces.C.Strings;

use Interfaces.C;
use Interfaces.C.Strings;

package body Pcap.Dlt is

   function Description (Dlt : Dlt_Type) return String is
      Description : Interfaces.C.Strings.chars_ptr;
   begin
      Description := pcap_datalink_val_to_description (dlt => Interfaces.C.int (Dlt));
      if Description = Interfaces.C.Strings.Null_Ptr then
         raise Constraint_Error with "invalid datalink";
      end if;
      return Interfaces.C.Strings.Value (Item => Description);
   end Description;

   function Dlt (Name : String) return Dlt_Type is
      C_Name  : aliased Interfaces.C.char_array := Interfaces.C.To_C (Item => Name);
      C_Value : Interfaces.C.int;
   begin
      C_Value := pcap_datalink_name_to_val (Interfaces.C.Strings.To_Chars_Ptr (Item => C_Name'Unchecked_Access));
      if C_Value = -1 then
         raise Constraint_Error with "invalid datalink name";
      end if;
      return Dlt_Type (C_Value);
   end Dlt;

   function Name (Dlt : Dlt_Type) return String is
      Name : Interfaces.C.Strings.chars_ptr;
   begin
      Name := pcap_datalink_val_to_name (dlt => Interfaces.C.int (Dlt));
      if Name = Interfaces.C.Strings.Null_Ptr then
         raise Constraint_Error with "invalid datalink";
      end if;
      return Interfaces.C.Strings.Value (Item => Name);
   end Name;

end Pcap.Dlt;
