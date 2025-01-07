/*
Connect to a mysql rdbms, read a large table in chunks and write to file system.
 */

import com.mysql.jdbc.exceptions.jdbc4.CommunicationsException
import java.nio.ByteBuffer
import java.nio.channels.FileChannel
import java.sql.SQLException
import groovy.sql.Sql

// args should be the path to an existing directory where we're storing the files
File baseDirectory = new File(args[0])
if (!baseDirectory.exists() || !baseDirectory.isDirectory()) {
    System.err << "${baseDirectory.getPath()} must exist and be a directory"
    return
}

// retrieve last saved point - we work backwards from max(activity_id)
int startId = 0
File lastSaved = new File(baseDirectory.getPath() + "/last_saved")
if (lastSaved.exists()) {
    startId = lastSaved.getText().toInteger()
}

File stopFile = new File(baseDirectory.getPath() + "/stop")
stopFile.deleteOnExit()

// counting
def batch = 1_000_000
def fetchLimit = 10_000

// jdbc settings
def url = 'jdbc:mysql://127.0.0.1:13313/sofi'
def user = 'jharris@sofi.org'
def password = ''
def driver = 'com.mysql.jdbc.Driver'
def sql
try {
    sql = Sql.newInstance(url, user, password, driver)
} catch (CommunicationsException e1) {
    System.err << "Unabled to communicate with database. Did you VPN in and startup Strong DM?"
    return
}

// if startId is 0 then figure out where to start
if (startId < 1) {
    def row = sql.firstRow("select max(id) as max from target_cmnts")
    startId = row.max + 1
}

// figure out next file name for saving to
File getNextFile(int startId, int batch, File baseDirectory) {
// round to next whole batch; if batch=10 then
// 1234 % 10 = 4 -> 1234-4+10 = 1240; so for startId=1234, name the file 1240 suggesting this file contains id's going up to 1240.
    def possibleName = (startId % batch == 0) ? startId : ((startId - (startId % batch)) + batch)

    File aFile = new File(baseDirectory.getPath() + File.separator + possibleName + ".sql")
    int attempt = 0
    while (aFile.exists()) {
        aFile = new File(baseDirectory.getPath() + File.separator + possibleName + "-[${++attempt}].sql")
    }
    return aFile
}

// use 'sql' instance ...
def insert = "INSERT INTO sofi.target_cmnts (id, target_activity_id, cmnt, cmnt_date, target_type, target_id, created_by, created_dt, updated_by, updated_dt) VALUES ("
def sep = ", "
def ssep = ", '"
def msep = "', '"
def esep = "', "

// in case of some exception flag to hard stop whole process
def stop = false

while (!stop) {
    File saveToFile = getNextFile(startId, batch, baseDirectory)
    RandomAccessFile stream = new RandomAccessFile(saveToFile, "rw")
    FileChannel channel = stream.getChannel()
    ByteBuffer buffer
    boolean m25, m50, m75 = false
    int runningPercent = 0
    String dateOfBatch = null

    // loop through a batch
    def nextId = startId - batch
    while (nextId < startId) {
        try {
            sql.eachRow("""SELECT t.* FROM target_cmnts t WHERE t.id>=${nextId} LIMIT ${fetchLimit}""", { row ->
                byte[] byteString = (insert + row.id + sep + row.target_activity_id + ssep + row.cmnt + msep + row.cmnt_date + msep +
                        row.target_type + msep + row.target_id + msep + row.created_by + msep + row.created_dt +
                        msep + row.updated_by + msep + row.updated_dt + "');\n").getBytes()

                if (null == dateOfBatch) {
                    dateOfBatch = row.cmnt_date
                    System.out << "batch date starts $dateOfBatch in file ${saveToFile.getName()}\n"
                }

                buffer = ByteBuffer.allocate(byteString.size())
                buffer.put(byteString)
                buffer.flip()
                channel.write(buffer)
            })

            // figure out what's been completed
            runningPercent = ((batch - (startId - nextId))/batch)*100

            // get next set to run
            nextId = nextId + fetchLimit

            if (!m25 && (runningPercent)>25) {
                System.out << "batch 25% done! (${saveToFile.length()/1024})\n"
                m25 = true
            }

            if (!m50 && (runningPercent)>50) {
                System.out << "batch 50% done! (${saveToFile.length() / 1024})\n"
                m50 = true
            }

            if (!m75 && (runningPercent)>75) {
                System.out << "batch 75% done! (${saveToFile.length() / 1024})\n"
                m75 = true
            }

        } catch (SQLException | CommunicationsException e) {
            stop = true
            System.err << "sql error, next restart will start at ${nextId}"
            break
        } catch (IOException ioe) {
            stop = true
            System.err << "got exception writing to ${saveToFile.getPath()}, next restart will start at $nextId\n"
            ioe.printStackTrace()
            break
        }
    }

    // close all NIO streams
    stream.close()
    channel.close()

    // if no error, setup next batch
    if (!stop) {
        System.out << "batch 100% done\n\n"
        startId = startId - batch
        lastSaved.setText(startId.toString())
        if (stopFile.exists()) {
            System.err << "stopping because of stop file"
            break
        }
    } else {
        break
    }

}

sql.close()
