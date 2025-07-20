# aunit

## Mapping file

```
ada_containers%s
ada_containers.ads
../../../include/aunit/containers/ada_containers.ads
ada_containers.aunit_lists%b
ada_containers-aunit_lists.adb
../../../include/aunit/containers/ada_containers-aunit_lists.adb
ada_containers.aunit_lists%s
ada_containers-aunit_lists.ads
../../../include/aunit/containers/ada_containers-aunit_lists.ads
aunit%b
aunit.adb
../../../include/aunit/framework/aunit.adb
aunit%s
aunit.ads
../../../include/aunit/framework/aunit.ads
aunit.assertions%b
aunit-assertions.adb
../../../include/aunit/framework/aunit-assertions.adb
aunit.assertions%s
aunit-assertions.ads
../../../include/aunit/framework/aunit-assertions.ads
aunit.memory%s
aunit-memory.ads
../../../include/aunit/framework/aunit-memory.ads
aunit.memory.utils%s
aunit-memory-utils.ads
../../../include/aunit/framework/aunit-memory-utils.ads
aunit.options%s
aunit-options.ads
../../../include/aunit/framework/aunit-options.ads
aunit.reporter%b
aunit-reporter.adb
../../../include/aunit/framework/aunit-reporter.adb
aunit.reporter%s
aunit-reporter.ads
../../../include/aunit/framework/aunit-reporter.ads
aunit.run%b
aunit-run.adb
../../../include/aunit/framework/aunit-run.adb
aunit.run%s
aunit-run.ads
../../../include/aunit/framework/aunit-run.ads
aunit.simple_test_cases%b
aunit-simple_test_cases.adb
../../../include/aunit/framework/aunit-simple_test_cases.adb
aunit.simple_test_cases%s
aunit-simple_test_cases.ads
../../../include/aunit/framework/aunit-simple_test_cases.ads
aunit.test_caller%b
aunit-test_caller.adb
../../../include/aunit/framework/aunit-test_caller.adb
aunit.test_caller%s
aunit-test_caller.ads
../../../include/aunit/framework/aunit-test_caller.ads
aunit.test_cases%b
aunit-test_cases.adb
../../../include/aunit/framework/aunit-test_cases.adb
aunit.test_cases%s
aunit-test_cases.ads
../../../include/aunit/framework/aunit-test_cases.ads
aunit.test_cases.registration%b
aunit-test_cases-registration.adb
../../../include/aunit/framework/aunit-test_cases-registration.adb
aunit.test_filters%b
aunit-test_filters.adb
../../../include/aunit/framework/aunit-test_filters.adb
aunit.test_filters%s
aunit-test_filters.ads
../../../include/aunit/framework/aunit-test_filters.ads
aunit.test_fixtures%b
aunit-test_fixtures.adb
../../../include/aunit/framework/aunit-test_fixtures.adb
aunit.test_fixtures%s
aunit-test_fixtures.ads
../../../include/aunit/framework/aunit-test_fixtures.ads
aunit.test_results%b
aunit-test_results.adb
../../../include/aunit/framework/aunit-test_results.adb
aunit.test_results%s
aunit-test_results.ads
../../../include/aunit/framework/aunit-test_results.ads
aunit.tests%s
aunit-tests.ads
../../../include/aunit/framework/aunit-tests.ads
aunit.test_suites%b
aunit-test_suites.adb
../../../include/aunit/framework/aunit-test_suites.adb
aunit.test_suites%s
aunit-test_suites.ads
../../../include/aunit/framework/aunit-test_suites.ads
aunit.time_measure%b
aunit-time_measure.adb
../../../include/aunit/framework/calendar/aunit-time_measure.adb
aunit.time_measure%s
aunit-time_measure.ads
../../../include/aunit/framework/calendar/aunit-time_measure.ads
aunit.io%s
aunit-io.ads
../../../include/aunit/framework/fileio/aunit-io.ads
aunit.memory%b
aunit-memory.adb
../../../include/aunit/framework/nativememory/aunit-memory.adb
aunit.memory.utils%b
aunit-memory-utils.adb
../../../include/aunit/framework/nativememory/aunit-memory-utils.adb
aunit.reporter.gnattest%b
aunit-reporter-gnattest.adb
../../../include/aunit/reporters/aunit-reporter-gnattest.adb
aunit.reporter.gnattest%s
aunit-reporter-gnattest.ads
../../../include/aunit/reporters/aunit-reporter-gnattest.ads
aunit.reporter.junit%b
aunit-reporter-junit.adb
../../../include/aunit/reporters/aunit-reporter-junit.adb
aunit.reporter.junit%s
aunit-reporter-junit.ads
../../../include/aunit/reporters/aunit-reporter-junit.ads
aunit.reporter.text%b
aunit-reporter-text.adb
../../../include/aunit/reporters/aunit-reporter-text.adb
aunit.reporter.text%s
aunit-reporter-text.ads
../../../include/aunit/reporters/aunit-reporter-text.ads
aunit.reporter.xml%b
aunit-reporter-xml.adb
../../../include/aunit/reporters/aunit-reporter-xml.adb
aunit.reporter.xml%s
aunit-reporter-xml.ads
../../../include/aunit/reporters/aunit-reporter-xml.ads
```

## Compile

```
git clone https://github.com/AdaCore/aunit.git
cd aunit
mkdir -p lib/aunit-obj/native-full
cd lib/aunit-obj/native-full
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X -gnatem=../../../map.txt ../../../include/aunit/framework/fileio/aunit-io.ads
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X -gnatem=../../../map.txt ../../../include/aunit/framework/nativememory/aunit-memory.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X -gnatem=../../../map.txt ../../../include/aunit/framework/nativememory/aunit-memory-utils.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X -gnatem=../../../map.txt ../../../include/aunit/framework/calendar/aunit-time_measure.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X -gnatem=../../../map.txt ../../../include/aunit/reporters/aunit-reporter-text.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X -gnatem=../../../map.txt ../../../include/aunit/reporters/aunit-reporter-gnattest.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X -gnatem=../../../map.txt ../../../include/aunit/reporters/aunit-reporter-junit.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X -gnatem=../../../map.txt ../../../include/aunit/reporters/aunit-reporter-xml.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X -gnatem=../../../map.txt ../../../include/aunit/containers/ada_containers-aunit_lists.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X -gnatem=../../../map.txt ../../../include/aunit/containers/ada_containers.ads
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X -fno-strict-aliasing -gnatem=../../../map.txt ../../../include/aunit/framework/aunit.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X -gnatem=../../../map.txt ../../../include/aunit/framework/aunit-test_cases.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X -gnatem=../../../map.txt ../../../include/aunit/framework/aunit-test_caller.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X -gnatem=../../../map.txt ../../../include/aunit/framework/aunit-test_fixtures.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X -gnatem=../../../map.txt ../../../include/aunit/framework/aunit-test_suites.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X -gnatem=../../../map.txt ../../../include/aunit/framework/aunit-simple_test_cases.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X -gnatem=../../../map.txt ../../../include/aunit/framework/aunit-assertions.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X -gnatem=../../../map.txt ../../../include/aunit/framework/aunit-tests.ads
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X -gnatem=../../../map.txt ../../../include/aunit/framework/aunit-run.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X -gnatem=../../../map.txt ../../../include/aunit/framework/aunit-test_results.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X -gnatem=../../../map.txt ../../../include/aunit/framework/aunit-test_filters.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X -gnatem=../../../map.txt ../../../include/aunit/framework/aunit-options.ads
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X -gnatem=../../../map.txt ../../../include/aunit/framework/aunit-reporter.adb

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
