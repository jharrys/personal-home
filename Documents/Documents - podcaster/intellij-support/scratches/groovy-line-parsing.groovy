def ids = new File("/Users/jharrys/tmp/cids.csv")
println "starting with church locations..."

def count = 0
def map = [:]

ids.eachLine { l, ln ->
    count++
    def str = new StringBuilder(l.take(7))
    str.insert(3, "-")
    map.put(str.toString(), l)
}

println "read total: $count"

def yl = new File("/Users/jharrys/tmp/t1")
def out = new FileWriter("/Users/jharrys/tmp/out.csv")
println "now matching with $yl"

count = 0
yl.eachLine { l, ln ->
    count++
    def (yid, cid) = l.split(", ")
    def loc = "$yid, $cid, ${map.get(cid)}\n"
    out.write(loc)
    println "yid: $loc"
}

out.flush()
out.close()

println "read total: $count"
println "finished matching"
