#!/bin/bash

usage() {
  echo "usage: `basename $0` [-s]"
  echo
  echo "-s will sort the output on the Month field first and then the day field"
}

function getBranches() {
  for x in $(git branch -r |grep -v "HEAD\|master")
  do
    meta=()
    while IFS=  read -r line; do
      line=$(echo $line |sed 's/.*\<\(..*\)\>/\1/')
      meta+=( "$line" )
    done < <( git --no-pager log -1 $x |sed -n -E /Author\|Date/p )
    printf "%s\t%s\t%s\n" "$x" "${meta[0]}" "${meta[1]}"
  done
}

#if ( ! getopts ":sh" opt); then
#  usage
#  exit $E_OPTERROR;
#fi

while getopts ":sh" opt; do
  case $opt in
    s)
      optSorted=1
      ;;
    h)
      usage
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

if [ -n "$optSorted" ];
then
  getBranches |column -t |sort -k 8,8n -k 5,5M -k 6,6n
else
  getBranches |column -t
fi
