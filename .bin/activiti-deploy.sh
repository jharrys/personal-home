#!/bin/sh

BARJARPATH=~/.bin/bar-util.jar

function usage {
  echo "usage: $1 [-h host] [-p port] [-H] deploy /path/to/bar/file|undeploy deployId"
  echo ""
  echo "-H will show this help message"
  exit 1
}

# Check that we have at least 1 argument
if [ $# -lt 1 ];
then
  usage $0
fi

while getopts "h:p:H" opt; do
  case $opt in
    h)
      HOST=$OPTARG
      ;;
    p)
      PORT=$OPTARG
      ;;
    H)
      usage $0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      return 125
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      return 125
      ;;
  esac
done

# shift all the parsed arguments to leave everything else that wasn't parsed
shift $((OPTIND-1))

COMMAND=$*

#COMMAND=$1
#echo $COMMAND
#shift
#COMMANDARG=$1

#echo "java -jar ~/.bin/bar-util.jar -d com.mysql.jdbc.Driver -u jdbc:mysql://${HOST}:${PORT}/activiti_carma?autoReconnect=true -U ActivitiCarma -p ActivitiCarma ${COMMAND} ${COMMANDARG}"
#java -jar ~/.bin/bar-util.jar -d com.mysql.jdbc.Driver -u jdbc:mysql://${HOST}:${PORT}/activiti_carma?autoReconnect=true -U ActivitiCarma -p ActivitiCarma ${COMMAND} ${COMMANDARG}
java -jar ${BARJARPATH} -d com.mysql.jdbc.Driver -u jdbc:mysql://${HOST}:${PORT}/activiti_carma?autoReconnect=true -U ActivitiCarma -p ActivitiCarma ${COMMAND}

