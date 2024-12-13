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
with Pcap.Exceptions;

use Interfaces.C;

package body Pcap.Lib.Live is

   function Activate (Self : Live_Packet_Capture_Type) return Status_Type is
      Return_Value : Interfaces.C.int;
   begin
      Return_Value := pcap_activate (p => Self.Handle);
      return Status_Type (Return_Value);
   end Activate;

   procedure Create (Self         : in out Live_Packet_Capture_Type;
                     Source       :        String;
                     Error_Buffer :    out Pcap.Error_Buffer.Bounded_String) is
      C_Source : aliased Interfaces.C.char_array := Interfaces.C.To_C (Item => Source);
      Errbuf   : aliased Interfaces.C.char_array := (0 .. PCAP_ERRBUF_SIZE => Interfaces.C.nul);
   begin
      Error_Buffer := Pcap.Error_Buffer.Null_Bounded_String;
      if Self.Handle = null then
         Self.Handle := pcap_create (source => Interfaces.C.Strings.To_Chars_Ptr (Item => C_Source'Unchecked_Access),
                                     errbuf => Interfaces.C.Strings.To_Chars_Ptr (Item => Errbuf'Unchecked_Access));
         if Errbuf (0) /= Interfaces.C.nul then
            Error_Buffer := Pcap.Error_Buffer.To_Bounded_String (Source => Interfaces.C.To_Ada (Item => Errbuf));
         end if;
         if Self.Handle = null then
            raise Pcap.Exceptions.Pcap_Error with Interfaces.C.To_Ada (Item => Errbuf);
         end if;
      end if;
   end Create;

   procedure Open (Self             : in out Live_Packet_Capture_Type;
                   Device           :        String;
                   Snapshot_Length  :        Snapshot_Length_Type := 65535;
                   Promiscuous_Mode :        Boolean              := False;
                   Read_Timeout     :        Timeout_Milliseconds_Type;
                   Error_Buffer     :    out Pcap.Error_Buffer.Bounded_String) is
      C_Device : aliased Interfaces.C.char_array := Interfaces.C.To_C (Item => Device);
      Errbuf   : aliased Interfaces.C.char_array := (0 .. PCAP_ERRBUF_SIZE => Interfaces.C.nul);
   begin
      Error_Buffer := Pcap.Error_Buffer.Null_Bounded_String;
      if Self.Handle = null then
         Self.Handle := pcap_open_live (device  => Interfaces.C.Strings.To_Chars_Ptr (Item => C_Device'Unchecked_Access),
                                        snaplen => Interfaces.C.int (Snapshot_Length),
                                        promisc => Interfaces.C.int (Boolean'Pos (Promiscuous_Mode)),
                                        to_ms   => Interfaces.C.int (Read_Timeout),
                                        errbuf  => Interfaces.C.Strings.To_Chars_Ptr (Item => Errbuf'Unchecked_Access));
         if Errbuf (0) /= Interfaces.C.nul then
            Error_Buffer := Pcap.Error_Buffer.To_Bounded_String (Source => Interfaces.C.To_Ada (Item => Errbuf));
         end if;
         if Self.Handle = null then
            raise Pcap.Exceptions.Pcap_Error with Interfaces.C.To_Ada (Item => Errbuf);
         end if;
      end if;
   end Open;

   function Set_Buffer_Size (Self        : Live_Packet_Capture_Type;
                             Buffer_Size : Buffer_Size_Type) return Status_Type is
      Return_Value : Interfaces.C.int;
   begin
      Return_Value := pcap_set_buffer_size (p           => Self.Handle,
                                            buffer_size => Interfaces.C.int (Buffer_Size));
      return Status_Type (Return_Value);
   end Set_Buffer_Size;

   function Set_Immediate_Mode (Self           : Live_Packet_Capture_Type;
                                Immediate_Mode : Boolean := True) return Status_Type is
      Return_Value : Interfaces.C.int;
   begin
      Return_Value := pcap_set_immediate_mode (p              => Self.Handle,
                                               immediate_mode => Boolean'Pos (Immediate_Mode));
      return Status_Type (Return_Value);
   end Set_Immediate_Mode;

   function Set_Monitor_Mode (Self         : Live_Packet_Capture_Type;
                              Monitor_Mode : Boolean := True) return Status_Type is
      Return_Value : Interfaces.C.int;
   begin
      Return_Value := pcap_set_rfmon (p     => Self.Handle,
                                      rfmon => Boolean'Pos (Monitor_Mode));
      return Status_Type (Return_Value);
   end Set_Monitor_Mode;

   function Set_Promiscuous_Mode (Self             : Live_Packet_Capture_Type;
                                  Promiscuous_Mode : Boolean := True) return Status_Type is
      Return_Value : Interfaces.C.int;
   begin
      Return_Value := pcap_set_promisc (p       => Self.Handle,
                                        promisc => Boolean'Pos (Promiscuous_Mode));
      return Status_Type (Return_Value);
   end Set_Promiscuous_Mode;

   function Set_Snapshot_Length (Self            : Live_Packet_Capture_Type;
                                 Snapshot_Length : Snapshot_Length_Type := 65535) return Status_Type is
      Return_Value : Interfaces.C.int;
   begin
      Return_Value := pcap_set_snaplen (p       => Self.Handle,
                                        snaplen => Interfaces.C.int (Snapshot_Length));
      return Status_Type (Return_Value);
   end Set_Snapshot_Length;

   function Set_Timeout (Self    : Live_Packet_Capture_Type;
                         Timeout : Timeout_Milliseconds_Type) return Status_Type is
      Return_Value : Interfaces.C.int;
   begin
      Return_Value := pcap_set_timeout (p     => Self.Handle,
                                        to_ms => Interfaces.C.int (Timeout));
      return Status_Type (Return_Value);
   end Set_Timeout;

   function Set_Timestamp_Precision (Self                : Live_Packet_Capture_Type;
                                     Timestamp_Precision : Timestamp_Precision_Type) return Status_Type is
      Return_Value : Interfaces.C.int;
   begin
      Return_Value := pcap_set_tstamp_precision (p                => Self.Handle,
                                                 tstamp_precision => Timestamp_Precision_Type'Pos (Timestamp_Precision));
      return Status_Type (Return_Value);
   end Set_Timestamp_Precision;

end Pcap.Lib.Live;
