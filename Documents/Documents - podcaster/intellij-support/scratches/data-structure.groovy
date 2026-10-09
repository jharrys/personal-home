/*
Adding different data structure implementations.
*/

/*
Stack Abstract Data Type (ADT) without a max size
Daily usage:
1. Open and closing the curly braces problem in programs
2. Going back in the browser history
3. An "undo" mechanism in text editors; this operation is accomplished by keeping all text changes in a stack.
-----
isEmpty
isFull
push
pop
peek
size
 */
class Stack {

    int MAXSIZE = 10
    def array
    int top = -1

    public Stack() {
        array = new Integer[MAXSIZE]
        top = -1
    }

    public Stack(int size) {
        MAXSIZE = size
    }

    boolean isEmpty() {
        top == -1 ? true : false
    }

    boolean isFull() {
        top == MAXSIZE ? true : false
    }

    int peek() {
        return array[top]
    }

    int pop() {
        int result
        if (!isEmpty()) {
            result = array[top]
            top--
        } else {
            println("Stack is empty.")
        }
        return result
    }

    void push(int datum) {
        if(!isFull()) {
            top++
            array[top] = datum
        } else {
            println("Stack is full.")
        }
    }
}
println("-----------------------------------------------------------------------")
println("Stack ADT in Groovy")
println("-----------------------------------------------------------------------")
Stack stack = new Stack()
stack.push(1)
stack.push(5)
stack.push(31)
stack.push(6)

println("peek: ${stack.peek()}")
println("pop: ${stack.pop()}")
println("peek: ${stack.peek()}")

/*
-----------------------------------------------------
Queue ADT
Implemented like a sliding window of MAX size. As front and rear move, front being the first in/first out.
-------
enqueue
dequeue
peek
isFull
isEmpty
 */

class Queue {
    int MAX = 10
    def array
    int front = 0   // FIFO - we take off of the front and move front backwards
    int rear = -1   // Where we add things
    int count = 0

    Queue() {
        array = new Integer[MAX]
    }

    Queue(int max) {
        MAX = max
        Queue()
    }

    int peek() {
        return array[front]
    }

    boolean isEmpty() {
        return count == 0
    }

    boolean isFull() {
        return count == MAX
    }

    int size() {
        return count
    }

    void insert (int datum) {
        if (!isFull()) {
            // if rear is at end of array, reset to -1 as we are starting over
            if (rear == MAX - 1) {
                rear = -1
            }

            array[++rear] = datum
            count++
        }
    }

    int remove() {
        // first access array[front] and then add 1 to front
        int data = array[front++]

        if (front == MAX) {
            front = 0
        }

        count--
        return data
    }

}
println("-----------------------------------------------------------------------")
println("Queue ADT in Groovy")
println("-----------------------------------------------------------------------")
Queue q = new Queue()
/* insert 5 items */
q.insert(3)
q.insert(5)
q.insert(9)
q.insert(1)
q.insert(12)

// front : 0
// rear  : 4
// ------------------
// index : 0 1 2 3 4
// ------------------
// queue : 3 5 9 1 12
q.insert(15)

// front : 0
// rear  : 5
// ---------------------
// index : 0 1 2 3 4  5
// ---------------------
// queue : 3 5 9 1 12 15

if(q.isFull()) {
    printf("Queue is full!\n")
}

// remove one item
int num = q.remove()

printf("Element removed: %d\n",num)
// front : 1
// rear  : 5
// -------------------
// index : 1 2 3 4  5
// -------------------
// queue : 5 9 1 12 15

// insert more items
q.insert(16)

// front : 1
// rear  : -1
// ----------------------
// index : 0  1 2 3 4  5
// ----------------------
// queue : 16 5 9 1 12 15

// As queue is full, elements will not be inserted.
q.insert(17)
q.insert(18)

// ----------------------
// index : 0  1 2 3 4  5
// ----------------------
// queue : 16 5 9 1 12 15
printf("Element at front: %d\n",q.peek())

printf("----------------------\n")
printf("index : 5 4 3 2  1  0\n")
printf("----------------------\n")
printf("Queue:  ")

while(!q.isEmpty()) {
    int n = q.remove()
    printf("%d ",n)
}
