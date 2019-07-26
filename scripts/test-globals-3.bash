#!/bin/bash

. "$( dirname ${BASH_SOURCE[0]} )/.globals.bash"

echo "### test-globals-3.bash"

echo "### \$GLOBALS_INJECT=$GLOBALS_INJECT"
echo ""

echo "### test-globals-3.bash"
echo "\$1=$1"

global TESTA="\
   $( echo 'test a' )\
   TESTC='test c'\
"
echo "\$TESTA=$TESTA"

sleep 5   # check that $TESTA is written to terminal before this timer expires

global TESTB="test b"
echo "\$TESTB=$TESTB"

echo "\$TESTC=$TESTC"

echo "###"

exit 42