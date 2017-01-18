#! /usr/bin/bash

extensions="c h"
excluded="./lib/* ./platform/win32/*"

lines=0

is_excluded()
{
    for pattern in $excluded; do
        if [ $pattern = $1 ]; then
            echo YES
            return
        fi
    done
    echo NO
}

for ex in $extensions; do
    for src in `find . -name "*.$ex"`; do
        if [ `is_excluded $src` = "NO" ]; then
            echo $src
            lines=$((lines+`wc -l  $src|awk '{print $1}'`))
        fi
    done
done
