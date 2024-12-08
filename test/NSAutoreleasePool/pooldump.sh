#! /bin/sh

./pooldump-dot.awk "$1.csv" > "$1.dot" \
&& dot -Tsvg "$1.dot" -o "$1.svg" \
&& xdg-open "$1.svg"

