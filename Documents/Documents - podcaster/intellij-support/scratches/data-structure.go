package main
import "fmt"

/*
Data structures in Golang.
*/

/*
Stack Abstract Data Type (ADT) without a max size
Daily usage:
1. Open and closing the curly braces problem in programs
2. Going back in the browser history
3. An "undo" mechanism in text editors; this operation is accomplished by keeping all text changes in a stack.
 */
type Stack []string

// check if stack is empty
func (s *Stack) isEmpty() bool {
	return len(*s) == 0
}

// push new string onto stack
func (s *Stack) Push(str string) {
	*s = append(*s, str)
}

// Remove and return top element of stack. Return false if stack is empty.
func (s *Stack) Pop() (string, bool) {
	if s.isEmpty() {
		return  "", false
	} else {
		index := len(*s) - 1 // Get the index of the top most element.
		element := (*s)[index] // Index into the slice and obtain the element.
		*s = (*s)[:index] // Remove it from the stack by slicing it off.
		return element, true
	}
}

// Return top element of stack. Return false if stack is empty.
func (s *Stack) Peek() (string, bool) {
	if s.isEmpty() {
		return  "", false
	} else {
		index := len(*s) - 1 // Get the index of the top most element.
		element := (*s)[index] // Index into the slice and obtain the element.
		return element, true
	}
}

func (s *Stack) size() int  {
	return  len(*s)
}

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
type Queue []int

func (q *Queue) isEmpty() bool {
	return  len(*q) == 0
}

func (q *Queue) size() int {
	return  len(*q)
}

func (q *Queue) peek() (int, bool) {
	if q.isEmpty() {
		return  -1, false
	} else  {
	    return
	}
}

func main() {
	var stack Stack // create a stack variable of type Stack

	stack.Push("this")
	stack.Push("is")
	stack.Push("sparta!!")

	fmt.Println("Size of stack: ", stack.size())

	for len(stack) > 0 {
		x, y := stack.Pop()
		if y == true {
			fmt.Println(x)
		}
	}
}
