/*
Adding different data structure implementations.

Executing:
- from cli: `kotlinc -script data-structure.kts`
- or just run from idea
*/

/*
Stack Abstract Data Type (ADT)
Daily usage:
1. Open and closing the curly braces problem in programs
2. Going back in the browser history
3. An "undo" mechanism in text editors; this operation is accomplished by keeping all text changes in a stack.
 */
class Stack(size:Int) {
    private var maxSize = size
    private var array = IntArray(maxSize)
    private var top = -1

    fun isEmpty(): Boolean {
        return top == -1
    }

    fun isFull(): Boolean {
        return top == maxSize-1
    }

    fun push(datum: Int) {
        if (isFull()) {
            println("Stack is full.")
            return
        }

        top++
        this.array[top] = datum
    }

    fun pop() : Any {
        if (isEmpty()) {
            throw Exception("Stack is empty.")
        }

        var data: Int = this.array[top--]
        return data
    }

    fun peek() : Any {
        return this.array[top]
    }

    fun size() : Any {
        return top+1
    }
}

var stack = Stack(10)
println("is Stack empty : "+stack.isEmpty())
stack.push(15)
println("peek is : " +stack.peek())
stack.push(534)
stack.push(5)
stack.push(13)
println("the pop elements is : " +stack.pop())
println("the size is : " +stack.size())
println("is Stack empty : " +stack.isEmpty())
println("is Stack full : " +stack.isFull())
