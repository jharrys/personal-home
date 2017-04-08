#!/bin/sh

# Simply delegate to the domains' stopWebLogic.sh script

# source in my type setting
. colors.sh

DOMAIN_HOME="/Users/lpjharri/local/wldomains/carma"

$colored_fg_yellow
echo "Executing shutdown ..."
$type_reset

${DOMAIN_HOME}/bin/stopWebLogic.sh >/dev/null 2>&1
EXIT_STATUS=$?

if [[ ${EXIT_STATUS} -eq 0 ]];
then
  $colored_fg_yellow
  echo "Carma domain of Weblogic has been shutdown `${type_bold}`successfully."
  $type_reset
else
  $colored_fg_red
  echo "A problem occurred. Carma Weblogic shutdown `${type_bold}`failed."
  $type_reset
fi

