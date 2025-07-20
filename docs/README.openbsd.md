# aunit

## Compile

```
git clone https://github.com/AdaCore/aunit.git
cd aunit
mkdir -p lib/aunit-obj/native-full
gnatmake -c -D lib/aunit-obj/native-full -vh -aIsrc/include/aunit -gnatA -O2 -gnatp -gnatn -gnatwa.X framework/fileio/aunit-io.ads
gnatmake -c -D lib/aunit-obj/native-full -vh -aIsrc/include/aunit -gnatA -O2 -gnatp -gnatn -gnatwa.X framework/nativememory/aunit-memory.adb
gnatmake -c -D lib/aunit-obj/native-full -vh -aIsrc/include/aunit -gnatA -O2 -gnatp -gnatn -gnatwa.X framework/nativememory/aunit-memory-utils.adb
gnatmake -c -D lib/aunit-obj/native-full -vh -aIsrc/include/aunit -gnatA -O2 -gnatp -gnatn -gnatwa.X framework/calendar/aunit-time_measure.adb
gnatmake -c -D lib/aunit-obj/native-full -vh -aIsrc/include/aunit -gnatA -O2 -gnatp -gnatn -gnatwa.X reporters/aunit-reporter-text.adb
gnatmake -c -D lib/aunit-obj/native-full -vh -aIsrc/include/aunit -gnatA -O2 -gnatp -gnatn -gnatwa.X reporters/aunit-reporter-gnattest.adb
gnatmake -c -D lib/aunit-obj/native-full -vh -aIsrc/include/aunit -gnatA -O2 -gnatp -gnatn -gnatwa.X reporters/aunit-reporter-junit.adb
gnatmake -c -D lib/aunit-obj/native-full -vh -aIsrc/include/aunit -gnatA -O2 -gnatp -gnatn -gnatwa.X reporters/aunit-reporter-xml.adb
gnatmake -c -D lib/aunit-obj/native-full -vh -aIsrc/include/aunit -gnatA -O2 -gnatp -gnatn -gnatwa.X containers/ada_containers-aunit_lists.adb
gnatmake -c -D lib/aunit-obj/native-full -vh -aIsrc/include/aunit -gnatA -O2 -gnatp -gnatn -gnatwa.X containers/ada_containers.ads
gnatmake -c -D lib/aunit-obj/native-full -vh -aIsrc/include/aunit -gnatA -O2 -gnatp -gnatn -gnatwa.X -fno-strict-aliasing framework/aunit.adb
gnatmake -c -D lib/aunit-obj/native-full -vh -aIsrc/include/aunit -gnatA -O2 -gnatp -gnatn -gnatwa.X framework/aunit-test_cases.adb
gnatmake -c -D lib/aunit-obj/native-full -vh -aIsrc/include/aunit -gnatA -O2 -gnatp -gnatn -gnatwa.X framework/aunit-test_caller.adb
gnatmake -c -D lib/aunit-obj/native-full -vh -aIsrc/include/aunit -gnatA -O2 -gnatp -gnatn -gnatwa.X framework/aunit-test_fixtures.adb
gnatmake -c -D lib/aunit-obj/native-full -vh -aIsrc/include/aunit -gnatA -O2 -gnatp -gnatn -gnatwa.X framework/aunit-test_suites.adb
gnatmake -c -D lib/aunit-obj/native-full -vh -aIsrc/include/aunit -gnatA -O2 -gnatp -gnatn -gnatwa.X framework/aunit-simple_test_cases.adb
gnatmake -c -D lib/aunit-obj/native-full -vh -aIsrc/include/aunit -gnatA -O2 -gnatp -gnatn -gnatwa.X framework/aunit-assertions.adb
gnatmake -c -D lib/aunit-obj/native-full -vh -aIsrc/include/aunit -gnatA -O2 -gnatp -gnatn -gnatwa.X framework/aunit-tests.ads
gnatmake -c -D lib/aunit-obj/native-full -vh -aIsrc/include/aunit -gnatA -O2 -gnatp -gnatn -gnatwa.X framework/aunit-run.adb
gnatmake -c -D lib/aunit-obj/native-full -vh -aIsrc/include/aunit -gnatA -O2 -gnatp -gnatn -gnatwa.X framework/aunit-test_results.adb
gnatmake -c -D lib/aunit-obj/native-full -vh -aIsrc/include/aunit -gnatA -O2 -gnatp -gnatn -gnatwa.X framework/aunit-test_filters.adb
gnatmake -c -D lib/aunit-obj/native-full -vh -aIsrc/include/aunit -gnatA -O2 -gnatp -gnatn -gnatwa.X framework/aunit-options.ads
gnatmake -c -D lib/aunit-obj/native-full -vh -aIsrc/include/aunit -gnatA -O2 -gnatp -gnatn -gnatwa.X framework/aunit-reporter.adb
```

