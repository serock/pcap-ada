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
with Ada.Exceptions;
with AUnit.Assertions;
with Pcap;
with Pcap.Datalink_Constants;
with Pcap.Exceptions;

package body Pcap_Test is

   overriding function Name (Test : Test_Case_Type) return AUnit.Message_String is
   begin
      return AUnit.Format ("Pcap Tests");
   end Name;

   overriding procedure Register_Tests (Test : in out Test_Case_Type) is
   begin
      AUnit.Test_Cases.Registration.Register_Routine (Test    => Test,
                                                      Routine => Test_Datalink_Name_To_Value'Access,
                                                      Name    => "Test datalink name to value");

      AUnit.Test_Cases.Registration.Register_Routine (Test    => Test,
                                                      Routine => Test_Datalink_Value_To_Description'Access,
                                                      Name    => "Test datalink value to description");

      AUnit.Test_Cases.Registration.Register_Routine (Test    => Test,
                                                      Routine => Test_Datalink_Value_To_Name'Access,
                                                      Name    => "Test datalink value to name");

      AUnit.Test_Cases.Registration.Register_Routine (Test    => Test,
                                                      Routine => Test_Pcap_Ada_Version'Access,
                                                      Name    => "Test Pcap Ada version");

      AUnit.Test_Cases.Registration.Register_Routine (Test    => Test,
                                                      Routine => Test_Pcap_Api_Version'Access,
                                                      Name    => "Test Pcap Api version");

      AUnit.Test_Cases.Registration.Register_Routine (Test    => Test,
                                                      Routine => Test_Libpcap_Version'Access,
                                                      Name    => "Test libpcap version");

      AUnit.Test_Cases.Registration.Register_Routine (Test    => Test,
                                                      Routine => Test_Status_To_String'Access,
                                                      Name    => "Test status to string");

      AUnit.Test_Cases.Registration.Register_Routine (Test    => Test,
                                                      Routine => Test_Strerror'Access,
                                                      Name    => "Test strerror");
   end Register_Tests;

   procedure Test_Datalink_Name_To_Value (Test : in out AUnit.Test_Cases.Test_Case'Class) is
   begin
      AUnit.Assertions.Assert (Actual   => Pcap.Datalink_Name_To_Value (Name => "EN10MB")'Image,
                               Expected => Pcap.Datalink_Constants.DLT_EN10MB'Image,
                               Message  => "Wrong datalink value");

      AUnit.Assertions.Assert (Actual   => Pcap.Datalink_Name_To_Value (Name => "RDS")'Image,
                               Expected => Pcap.Datalink_Constants.DLT_RDS'Image,
                               Message  => "Wrong datalink value");

      declare
         Value : Pcap.Datalink_Type;
      begin
         Value := Pcap.Datalink_Name_To_Value (Name => "DLT_EN10MB");
         AUnit.Assertions.Assert (Condition => False,
                                  Message   => "Expected exception Pcap_Error");
      exception
         when E : Pcap.Exceptions.Pcap_Error =>
            AUnit.Assertions.Assert (Actual   => Ada.Exceptions.Exception_Message (X => E),
                                     Expected => "Invalid argument",
                                     Message  => "Wrong exception message");
      end;
   end Test_Datalink_Name_To_Value;

   procedure Test_Datalink_Value_To_Description (Test : in out AUnit.Test_Cases.Test_Case'Class) is
   begin
      AUnit.Assertions.Assert (Actual   => Pcap.Datalink_Value_To_Description (Value => Pcap.Datalink_Constants.DLT_EN10MB),
                               Expected => "Ethernet",
                               Message  => "Wrong datalink description");

      AUnit.Assertions.Assert (Actual   => Pcap.Datalink_Value_To_Description (Value => Pcap.Datalink_Constants.DLT_RDS),
                               Expected => "IEC 62106 Radio Data System groups",
                               Message  => "Wrong datalink description");
      declare
         Name : String := Pcap.Datalink_Value_To_Description (Value => Pcap.Datalink_Type'Last);
      begin
         AUnit.Assertions.Assert (Condition => False,
                                  Message   => "Expected exception Pcap_Error");
      end;
   exception
      when E : Pcap.Exceptions.Pcap_Error =>
         AUnit.Assertions.Assert (Actual   => Ada.Exceptions.Exception_Message (X => E),
                                  Expected => "Invalid argument",
                                  Message  => "Wrong exception message");
   end Test_Datalink_Value_To_Description;

   procedure Test_Datalink_Value_To_Name (Test : in out AUnit.Test_Cases.Test_Case'Class) is
   begin
      AUnit.Assertions.Assert (Actual   => Pcap.Datalink_Value_To_Name (Value => Pcap.Datalink_Constants.DLT_EN10MB),
                               Expected => "EN10MB",
                               Message  => "Wrong datalink name");

      AUnit.Assertions.Assert (Actual   => Pcap.Datalink_Value_To_Name (Value => Pcap.Datalink_Constants.DLT_RDS),
                               Expected => "RDS",
                               Message  => "Wrong datalink name");
      declare
         Name : String := Pcap.Datalink_Value_To_Name (Value => Pcap.Datalink_Type'Last);
      begin
         AUnit.Assertions.Assert (Condition => False,
                                  Message   => "Expected exception Pcap_Error");
      end;
   exception
      when E : Pcap.Exceptions.Pcap_Error =>
         AUnit.Assertions.Assert (Actual   => Ada.Exceptions.Exception_Message (X => E),
                                  Expected => "Invalid argument",
                                  Message  => "Wrong exception message");
   end Test_Datalink_Value_To_Name;

   procedure Test_Libpcap_Version (Test : in out AUnit.Test_Cases.Test_Case'Class) is
      Version : constant String := Pcap.Pcap_Version;
   begin
      AUnit.Assertions.Assert (Condition => Version'Length > 16 and then Version (1 .. 15) = "libpcap version",
                               Message   => "Version does not start with 'libpcap version'");
   end Test_Libpcap_Version;

   procedure Test_Pcap_Ada_Version (Test : in out AUnit.Test_Cases.Test_Case'Class) is
   begin
      AUnit.Assertions.Assert (Actual   => Pcap.Pcap_Ada_Version,
                               Expected => "1.0.0-dev",
                               Message  => "Wrong Pcap Ada version");
   end Test_Pcap_Ada_Version;

   procedure Test_Pcap_Api_Version (Test : in out AUnit.Test_Cases.Test_Case'Class) is
   begin
      AUnit.Assertions.Assert (Actual   => Pcap.Pcap_Api_Version,
                               Expected => "1.8.1",
                               Message  => "Wrong Pcap Api version");
   end Test_Pcap_Api_Version;

   procedure Test_Status_To_String (Test : in out AUnit.Test_Cases.Test_Case'Class) is
   begin
      AUnit.Assertions.Assert (Actual   => Pcap.Status_To_String (Status => Pcap.PCAP_ERROR),
                               Expected => "Generic error",
                               Message  => "Wrong status string");
      AUnit.Assertions.Assert (Actual   => Pcap.Status_To_String (Status => Pcap.PCAP_ERROR_PROMISC_PERM_DENIED),
                               Expected => "You don't have permission to capture in promiscuous mode on that device",
                               Message  => "Wrong status string");
      AUnit.Assertions.Assert (Actual   => Pcap.Status_To_String (Status => Pcap.PCAP_WARNING),
                               Expected => "Generic warning",
                               Message  => "Wrong status string");
      AUnit.Assertions.Assert (Actual   => Pcap.Status_To_String (Status => Pcap.PCAP_WARNING_TSTAMP_TYPE_NOTSUP),
                               Expected => "That type of time stamp is not supported by that device",
                               Message  => "Wrong status string");
   end Test_Status_To_String;

   procedure Test_Strerror (Test : in out AUnit.Test_Cases.Test_Case'Class) is
   begin
      AUnit.Assertions.Assert (Actual   => Pcap.Strerror (Error => 13),
                               Expected => "Permission denied",
                               Message  => "Wrong error string");
   end Test_Strerror;

end Pcap_Test;
