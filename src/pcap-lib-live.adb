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
with Interfaces.C;
with Pcap.Exceptions;

package body Pcap.Lib.Live is

   procedure Activate (Self : in out Live_Packet_Capture_Type) is
      C_Return_Value : Interfaces.C.int;
   begin
      C_Return_Value := pcap_activate (p => Self.Handle);
      Self.Status := Status_Type (C_Return_Value);
      if Self.Has_Error_Status then
         raise Pcap.Exceptions.Pcap_Error with (if Self.Status = PCAP_ERROR then Self.Get_Error_Text else Self.Status_To_String);
      end if;
      Self.Activated := True;
   end Activate;

   procedure Create (Self         : in out Live_Packet_Capture_Type;
                     Source       :        String) is
      C_Error_Buffer : aliased Interfaces.C.char_array := (0 .. PCAP_ERRBUF_SIZE => Interfaces.C.nul);
      C_Source       : aliased Interfaces.C.char_array := Interfaces.C.To_C (Item => Source);
   begin
      if Self.Handle = null then
         Self.Handle := pcap_create (source => Interfaces.C.Strings.To_Chars_Ptr (Item => C_Source'Unchecked_Access),
                                     errbuf => Interfaces.C.Strings.To_Chars_Ptr (Item => C_Error_Buffer'Unchecked_Access));
         if Self.Handle = null then
            raise Pcap.Exceptions.Pcap_Error with Interfaces.C.To_Ada (Item => C_Error_Buffer);
         end if;
      end if;
   end Create;

   procedure Open (Self             : in out Live_Packet_Capture_Type;
                   Device           :        String;
                   Snapshot_Length  :        Snapshot_Length_Type := 65535;
                   Promiscuous_Mode :        Boolean              := False;
                   Read_Timeout     :        Timeout_Milliseconds_Type;
                   Error_Buffer     :    out Pcap.Error_Buffer.Bounded_String) is
      C_Device       : aliased Interfaces.C.char_array := Interfaces.C.To_C (Item => Device);
      C_Error_Buffer : aliased Interfaces.C.char_array := (0 .. PCAP_ERRBUF_SIZE => Interfaces.C.nul);
      use type Interfaces.C.char;
   begin
      Error_Buffer := Pcap.Error_Buffer.Null_Bounded_String;
      if Self.Handle = null then
         Self.Handle := pcap_open_live (device  => Interfaces.C.Strings.To_Chars_Ptr (Item => C_Device'Unchecked_Access),
                                        snaplen => Interfaces.C.int (Snapshot_Length),
                                        promisc => Interfaces.C.int (Boolean'Pos (Promiscuous_Mode)),
                                        to_ms   => Interfaces.C.int (Read_Timeout),
                                        errbuf  => Interfaces.C.Strings.To_Chars_Ptr (Item => C_Error_Buffer'Unchecked_Access));
         if C_Error_Buffer (0) /= Interfaces.C.nul then
            Error_Buffer := Pcap.Error_Buffer.To_Bounded_String (Source => Interfaces.C.To_Ada (Item => C_Error_Buffer));
         end if;
         if Self.Handle = null then
            raise Pcap.Exceptions.Pcap_Error with Interfaces.C.To_Ada (Item => C_Error_Buffer);
         end if;
         Self.Activated := True;
      end if;
   end Open;

   function Can_Set_Monitor_Mode (Self : in out Live_Packet_Capture_Type) return Boolean is
      C_Return_Value : Interfaces.C.int;
      use type Interfaces.C.int;
   begin
      C_Return_Value := pcap_can_set_rfmon (p => Self.Handle);
      Self.Status := (if C_Return_Value < 0 then Status_Type (C_Return_Value) else PCAP_SUCCESS_WITHOUT_WARNINGS);
      if Self.Has_Error_Status then
         raise Pcap.Exceptions.Pcap_Error with (if Self.Status = PCAP_ERROR then Self.Get_Error_Text else Self.Status_To_String);
      end if;
      return C_Return_Value = 1;
   end Can_Set_Monitor_Mode;

   overriding function Datalink (Self : in out Live_Packet_Capture_Type) return Datalink_Type is
   begin
      return Abstract_Base_Packet_Capture_Type (Self).Datalink;
   end Datalink;

   function Get_Nonblock (Self : in out Live_Packet_Capture_Type) return Boolean is
      C_Error_Buffer : aliased Interfaces.C.char_array := (0 .. PCAP_ERRBUF_SIZE => Interfaces.C.nul);
      C_Return_Value : Interfaces.C.int;
      use type Interfaces.C.int;
   begin
      C_Return_Value := pcap_getnonblock (p      => Self.Handle,
                                          errbuf => Interfaces.C.Strings.To_Chars_Ptr (Item => C_Error_Buffer'Unchecked_Access));
      Self.Status := (if C_Return_Value < 0 then Status_Type (C_Return_Value) else PCAP_SUCCESS_WITHOUT_WARNINGS);
      if Self.Has_Error_Status then
         raise Pcap.Exceptions.Pcap_Error with Interfaces.C.To_Ada (Item => C_Error_Buffer);
      end if;
      return C_Return_Value /= 0;
   end Get_Nonblock;

   procedure List_Datalinks (Self      : in out Live_Packet_Capture_Type;
                             Datalinks :    out Datalinks_Type) is
      C_Return_Value : Interfaces.C.int;
      C_Dlt_Buffer   : System.Address;
      use type Interfaces.C.int;
   begin
      C_Return_Value := pcap_list_datalinks (p       => Self.Handle,
                                             dlt_buf => C_Dlt_Buffer);
      Self.Status := (if C_Return_Value < 0 then Status_Type (C_Return_Value) else PCAP_SUCCESS_WITHOUT_WARNINGS);
      if Self.Has_Error_Status then
         raise Pcap.Exceptions.Pcap_Error with (if Self.Status = PCAP_ERROR then Self.Get_Error_Text else Self.Status_To_String);
      end if;
      declare
         Number_Of_Datalinks : constant Integer := Integer (C_Return_Value);
         C_Datalinks         : array (Integer range 0 .. Number_Of_Datalinks - 1) of Interfaces.C.int with Address => C_Dlt_Buffer;
         Datalinks_Copy      : Datalinks_Type (0 .. Number_Of_Datalinks - 1);
      begin
         for I in 0 .. Number_Of_Datalinks - 1 loop
            Datalinks_Copy (I) := Datalink_Type (C_Datalinks (I));
         end loop;
         Datalinks := Datalinks_Copy;
      end;
      pcap_free_datalinks (dlt_list => C_Dlt_Buffer);
   end List_Datalinks;

   procedure List_Timestamp_Types (Self            : in out Live_Packet_Capture_Type;
                                   Timestamp_Types :    out Timestamp_Types_Type) is
      C_Return_Value : Interfaces.C.int;
      C_Tstamp_Types : System.Address;
      use type Interfaces.C.int;
   begin
      C_Return_Value := pcap_list_tstamp_types (p            => Self.Handle,
                                                tstamp_types => C_Tstamp_Types);
      Self.Status := (if C_Return_Value < 0 then Status_Type (C_Return_Value) else PCAP_SUCCESS_WITHOUT_WARNINGS);
      if Self.Has_Error_Status then
         raise Pcap.Exceptions.Pcap_Error with (if Self.Status = PCAP_ERROR then Self.Get_Error_Text else Self.Status_To_String);
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

   procedure Set_Buffer_Size (Self        : in out Live_Packet_Capture_Type;
                              Buffer_Size :        Buffer_Size_Type) is
      C_Return_Value : Interfaces.C.int;
   begin
      C_Return_Value := pcap_set_buffer_size (p           => Self.Handle,
                                              buffer_size => Interfaces.C.int (Buffer_Size));
      Self.Status := Status_Type (C_Return_Value);
      if Self.Has_Error_Status then
         raise Pcap.Exceptions.Pcap_Error with Self.Status_To_String;
      end if;
   end Set_Buffer_Size;

   procedure Set_Datalink (Self     : in out Live_Packet_Capture_Type;
                           Datalink :        Datalink_Type) is
      C_Return_Value : Interfaces.C.int;
   begin
      C_Return_Value := pcap_set_datalink (p   => Self.Handle,
                                           dlt => Interfaces.C.int (Datalink));
      Self.Status := Status_Type (C_Return_Value);
      if Self.Has_Error_Status then
         raise Pcap.Exceptions.Pcap_Error with Self.Get_Error_Text;
      end if;
   end Set_Datalink;

   procedure Set_Direction (Self      : in out Live_Packet_Capture_Type;
                            Direction :        Direction_Type) is
      C_Return_Value : Interfaces.C.int;
   begin
      C_Return_Value := pcap_setdirection (p => Self.Handle,
                                           d => pcap_direction_t'Val (Direction_Type'Pos (Direction)));
      Self.Status := Status_Type (C_Return_Value);
      if Self.Has_Error_Status then
         raise Pcap.Exceptions.Pcap_Error with Self.Get_Error_Text;
      end if;
   end Set_Direction;

   procedure Set_Immediate_Mode (Self           : in out Live_Packet_Capture_Type;
                                 Immediate_Mode :        Boolean := True) is
      C_Return_Value : Interfaces.C.int;
   begin
      C_Return_Value := pcap_set_immediate_mode (p              => Self.Handle,
                                                 immediate_mode => Boolean'Pos (Immediate_Mode));
      Self.Status := Status_Type (C_Return_Value);
      if Self.Has_Error_Status then
         raise Pcap.Exceptions.Pcap_Error with Self.Status_To_String;
      end if;
   end Set_Immediate_Mode;

   procedure Set_Monitor_Mode (Self         : in out Live_Packet_Capture_Type;
                               Monitor_Mode :        Boolean := True) is
      C_Return_Value : Interfaces.C.int;
   begin
      C_Return_Value := pcap_set_rfmon (p     => Self.Handle,
                                        rfmon => Boolean'Pos (Monitor_Mode));
      Self.Status := Status_Type (C_Return_Value);
      if Self.Has_Error_Status then
         raise Pcap.Exceptions.Pcap_Error with Self.Status_To_String;
      end if;
   end Set_Monitor_Mode;

   procedure Set_Nonblock (Self     : in out Live_Packet_Capture_Type;
                           Nonblock :        Boolean := True) is
      C_Error_Buffer : aliased Interfaces.C.char_array := (0 .. PCAP_ERRBUF_SIZE => Interfaces.C.nul);
      C_Return_Value : Interfaces.C.int;
   begin
      C_Return_Value := pcap_setnonblock (p        => Self.Handle,
                                          nonblock => (if Nonblock then 1 else 0),
                                          errbuf   => Interfaces.C.Strings.To_Chars_Ptr (Item => C_Error_Buffer'Unchecked_Access));
      Self.Status := Status_Type (C_Return_Value);
      if Self.Has_Error_Status then
         raise Pcap.Exceptions.Pcap_Error with Interfaces.C.To_Ada (Item => C_Error_Buffer);
      end if;
   end Set_Nonblock;

   procedure Set_Promiscuous_Mode (Self             : in out Live_Packet_Capture_Type;
                                   Promiscuous_Mode :        Boolean := True) is
      C_Return_Value : Interfaces.C.int;
   begin
      C_Return_Value := pcap_set_promisc (p       => Self.Handle,
                                          promisc => Boolean'Pos (Promiscuous_Mode));
      Self.Status := Status_Type (C_Return_Value);
      if Self.Has_Error_Status then
         raise Pcap.Exceptions.Pcap_Error with Self.Status_To_String;
      end if;
   end Set_Promiscuous_Mode;

   procedure Set_Snapshot_Length (Self            : in out Live_Packet_Capture_Type;
                                  Snapshot_Length :        Snapshot_Length_Type := 65535) is
      C_Return_Value : Interfaces.C.int;
   begin
      C_Return_Value := pcap_set_snaplen (p       => Self.Handle,
                                          snaplen => Interfaces.C.int (Snapshot_Length));
      Self.Status := Status_Type (C_Return_Value);
      if Self.Has_Error_Status then
         raise Pcap.Exceptions.Pcap_Error with Self.Status_To_String;
      end if;
   end Set_Snapshot_Length;

   procedure Set_Timeout (Self    : in out Live_Packet_Capture_Type;
                          Timeout :        Timeout_Milliseconds_Type) is
      C_Return_Value : Interfaces.C.int;
   begin
      C_Return_Value := pcap_set_timeout (p     => Self.Handle,
                                          to_ms => Interfaces.C.int (Timeout));
      Self.Status := Status_Type (C_Return_Value);
      if Self.Has_Error_Status then
         raise Pcap.Exceptions.Pcap_Error with Self.Status_To_String;
      end if;
   end Set_Timeout;

   procedure Set_Timestamp_Precision (Self                : in out Live_Packet_Capture_Type;
                                      Timestamp_Precision :        Timestamp_Precision_Type) is
      C_Return_Value : Interfaces.C.int;
   begin
      C_Return_Value := pcap_set_tstamp_precision (p                => Self.Handle,
                                                   tstamp_precision => Interfaces.C.int (Timestamp_Precision));
      Self.Status := Status_Type (C_Return_Value);
      if Self.Has_Error_Status then
         raise Pcap.Exceptions.Pcap_Error with Self.Status_To_String;
      end if;
   end Set_Timestamp_Precision;

   procedure Set_Timestamp_Type (Self           : in out Live_Packet_Capture_Type;
                                 Timestamp_Type :        Timestamp_Type_Type) is
      C_Return_Value : Interfaces.C.int;
   begin
      C_Return_Value := pcap_set_tstamp_type (p           => Self.Handle,
                                              tstamp_type => Interfaces.C.int (Timestamp_Type));
      Self.Status := Status_Type (C_Return_Value);
      if Self.Has_Error_Status then
         raise Pcap.Exceptions.Pcap_Error with Self.Status_To_String;
      end if;
   end Set_Timestamp_Type;

   function Stats (Self  : in out Live_Packet_Capture_Type) return Packet_Statistics_Type is
      C_Return_Value : Interfaces.C.int;
      C_Stats        : Pcap.pcap_stat;
      Statistics     : Packet_Statistics_Type;
      use type Interfaces.C.int;
   begin
      C_Return_Value := pcap_stats (p  => Self.Handle,
                                    ps => C_Stats);
      Self.Status := (if C_Return_Value < 0 then Status_Type (C_Return_Value) else PCAP_SUCCESS_WITHOUT_WARNINGS);
      if Self.Has_Error_Status then
         raise Pcap.Exceptions.Pcap_Error with (if Self.Status = PCAP_ERROR then Self.Get_Error_Text else Self.Status_To_String);
      end if;
      Statistics.Received := Natural (C_Stats.ps_recv);
      Statistics.Dropped := Natural (C_Stats.ps_drop);
      Statistics.Dropped_By_Network_Interface := Natural (C_Stats.ps_ifdrop);
      return Statistics;
   end Stats;

end Pcap.Lib.Live;
