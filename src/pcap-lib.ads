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
with Ada.Finalization;
with Pcap.Dlt;

package Pcap.Lib is

   type Packet_Capture_Type is limited new Ada.Finalization.Limited_Controlled with private;

   type Snapshot_Length_Type is new Positive;

   type Timestamp_Precision_Type is (Micro, Nano);

   function Is_Open (Self : Packet_Capture_Type) return Boolean;

   procedure Open_Dead (Self            : in out Packet_Capture_Type;
                        Datalink        :        Pcap.Dlt.Dlt_Type;
                        Snapshot_Length :        Snapshot_Length_Type)
   with Pre  => not Self.Is_Open,
        Post => Self.Is_Open;

   procedure Open_Dead (Self            : in out Packet_Capture_Type;
                        Datalink        :        Pcap.Dlt.Dlt_Type;
                        Snapshot_Length :        Snapshot_Length_Type;
                        Precision       :        Timestamp_Precision_Type)
   with Pre  => not Self.Is_Open,
        Post => Self.Is_Open;

   function Pcap_Ada_Version return String;

   function Pcap_Version return String;

private

   type Packet_Capture_Type is limited new Ada.Finalization.Limited_Controlled with
      record
         Active : Boolean;
         Handle : pcap_t_ptr;
      end record;

   overriding procedure Finalize (Self : in out Packet_Capture_Type);

   function Is_Open (Self : Packet_Capture_Type) return Boolean is (Self.Handle /= null);

   function Pcap_Ada_Version return String is ($PCAP_ADA_VERSION);

   function Pcap_Version return String is (Interfaces.C.Strings.Value (Item => pcap_lib_version));

end Pcap.Lib;
