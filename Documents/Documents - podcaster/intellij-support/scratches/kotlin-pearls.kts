// from https://dzone.com/articles/kotlin-pearls-7-unit-nothing-any-and-null

/*
********* Statements vs Expression **********
 */
//Expression: any line of code that produces another value
//NOTE: in Kotlin all funcs at least return Unit, so all funcs are expr.
// in Java, funcs without return types are not expressions

// in java if/switch are not expressions
// in kotlin, if/when/try can return values so they are expressions
val bigger = if (a>b) a else b //kotlin expression

// kotlin expression from try
val o = try {
    gson.fromJson(json)
} catch (e: Throwable) {
    null
}

val color = when {
    relax -> GREEN
    studyTime -> YELLOW
    else -> BLUE
}

//Statement in kotlin: in an imperative lang expresses an ACTION
val a = 10
val b = listOf(1,2,3).maxBy { it.div(it) }
println("hello")
// in a pure functional lang, statements do not exist
// also a standalone expr is a statement = "expression statement"
updateUser(user)


/*
********* ANY **********
 */
// The root of the Kotlin class hierarchy; Any is superclass to all
// source is leaner than Java Object class
// also -
/* public open class Any {
    public open operator fun equals(other: Any?): Boolean
    public open fun hashCode(): Int
    public open fun toString(): String
}*/
// Under the hood of the JVM, Any doesn't exist and gets compiled to Object

/*
********* NLR: non local returns **********
 */

// returning from a lambda returns from the whole method/fun
// kotlin says the fun should be inlined to make it work
// if you look at the "forEach" source, it is inlined.
// also - an NLR is a valid Nothing type in kotlin
fun nonlocalreturnexample(): Int {
    val list = listOf(1, 2, 3, 4)
    list.forEach {
        if (it >= 2) {
            println("printing $it because greater than 2")
            // this return will return not just the foreach lambda, but the whole fun
            return it
        }
        println("$it is less than 2")
    }
    println("must not get here")
    return -1
}
val n = nonlocalreturnexample()
println("done - printing $n")

/*
********* Nothing **********
 */
// Nothing is a subclass of all classes
// It's a Type, but one that cannot be instantiated (private ctor)
// Works for fun that always throw an exception or never return because of infinite loop
fun fooOne(): Unit { while (true) { } } // works fine
fun fooZero(): Nothing { while (true) { } } // works fine
//both above ok
fun barOne(): Unit { println("hi") }
//fun barZero(): Nothing { println("hi") }  //compile error

/*
********* TODO() **********
 */
// A classic Kotlin Nothing built-in fun is TODO()
// public inline fun TODO(): Nothing = throw NotImplementedError()
fun notDone() : Unit = TODO()

/*
********* Smart Casting **********
 */
data class User(val name: String)
fun showUsers(users: List<User>?) {
    users ?: return // smart casts users to a non-null type
    // rest of code can use users without worrying about null
    val adapters = users.map { UserAdapter(it, ::onUserClicked) }
    list.adapter = UserListAdapter(adapters)
}
