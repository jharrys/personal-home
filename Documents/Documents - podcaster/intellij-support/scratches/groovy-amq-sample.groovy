#!/usr/bin/env groovy
import org.apache.activemq.ActiveMQConnectionFactory

@Grab(group='org.apache.activemq', module='activemq-all', version='5.15.3')

import javax.jms.*

/*
Simple groovy script to read from an activemq queue and spit out its contents.
 */
def defaultHost = "localhost"
def defaultPort = "61616"
def defaultUser = "admin"
def defaultPassword = "admin"

def cli = new CliBuilder(
usage: 'amq [-h host] [-p port] [-u user] [-p password] [-m|--message] -q queue-name',
header: '\nAvailable options (use -h for help):\n',
footer: '\nThe following example will print out any messages stuck in sl-check-income-review-results queue\n./amq -q sl-check-income-review-results\n')
cli.width = 120
cli.with
        {
            h(longOpt: 'help', "Usage Information", required: false)
            H(longOpt: 'host', "defaults to $defaultHost", args: 1, required: false)
            p(longOpt: 'port', "defaults to $defaultPort", args: 1, required: false)
            u(longOpt: 'user', "defaults to $defaultUser", args: 1, required: false)
            P(longOpt: 'pass', 'defaults to default activemq password', args: 1, required: false)
            q(longOpt: 'queue', 'queue - required', args: 1, required: true)
            m(longOpt:  'message', 'only prints message; default is to print all properties', required: false)
        }
def opt = cli.parse(args)

if (!opt) return
if (opt.h) cli.usage()

def host = opt.H ?: defaultHost
def port = opt.p ?: defaultPort
def user = opt.u ?: defaultUser
def passwd = opt.P ?: defaultPassword
def uri = "tcp://$host:$port"
def queueName = opt.q
def message = opt.m ? true : false


try {
    ConnectionFactory connectionFactory = new ActiveMQConnectionFactory(uri)
    println("attempting to connect to broker with uri $uri ...")
    Connection connection = connectionFactory.createConnection(user, passwd)

    connection.start()
    println("connection started without issues")

    Session session = connection.createSession(false, Session.AUTO_ACKNOWLEDGE)

    Queue queue = session.createQueue(queueName)
    QueueBrowser queueBrowser = session.createBrowser(queue)
    Enumeration msgs = queueBrowser.getEnumeration()
    println("successfully connected to queue ${queueBrowser.getQueue().getQueueName()}")

    if (!msgs.hasMoreElements()) {
        println("no messages to process, terminating")
    } else {
        def counter = 1
        while (msgs.hasMoreElements()) {
            def beginMessageString = "**************** Begin message $counter ****************"
            def endMessageString = "--------------- End message $counter ---------------"
            Message tempMsg = (Message) msgs.nextElement()
            if (message) {
                println()
                println("$beginMessageString\n")
                println(tempMsg.getText())
                println("\n$endMessageString")
            } else {
                println()
                println(beginMessageString)
                tempMsg.getMetaPropertyValues()
                        .findAll {it.value != null}
                        .each {
                            println("${it.name}: ${it.value.toString()}")
                }
                println(endMessageString)
            }
            ++counter
        }
    }

    session.close()
    connection.close()
} catch (JMSException e) {
    System.err.println("Unable to process messages, received error.")
    e.printStackTrace()
}