## Create archive

```
ar cr lib/aunit/native-full/libaunit.a lib/aunit-obj/native-full/ada_containers-aunit_lists.o lib/aunit-obj/native-full/ada_containers.o lib/aunit-obj/native-full/aunit-assertions.o lib/aunit-obj/native-full/aunit-io.o lib/aunit-obj/native-full/aunit-memory-utils.o lib/aunit-obj/native-full/aunit-memory.o lib/aunit-obj/native-full/aunit-options.o lib/aunit-obj/native-full/aunit-reporter-gnattest.o lib/aunit-obj/native-full/aunit-reporter-junit.o lib/aunit-obj/native-full/aunit-reporter-text.o lib/aunit-obj/native-full/aunit-reporter-xml.o lib/aunit-obj/native-full/aunit-reporter.o lib/aunit-obj/native-full/aunit-run.o lib/aunit-obj/native-full/aunit-simple_test_cases.o lib/aunit-obj/native-full/aunit-test_caller.o lib/aunit-obj/native-full/aunit-test_cases.o lib/aunit-obj/native-full/aunit-test_filters.o lib/aunit-obj/native-full/aunit-test_fixtures.o lib/aunit-obj/native-full/aunit-test_results.o lib/aunit-obj/native-full/aunit-test_suites.o lib/aunit-obj/native-full/aunit-tests.o lib/aunit-obj/native-full/aunit-time_measure.o lib/aunit-obj/native-full/aunit.o
ranlib lib/aunit/native-full/libaunit.a
```

# pcap-ada

## Compile

```
mkdir -p obj/release
gnatmake -c -D obj/release -vh -aIsrc -gnatA -O3 -gnatn -ffunction-sections -fdata-sections -gnatW8 -gnateDPCAP_ADA_VERSION=\"1.0.0-dev\" -gnateDPCAP_ADA_OS_KIND=openbsd -gnatep=preprocessor-data.txt -fPIC pcap.adb pcap-datalink_constants.ads
```

## Link

```
mkdir -p lib
egcc -shared -o lib/libpcap-ada.so.1.0.0-dev -L/usr/local/lib/gcc/x86_64-unknown-openbsd/11.2.0/adalib -Wl,-rpath,/usr/local/lib/gcc/x86_64-unknown-openbsd/11.2.0/adalib -Wl,-soname,libpcap-ada.so.1.0.0-dev obj/release/pcap-datalink_constants.o obj/release/pcap-exceptions.o obj/release/pcap.o -lgnat
```

# pcap-ada tests

## Compile

```
cd tests
mkdir -p obj/release
mkdir -p bin
gnatmake -c -D obj/release -vh -aIsrc -gnatA -O3 -gnatn -ffunction-sections -fdata-sections -gnatW8 -gnateDPCAP_ADA_VERSION=\"1.0.0-dev\" -gnateDPCAP_ADA_OS_KIND=openbsd -gnatep=preprocessor-data.txt harness.adb
gnatmake -c -D obj/release -vh -aIsrc -gnatA -O3 -gnatn -ffunction-sections -fdata-sections -gnatW8 -gnateDPCAP_ADA_VERSION=\"1.0.0-dev\" -gnateDPCAP_ADA_OS_KIND=openbsd -gnatep=preprocessor-data.txt pcap_ada_test_suite.adb
gnatmake -c -D obj/release -vh -aIsrc -gnatA -O3 -gnatn -ffunction-sections -fdata-sections -gnatW8 -gnateDPCAP_ADA_VERSION=\"1.0.0-dev\" -gnateDPCAP_ADA_OS_KIND=openbsd -gnatep=preprocessor-data.txt pcap_dead_test.adb
gnatmake -c -D obj/release -vh -aIsrc -gnatA -O3 -gnatn -ffunction-sections -fdata-sections -gnatW8 -gnateDPCAP_ADA_VERSION=\"1.0.0-dev\" -gnateDPCAP_ADA_OS_KIND=openbsd -gnatep=preprocessor-data.txt pcap_live_activated_test.adb
gnatmake -c -D obj/release -vh -aIsrc -gnatA -O3 -gnatn -ffunction-sections -fdata-sections -gnatW8 -gnateDPCAP_ADA_VERSION=\"1.0.0-dev\" -gnateDPCAP_ADA_OS_KIND=openbsd -gnatep=preprocessor-data.txt pcap_live_test.adb
gnatmake -c -D obj/release -vh -aIsrc -gnatA -O3 -gnatn -ffunction-sections -fdata-sections -gnatW8 -gnateDPCAP_ADA_VERSION=\"1.0.0-dev\" -gnateDPCAP_ADA_OS_KIND=openbsd -gnatep=preprocessor-data.txt pcap_test.adb

```
