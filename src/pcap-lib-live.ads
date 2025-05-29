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
with Pcap.Error_Buffer;

package Pcap.Lib.Live is

   type Buffer_Size_Type is new Positive;

   type Datalinks_Type is array (Integer range <>) of Datalink_Type;

   type Direction_Type is (DIRECTION_IN_OUT, DIRECTION_IN, DIRECTION_OUT);

   type Snapshot_Length_Type is new Positive;

   type Timeout_Milliseconds_Type is new Positive;

   type Live_Packet_Capture_Type is limited new Abstract_Base_Packet_Capture_Type with private;

   function Is_Activated (Self : Live_Packet_Capture_Type) return Boolean;

   function Is_Not_Activated (Self : Live_Packet_Capture_Type) return Boolean;

   procedure Activate (Self : in out Live_Packet_Capture_Type)
     with Pre => Self.Is_Open and then not Self.Is_Activated;

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

   overriding function Datalink (Self : in out Live_Packet_Capture_Type) return Datalink_Type
     with Pre => Self.Is_Open and then Self.Is_Activated;

   procedure List_Datalinks (Self      : in out Live_Packet_Capture_Type;
                             Datalinks :    out Datalinks_Type);

   procedure Set_Buffer_Size (Self        : in out Live_Packet_Capture_Type;
                              Buffer_Size :        Buffer_Size_Type)
     with Pre => Self.Is_Open and then Self.Is_Not_Activated;

   procedure Set_Datalink (Self     : in out Live_Packet_Capture_Type;
                           Datalink :        Datalink_Type)
     with Pre => Self.Is_Open and then Self.Is_Activated;

   procedure Set_Direction (Self      : in out Live_Packet_Capture_Type;
                            Direction :        Direction_Type)
     with Pre => Self.Is_Open and then Self.Is_Activated;

   procedure Set_Immediate_Mode (Self           : in out Live_Packet_Capture_Type;
                                 Immediate_Mode :        Boolean := True)
     with Pre => Self.Is_Open and then Self.Is_Not_Activated;

   procedure Set_Monitor_Mode (Self         : in out Live_Packet_Capture_Type;
                               Monitor_Mode :        Boolean := True)
     with Pre => Self.Is_Open and then Self.Is_Not_Activated;

   procedure Set_Promiscuous_Mode (Self             : in out Live_Packet_Capture_Type;
                                   Promiscuous_Mode :        Boolean := True)
     with Pre => Self.Is_Open and then Self.Is_Not_Activated;

   procedure Set_Snapshot_Length (Self            : in out Live_Packet_Capture_Type;
                                  Snapshot_Length :        Snapshot_Length_Type := 65535)
     with Pre => Self.Is_Open and then Self.Is_Not_Activated;

   procedure Set_Timeout (Self    : in out Live_Packet_Capture_Type;
                          Timeout :        Timeout_Milliseconds_Type)
     with Pre => Self.Is_Open and then Self.Is_Not_Activated;

   procedure Set_Timestamp_Precision (Self                : in out Live_Packet_Capture_Type;
                                      Timestamp_Precision :        Timestamp_Precision_Type)
     with Pre => Self.Is_Open and then Self.Is_Not_Activated;

   procedure Set_Timestamp_Type (Self           : in out Live_Packet_Capture_Type;
                                 Timestamp_Type :        Timestamp_Type_Type)
     with Pre => Self.Is_Open and then Self.Is_Not_Activated;

private

   type Live_Packet_Capture_Type is limited new Abstract_Base_Packet_Capture_Type with
      record
         Activated : Boolean := False;
      end record;

   function Is_Activated (Self : Live_Packet_Capture_Type) return Boolean is (Self.Activated);

   function Is_Not_Activated (Self : Live_Packet_Capture_Type) return Boolean is (not Self.Activated);

end Pcap.Lib.Live;
