#!/bin/sh
# copied from sofi-kubernetes/scripts/kraken-register-service.sh and made it mine without the ssh call.
# i want to add the reverse or forward tunnel using ~C for great control.
SCRIPTLOC="/Users/jharris/git/sofi-kubernetes/scripts"

function instructions {
    RED="\033[0;31m"
    GREEN="\033[0;32m"
    RESET="\033[m"

    SERVICE=$1
    HOST=$2
    IP=$3
    cat <<-'EOF'
                              .--`
                            :ymy.`
                          `sMd:`
                         `hMM/
                         hMMN.                              ```
                        -MMMm                              .:+ss-
                        -MMMM/                                `smy:.```
                         mMMMm.                                 .+ymddhhsso/-`
                         /MMMMM+-`                                  .-:+smMMMNy.
                          oMMMMMMm:`             __                       :hMMMy
                           :dMMMMMMN+`           \ \___     .__           .oMMM/
              .:-`::: ``     -hMMMMMMm/        .--""__-\..--"/         ./hMMMNo
           /yyNMMNMMNmMNsoy+   oMMMMMMm-   .__.|-"""..+.. ' /       `/hNMMMd+`
         `omMMMMMMMMMMMMMMMMs+wwsMMMMMMd   \________`s`____/       -dMMMd+.
wwwww.sdMMMMMMMMMMMMMMMMMMd. :MMMMMMm`wwwwww`-www/+wwwwwwww`-ww-NMMMM:wwwwwwwwwwww
.....oNMMMMMMMd:..-+hMMMMMN``+MMMMMMm`......./:.`+o.......+NMm//MMMMN/............
.....hNMMMMMMM-......mMMMMh.-NMMMMMMy..........y/.h/...:smmydMM/dMMMMMh/..........
::::hMMMMMMMMMNNmhs++NMMMN//NMMMMMMh+hho/:-----ss-:shdmmh+:+dMMo:NMMMMMo::::::::::
////mMMMMMMMMmsooshdmmmhs+yMMMMMMMdoNMmyyhhhhyys/////////omMMMN+dMMMMMm///////////
oooomMMMMMMMMNsoooooooo+yNMMMMMMMdo+dMMNmdysoooooooooooydMMMMdyNMMMMMdoooooooooooo
ssssdMMMMMMMMMysssssssymMMMMMMMMdssssyhmNMMMNdysssssssyMMMMMyhMMMMMMNyssssyyyyyyyy
yyyyhmMMMMMMMMmhhhhhhdMMMMMMMMMNhhhhhhhhhmMMMMdhhhhhhhmMMMMmdMMMMMMmhhhhhhhhhhhhhh
mmmmmmNMMMMMMMMmmmmmmMMMMMMMMMMmmmmmmmNNMMMMMMmmmmmmmmmMMMMMMMMMMMMmmmmmmmmmmmmmmm
mmmmmmNMMMMMMMMMNNmmmNMMMMMMMMMNNNNNMMMMMMMMNNNNNNNNNNNNMMMMMMMMMMMNNNNNNNNNNNNNNN
NNNNNNNNMMMMMMMMMMMNNNNMMMMMMMNNNNNMMMMMMMMNNNNNNNNNNNNNMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
EOF
    echo ${GREEN}"*****************************${RESET} Instructions: ${GREEN}*****************************${RESET}"
    echo "1. Ensure you stopped the ${RED}${SERVICE}${RESET} instance on ${RED}${HOST}${RESET}."
    echo "   If not exit this script and do it first."
    echo ""
    echo "2. Start and leave this SSH terminal window open to keep the reverse"
    echo "   tunnel working."
    echo ""
    echo "3. Navigate to your local ${RED}${SERVICE}${RESET} project and do a ./buildconf"
    echo ""
    echo "3a. If buildconf is not configured yet you can configure your local"
    echo "    ${RED}${SERVICE}${RESET} to point to ${RED}${HOST}${RESET} for any dependencies."
    echo "    Usually these include databases and consul."
    echo "    Example changes in localmac.overrides or whatever config you use:"
    echo "      node.ipaddress=\"${RED}consul.service.consul-dev${RESET}\""
    echo "      node.hostname=\"${RED}consul.service.consul-dev${RESET}\""
    echo "      db.default.url=\"jdbc:mysql://${RED}mysql.service.consul-dev${RESET}/sofi"
    echo "      filestore.clamAVDHost=\"${RED}clamav.service.consul-dev${RESET}\""
    echo "      fauxperian.url=\"http://${RED}fauxperian.service.consul-dev${RESET}:8998\""
    echo "${GREEN}*************************************************************************${RESET}"

}
if [ ! "$#" -gt "1" ]; then
  script=`basename "$0"`
  instructions service kraken-x kraken-ip
  echo "Usage: ${script} kraken-host service [port]"
  echo "    ${script} kraken-2 products 9012"
  exit 1
fi

# Because colors are cool
RED="\033[0;31m"
GREEN="\033[0;32m"
RESET="\033[m"

HOST=$1
IP=`ping -c 1 ${HOST} | head -n 1 | perl -n -e '/([0-9\.]{6,})/ && print $1'`
if [ "$IP" == "" ]; then
    echo "${RED}Error!${RESET} Cannot find IP address for ${HOST} ${RED}(╯°□°）╯︵ ┻━┻${RESET}"
    exit 1
fi


TARGET=$2

if [ -z "$3" ]; then
 echo "No port provided. Looking up port via configurations"
 PORT=`${SCRIPTLOC}/lookup-compose-port.sh $2`
else
  PORT=$3
fi

DATA="{  \"ID\": \"${TARGET}\",  \"Name\": \"${TARGET}\",   \"Address\": \"${IP}\",  \"Port\": ${PORT},  \"EnableTagOverride\": false}"

#DATA="{\"Node\":\"${NODE}\", \"Address\":\"${IP}\", \"Service\":{\"Service\":\"${TARGET}\", \"Port\":${PORT},\"ID\":\"${TARGET}\"}}"
echo "Registering ${TARGET}:${PORT} on consul running on ${IP}"

echo "Building /tmp/kraken-${TARGET}"
echo "KRAKEN_IP=${IP}\nKRAKEN_HOST=${HOST}" > /tmp/kraken-${TARGET}

URL="http://${IP}:8500/v1/agent/service/register"

RESULT=`curl -s -S -4 -XPUT -H 'Content-Type: application/json' -d "${DATA}" ${URL}`
if [ "$RESULT" != "" ]; then
    echo "Called ${URL} with ${DATA}"
    echo "${RED}Error!${RESET} Consul registration failed for ${TARGET} ${RED}(╯°□°）╯︵ ┻━┻${RESET}"
    exit 1
fi

echo "Changing consul dns to point to ${IP}"
${SCRIPTLOC}/setup-consul-dns.sh $HOST

echo "Done ... you can ~C in and execute \"-R ${PORT}:localhost:${PORT}\""
