separate (Pcap_Test) procedure Test_Datalink_Value_To_Name (Test : in out AUnit.Test_Cases.Test_Case'Class) is
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
