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
with Pcap.Dlt;

package Pcap.Lib is

   type Status_Type is new Integer;

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

   type Snapshot_Length_Type is new Positive;

   type Timestamp_Precision_Type is new Natural;

   PCAP_TSTAMP_PRECISION_MICRO : constant Timestamp_Precision_Type;
   PCAP_TSTAMP_PRECISION_NANO  : constant Timestamp_Precision_Type;

   type Abstract_Packet_Capture_Type is abstract limited new Ada.Finalization.Limited_Controlled with private;

   procedure Close (Self : in out Abstract_Packet_Capture_Type)
     with Pre => Self.Is_Open;

   function Is_Open (Self : Abstract_Packet_Capture_Type) return Boolean;

   function Geterr (Self : Abstract_Packet_Capture_Type) return String
     with Pre => Self.Is_Open;

   function Has_Error_Status (Self : Abstract_Packet_Capture_Type) return Boolean;

   function Has_Warning_Status (Self : Abstract_Packet_Capture_Type) return Boolean;

   procedure Perror (Self   : Abstract_Packet_Capture_Type;
                     Prefix : String)
     with Pre => Self.Is_Open;

   function Status_To_String (Self : Abstract_Packet_Capture_Type) return String
     with Pre => Self.Is_Open;

   type Packet_Capture_Type is limited new Abstract_Packet_Capture_Type with private;

   procedure Open_Dead (Self            : in out Packet_Capture_Type;
                        Datalink        :        Pcap.Dlt.Dlt_Type;
                        Snapshot_Length :        Snapshot_Length_Type     := 65535;
                        Precision       :        Timestamp_Precision_Type := PCAP_TSTAMP_PRECISION_MICRO)
     with Pre => not Self.Is_Open;

   function Pcap_Ada_Version return String;

   function Pcap_Version return String;

   function Status_To_String (Status : Status_Type) return String;

   function Strerror (Error : Integer) return String;

private

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

   type Abstract_Packet_Capture_Type is abstract limited new Ada.Finalization.Limited_Controlled with
      record
         Handle : pcap_t_ptr;
         Status : Status_Type := 0;
      end record;

   overriding procedure Finalize (Self : in out Abstract_Packet_Capture_Type);

   function Is_Open (Self : Abstract_Packet_Capture_Type) return Boolean is (Self.Handle /= null);

   type Packet_Capture_Type is limited new Abstract_Packet_Capture_Type with null record;

   function Pcap_Ada_Version return String is ($PCAP_ADA_VERSION);

   function Pcap_Version return String is (Interfaces.C.Strings.Value (Item => pcap_lib_version));

end Pcap.Lib;
