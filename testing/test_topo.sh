#!/bin/bash

source testing/test_preamble.sh

echo Topology Tests >> $TEST_RESULTS

echo mudacl tests | tee -a $TEST_RESULTS
mudacl/bin/test.sh
echo Mudacl exit code $? | tee -a $TEST_RESULTS

bacnet_file='$TEST_ROOT/tmp/bacnet_result.txt'
socket_file='$TEST_ROOT/tmp/socket_result.txt'

MAC_BASE=9a:02:57:1e:8f

source testing/test_utils.sh

echo Creating MUD templates...
bin/mudacl

generate open 3
cmd/build missing
check_socket 01 02 1 1
check_socket 02 01 1 1
check_bacnet 01 02 1 1 1 1
check_bacnet 02 03 1 1 1 1
check_bacnet 03 01 1 1 1 1
run_test 3

generate minimal 3
check_bacnet 01 02 1 1 1 1
check_bacnet 02 03 0 1 1 1
check_bacnet 03 01 1 1 1 1
run_test 3

generate commissioning 4
check_socket 01 04 0 0
check_socket 01 02 0 0
check_socket 04 01 0 0
check_bacnet 01 02 1 1 1 1
check_bacnet 01 04 1 1 1 1
check_bacnet 02 03 0 1 1 1
check_bacnet 02 04 1 1 1 1
check_bacnet 03 01 1 1 1 1
run_test 4

echo Done with tests | tee -a $TEST_RESULTS
