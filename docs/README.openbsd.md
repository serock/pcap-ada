This was an attempt to get the test harness to build and run on OpenBSD 7.7.
Although it builds, when running the harness, it fails immediately with a SIGABRT.
Neither `egdb` nor `lldb` provided me with any useful information from the `harness.core` file.

# Setup

```
mkdir -p ~/git
cd ~/git
git clone https://github.com/serock/pcap-ada.git
git clone https://github.com/AdaCore/aunit.git
```

# aunit

## Compile

```
export PCAP_ADA_HOME=~/git/pcap-ada
export AUNIT_HOME=~/git/aunit
export AUNIT_SRC_ROOT=$AUNIT_HOME/include/aunit
mkdir -p $AUNIT_HOME/lib/aunit-obj/native-full
mkdir -p $AUNIT_HOME/lib/aunit/native-full
cd $AUNIT_HOME
cd lib/aunit-obj/native-full
export ADA_INCLUDE_PATH=$AUNIT_SRC_ROOT/containers:$AUNIT_SRC_ROOT/framework:$AUNIT_SRC_ROOT/framework/calendar:$AUNIT_SRC_ROOT/framework/fileio:$AUNIT_SRC_ROOT/framework/fullexception:$AUNIT_SRC_ROOT/framework/nativememory:$AUNIT_HOME/include/aunit/reporters
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
ar rc lib/aunit/native-full/libaunit.a lib/aunit-obj/native-full/*.o
cp lib/aunit-obj/native-full/*.ali lib/aunit/native-full
```

# pcap-ada

## Compile

```
mkdir -p ~/git/pcap-ada/obj/release
mkdir -p ~/git/pcap-ada/lib
mkdir -p ~/git/pcap-ada/tests/bin
mkdir -p ~/git/pcap-ada/tests/obj/release
cd $PCAP_ADA_HOME
export ADA_INCLUDE_PATH=src:src/tstamp-openbsd
gnatmake -c -D obj/release -vh -gnatA -O3 -gnatn -ffunction-sections -fdata-sections -gnatW8 -gnateDPCAP_ADA_VERSION=\"1.0.0-dev\" -gnateDPCAP_ADA_OS_KIND=openbsd -gnatep=preprocessor-data.txt -fPIC pcap.adb pcap-datalink_constants.ads
```

## Link

```
egcc -shared -o lib/libpcap-ada.so.1.0.0-dev -L/usr/local/lib/gcc/x86_64-unknown-openbsd/11.2.0/adalib -Wl,-rpath,/usr/local/lib/gcc/x86_64-unknown-openbsd/11.2.0/adalib -Wl,-soname,libpcap-ada.so.1.0.0-dev obj/release/pcap-datalink_constants.o obj/release/pcap-exceptions.o obj/release/pcap.o -lgnat
ln -s lib/libpcap-ada.so.1.0.0-dev lib/libpcap-ada.so
cp obj/release/*.ali lib/
```

# pcap-ada tests

## Compile

```
cd tests/obj/release
export ADA_INCLUDE_PATH=../../../src:$AUNIT_SRC_ROOT/containers:$AUNIT_SRC_ROOT/framework:$AUNIT_SRC_ROOT/framework/calendar:$AUNIT_SRC_ROOT/framework/fileio:$AUNIT_SRC_ROOT/framework/fullexception:$AUNIT_SRC_ROOT/framework/nativememory:$AUNIT_HOME/include/aunit/reporters
egcc -c -gnatA -O3 -gnatn -ffunction-sections -fdata-sections -gnatW8 -gnateDPCAP_ADA_VERSION=\"1.0.0-dev\" -gnateDPCAP_ADA_OS_KIND=openbsd -gnatep=preprocessor-data.txt ../../src/harness.adb
egcc -c -gnatA -O3 -gnatn -ffunction-sections -fdata-sections -gnatW8 -gnateDPCAP_ADA_VERSION=\"1.0.0-dev\" -gnateDPCAP_ADA_OS_KIND=openbsd -gnatep=preprocessor-data.txt ../../src/pcap_ada_test_suite.adb
egcc -c -gnatA -O3 -gnatn -ffunction-sections -fdata-sections -gnatW8 -gnateDPCAP_ADA_VERSION=\"1.0.0-dev\" -gnateDPCAP_ADA_OS_KIND=openbsd -gnatep=preprocessor-data.txt ../../src/pcap_dead_test.adb
egcc -c -gnatA -O3 -gnatn -ffunction-sections -fdata-sections -gnatW8 -gnateDPCAP_ADA_VERSION=\"1.0.0-dev\" -gnateDPCAP_ADA_OS_KIND=openbsd -gnatep=preprocessor-data.txt ../../src/pcap_live_activated_test.adb
egcc -c -gnatA -O3 -gnatn -ffunction-sections -fdata-sections -gnatW8 -gnateDPCAP_ADA_VERSION=\"1.0.0-dev\" -gnateDPCAP_ADA_OS_KIND=openbsd -gnatep=preprocessor-data.txt ../../src/pcap_live_test.adb
egcc -c -gnatA -O3 -gnatn -ffunction-sections -fdata-sections -gnatW8 -gnateDPCAP_ADA_VERSION=\"1.0.0-dev\" -gnateDPCAP_ADA_OS_KIND=openbsd -gnatep=preprocessor-data.txt ../../src/pcap_test.adb
```

## Bind

```
export ADA_OBJECTS_PATH=$AUNIT_HOME/lib/aunit/native-full:../../../lib
gnatbind -shared -o b__harness.adb ./harness.ali -Es -x
egcc -c -gnatA -gnatWb -gnatiw -gnatws -O3 -ffunction-sections -fdata-sections b__harness.adb -o b__harness.o
unset ADA_OBJECTS_PATH
```

## Link

```
egcc harness.o b__harness.o pcap_dead_test.o pcap_live_activated_test.o pcap_live_test.o pcap_test.o pcap_ada_test_suite.o -L../../../lib -L/usr/local/lib/gcc/x86_64-unknown-openbsd/11.2.0/adalib -L$AUNIT_HOME/lib/aunit/native-full -shared-libgcc -lpcap-ada -lpcap -lgnat -launit -Wl,-rpath,$PCAP_ADA_HOME/lib:/usr/local/lib/gcc/x86_64-unknown-openbsd/11.2.0/adalib -o ../../bin/harness
```
