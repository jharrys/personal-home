import groovy.sql.Sql

import java.sql.SQLException
import java.time.LocalDate

// config
def err = System.err

// aws
def aws_bucket = "localytics-data-migration-dev"
def prefix = "fact_tables"
def filename = "some_name"

// jdbc settings
def url = "jdbc:snowflake://localyticsdirectaccess.snowflakecomputing.com:443?warehouse=LDS_WH"
def user = "LDS_admin"
def password = "dataKey87!"
def driver = "net.snowflake.client.jdbc.SnowflakeDriver"
def table = "fact_events"

// jdbc connect
println "run started."
def sql

try {
    sql = Sql.newInstance(url, user, password, driver)
} catch (SQLException ignored) {
    String message = "Unable to communicate with database."
    err.println message
    return
}

LocalDate start = LocalDate.parse("2020-01-04")
LocalDate current = start
LocalDate end = LocalDate.parse("2020-01-08")
while (current < end) {
    def currentAsString = current.toString().replace("-", "")
    println "Running $currentAsString and storing to $prefix/$table/$currentAsString/$table-$currentAsString"
    def timer = System.currentTimeMillis()
    def run = """
COPY INTO 's3://$aws_bucket/$prefix/$table/$currentAsString/$table-$currentAsString'
    FROM (SELECT OBJECT_CONSTRUCT(*)
          FROM localytics.direct_sql_hosted.$table
          WHERE CLIENT_DATE >= ?
            AND CLIENT_DATE <= ?)
    CREDENTIALS = (AWS_KEY_ID = 'AKIASHCD7MXGN4UXKEOP' AWS_SECRET_KEY = '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')
    FILE_FORMAT = (TYPE = JSON, COMPRESSION = NONE)
    MAX_FILE_SIZE = 1073741824;
"""

    println "executing $run"

    try {
        sql.execute(run, [current.toString(), current.toString()])
    } catch (SQLException e) {
        err.println e.getMessage()
        break
    }

    current = current.plusDays(1L)
    println "timer took: ${System.currentTimeMillis() - timer} ms"
    println "End of $currentAsString run for $table"
    println "============================\n"
}
sql.close()
println "run ended."
