#!/bin/sh

##################################################
# author:       j. harris
# created:      2016-12-2
#
# the full git pull request
##################################################

if [ $# -lt 1 ];
then
    echo "usage: $0 pull-request-number"
    exit 1
fi

##################################################
# setup script variables
##################################################

ORIGINAL_DIR=$(pwd)
SCRIPT_NAME=$(basename $0)
echo $SCRIPT_NAME
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
}

function request_cleanup() {
    echo "Do you want to cleanup?"
    read -s -n 1 answer
    
    if [ "${answer}" == "Y" -o "${answer}" == "y" ];
    then
        cleanup
    else
        echo "\n"
        echo "Did not clean up. When done remember to:"
        echo "rm -rf ${TEMP_AREA}; git worktree prune; git branch -D ${TMP_BRANCH_NAME}"
    fi
}

##################################################
# trap signals
##################################################

# trap signals
trap "cleanup ABRT" ABRT
#trap "cleanup EXIT" EXIT
trap "cleanup HUP" HUP
trap "cleanup INT" INT
trap "cleanup QUIT" QUIT
trap "cleanup TERM" TERM

##################################################
# main work starts here
##################################################

clear
echo "----------------------------------------------"
echo "Starting the pull request workflow"
echo "----------------------------------------------"

##################################################
# fetch pull request into a new branch
##################################################

git fetch origin refs/pull-requests/${PULL_REQUEST_NUMBER}/from:${TMP_BRANCH_NAME} &>/dev/null

if [ $? -gt 0 ];
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

if [ $? -gt 0 ];
then
    echo "\n"
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo "FAILED: setting up the work tree in ${TEMP_AREA} for pull request ${PULL_REQUEST_NUMBER}"
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

    exit 1
fi

cd ${TEMP_AREA}

echo "----------------------------------------------"
echo "Temp worktree setup, now in ${TEMP_AREA}"
echo "----------------------------------------------"

##################################################
# do actual merge into master
##################################################

git checkout -b zzz master &>/dev/null
git merge ${TMP_BRANCH_NAME} &>${MERGE_OUTPUT_FILE}

if [ $? -gt 0 ];
then
    echo "\n"
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo "MERGE FAILURE: read ${MERGE_OUTPUT_FILE}"
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    cleanup
    exit 2
fi

git checkout ${TMP_BRANCH_NAME} &>/dev/null
git branch -D zzz &>/dev/null

echo "----------------------------------------------"
echo "Merge succeeded - see ${MERGE_OUTPUT_FILE}
echo "----------------------------------------------"

##################################################
# mvn package with unit & integ tests & javadoc
##################################################

echo "\n"
echo "Please wait as we compile and test the merged code ..."

mvn clean package javadoc:aggregate test -Dtest=\*Integ,\*Test &>${MAVEN_OUTPUT_FILE}

if [ $? -gt 0 ];
then
    echo "\n"
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo "              FAILURE with compilation or tests"
    echo "              dsee ${MAVEN_OUTPUT_FILE}"
    echo ""
    echo "rerun: mvn clean package javadoc:aggregate test -Dtest=\*Integ,\*Test"
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo "\n"
    
    request_cleanup
    
    exit 3
fi

echo "\n"
echo "___---___---___---___---___---___---___---___---___---"
echo "              EVERYTHING PASSED!!!"
echo "              see ${MAVEN_OUTPUT_FILE}"
echo "___---___---___---___---___---___---___---___---___---"
echo "\n"

request_cleanup
