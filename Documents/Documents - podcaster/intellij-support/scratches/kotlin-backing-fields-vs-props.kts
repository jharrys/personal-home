// example of implicit backing fields
// has getter aut set
class Human1 {
    val age = 20
}

// example of backing fields
// we specify getter with more control
class Human2 {
    val age = 20
        get() {
            println("Age is: $field")
            return field
        }
}

// example of backing properties
// in Human1 & Human2 when we call the age property we go through
// the getter ... this example shows us how to avoid going through getter
// and going directly
// note _age is underscore and private
class Human3 {
    private val _age: Int = 20
    val age: Int
        get() {
            // do other calcs
            return _age
        }

    // with printage we want to avoid calling get() and avoid
    // "do other calcs"
    val printAge = {
        println("Age is: $_age")
    }
}

// constants:
// top level, object declaration or companion object
// top level means it can't be declared in a class, but it can be declared in a file outside of a
// class structure
// no custom getter
// a primitive type
// can be used in annotations
object Human4 {
    const val SUBSYSTEM_DEPRECATED: String = "This subsystem is deprecated"

    @Deprecated(SUBSYSTEM_DEPRECATED)
    fun foo() {
        // something bar
    }
}
