#!/bin/bash

. "$( dirname ${BASH_SOURCE[0]} )/.globals.bash"

echo "### test-globals-1.bash"

echo "### \$GLOBALS_INJECT=$GLOBALS_INJECT"
echo ""

call "$( dirname ${BASH_SOURCE[0]} )/test-globals-2.bash" my-param
echo "\$?=$?"
echo ""

echo "### test-globals-1.bash"
echo "\$LASTEXITCODE=$LASTEXITCODE"
echo "\$TESTA=$TESTA"
echo "\$TESTB=$TESTB"
echo "\$TESTC=$TESTC"
echo "###"

exit $LASTEXITCODE
