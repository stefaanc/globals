#!/bin/bash

. "$( dirname ${BASH_SOURCE[0]} )/.globals.bash"

#trap 'LASTEXITCODE=$?; echo "trapped error"; exit $LASTEXITCODE' ERR
#trap 'LASTEXITCODE=$?; echo "trapped exit"; exit $LASTEXITCODE' EXIT

echo "### test-globals-1.bash"

echo "### \$GLOBALS_INJECT=$GLOBALS_INJECT"
echo ""

#call "$( dirname ${BASH_SOURCE[0]} )/test-globals-2.bash-xxx" my-param
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
