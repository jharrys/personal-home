@GrabConfig(systemClassLoader = true)
@Grab(group = 'mysql', module = 'mysql-connector-java', version = '5.1.46')
import com.mysql.jdbc.exceptions.jdbc4.CommunicationsException

@Grab(group = 'org.xerial', module = 'sqlite-jdbc', version = '3.36.0.3')

import groovy.sql.Sql
import java.sql.SQLIntegrityConstraintViolationException

/*
Usage:

1. Update variable urlAurora to point to your own mysql database.
2. Update variable baseDirectory to the top of where all your language exports are located from the python script (structure doesn't matter, this code just recurses the folders looking for catalog.sqlite files)
3. The dependencies should auto-download and be part of your classpath using Groovy's embedded Grape Dep. Manager.
4. So just execute from command line: groovy copy-sqlite-to-mysql-data.groovy
5. if you want to re-run the script, use Intellij's feature to right-click on the database mysql (aurora) tables -> Database Tools -> Truncate to clean out all the data from the SM_* tables.
 */

/*
If you want to quiet down the logger, uncomment below.
*/
//Logger.getLogger('groovy.sql').level = Level.SEVERE

// jdbc settings
def urlAurora = 'jdbc:mysql://127.0.0.1:3306/ipspipeline?useSSL=false&user=root&password='
def baseDirectory = '/Users/jharrys/git/ips-pipeline/django-music-cms/exports/v5/staging'
def aurora
def sqlite

// get list of all catalog.sqlite files to parse
def catalogFiles = []
filterForCatalogsClosure = {

    it.eachDir(filterForCatalogsClosure)
    it.eachFileMatch(~/catalog\.sqlite/) { file ->
        catalogFiles << file.absolutePath
    }
}
filterForCatalogsClosure(new File(baseDirectory))

// setup aurora database as target for all the language data
def tables = []
try {
    aurora = Sql.newInstance(urlAurora)
    aurora.eachRow('SHOW TABLES', { row ->
        row.toRowResult().each { colName, value ->
            if (value.toString().startsWith("SM_")) {
                tables.add(value.toString().substring(value.toString().indexOf("_") + 1))
            }
        }
    })
} catch (CommunicationsException e) {
    System.err << "Unable to communicate with mysql: ${e.message}"
    return
}

catalogFiles.each { file ->
    def urlSqlite = "jdbc:sqlite:$file"
    try {
        sqlite = Sql.newInstance(urlSqlite)
    } catch (Exception e) {
        System.err << "Unable to communicate with sqlite: ${e.message}"
        return
    }

    def metaMap = [:]
    sqlite.eachRow('SELECT * FROM Metadata', {
        metaMap[it['key']] = it['value']
    })
    def langCode = metaMap['legacyCode']

    println("start language $langCode")
    tables.each {
        copy(it as String, sqlite, aurora, langCode)
        println("\tcopied from sqlite $it to aurora SM_$it.")
    }
}

static def copy(String tableName, Sql sourceDb, Sql targetDb, String langCode) {
    def sql = """select * from $tableName"""
    sourceDb.eachRow(sql.toString(), { row ->
        def params = [:]
        StringBuilder sb = new StringBuilder("insert into SM_$tableName values (")
        StringBuilder columns = new StringBuilder()
        StringBuilder values = new StringBuilder()
        boolean first = true
        row.toRowResult().each { colName, value ->
            params[colName] = value
            if (first) {
                columns.append(colName == "key" ? "`key`" : colName)
                values.append(":")
                values.append(colName)
                first = false
            } else {
                columns.append(", ${colName == "key" ? "`key`" : colName}")
                values.append(",:$colName")
            }
        }
        columns.append(", lang")
        values.append(", \"$langCode\"")
        String sqlInsert = "insert into SM_$tableName (${columns.toString()}) values (${values.toString()})"
        try {
            targetDb.executeInsert(params, sqlInsert)
        } catch (SQLIntegrityConstraintViolationException e) {
            //ignore error and keep going.
        }
    })
}

if (sqlite != null) {
    sqlite.close()
}

if (aurora != null) {
    aurora.close()
}

println("finished.")