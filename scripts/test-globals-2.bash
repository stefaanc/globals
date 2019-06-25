#!/bin/bash

# . ./.globals.bash

echo "### test-globals-2.bash"

echo "### \$GLOBALS_INJECT=$GLOBALS_INJECT"
echo ""

call ./test-globals-3.bash $1
echo "\$?=$?"
echo ""

echo "### test-globals-2.bash"
echo "\$1=$1"
echo "\$LASTEXITCODE=$LASTEXITCODE"
echo "\$TESTA=$TESTA"
echo "\$TESTB=$TESTB"
echo "\$TESTC=$TESTC"
echo "###"

exit $LASTEXITCODE
