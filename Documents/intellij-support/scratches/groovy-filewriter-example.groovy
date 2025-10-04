int a = 0
File file = new File("/Users/jharris/tmp/a.txt")
file.writer
java.io.FileWriter fileWriter = new FileWriter(`"/Users/jharris/tmp/a.txt", true)
    while (a < 1000) {
        fileWriter.write(" " + a + "\n")
        ++a
        sleep(50)
    }
fileWriter.flush()
fileWriter.close()
