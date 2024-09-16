#!/bin/bash
#
# 12/22/2023 by Johnnie H.
# determines if we are logged in to aws-cli, if not it runs aws-azure-login
RESULT=$(aws sts get-caller-identity --no-cli-pager)
CALL_STATUS=$?
if [ $CALL_STATUS -gt 0 ]; then
  echo "Not currently logged in."
  aws-azure-login
else
  echo "Logged in already."
fi

exit 0
