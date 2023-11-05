#!/bin/bash

set -e

d=$(cd $(dirname $0)/..; pwd)
dumpsh="${d}/makedepdump.sh"

result="$(mktemp)"
find "${d}/tests" -type d | grep -v "tests$" | while read testcase ; do
    "$dumpsh" -C "$testcase" | sort > "$result"
    diff -u "${testcase}/want" "$result"
done
