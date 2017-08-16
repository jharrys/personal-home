#!/bin/bash

trap '{
    # this block gets called before exit
    if [ -z "$out" ]; then
        echo "No hosts with VNC enabled found."
        exit 0
    fi
    # some time consuming calulations might be done here
    printf "%s\n" "${out[@]}"
    echo "${#out[@]} host(s) found."
    echo "These instances were found."
    printf "%s\n" "${instances[@]}"
}' EXIT

instances=()
out=(); i=0
while read -r line; do
    i=`expr $i + 1`
    if [ $i -lt 5 ]; then continue; fi # skip the header lines

    out+=("$line")

    name=$(echo $line | cut -d ' ' -f 7-9)
    instances+=("$name")

    # break if no more items will follow (e.g. Flags != 3)
    if [ $(echo $line | cut -d ' '  -f 3) -ne '3' ]; then
        break
    fi
done < <((sleep 0.5; pgrep -q dns-sd && kill -13 $(pgrep dns-sd)) & # kill quickly if trapped
            dns-sd -B _printer._tcp)

for x in $instances
do
  line=$($(sleep 0.5; pgrep -q dns-sd && kill -13 $(pgrep dns-sd)) & dns-sd -L "$x" _ipp._tcp. local.)

  interfaceName=${line}
done

# kill child processes
pgrep -q dns-sd && kill -13 $(pgrep dns-sd)
exit 0
