# Kotlin Suspending Function
A suspending function says, suspend me and my coroutine and allow the calling coroutine to start time slicing, then come back and check on me to see if I'm done or ready for more work.

```
fun testRunFunction() {
    runBlocking { // allows all this to happen in single thread - main
        // Start a coroutine - coroutineContext param makes it happen in main
        launch(coroutineContext) {
            println("In start : ${Thread.currentThread().name}")
            delay(200)
            println("In ended : ${Thread.currentThread().name}")
        }

        run {
            println("Out start: ${Thread.currentThread().name}")
            delay(300)
            println("Out ended: ${Thread.currentThread().name}")
        }
    }
}
```
Output

```
Out start: main
In start : main
In ended : main
Out ended: main
```

runBlocking is a coroutine builder that starts the main coroutine (C1) in Thread main.

launch is another coroutine builder within it (C2), and it starts the process of starting up, in the meantime the run block (C1) continues to execute.

The run block (C1) calls a suspending function, delay, which suspends C1 without blocking and places the thread it was using back in the pool. This allows C2 to run concurrently (time slice) and start its code block by grabbing a thread from the thread pool to continue executing its own code. C2 prints out and calls delay (again a suspending function), suspending C2. But delay is shorter than the C1 delay, so it comes back quicker, hence you see "In ended: main" before C1's last print out.

Note (proving suspend over blocking): if you replaced C1's delay in the run block with "Thread.sleep(300)", you would see the output to be:

```
Out start: main
Out ended: main
In start : main
In ended : main
```

Because C2 would not get a chance to run concurrently, as C1 would not suspend itself. Instead, it blocks the whole Thread (we constrained it to the main Thread) so that C1 would complete first and then allow C2 to run.


