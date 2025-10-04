# Data Structures

## A few important categories

- **search** -  Algorithm to search an item in a data structure.
- **sort** - Algorithm to sort items in a certain order.
- **insert** - Algorithm to insert item in a data structure.
- **update** - Algorithm to update an existing item in a data structure.
- **delete** - Algorithm to delete an existing item from a data structure.

## Characteristics of an algorithm

- **unambiguous** − Algorithm should be clear and unambiguous. Each of its steps (or phases), and their inputs/outputs should be clear and must lead to only one meaning.
- **input** − An algorithm should have 0 or more well-defined inputs.
- **output** − An algorithm should have 1 or more well-defined outputs, and should match the desired output.
- **finiteness** − Algorithms must terminate after a finite number of steps.
- **feasibility** − Should be feasible with the available resources.
- **independent** − An algorithm should have step-by-step directions, which should be independent of any programming code.

## Algorithm complexity

- **time factor** - counting the number of key operations
- **space factor** - the maximum memory required to run the algorithm
- **big oh notation (O)** - worst case time complexity
- **omega notation (Ω)** - best case time complexity
- **theta notation (ϑ)** - express both lower bound and upper bound of an algorithm's running time (avg of big oh and omega)

## Asymptotic notation

_Asymptotic_ means approaching a value or curve arbitrarily closely (i.e., as some sort of limit is taken).
We use this model to ignore the constant factors and insignificant parts of an expression, to
device a better way of representing complexities of algorithms, in a single coefficient, so that
comparison between algorithms can be done easily.

| name        |            | notation |
|-------------|:----------:|---------:|
| constant    | - |    Ο(1) |
| logarithmic | - |    Ο(log n) |
| linear      | - |    Ο(n) |
| n log n	  | - |    Ο(n log n) |
| quadratic   | - |    Ο(n^2) |
| cubic       | - |    Ο(n^3)|
| polynomial  | - |    n^Ο(1)|
| exponential | - |    2^Ο(n) |

## Calculating complexity in code

1. Assess a O() for each line of code.
2. Add them up, using multiplication for nested loops.
3. A for loop that loops through all n O(n) then multiplied with all operations inside loop.

`Below: O(n)*(O(1) + O(1)) => O(2n) => O(n).`

```
for (int i=0; i<N; i++) {
  int tmp = array[i] // O(1)
  tmp = tmp + 1 // O(1)
}
```

Another example ... my thoughts/theory
```
for(int i=0; i<N; i++) { // O(n)
  for(int j=0; j<N/2; j++) { // O(log n) - my attempting at doing pseudo code to show binary search or log n
    int tmp = array[j] // O(1)
  }
}
```
`Above: O(n) * O(log n) * O(1) => O(n log n)`

