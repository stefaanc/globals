#!/bin/bash
#
# Copyright (c) 2019 Stefaan Coussement
# MIT License
#
# more info: https://github.com/stefaanc/globals
#

if [[ "$GLOBALS_INJECT" != "" ]] ; then 
    # don't re-source, use the exported functions instead
    return
fi

global () {
    # format the command to be able to safely eval it
    # and safely send it over the inject-stream
    local name="$( echo "$1" | sed -e 's/=.*$//' )"
    local value="$( echo "$1" | sed -e 's/^[^=]*=//' )"
    local command="$( printf '%q=%q' "$name" "$value" )"

    # echo -n "#>> \$command=$command"; echo ""   # for debugging

    # define global variable in this environment 
    # and make it available to future child-shells
    eval "export $command"

    if [[ "$GLOBALS_INJECT" != "" ]] ; then
        # inject global variable into the environment of the calling script, 
        # by sending it to the inject-stream of the calling script
        echo "$command" >&$GLOBALS_INJECT
    fi
}
export -f global

call () {
    {   
        local injects="$( 
            # setup an inject-stream, redirecting it to the injects-variable, 
            # and make the inject-stream available to future child-shells
            exec {GLOBALS_INJECT}>&1
            export GLOBALS_INJECT

            # call the requested command, 
            # redirecting its standard output to the alternative-output-stream,
            # to avoid this output ends up in the injects-variable
            bash "$@" 1>&${altout} 

            # add the exit-code from the called command to the injects-variable
            echo "LASTEXITCODE=$?" 
        )"
    } {altout}>&1 # fold alternative-output-stream back into standard-output-stream

    # echo "#>> \$injects=$injects"; echo ""   # for debugging

    while read line ; do
        # create/update the global variable with the value from the injects-item
        global "$line"
    done <<< "$injects"

    (exit $LASTEXITCODE)
}
export -f call
