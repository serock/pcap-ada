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
with Pcap.Error_Buffer;

package Pcap.Lib.Live is

   type Buffer_Size_Type is new Positive;

   type Snapshot_Length_Type is new Positive;

   type Timeout_Milliseconds_Type is new Positive;

   type Live_Packet_Capture_Type is limited new Abstract_Packet_Capture_Type with private;

   function Activate (Self : Live_Packet_Capture_Type) return Status_Type
     with Pre => Self.Is_Open;

   procedure Create (Self         : in out Live_Packet_Capture_Type;
                     Source       :        String;
                     Error_Buffer :    out Pcap.Error_Buffer.Bounded_String)
     with Pre => not Self.Is_Open;

   procedure Open (Self             : in out Live_Packet_Capture_Type;
                   Device           :        String;
                   Snapshot_Length  :        Snapshot_Length_Type := 65535;
                   Promiscuous_Mode :        Boolean              := False;
                   Read_Timeout     :        Timeout_Milliseconds_Type;
                   Error_Buffer     :    out Pcap.Error_Buffer.Bounded_String)
     with Pre => not Self.Is_Open;

   function Set_Buffer_Size (Self        : Live_Packet_Capture_Type;
                             Buffer_Size : Buffer_Size_Type) return Status_Type
     with Pre => Self.Is_Open;

   function Set_Immediate_Mode (Self           : Live_Packet_Capture_Type;
                                Immediate_Mode : Boolean := True) return Status_Type
     with Pre => Self.Is_Open;

   function Set_Monitor_Mode (Self         : Live_Packet_Capture_Type;
                              Monitor_Mode : Boolean := True) return Status_Type
     with Pre => Self.Is_Open;

   function Set_Promiscuous_Mode (Self             : Live_Packet_Capture_Type;
                                  Promiscuous_Mode : Boolean := True) return Status_Type
     with Pre => Self.Is_Open;

   function Set_Snapshot_Length (Self            : Live_Packet_Capture_Type;
                                 Snapshot_Length : Snapshot_Length_Type := 65535) return Status_Type
     with Pre => Self.Is_Open;

   function Set_Timeout (Self    : Live_Packet_Capture_Type;
                         Timeout : Timeout_Milliseconds_Type) return Status_Type
     with Pre => Self.Is_Open;

   function Set_Timestamp_Precision (Self                : Live_Packet_Capture_Type;
                                     Timestamp_Precision : Timestamp_Precision_Type) return Status_Type
     with Pre => Self.Is_Open;

private

   type Live_Packet_Capture_Type is limited new Abstract_Packet_Capture_Type with null record;

end Pcap.Lib.Live;
