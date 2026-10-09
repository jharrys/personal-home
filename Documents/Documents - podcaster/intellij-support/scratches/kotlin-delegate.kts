import kotlin.properties.Delegates

class DelegatePropertiesExample(map: MutableMap<String, Any?>) {
    var key1: String by map
    var key2: String by map
    var key3: Any? by map
}

var aMap: MutableMap<String, Any?> = mutableMapOf("one" to 1, "two" to 2)

var delegatePropsExample = DelegatePropertiesExample(aMap)

println(aMap)

delegatePropsExample.key1 = "value1"
delegatePropsExample.key2 = "value2"
delegatePropsExample.key3 = 98.6f

println(aMap)

/*************************************************
 * Lazy Delegate
 */
class User(val id: Int) {
    // note name is val, because it's lazy it can be instantiated late
    val name: String by lazy {
        // load service ... super expensive
        Thread.sleep(1000)
        "Robert"
    }
}

val user = User(1)
println(user.name)

/*************************************************
 * Observeable Delegate
 */
var observableData: String by Delegates.observable("my initial value") { property, oldValue,
                                                                      newValue ->
    println("${property.name}: $oldValue -> $newValue")
}

observableData = "hello"
observableData = "goodbye"

/*************************************************
 * Vetoable Delegate
 */
var vetoableData: Int by Delegates.vetoable(0) { property, oldValue, newValue ->
    println("${property.name}: $oldValue -> $newValue")
    newValue >= 0
}

vetoableData = -1
println("vetoableData = $vetoableData")
vetoableData = 1
println("vetoableData = $vetoableData")

