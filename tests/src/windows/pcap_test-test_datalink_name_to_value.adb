separate (Pcap_Test) procedure Test_Datalink_Name_To_Value (Test : in out AUnit.Test_Cases.Test_Case'Class) is
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
