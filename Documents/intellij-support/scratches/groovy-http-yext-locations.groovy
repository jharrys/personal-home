// @formatter:off
import groovy.json.JsonSlurper

def file = new FileWriter("/Users/jharrys/tmp/existing-locs.csv")

file.write("yext-id, church-id\n")

def uri = "https://sandbox.yext.com/v2/accounts/2477661/entities?api_key=897b3387e6f05a6fe3a9dfd05666c8fa&v=20200420&limit=12"
//def uri = "https://api.yext.com/v2/accounts/me/entities?api_key=ab3ec7eda0bf73f2fc7f4a777aa491b0&v=20200420&limit=50"

def token = ""
def slurper = new JsonSlurper()
def callCount = 0
def entityCount = 0
def actualCount = 0

do {
    callCount++

    def activeUri = "${uri}${token}"

    println "callCount: ${callCount}"
    println("connecting: $activeUri")
    def getYext = new URL(activeUri)
    def connection = getYext.openConnection()
    connection.requestMethod="GET"

    // reset token
    token = ""

    if (connection.responseCode==200) {
        def object = slurper.parseText(connection.content.text)

        if (callCount == 1) {
            entityCount = object.response.count
            println "entities available for processing: $entityCount"
        }

        if (object.response.pageToken != null && object.response.pageToken != "") {
            token = "&pageToken=${object.response.pageToken}"
            println("Next page token: $token\n")
        }

        // only parse if collection is not empty
        if (object.response.entities) {
            object.response.entities.each {
                actualCount++
                println "yext-uid: $it.meta.uid, church-id: $it.meta.id"
                file.write("${it.meta.uid}, ${it.meta.id}\n")
            }
            println "entity count so far: $actualCount"
        }

        println "------ done with ${callCount} -------\n\n"
    }

} while(token != null && token != "")

println "done listing all entities - made $callCount GET calls and received $actualCount entities of $entityCount"

file.flush()
file.close()

assert entityCount == actualCount
