/*
Default implementation of equals and hashcode in Kotlin
 */
abstract class Day {
    abstract var isClosed: Boolean
    abstract var openIntervals: MutableList<String>

    override operator fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false
        other as Day
        if (this.isClosed != other.isClosed) return false
        if (this.openIntervals != other.openIntervals) return false
        return true
    }

    override fun hashCode(): Int {
        var result = isClosed.hashCode()
        result = 31 * result + openIntervals.hashCode()
        return result
    }
}
