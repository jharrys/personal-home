#!/bin/sh
# looks for regular files that contain the UTF-8 Byte Order Mark (BOM)
# BOM describes endianness of file - which doesn't make sense for UTF-8
find . $1 -type f -print0 | xargs -0 awk '/^\xEF\xBB\xBF/ {print FILENAME}{nextfile}'

