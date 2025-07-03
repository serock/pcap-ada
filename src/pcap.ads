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
with Ada.Finalization;
private with Interfaces.C.Strings;
private with System;

package Pcap is

   subtype Buffer_Size_Type is Positive;

   type Datalink_Type is new Natural;

   type Datalinks_Type is array (Integer range <>) of Datalink_Type;

   type Direction_Type is (DIRECTION_IN_OUT, DIRECTION_IN, DIRECTION_OUT);

   type Packet_Statistics_Type is
      record
         Received                     : Natural;
         Dropped                      : Natural;
         Dropped_By_Network_Interface : Natural;
      end record;

   subtype Snapshot_Length_Type is Positive;

   type Status_Type is new Integer;

   subtype Timeout_Milliseconds_Type is Positive;

   type Timestamp_Precision_Type is new Natural;

   type Timestamp_Type_Type is new Natural;

   type Timestamp_Types_Type is array (Integer range <>) of Timestamp_Type_Type;

   subtype Warning_Text_Type is String (1 .. 256);

   subtype Warning_Text_Length_Type is Integer range 0 .. Warning_Text_Type'Last;

   PCAP_SUCCESS_WITHOUT_WARNINGS   : constant Status_Type;

   PCAP_ERROR                      : constant Status_Type;
   PCAP_ERROR_BREAK                : constant Status_Type;
   PCAP_ERROR_NOT_ACTIVATED        : constant Status_Type;
   PCAP_ERROR_ACTIVATED            : constant Status_Type;
   PCAP_ERROR_NO_SUCH_DEVICE       : constant Status_Type;
   PCAP_ERROR_RFMON_NOTSUP         : constant Status_Type;
   PCAP_ERROR_NOT_RFMON            : constant Status_Type;
   PCAP_ERROR_PERM_DENIED          : constant Status_Type;
   PCAP_ERROR_IFACE_NOT_UP         : constant Status_Type;
   PCAP_ERROR_CANTSET_TSTAMP_TYPE  : constant Status_Type;
   PCAP_ERROR_PROMISC_PERM_DENIED  : constant Status_Type;

   PCAP_WARNING                    : constant Status_Type;
   PCAP_WARNING_PROMISC_NOTSUP     : constant Status_Type;
   PCAP_WARNING_TSTAMP_TYPE_NOTSUP : constant Status_Type;

   PCAP_TSTAMP_PRECISION_MICRO : constant Timestamp_Precision_Type;
   PCAP_TSTAMP_PRECISION_NANO  : constant Timestamp_Precision_Type;

   PCAP_TSTAMP_HOST                 : constant Timestamp_Type_Type;
   PCAP_TSTAMP_HOST_LOWPREC         : constant Timestamp_Type_Type;
   PCAP_TSTAMP_HOST_HIPREC          : constant Timestamp_Type_Type;
   PCAP_TSTAMP_ADAPTER              : constant Timestamp_Type_Type;
   PCAP_TSTAMP_ADAPTER_UNSYNCED     : constant Timestamp_Type_Type;
   PCAP_TSTAMP_HOST_HIPREC_UNSYNCED : constant Timestamp_Type_Type;

   function Datalink_Name_To_Value (Name : String) return Datalink_Type;

   function Datalink_Value_To_Description (Value : Datalink_Type) return String;

   function Datalink_Value_To_Name (Value : Datalink_Type) return String;

   function Pcap_Ada_Version return String;

   function Pcap_Api_Version return String;

   function Pcap_Version return String;

   function Status_To_String (Status : Status_Type) return String;

   function Strerror (Error : Integer) return String;

   function Timestamp_Type_Name_To_Value (Name : String) return Timestamp_Type_Type;

   function Timestamp_Type_Value_To_Description (Value : Timestamp_Type_Type) return String;

   function Timestamp_Type_Value_To_Name (Value : Timestamp_Type_Type) return String;

   ----------------------------------------------------------------------------

   type Packet_Capture_Type is limited new Ada.Finalization.Limited_Controlled with private;

   procedure Activate (Self : in out Packet_Capture_Type)
     with Pre => Self.Is_Open and then not Self.Is_Activated;

   procedure Break_Loop (Self : Packet_Capture_Type);

   function Can_Set_Monitor_Mode (Self : in out Packet_Capture_Type) return Boolean
     with Pre => Self.Is_Open and then Self.Is_Not_Activated;

   procedure Close (Self : in out Packet_Capture_Type)
     with Pre => Self.Is_Open;

   procedure Create (Self         : in out Packet_Capture_Type;
                     Source       :        String)
     with Pre => not Self.Is_Open;

   function Datalink (Self : in out Packet_Capture_Type) return Datalink_Type
     with Pre => Self.Is_Open and then Self.Is_Activated;

   function Get_Error_Text (Self : Packet_Capture_Type) return String
     with Pre => Self.Is_Open;

   function Get_Nonblock (Self : in out Packet_Capture_Type) return Boolean
     with Pre => Self.Is_Open and then Self.Is_Activated;

   function Get_Timestamp_Precision (Self : Packet_Capture_Type) return Timestamp_Precision_Type
     with Pre => Self.Is_Open;

   function Has_Error_Status (Self : Packet_Capture_Type) return Boolean;

   function Has_Warning_Status (Self : Packet_Capture_Type) return Boolean;

   function Is_Activated (Self : Packet_Capture_Type) return Boolean;

   function Is_Not_Activated (Self : Packet_Capture_Type) return Boolean;

   function Is_Open (Self : Packet_Capture_Type) return Boolean;

   procedure List_Datalinks (Self      : in out Packet_Capture_Type;
                             Datalinks :    out Datalinks_Type);

   procedure List_Timestamp_Types (Self            : in out Packet_Capture_Type;
                                   Timestamp_Types :    out Timestamp_Types_Type);

   procedure Open_Dead (Self            : in out Packet_Capture_Type;
                        Datalink        :        Datalink_Type;
                        Snapshot_Length :        Snapshot_Length_Type     := 65535;
                        Precision       :        Timestamp_Precision_Type := PCAP_TSTAMP_PRECISION_MICRO)
     with Pre => not Self.Is_Open;

   procedure Open_Live (Self                : in out Packet_Capture_Type;
                        Device              :        String;
                        Snapshot_Length     :        Snapshot_Length_Type := 65535;
                        Promiscuous_Mode    :        Boolean              := False;
                        Read_Timeout        :        Timeout_Milliseconds_Type;
                        Warning_Text        :    out Pcap.Warning_Text_Type;
                        Warning_Text_Length :    out Pcap.Warning_Text_Length_Type)
     with Pre => not Self.Is_Open;

   procedure Perror (Self   : Packet_Capture_Type;
                     Prefix : String)
     with Pre => Self.Is_Open;

   procedure Set_Buffer_Size (Self        : in out Packet_Capture_Type;
                              Buffer_Size :        Buffer_Size_Type)
     with Pre => Self.Is_Open and then Self.Is_Not_Activated;

   procedure Set_Datalink (Self     : in out Packet_Capture_Type;
                           Datalink :        Datalink_Type)
     with Pre => Self.Is_Open and then Self.Is_Activated;

   procedure Set_Direction (Self      : in out Packet_Capture_Type;
                            Direction :        Direction_Type)
     with Pre => Self.Is_Open and then Self.Is_Activated;

   procedure Set_Immediate_Mode (Self           : in out Packet_Capture_Type;
                                 Immediate_Mode :        Boolean := True)
     with Pre => Self.Is_Open and then Self.Is_Not_Activated;

   procedure Set_Monitor_Mode (Self         : in out Packet_Capture_Type;
                               Monitor_Mode :        Boolean := True)
     with Pre => Self.Is_Open and then Self.Is_Not_Activated;

   procedure Set_Nonblock (Self     : in out Packet_Capture_Type;
                           Nonblock :        Boolean := True)
     with Pre => Self.Is_Open and then Self.Is_Activated;

   procedure Set_Promiscuous_Mode (Self             : in out Packet_Capture_Type;
                                   Promiscuous_Mode :        Boolean := True)
     with Pre => Self.Is_Open and then Self.Is_Not_Activated;

   procedure Set_Snapshot_Length (Self            : in out Packet_Capture_Type;
                                  Snapshot_Length :        Snapshot_Length_Type := 65535)
     with Pre => Self.Is_Open and then Self.Is_Not_Activated;

   procedure Set_Timeout (Self    : in out Packet_Capture_Type;
                          Timeout :        Timeout_Milliseconds_Type)
     with Pre => Self.Is_Open and then Self.Is_Not_Activated;

   procedure Set_Timestamp_Precision (Self                : in out Packet_Capture_Type;
                                      Timestamp_Precision :        Timestamp_Precision_Type)
     with Pre => Self.Is_Open and then Self.Is_Not_Activated;

   procedure Set_Timestamp_Type (Self           : in out Packet_Capture_Type;
                                 Timestamp_Type :        Timestamp_Type_Type)
     with Pre => Self.Is_Open and then Self.Is_Not_Activated;

   function Stats (Self  : in out Packet_Capture_Type) return Packet_Statistics_Type
     with Pre => Self.Is_Open and then Self.Is_Activated;

   function Status_To_String (Self : Packet_Capture_Type) return String
     with Pre => Self.Is_Open;

