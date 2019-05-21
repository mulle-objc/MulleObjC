#! /usr/bin/env bash


find_line()
{
    local lines="$1"
    local search="$2"

    local line

    while read -r line
    do
       [ "${line}" = "${search}" ] && return 0
    done <<< "${lines}"
    return 1
}


lines="`cat`"
find_line "${lines}" "$1"

