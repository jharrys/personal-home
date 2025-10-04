import java.math.BigInteger

//kotlin

class Variance {
    // covariance
    fun processCo(alist: MutableList<out Number>) {
        for (item in alist) {
            println(item)
        }
        // alist.add(2) // illegal because we declared out (publisher)
    }

    fun processContra(blist: MutableList<in Number>) {
        val bi = BigInteger("1")
        blist.add(bi)
        for(item in blist) {
            println(item)
        }
    }

}

var variance = Variance()
val alist: MutableList<Int> = mutableListOf(1, 2, 3)
val blist: MutableList<Double> = mutableListOf(1.2, 2.4, 3.4)

variance.processCo(alist)
variance.processCo(blist)

val clist: MutableList<Number> = mutableListOf(2.2, 3.3, 4.4)
variance.processContra(clist)

