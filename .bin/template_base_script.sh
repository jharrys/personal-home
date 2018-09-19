#!/bin/bash

# by Johnnie Harris
# XX/YY/ZZZZ
#
# What
# Why

usage() {
  echo "usage: `basename $0` [-h] [-f] [-w argument]"
  echo
  echo "-h this usage message"
  echo "-f fake option without arg"
  echo "-w fake option with arg"
}

aFunction() {
  echo "aFunction was called because you provided the -f option"
}

# start executing after functions
#if [ $# -lt 1 ];
#then
#  usage
#  exit 1
#fi

if ( ! getopts ":fhw:" opt); then
  usage
  exit $E_OPTERROR;
fi

# parse options - the first ":" tells getopts we'll handle the errs
while getopts ":fhw:" opt; do
  case $opt in
    f)
      fakeOptionWithoutArgument=1
      ;;
    w)
      withArgument=$OPTARG
      ;;
    h)
      usage $0
      exit 1
      ;;
    \?)
      echo "not an option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "-$OPTARG needs an arg" >&2
      exit 1
      ;;
  esac
done

if [ -n "$fakeOptionWithoutArgument" ];
then
  aFunction
else
  echo "no -f option supplied, plain jane execution"
fi

[ -n "$withArgument" ] && echo "argument to -w was $withArgument"
