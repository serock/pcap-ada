# aunit

## Compile

```
cd ~/git
git clone https://github.com/AdaCore/aunit.git
export AUNIT_HOME=~/git/aunit
export AUNIT_SRC_ROOT=$AUNIT_HOME/include/aunit
export ADA_INCLUDE_PATH=$AUNIT_SRC_ROOT/containers:$AUNIT_SRC_ROOT/framework:$AUNIT_SRC_ROOT/framework/calendar:$AUNIT_SRC_ROOT/framework/fileio:$AUNIT_SRC_ROOT/framework/fullexception:$AUNIT_SRC_ROOT/framework/nativememory:$AUNIT_HOME/include/aunit/reporters
cd aunit
mkdir -p lib/aunit-obj/native-full
cd lib/aunit-obj/native-full
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X $AUNIT_SRC_ROOT/framework/fileio/aunit-io.ads
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X $AUNIT_SRC_ROOT/framework/nativememory/aunit-memory.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X $AUNIT_SRC_ROOT/framework/nativememory/aunit-memory-utils.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X $AUNIT_SRC_ROOT/framework/calendar/aunit-time_measure.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X $AUNIT_SRC_ROOT/reporters/aunit-reporter-text.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X $AUNIT_SRC_ROOT/reporters/aunit-reporter-gnattest.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X $AUNIT_SRC_ROOT/reporters/aunit-reporter-junit.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X $AUNIT_SRC_ROOT/reporters/aunit-reporter-xml.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X $AUNIT_SRC_ROOT/containers/ada_containers-aunit_lists.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X $AUNIT_SRC_ROOT/containers/ada_containers.ads
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X -fno-strict-aliasing $AUNIT_SRC_ROOT/framework/aunit.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X $AUNIT_SRC_ROOT/framework/aunit-test_cases.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X $AUNIT_SRC_ROOT/framework/aunit-test_caller.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X $AUNIT_SRC_ROOT/framework/aunit-test_fixtures.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X $AUNIT_SRC_ROOT/framework/aunit-test_suites.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X $AUNIT_SRC_ROOT/framework/aunit-simple_test_cases.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X $AUNIT_SRC_ROOT/framework/aunit-assertions.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X $AUNIT_SRC_ROOT/framework/aunit-tests.ads
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X $AUNIT_SRC_ROOT/framework/aunit-run.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X $AUNIT_SRC_ROOT/framework/aunit-test_results.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X $AUNIT_SRC_ROOT/framework/aunit-test_filters.adb
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X $AUNIT_SRC_ROOT/framework/aunit-options.ads
egcc -c -x ada -gnatA -O2 -gnatp -gnatn -gnatwa.X $AUNIT_SRC_ROOT/framework/aunit-reporter.adb
cd -
```

## Create archive

```
mkdir -p lib/aunit/native-full
ar rc lib/aunit/native-full/libaunit.a lib/aunit-obj/native-full/*.o
rm lib/aunit-obj/native-full/*.o
chmod -w lib/aunit-obj/native-full/*.ali
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
egcc -c -gnatA -O3 -gnatn -ffunction-sections -fdata-sections -gnatW8 -gnateDPCAP_ADA_VERSION=\"1.0.0-dev\" -gnateDPCAP_ADA_OS_KIND=openbsd -gnatep=../../../src/preprocessor-data.txt ../../src/harness.adb
egcc -c -gnatA -O3 -gnatn -ffunction-sections -fdata-sections -gnatW8 -gnateDPCAP_ADA_VERSION=\"1.0.0-dev\" -gnateDPCAP_ADA_OS_KIND=openbsd -gnatep=../../../src/preprocessor-data.txt ../../src/pcap_ada_test_suite.adb
egcc -c -I ../../../src -gnatA -O3 -gnatn -ffunction-sections -fdata-sections -gnatW8 -gnateDPCAP_ADA_VERSION=\"1.0.0-dev\" -gnateDPCAP_ADA_OS_KIND=openbsd -gnatep=../../../src/preprocessor-data.txt ../../src/pcap_dead_test.adb
egcc -c -I ../../../src -gnatA -O3 -gnatn -ffunction-sections -fdata-sections -gnatW8 -gnateDPCAP_ADA_VERSION=\"1.0.0-dev\" -gnateDPCAP_ADA_OS_KIND=openbsd -gnatep=../../../src/preprocessor-data.txt ../../src/pcap_live_activated_test.adb
egcc -c -I src -I ../src -gnatA -O3 -gnatn -ffunction-sections -fdata-sections -gnatW8 -gnateDPCAP_ADA_VERSION=\"1.0.0-dev\" -gnateDPCAP_ADA_OS_KIND=openbsd -gnatep=../../../src/preprocessor-data.txt ../../src/pcap_live_test.adb
egcc -c -I src -I ../src -gnatA -O3 -gnatn -ffunction-sections -fdata-sections -gnatW8 -gnateDPCAP_ADA_VERSION=\"1.0.0-dev\" -gnateDPCAP_ADA_OS_KIND=openbsd -gnatep=../../../src/preprocessor-data.txt ../../src/pcap_test.adb
```
