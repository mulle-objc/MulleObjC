#! /usr/bin/env bash


find_line()
{
    local lines="$1"
    local search="$2"

    fgrep -x -s -q -e "${search}" <<< "${lines}"
}


lines="`cat`"
find_line "${lines}" "$1"

