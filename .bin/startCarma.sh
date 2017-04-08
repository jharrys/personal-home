#!/bin/sh

# source in my type setting
. colors.sh

unset WITHTAM
unset TAIL

DOMAIN_HOME="/Users/lpjharri/local/wldomains/carma"
NOHUPLOG="${DOMAIN_HOME}/logs/nohup-carma.log"

while getopts "mtl" opt; do
  case $opt in
    m)
      OUTPUT=$(sudo /usr/local/mysql/support-files/mysql.server start)
      $colored_fg_magenta; echo $OUTPUT; $type_reset
      ;;
    t)
      WITHTAM=true
      JAVA_OPTIONS="${JAVA_OPTIONS} -Dtamjunctionsimulation=true"
      export JAVA_OPTIONS
      ;;
    l)
      TAIL=true
      ;;
    \?)
      echo "Invavlid option: -$OPTARG" >&2
      return 125
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      return 125
      ;;
  esac
done

debugFlag=true
export debugFlag

PRE_CLASSPATH=/Users/lpjharri/local/appservers/wls-12.1.3/oracle\_common/modules/javax.persistence\_2.1.jar:/Users/lpjharri/local/appservers/wls-12.1.3/wlserver/modules/com.oracle.weblogic.jpa21support\_1.0.0.0\_2-1.jar
export PRE_CLASSPATH

pgrep -f -i weblogic >/dev/null 2>&1
EXIT_STATUS=$?

if [[ ${EXIT_STATUS} -eq 0 ]];
then
  $colored_fg_yellow
  echo "Weblogic is already running."
  $type_reset
  exit 1
else
  nohup ${DOMAIN_HOME}/bin/startWebLogic.sh > ${DOMAIN_HOME}/logs/nohup-carma.log 2>&1 &

  $colored_fg_magenta
  echo "Started a new instance of Weblogic."

  [[ -n ${WITHTAM} ]] && echo "Tam junction simulations turned on."
  $type_reset

fi

if [[ -n ${TAIL} ]];
then
  tail -f ${NOHUPLOG}
fi
