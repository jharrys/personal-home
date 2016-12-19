#!/bin/sh

##################################################
# author:       j. harris
# created:      2016-12-2
#
# EXIT CODES
# 4 - maven compile or test failures (see output for detals)
# 3 - git merge failure (see output for details)
# 2 = git worktree add failure
# 1 = git fetch failure (fetching the pull request)
# 127 = cleanup of the $TEMP_AREA failed
#
# the full git pull request
##################################################

if [ $# -lt 1 ];
then
  echo 'usage: $0 pull-request-number

  EXIT CODES:
  127 = error cleaning the temp area
  126 = this usage help screen
  4 = maven errors with compilation or test failures
  3 = git merge error (see output for details)
  2 = git worktree add error
  1 = git error fetching pull request
  '
  exit 126
fi

##################################################
# setup script variables
##################################################

# 4=mvn error;3=git merge error;2=git worktree error;1=git fetch error
EXIT_CONDITION=0

# 1=YES;0=NO
CLEANUP=1

ORIGINAL_DIR=$(pwd)
SCRIPT_NAME=$(basename $0)
PROJECT_NAME=$(basename $ORIGINAL_DIR)
WORK_DIR=/tmp
TEMP_AREA=${WORK_DIR}/${PROJECT_NAME}
PULL_REQUEST_NUMBER=$1
TMP_BRANCH_NAME=${1}_GPR
DATE=$(date "+%Y%m%d-%H%M%S")
MAVEN_OUTPUT_FILE=${WORK_DIR}/${SCRIPT_NAME%%.*}-maven-output.${DATE}
MERGE_OUTPUT_FILE=${WORK_DIR}/${SCRIPT_NAME%%.*}-merge-output.${DATE}

##################################################
# ensure TEMP_AREA is clean
##################################################

if [ -e ${TEMP_AREA} ];
then
  echo "\n"
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  echo "${TEMP_AREA} already exists, cannot continue until it is cleaned up."
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  exit 1
fi

##################################################
# functions
##################################################

function cleanup() {

  trap 'exit ${RC}' EXIT

  if [ ${CLEANUP} -eq 1 ]; then
    cd $ORIGINAL_DIR

    if [ "${TEMP_AREA}" == "/tmp/" ];
    then
      echo "\n"
      echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      echo "Unable to clean up tmp area"
      echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      return 127
    fi

    rm -rf ${TEMP_AREA}

    git worktree prune &>/dev/null

    git branch -D ${TMP_BRANCH_NAME} &>/dev/null

    echo "Removed ${TEMP_AREA} and git branch ${TMP_BRANCH_NAME}"
  else
    echo "\n"
    echo "Did not clean up. When done remember to:"
    echo "rm -rf ${TEMP_AREA}; git worktree prune; git branch -D ${TMP_BRANCH_NAME}"
  fi
}

function request_cleanup() {
  echo "Do you want to cleanup?"
  read -s -n 1 answer

  if [ "${answer}" == "Y" -o "${answer}" == "y" ];
  then
    CLEANUP=1
  else
    CLEANUP=0
  fi

  cleanup
}

##################################################
# trap signals
##################################################

# trap signals
trap "cleanup ABRT" ABRT
trap "cleanup HUP" HUP
trap "cleanup INT" INT
trap "cleanup QUIT" QUIT
trap "cleanup TERM" TERM

trap 'RC=$?;request_cleanup' EXIT

##################################################
# main work starts here
##################################################

clear
echo "----------------------------------------------"
echo "Starting the pull request workflow"
echo "----------------------------------------------"

##################################################
# set up environment; ensure we have latest
##################################################
git checkout master &>/dev/null && git pull &>/dev/null || echo "\n Failed pulling master branch"

##################################################
# fetch pull request into a new branch
##################################################

git fetch origin refs/pull-requests/${PULL_REQUEST_NUMBER}/from:${TMP_BRANCH_NAME} &>/dev/null

EXIT_CONDITION=$?

if [ ${EXIT_CONDITION} -gt 0 ];
then
  echo "\n"
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  echo "FAILED: to checkout ${PULL_REQUEST_NUMBER} into the local branch ${TMP_BRANCH_NAME}"
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

  exit 1
fi

echo "----------------------------------------------"
echo "Pull request fetched locally"
echo "----------------------------------------------"

##################################################
# Setup separate git worktree
##################################################

git worktree add $TEMP_AREA ${TMP_BRANCH_NAME} &>/dev/null

EXIT_CONDITION=$?

if [ ${EXIT_CONDITION} -gt 0 ];
then
  echo "\n"
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  echo "FAILED: setting up the work tree in ${TEMP_AREA} for pull request ${PULL_REQUEST_NUMBER}"
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

  exit 2
fi

cd ${TEMP_AREA}

echo "----------------------------------------------"
echo "Temp worktree setup."
echo "Worktree created in ${TEMP_AREA}"
echo "----------------------------------------------"

##################################################
# do actual merge into master
##################################################

git checkout -b zzz master &>/dev/null
git merge ${TMP_BRANCH_NAME} &>${MERGE_OUTPUT_FILE}

EXIT_CONDITION=$?

if [ ${EXIT_CONDITION} -gt 0 ];
then
  echo "\n"
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  echo "MERGE FAILURE: read ${MERGE_OUTPUT_FILE}"
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

  exit 3
fi

git checkout ${TMP_BRANCH_NAME} &>/dev/null
git branch -D zzz &>/dev/null

echo "----------------------------------------------"
echo "Merge succeeded - see ${MERGE_OUTPUT_FILE}"
echo "----------------------------------------------"

##################################################
# mvn package with unit & integ tests & javadoc
##################################################

echo "\n"
echo "Please wait as we compile and test the merged code ..."

mvn clean package javadoc:aggregate test -Dtest=\*Integ,\*Test &>${MAVEN_OUTPUT_FILE}

EXIT_CONDITION=$?

if [ ${EXIT_CONDITION} -gt 0 ];
then
  echo "\n"
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  echo "              FAILURE with compilation or tests"
  echo "              see ${MAVEN_OUTPUT_FILE}"
  echo ""
  echo "rerun: mvn clean package javadoc:aggregate test -Dtest=\*Integ,\*Test"
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  echo "\n"

  exit 4
fi

echo "\n"
echo "___---___---___---___---___---___---___---___---___---"
echo "  EVERYTHING PASSED!!!"
echo "  see ${MAVEN_OUTPUT_FILE}"
echo "___---___---___---___---___---___---___---___---___---"
echo "\n"

exit 0
