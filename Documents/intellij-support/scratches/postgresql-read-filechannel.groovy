/*
Connect to postgresql and read to file using nio channel.
 */

import java.nio.ByteBuffer
import java.nio.channels.FileChannel
import java.sql.SQLException
import groovy.sql.Sql

// Arg is the file to use
// the file for this script is a list of partyIds; one partyId per line
File datafile = new File(args[0])

// setup file to save data to
File saveToFile = new File("/Users/jharris/tmp/tmx-with-email.csv")
RandomAccessFile stream = new RandomAccessFile(saveToFile, "rw")
FileChannel channel = stream.getChannel()
ByteBuffer buffer

// jdbc settings
def url = 'jdbc:postgresql://localhost:15759/sofi_customers'
def driver = 'org.postgresql.Driver'
Sql sql = Sql.newInstance(url, driver)

datafile.withReader { reader ->
    while ((partyIdString = reader.readLine()) != null) {
        BigInteger partyId = new BigInteger(partyIdString)
        sql.eachRow("SELECT DISTINCT e.email_addr FROM email e WHERE e.party_id=${partyId}") { rs ->
            String email = rs.email_addr
            if (email == null || email.isEmpty()) {
                email = "no-email-found"
            }
            byte[] byteString = ("${partyIdString},${email}\n").getBytes()
            buffer = ByteBuffer.allocate(byteString.size())
            buffer.put(byteString)
            buffer.flip()
            channel.write(buffer)
        }
//        break
    }
}

stream.close()
channel.close()
sql.close()
