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
with Pcap.Lib;

package body Pcap_Lib_Test is

   overriding function Name (Test : Test_Case_Type) return AUnit.Message_String is
   begin
      return AUnit.Format ("Pcap.Lib Tests");
   end Name;

   overriding procedure Register_Tests (Test : in out Test_Case_Type) is
   begin
      AUnit.Test_Cases.Registration.Register_Routine (Test    => Test,
                                                      Routine => Test_Pcap_Ada_Version'Access,
                                                      Name    => "Test Pcap Ada version");

      AUnit.Test_Cases.Registration.Register_Routine (Test    => Test,
                                                      Routine => Test_Pcap_Api_Version'Access,
                                                      Name    => "Test Pcap Api version");

      AUnit.Test_Cases.Registration.Register_Routine (Test    => Test,
                                                      Routine => Test_Libpcap_Version'Access,
                                                      Name    => "Test libpcap version");
   end Register_Tests;

   procedure Test_Pcap_Ada_Version (Test : in out AUnit.Test_Cases.Test_Case'Class) is
   begin
      AUnit.Assertions.Assert (Actual   => Pcap.Lib.Pcap_Ada_Version,
                               Expected => "1.0.0-dev",
                               Message  => "Wrong Pcap Ada version");
   end Test_Pcap_Ada_Version;

   procedure Test_Pcap_Api_Version (Test : in out AUnit.Test_Cases.Test_Case'Class) is
   begin
      AUnit.Assertions.Assert (Actual   => Pcap.Lib.Pcap_Api_Version,
                               Expected => "1.8.1",
                               Message  => "Wrong Pcap Api version");
   end Test_Pcap_Api_Version;

   procedure Test_Libpcap_Version (Test : in out AUnit.Test_Cases.Test_Case'Class) is
      Version : constant String := Pcap.Lib.Pcap_Version;
   begin
      AUnit.Assertions.Assert (Condition => Version'Length > 16 and then Version (1 .. 15) = "libpcap version",
                               Message   => "Version does not start with 'libpcap version'");
   end Test_Libpcap_Version;

end Pcap_Lib_Test;
