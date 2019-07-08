#!/bin/sh

# 2018-07-01
# by Johnnie H.
# Assigns then completes an activity given its ID.

[ $# -lt 2 ] && echo "usage: $0 HOST ACTIVITY_ID" && exit 1

host=$1
activity_id=$2

function run() {
  cmd_exec=$1
  type=$2

  cmd_output=$($cmd_exec)

  return_status=$?
  cmd_status=$(echo $cmd_output |jq '.status')

  if [ $return_status -gt 0 -o "$cmd_status" == '"error"' ];
  then
    echo "could not ${type} activity id ${activity_id} on host: $host"
    [ $return_status -gt 0 ] && exit $return_status || exit 1
  fi
}

checkout_cmd="curl -s -X GET http://${host}:9020/w/api/v1/activity/checkoutActivity/bbdab2f76d0fbf8a6c860fda9b681fd159937cbe0acfe76d6a213beeb35b2f24/${activity_id}"
complete_cmd="curl -s -X POST http://${host}:9020/w/api/v1/activity/completeActivity/bbdab2f76d0fbf8a6c860fda9b681fd159937cbe0acfe76d6a213beeb35b2f24/3236/${activity_id}/CMPLT"

run "$checkout_cmd" "checkout"
echo "$activity_id checked out"
run "$complete_cmd" "complete"
echo "$activity_id set to CMPLT"

