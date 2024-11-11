#!/bin/sh

# Bash does not understand floating point numbers
float_val="3.2"
echo ${float_val:0:1}
if [ ${float_val:0:1} -gt "2" ]; then
  echo greater
else
  echo less or equal
fi
