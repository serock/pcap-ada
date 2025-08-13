separate (Pcap_Test) procedure Test_Libpcap_Version (Test : in out AUnit.Test_Cases.Test_Case'Class) is
   Version : constant String := Pcap.Pcap_Version;
begin
   AUnit.Assertions.Assert (Condition => Version'Length > 15 and then Version (1 .. 15) = "libpcap version",
                            Message   => "Wrong libpcap version");
end Test_Libpcap_Version;
