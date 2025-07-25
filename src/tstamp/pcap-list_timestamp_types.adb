--  SPDX-License-Identifier: BSD-3-Clause
-----------------------------------------------------------------------------
--  Copyright (c) 2024-2025 John Serock
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
separate (Pcap) procedure List_Timestamp_Types (Capture         : in out Packet_Capture_Type;
                                                Timestamp_Types :    out Timestamp_Types_Type) is
   C_Return_Value : Interfaces.C.int;
   C_Tstamp_Types : System.Address;
   use type Interfaces.C.int;
begin
   C_Return_Value := pcap_list_tstamp_types (p            => Capture.Handle,
                                             tstamp_types => C_Tstamp_Types);
   Capture.Status := (if C_Return_Value < 0 then Status_Type (C_Return_Value) else PCAP_SUCCESS_WITHOUT_WARNINGS);
   if Capture.Has_Error_Status then
         raise Pcap.Exceptions.Pcap_Error with (if Capture.Status = PCAP_ERROR then Capture.Get_Error_Text else Capture.Status_To_String);
   end if;
   declare
      Number_Of_Timestamp_Types : constant Integer := Integer (C_Return_Value);
      C_Timestamp_Types         : array (Integer range 0 .. Number_Of_Timestamp_Types - 1) of Interfaces.C.int with Address => C_Tstamp_Types;
      Timestamp_Types_Copy      : Timestamp_Types_Type (0 .. Number_Of_Timestamp_Types - 1);
   begin
      for I in 0 .. Number_Of_Timestamp_Types - 1 loop
         Timestamp_Types_Copy (I) := Timestamp_Type_Type (C_Timestamp_Types (I));
      end loop;
      Timestamp_Types := Timestamp_Types_Copy;
      if Number_Of_Timestamp_Types > 0 then
         pcap_free_tstamp_types (tstamp_types => C_Tstamp_Types);
      end if;
   end;
end List_Timestamp_Types;
