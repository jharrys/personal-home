@Grab('org.yaml:snakeyaml:1.17')

/*
This script parses a docker-compose.yml file and attempts to extract port and JAVA_TOOL_OPTIONS from $myService.
If these are null, it then updates the fil with the defaults in this file.
 */

import org.yaml.snakeyaml.Yaml

String myService="student-loan-consumers"
String addPort="6666"
String jvmOption="-Dcom.sun.management.jmxremote=true -Dcom.sun.management.jmxremote.rmi.port=$addPort -Dcom.sun.management.jmxremote.port=$addPort -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=10.0.16.146"
String file="/Users/jharris/git/dev-compose-env/docker-compose.yml"

Yaml parser = new Yaml()
def example = parser.load((file as File).text)

// update port
def ports = example.services[myService].ports
if (ports == null) {
    example.services[myService].ports = ["$addPort:$addPort"]
} else {
    ports.add("$addPort:$addPort")
}

// Environment
def environment = example.services[myService].environment

if (environment == null) {
    environment = example.services[myService].environment='JAVA_TOOL_OPTIONS='
}

int index=0
for (String env : environment) {
    if (env.startsWith('JAVA_TOOL_OPTIONS=')) {
        environment[index] = "$env $jvmOption"
        found = true
        break
    }
    ++index
}

println example.services[myService]

//println example.dump()
