separate (Pcap_Test) procedure Test_Libpcap_Version (Test : in out AUnit.Test_Cases.Test_Case'Class) is
begin
   AUnit.Assertions.Assert (Actual   => Pcap.Pcap_Version,
                            Expected => "OpenBSD libpcap",
                            Message  => "Wrong libpcap version");
end Test_Libpcap_Version;