private

#if PCAP_OS_TYPE = "freebsd" or PCAP_OS_TYPE = "linux" or PCAP_OS_TYPE = "macos" or PCAP_OS_TYPE = "openbsd"
   EINVAL : constant := 22;
#elsif PCAP_OS_TYPE = "windows"
   EINVAL : constant := 10022;
#end if;

   PCAP_ERRBUF_SIZE : constant := 256;

   type pcap_t is null record;

   type pcap_t_ptr is access pcap_t;

   type pcap_direction_t is
     (PCAP_D_INOUT,
      PCAP_D_IN,
      PCAP_D_OUT)
   with Convention => C;

   subtype pcap_errbuf_t is Interfaces.C.char_array (0 .. PCAP_ERRBUF_SIZE);

   type pcap_stat is
      record
         ps_recv   : aliased Interfaces.C.unsigned;
         ps_drop   : aliased Interfaces.C.unsigned;
         ps_ifdrop : aliased Interfaces.C.unsigned;
      end record
   with Convention => C;

   function pcap_activate (p : pcap_t_ptr) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_activate";

   procedure pcap_breakloop (p : pcap_t_ptr)
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_breakloop";

   function pcap_can_set_rfmon (p : pcap_t_ptr) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_can_set_rfmon";

   function pcap_create (source :     Interfaces.C.char_array;
                         errbuf : out pcap_errbuf_t) return pcap_t_ptr
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_create";

   procedure pcap_close (p : pcap_t_ptr)
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_close";

   function pcap_datalink (p : pcap_t_ptr) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_datalink";

   function pcap_datalink_name_to_val (name : Interfaces.C.char_array) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_datalink_name_to_val";

   function pcap_datalink_val_to_name (dlt : Interfaces.C.int) return Interfaces.C.Strings.chars_ptr
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_datalink_val_to_name";

   function pcap_datalink_val_to_description (dlt : Interfaces.C.int) return Interfaces.C.Strings.chars_ptr
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_datalink_val_to_description";

   procedure pcap_free_datalinks (dlt_list : System.Address)
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_free_datalinks";

   procedure pcap_free_tstamp_types (tstamp_types : System.Address)
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_free_tstamp_types";

   function pcap_get_tstamp_precision (p : pcap_t_ptr) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_get_tstamp_precision";

   function pcap_geterr (p : pcap_t_ptr) return Interfaces.C.Strings.chars_ptr
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_geterr";

   function pcap_getnonblock (p      :     pcap_t_ptr;
                              errbuf : out pcap_errbuf_t) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_getnonblock";

   function pcap_inject (p    : pcap_t_ptr;
                         buf  : System.Address;
                         size : Interfaces.C.size_t) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_inject";

   function pcap_lib_version return Interfaces.C.Strings.chars_ptr
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_lib_version";

   function pcap_list_datalinks (p       :     pcap_t_ptr;
                                 dlt_buf : out System.Address) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_list_datalinks";

   function pcap_list_tstamp_types (p            :     pcap_t_ptr;
                                    tstamp_types : out System.Address) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_list_tstamp_types";

   function pcap_open_dead (linktype : Interfaces.C.int;
                            snaplen  : Interfaces.C.int) return pcap_t_ptr
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_open_dead";

   function pcap_open_dead_with_tstamp_precision (linktype  : Interfaces.C.int;
                                                  snaplen   : Interfaces.C.int;
                                                  precision : Interfaces.C.unsigned) return pcap_t_ptr
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_open_dead_with_tstamp_precision";

   function pcap_open_live (device  :     Interfaces.C.char_array;
                            snaplen :     Interfaces.C.int;
                            promisc :     Interfaces.C.int;
                            to_ms   :     Interfaces.C.int;
                            errbuf  : out pcap_errbuf_t) return pcap_t_ptr
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_open_live";

   procedure pcap_perror (p      : pcap_t_ptr;
                          prefix : Interfaces.C.char_array)
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_perror";

   function pcap_sendpacket (p    : pcap_t_ptr;
                             buf  : System.Address;
                             size : Interfaces.C.int) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_sendpacket";

   function pcap_set_buffer_size (p           : pcap_t_ptr;
                                  buffer_size : Interfaces.C.int) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_set_buffer_size";

   function pcap_set_datalink (p   : pcap_t_ptr;
                               dlt : Interfaces.C.int) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_set_datalink";

   function pcap_set_immediate_mode (p              : pcap_t_ptr;
                                     immediate_mode : Interfaces.C.int) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_set_immediate_mode";

   function pcap_set_promisc (p       : pcap_t_ptr;
                              promisc : Interfaces.C.int) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_set_promisc";

   function pcap_set_rfmon (p     : pcap_t_ptr;
                            rfmon : Interfaces.C.int) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_set_rfmon";

   function pcap_set_snaplen (p       : pcap_t_ptr;
                              snaplen : Interfaces.C.int) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_set_snaplen";

   function pcap_set_timeout (p     : pcap_t_ptr;
                              to_ms : Interfaces.C.int) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_set_timeout";

   function pcap_set_tstamp_precision (p                : pcap_t_ptr;
                                       tstamp_precision : Interfaces.C.int) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_set_tstamp_precision";

   function pcap_set_tstamp_type (p           : pcap_t_ptr;
                                  tstamp_type : Interfaces.C.int) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_set_tstamp_type";

   function pcap_setdirection (p : pcap_t_ptr;
                               d : pcap_direction_t) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_setdirection";

   function pcap_setnonblock (p        :     pcap_t_ptr;
                              nonblock :     Interfaces.C.int;
                              errbuf   : out pcap_errbuf_t) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_setnonblock";

   function pcap_stats (p  :     pcap_t_ptr;
                        ps : out pcap_stat) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_stats";

   function pcap_statustostr (error : Interfaces.C.int) return Interfaces.C.Strings.chars_ptr
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_statustostr";

   function pcap_strerror (error : Interfaces.C.int) return Interfaces.C.Strings.chars_ptr
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_strerror";

   function pcap_tstamp_type_name_to_val (name : Interfaces.C.char_array) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_tstamp_type_name_to_val";

   function pcap_tstamp_type_val_to_name (tstamp_type : Interfaces.C.int) return Interfaces.C.Strings.chars_ptr
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_tstamp_type_val_to_name";

   function pcap_tstamp_type_val_to_description (tstamp_type : Interfaces.C.int) return Interfaces.C.Strings.chars_ptr
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_tstamp_type_val_to_description";

   ----------------------------------------------------------------------------

   PCAP_SUCCESS_WITHOUT_WARNINGS   : constant Status_Type := 0;

   PCAP_ERROR                      : constant Status_Type := -1;
   PCAP_ERROR_BREAK                : constant Status_Type := -2;
   PCAP_ERROR_NOT_ACTIVATED        : constant Status_Type := -3;
   PCAP_ERROR_ACTIVATED            : constant Status_Type := -4;
   PCAP_ERROR_NO_SUCH_DEVICE       : constant Status_Type := -5;
   PCAP_ERROR_RFMON_NOTSUP         : constant Status_Type := -6;
   PCAP_ERROR_NOT_RFMON            : constant Status_Type := -7;
   PCAP_ERROR_PERM_DENIED          : constant Status_Type := -8;
   PCAP_ERROR_IFACE_NOT_UP         : constant Status_Type := -9;
   PCAP_ERROR_CANTSET_TSTAMP_TYPE  : constant Status_Type := -10;
   PCAP_ERROR_PROMISC_PERM_DENIED  : constant Status_Type := -11;

   PCAP_WARNING                    : constant Status_Type := 1;
   PCAP_WARNING_PROMISC_NOTSUP     : constant Status_Type := 2;
   PCAP_WARNING_TSTAMP_TYPE_NOTSUP : constant Status_Type := 3;

   PCAP_TSTAMP_PRECISION_MICRO : constant Timestamp_Precision_Type := 0;
   PCAP_TSTAMP_PRECISION_NANO  : constant Timestamp_Precision_Type := 1;

   PCAP_TSTAMP_HOST                 : constant Timestamp_Type_Type := 0;
   PCAP_TSTAMP_HOST_LOWPREC         : constant Timestamp_Type_Type := 1;
   PCAP_TSTAMP_HOST_HIPREC          : constant Timestamp_Type_Type := 2;
   PCAP_TSTAMP_ADAPTER              : constant Timestamp_Type_Type := 3;
   PCAP_TSTAMP_ADAPTER_UNSYNCED     : constant Timestamp_Type_Type := 4;
   PCAP_TSTAMP_HOST_HIPREC_UNSYNCED : constant Timestamp_Type_Type := 5;

   function Pcap_Ada_Version return String is ($PCAP_ADA_VERSION);

   function Pcap_Api_Version return String is ("1.8.1");

   function Pcap_Version return String is (Interfaces.C.Strings.Value (Item => pcap_lib_version));

   ----------------------------------------------------------------------------

   type Packet_Capture_Type is limited new Ada.Finalization.Limited_Controlled with
      record
         Handle    : pcap_t_ptr;
         Status    : Status_Type := 0;
         Activated : Boolean := False;
      end record;

   overriding procedure Finalize (Self : in out Packet_Capture_Type);

   function Is_Activated (Self : Packet_Capture_Type) return Boolean is (Self.Activated);

   function Is_Not_Activated (Self : Packet_Capture_Type) return Boolean is (not Self.Activated);

   function Is_Open (Self : Packet_Capture_Type) return Boolean is (Self.Handle /= null);

end Pcap;
