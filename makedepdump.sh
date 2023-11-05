#!/bin/bash

# print make database without builtin rules and variables
make -nprR "$@" |\
    awk '
BEGIN {
  in_files = 0
  ignore_lines = -1
}
/^# Files/ {
  # ignore before beginning of Files section
  in_files = 1
}
/^# files hash-table stats:/ {
  # ignore after end of Files section
  in_files = 0
}
/^# Not a target:/ {
  # ignore line after `# Not a target:`
  ignore_lines = 1
}

{
  if (in_files && ignore_lines < 0) {
    print
  } else if (ignore_lines >= 0) {
    ignore_lines--
  }
}
' |\
    grep -vE '^#' |\
    # ignore blank lines
    grep -vE '^$' |\
    # select targets
    grep -E '^[a-zA-Z_-]'
