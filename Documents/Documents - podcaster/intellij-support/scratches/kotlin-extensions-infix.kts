/*************************************************
 * Extensions
 *
 * extension methods cannot be inherited and cannot be overridden
 *
 * extensions need to be imported, so if this were defined in a package
 * called "extensions", then import as
 *
 * "import extensions.second"
 *
 * then use it as:
 *
 * val string = "12"
 * print(string.second())
 */

// String is called the receiver type
// the receiver object can be referenced through "this"
fun String.second(): Char {
    if (isEmpty()) throw NoSuchElementException("Char sequence is empty.")
    if (length < 2) throw NoSuchElementException("Char sequence length is less than 2.")
    return this[1]
}

val string = "12"
println(string.second())

/*************************************************
 * Infix functions
 *
 * Infix functions have their own position in operator precedence.
 *
 * One of the most common infix function is the to function to
 * create a Pair object. It can be invoked in this way
 *
 * 1 to "apple"
 * instead of
 * 1.to("apple")
 *
 * When calling infix function inside the class that it is defined,
 * it is important to explicitly use this.
 *
 * Rules:
 * 1. Must be a member function or an extension function
 * 2. Must have a single parameter
 * 3. Parameter is not vararg and has no default value.
 */

class Warrior(var hp: Int, var ap: Int) {
    infix fun attack(anotherWarrior: Warrior) {
        anotherWarrior.hp -= ap
    }
}

fun attackTest() {
    val warrior1 = Warrior(100, 20)
    val warrior2 = Warrior(100, 15)

    //**** HERE IS THE USE OF THE INFIX FUNCTION ****
    warrior1 attack warrior2
    println("Warrior 2 HP : ${warrior2.hp}")
}

attackTest()
