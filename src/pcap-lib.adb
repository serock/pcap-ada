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

package body Pcap.Lib is

   function Strerror (Error : Integer) return String is
      Str : Interfaces.C.Strings.chars_ptr;
   begin
      Str := pcap_strerror (error => Interfaces.C.int (Error));
      return Interfaces.C.Strings.Value (Item => Str);
   end Strerror;

   function Datalink_Name_To_Value (Name : String) return Datalink_Type is
      C_Name  : aliased Interfaces.C.char_array := Interfaces.C.To_C (Item => Name);
      C_Value : Interfaces.C.int;
      use type Interfaces.C.int;
   begin
      C_Value := pcap_datalink_name_to_val (Interfaces.C.Strings.To_Chars_Ptr (Item => C_Name'Unchecked_Access));
      if C_Value = -1 then
         raise Constraint_Error with "invalid datalink name";
      end if;
      return Datalink_Type (C_Value);
   end Datalink_Name_To_Value;

   function Datalink_Value_To_Description (Value : Datalink_Type) return String is
      Description : Interfaces.C.Strings.chars_ptr;
      use type Interfaces.C.Strings.chars_ptr;
   begin
      Description := pcap_datalink_val_to_description (dlt => Interfaces.C.int (Value));
      if Description = Interfaces.C.Strings.Null_Ptr then
         raise Constraint_Error with "invalid datalink";
      end if;
      return Interfaces.C.Strings.Value (Item => Description);
   end Datalink_Value_To_Description;

   function Datalink_Value_To_Name (Value : Datalink_Type) return String is
      Name : Interfaces.C.Strings.chars_ptr;
      use type Interfaces.C.Strings.chars_ptr;
   begin
      Name := pcap_datalink_val_to_name (dlt => Interfaces.C.int (Value));
      if Name = Interfaces.C.Strings.Null_Ptr then
         raise Constraint_Error with "invalid datalink";
      end if;
      return Interfaces.C.Strings.Value (Item => Name);
   end Datalink_Value_To_Name;

   function Status_To_String (Status : Status_Type) return String is
      Str : Interfaces.C.Strings.chars_ptr;
   begin
      Str := pcap_statustostr (error => Interfaces.C.int (Status));
      return Interfaces.C.Strings.Value (Item => Str);
   end Status_To_String;

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

   function Has_Error_Status (Self : Abstract_Packet_Capture_Type) return Boolean is
   begin
      return Self.Status < 0;
   end Has_Error_Status;

   function Has_Warning_Status (Self : Abstract_Packet_Capture_Type) return Boolean is
   begin
      return Self.Status > 0;
   end Has_Warning_Status;

   procedure Perror (Self   : Abstract_Packet_Capture_Type;
                     Prefix : String) is
      C_Prefix : aliased Interfaces.C.char_array := Interfaces.C.To_C (Item => Prefix);
   begin
      pcap_perror (p      => Self.Handle,
                   prefix => Interfaces.C.Strings.To_Chars_Ptr (Item => C_Prefix'Unchecked_Access));
   end Perror;

   function Status_To_String (Self : Abstract_Packet_Capture_Type) return String is
   begin
      return Status_To_String (Status => Self.Status);
   end Status_To_String;

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

   function Datalink (Self : in out Abstract_Base_Packet_Capture_Type) return Datalink_Type is
      Return_Value : Interfaces.C.int;
      use type Interfaces.C.int;
   begin
      Return_Value := pcap_datalink (p => Self.Handle);
      Self.Status := (if Return_Value < 0 then Status_Type (Return_Value) else PCAP_SUCCESS_WITHOUT_WARNINGS);
      if Self.Has_Error_Status then
         raise Pcap.Exceptions.Pcap_Error with Self.Status_To_String;
      end if;
      return Datalink_Type (Return_Value);
   end Datalink;

   function Timestamp_Type_Name_To_Value (Name : String) return Timestamp_Type_Type is
      C_Name  : aliased Interfaces.C.char_array := Interfaces.C.To_C (Item => Name);
      C_Value : Interfaces.C.int;
      use type Interfaces.C.int;
   begin
      C_Value := pcap_tstamp_type_name_to_val (name => Interfaces.C.Strings.To_Chars_Ptr (Item => C_Name'Unchecked_Access));
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

end Pcap.Lib;
