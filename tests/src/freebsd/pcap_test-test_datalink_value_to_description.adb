separate (Pcap_Test) procedure Test_Datalink_Value_To_Description (Test : in out AUnit.Test_Cases.Test_Case'Class) is
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
