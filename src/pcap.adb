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
with Pcap.Exceptions;

package body Pcap is

   function Datalink_Name_To_Value (Name : String) return Datalink_Type is
      C_Name  : constant Interfaces.C.char_array := Interfaces.C.To_C (Item => Name);
      C_Value : Interfaces.C.int;
      use type Interfaces.C.int;
   begin
      C_Value := pcap_datalink_name_to_val (name => C_Name);
      if C_Value < 0 then
         raise Pcap.Exceptions.Pcap_Error with Strerror (Error => EINVAL);
      end if;
      return Datalink_Type (C_Value);
   end Datalink_Name_To_Value;

   function Datalink_Value_To_Description (Value : Datalink_Type) return String is
      C_Description : Interfaces.C.Strings.chars_ptr;
      use type Interfaces.C.Strings.chars_ptr;
   begin
      C_Description := pcap_datalink_val_to_description (dlt => Interfaces.C.int (Value));
      if C_Description = Interfaces.C.Strings.Null_Ptr then
         raise Pcap.Exceptions.Pcap_Error with Strerror (Error => EINVAL);
      end if;
      return Interfaces.C.Strings.Value (Item => C_Description);
   end Datalink_Value_To_Description;

   function Datalink_Value_To_Name (Value : Datalink_Type) return String is
      C_Name : Interfaces.C.Strings.chars_ptr;
      use type Interfaces.C.Strings.chars_ptr;
   begin
      C_Name := pcap_datalink_val_to_name (dlt => Interfaces.C.int (Value));
      if C_Name = Interfaces.C.Strings.Null_Ptr then
         raise Pcap.Exceptions.Pcap_Error with Strerror (Error => EINVAL);
      end if;
      return Interfaces.C.Strings.Value (Item => C_Name);
   end Datalink_Value_To_Name;

   function Lookup_Device return String is
      C_Device       : Interfaces.C.Strings.chars_ptr;
      C_Error_Buffer : Pcap.pcap_errbuf_t := (others => Interfaces.C.nul);
      use type Interfaces.C.Strings.chars_ptr;
   begin
      C_Device := pcap_lookupdev (errbuf => C_Error_Buffer);
      if C_Device = Interfaces.C.Strings.Null_Ptr then
         raise Pcap.Exceptions.Pcap_Error with Interfaces.C.To_Ada (Item => C_Error_Buffer);
      end if;
      return Interfaces.C.Strings.Value (Item => C_Device);
   end Lookup_Device;

   function Status_To_String (Status : Status_Type) return String is
      C_String : Interfaces.C.Strings.chars_ptr;
   begin
      C_String := pcap_statustostr (error => Interfaces.C.int (Status));
      return Interfaces.C.Strings.Value (Item => C_String);
   end Status_To_String;

   function Strerror (Error : Integer) return String is
      C_String : Interfaces.C.Strings.chars_ptr;
   begin
      C_String := pcap_strerror (error => Interfaces.C.int (Error));
      return Interfaces.C.Strings.Value (Item => C_String);
   end Strerror;

   function Timestamp_Type_Name_To_Value (Name : String) return Timestamp_Type_Type is
      C_Name  : constant Interfaces.C.char_array := Interfaces.C.To_C (Item => Name);
      C_Value : Interfaces.C.int;
      use type Interfaces.C.int;
   begin
      C_Value := pcap_tstamp_type_name_to_val (name => C_Name);
      if C_Value < 0 then
         raise Pcap.Exceptions.Pcap_Error with Status_To_String (Status => Status_Type (C_Value));
      end if;
      return Timestamp_Type_Type (C_Value);
   end Timestamp_Type_Name_To_Value;

   function Timestamp_Type_Value_To_Description (Value : Timestamp_Type_Type) return String is
      C_Description : Interfaces.C.Strings.chars_ptr;
      C_Value       : constant Interfaces.C.int := Interfaces.C.int (Value);
      use type Interfaces.C.Strings.chars_ptr;
   begin
      C_Description := pcap_tstamp_type_val_to_description (tstamp_type => C_Value);
      if C_Description = Interfaces.C.Strings.Null_Ptr then
         return "";
      else
         return Interfaces.C.Strings.Value (Item => C_Description);
      end if;
   end Timestamp_Type_Value_To_Description;

   function Timestamp_Type_Value_To_Name (Value : Timestamp_Type_Type) return String is
      C_Name  : Interfaces.C.Strings.chars_ptr;
      C_Value : constant Interfaces.C.int := Interfaces.C.int (Value);
      use type Interfaces.C.Strings.chars_ptr;
   begin
      C_Name := pcap_tstamp_type_val_to_name (tstamp_type => C_Value);
      if C_Name = Interfaces.C.Strings.Null_Ptr then
         return "";
      else
         return Interfaces.C.Strings.Value (Item => C_Name);
      end if;
   end Timestamp_Type_Value_To_Name;

   ----------------------------------------------------------------------------

   procedure Activate (Self : in out Packet_Capture_Type) is
      C_Return_Value : Interfaces.C.int;
   begin
      C_Return_Value := pcap_activate (p => Self.Handle);
      Self.Status := Status_Type (C_Return_Value);
      if Self.Has_Error_Status then
         raise Pcap.Exceptions.Pcap_Error with (if Self.Status = PCAP_ERROR then Self.Get_Error_Text else Self.Status_To_String);
      end if;
      Self.Activated := True;
   end Activate;

   procedure Break_Loop (Self : Packet_Capture_Type) is
   begin
      pcap_breakloop (p => Self.Handle);
   end Break_Loop;

   function Can_Set_Monitor_Mode (Self : in out Packet_Capture_Type) return Boolean is
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

   procedure Close (Self : in out Packet_Capture_Type) is
   begin
      if Self.Handle /= null then
         pcap_close (p => Self.Handle);
         Self.Handle := null;
      end if;
   end Close;

   procedure Create (Self         : in out Packet_Capture_Type;
                     Source       :        String) is
      C_Error_Buffer : Pcap.pcap_errbuf_t;
      C_Source       : constant Interfaces.C.char_array := Interfaces.C.To_C (Item => Source);
   begin
      if Self.Handle = null then
         C_Error_Buffer := (others => Interfaces.C.nul);
         Self.Handle := pcap_create (source => C_Source,
                                     errbuf => C_Error_Buffer);
         if Self.Handle = null then
            raise Pcap.Exceptions.Pcap_Error with Interfaces.C.To_Ada (Item => C_Error_Buffer);
         end if;
      end if;
   end Create;

   function Datalink (Self : in out Packet_Capture_Type) return Datalink_Type is
      C_Return_Value : Interfaces.C.int;
      use type Interfaces.C.int;
   begin
      C_Return_Value := pcap_datalink (p => Self.Handle);
      Self.Status := (if C_Return_Value < 0 then Status_Type (C_Return_Value) else PCAP_SUCCESS_WITHOUT_WARNINGS);
      if Self.Has_Error_Status then
         raise Pcap.Exceptions.Pcap_Error with Self.Status_To_String;
      end if;
      return Datalink_Type (C_Return_Value);
   end Datalink;

   overriding procedure Finalize (Self : in out Packet_Capture_Type) is
   begin
      Self.Close;
   end Finalize;

   function Get_Nonblock (Self : in out Packet_Capture_Type) return Boolean is
      C_Error_Buffer : pcap_errbuf_t := (others => Interfaces.C.nul);
      C_Return_Value : Interfaces.C.int;
      use type Interfaces.C.int;
   begin
      C_Return_Value := pcap_getnonblock (p      => Self.Handle,
                                          errbuf => C_Error_Buffer);
      Self.Status := (if C_Return_Value < 0 then Status_Type (C_Return_Value) else PCAP_SUCCESS_WITHOUT_WARNINGS);
      if Self.Has_Error_Status then
         raise Pcap.Exceptions.Pcap_Error with Interfaces.C.To_Ada (Item => C_Error_Buffer);
      end if;
      return C_Return_Value /= 0;
   end Get_Nonblock;

   function Get_Timestamp_Precision (Self : Packet_Capture_Type) return Timestamp_Precision_Type is
      C_Precision : Interfaces.C.int;
   begin
      C_Precision := pcap_get_tstamp_precision (p => Self.Handle);
      return Timestamp_Precision_Type (C_Precision);
   end Get_Timestamp_Precision;

   function Get_Error_Text (Self : Packet_Capture_Type) return String is
      C_Error_Text : Interfaces.C.Strings.chars_ptr;
   begin
      C_Error_Text := pcap_geterr (p => Self.Handle);
      return Interfaces.C.Strings.Value (Item => C_Error_Text);
   end Get_Error_Text;

   function Has_Error_Status (Self : Packet_Capture_Type) return Boolean is
   begin
      return Self.Status < 0;
   end Has_Error_Status;

   function Has_Warning_Status (Self : Packet_Capture_Type) return Boolean is
   begin
      return Self.Status > 0;
   end Has_Warning_Status;

   procedure List_Datalinks (Self      : in out Packet_Capture_Type;
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

   procedure List_Timestamp_Types (Self            : in out Packet_Capture_Type;
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

   procedure Open_Dead (Self            : in out Packet_Capture_Type;
                        Datalink        :        Datalink_Type;
                        Snapshot_Length :        Snapshot_Length_Type     := 65535;
                        Precision       :        Timestamp_Precision_Type := PCAP_TSTAMP_PRECISION_MICRO) is
   begin
      if Self.Handle = null then
         Self.Handle := pcap_open_dead_with_tstamp_precision (linktype  => Interfaces.C.int (Datalink),
                                                              snaplen   => Interfaces.C.int (Snapshot_Length),
                                                              precision => Interfaces.C.unsigned (Precision));
      end if;
   end Open_Dead;

   procedure Open_Live (Self                : in out Packet_Capture_Type;
                        Device              :        String;
                        Snapshot_Length     :        Snapshot_Length_Type := 65535;
                        Promiscuous_Mode    :        Boolean              := False;
                        Read_Timeout        :        Timeout_Milliseconds_Type;
                        Warning_Text        :    out Pcap.Warning_Text_Type;
                        Warning_Text_Length :    out Pcap.Warning_Text_Length_Type) is
      C_Device       : constant Interfaces.C.char_array := Interfaces.C.To_C (Item => Device);
      C_Error_Buffer : Pcap.pcap_errbuf_t;
      use type Interfaces.C.char;
   begin
      if Self.Handle = null then
         C_Error_Buffer := (others => Interfaces.C.nul);
         Self.Handle := pcap_open_live (device  => C_Device,
                                        snaplen => Interfaces.C.int (Snapshot_Length),
                                        promisc => Interfaces.C.int (Boolean'Pos (Promiscuous_Mode)),
                                        to_ms   => Interfaces.C.int (Read_Timeout),
                                        errbuf  => C_Error_Buffer);
         if C_Error_Buffer (0) /= Interfaces.C.nul then
            declare
               Text : constant String := Interfaces.C.To_Ada (Item => C_Error_Buffer);
            begin
               Warning_Text_Length := Text'Length;
               Warning_Text (1 .. Warning_Text_Length) := Text;
            end;
         end if;
         if Self.Handle = null then
            raise Pcap.Exceptions.Pcap_Error with Interfaces.C.To_Ada (Item => C_Error_Buffer);
         end if;
         Self.Activated := True;
      end if;
   end Open_Live;

   procedure Perror (Self   : Packet_Capture_Type;
                     Prefix : String) is
      C_Prefix : constant Interfaces.C.char_array := Interfaces.C.To_C (Item => Prefix);
   begin
      pcap_perror (p      => Self.Handle,
                   prefix => C_Prefix);
   end Perror;

   procedure Set_Buffer_Size (Self        : in out Packet_Capture_Type;
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

   procedure Set_Datalink (Self     : in out Packet_Capture_Type;
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

   procedure Set_Direction (Self      : in out Packet_Capture_Type;
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

   procedure Set_Immediate_Mode (Self           : in out Packet_Capture_Type;
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

   procedure Set_Monitor_Mode (Self         : in out Packet_Capture_Type;
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

   procedure Set_Nonblock (Self     : in out Packet_Capture_Type;
                           Nonblock :        Boolean := True) is
      C_Error_Buffer : Pcap.pcap_errbuf_t := (others => Interfaces.C.nul);
      C_Return_Value : Interfaces.C.int;
   begin
      C_Return_Value := pcap_setnonblock (p        => Self.Handle,
                                          nonblock => (if Nonblock then 1 else 0),
                                          errbuf   => C_Error_Buffer);
      Self.Status := Status_Type (C_Return_Value);
      if Self.Has_Error_Status then
         raise Pcap.Exceptions.Pcap_Error with Interfaces.C.To_Ada (Item => C_Error_Buffer);
      end if;
   end Set_Nonblock;

   procedure Set_Promiscuous_Mode (Self             : in out Packet_Capture_Type;
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

   procedure Set_Snapshot_Length (Self            : in out Packet_Capture_Type;
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

   procedure Set_Timeout (Self    : in out Packet_Capture_Type;
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

   procedure Set_Timestamp_Precision (Self                : in out Packet_Capture_Type;
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

   procedure Set_Timestamp_Type (Self           : in out Packet_Capture_Type;
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

   function Stats (Self  : in out Packet_Capture_Type) return Packet_Statistics_Type is
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

   function Status_To_String (Self : Packet_Capture_Type) return String is
   begin
      return Status_To_String (Status => Self.Status);
   end Status_To_String;

end Pcap;
