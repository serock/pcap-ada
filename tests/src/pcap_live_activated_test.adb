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
with AUnit.Assertions;
with Pcap;
with Pcap.Datalink_Constants;

package body Pcap_Live_Activated_Test is

   Packet_Capture : Pcap.Packet_Capture_Type;

   overriding function Name (Test : Test_Case_Type) return AUnit.Message_String is
   begin
      return AUnit.Format ("Pcap Live Activated Packet Capture Tests");
   end Name;

   overriding procedure Register_Tests (Test : in out Test_Case_Type) is
   begin
      AUnit.Test_Cases.Registration.Register_Routine (Test    => Test,
                                                      Routine => Test_Datalink'Access,
                                                      Name    => "Test datalink");

   end Register_Tests;

   overriding procedure Set_Up (Test : in out Test_Case_Type) is
      Devices        : Pcap.Devices_Type;
      Warning        : Pcap.Warning_Text_Type;
      Warning_Length : Pcap.Warning_Text_Length_Type;
   begin
      Devices.Find_All;
      if Devices.Has_Device then
         Packet_Capture.Open_Live (Device              => Devices.Device.Name,
                                   Read_Timeout        => 2000,
                                   Warning_Text        => Warning,
                                   Warning_Text_Length => Warning_Length);
      end if;
   end Set_Up;

   overriding procedure Tear_Down (Test : in out Test_Case_Type) is
   begin
      Packet_Capture.Close;
   end Tear_Down;

   procedure Test_Datalink (Test : in out AUnit.Test_Cases.Test_Case'Class) is
   begin
      AUnit.Assertions.Assert (Actual   => Pcap.Datalink_Value_To_Name (Value => Packet_Capture.Datalink),
                               Expected => Pcap.Datalink_Value_To_Name (Value => Pcap.Datalink_Constants.DLT_EN10MB),
                               Message  => "Wrong datalink");
   end Test_Datalink;

end Pcap_Live_Activated_Test;
