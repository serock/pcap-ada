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
package body Pcap.Lib is

   function Status_To_String (Status : Status_Type) return String is
      Str : Interfaces.C.Strings.chars_ptr;
   begin
      Str := pcap_statustostr (error => Interfaces.C.int (Status));
      return Interfaces.C.Strings.Value (Item => Str);
   end Status_To_String;

   function Strerror (Error : Integer) return String is
      Str : Interfaces.C.Strings.chars_ptr;
   begin
      Str := pcap_strerror (error => Interfaces.C.int (Error));
      return Interfaces.C.Strings.Value (Item => Str);
   end Strerror;

   procedure Close (Self : in out Abstract_Packet_Capture_Type) is
   begin
      if Self.Handle /= null then
         pcap_close (p => Self.Handle);
         Self.Handle := null;
      end if;
   end Close;

   overriding procedure Finalize (Self : in out Abstract_Packet_Capture_Type) is
   begin
      Self.Close;
   end Finalize;

   function Geterr (Self : Abstract_Packet_Capture_Type) return String is
      Str : Interfaces.C.Strings.chars_ptr;
   begin
      Str := pcap_geterr (p => Self.Handle);
      return Interfaces.C.Strings.Value (Item => Str);
   end Geterr;

   procedure Perror (Self   : Abstract_Packet_Capture_Type;
                     Prefix : String) is
      C_Prefix : aliased Interfaces.C.char_array := Interfaces.C.To_C (Item => Prefix);
   begin
      pcap_perror (p      => Self.Handle,
                   prefix => Interfaces.C.Strings.To_Chars_Ptr (Item => C_Prefix'Unchecked_Access));
   end Perror;

   procedure Open_Dead (Self            : in out Packet_Capture_Type;
                        Datalink        :        Pcap.Dlt.Dlt_Type;
                        Snapshot_Length :        Snapshot_Length_Type     := 65535;
                        Precision       :        Timestamp_Precision_Type := Micro) is
   begin
      if Self.Handle = null then
         Self.Handle := pcap_open_dead_with_tstamp_precision (linktype  => Interfaces.C.int (Datalink),
                                                              snaplen   => Interfaces.C.int (Snapshot_Length),
                                                              precision => Interfaces.C.unsigned (Timestamp_Precision_Type'Pos (Precision)));
      end if;
   end Open_Dead;

end Pcap.Lib;
