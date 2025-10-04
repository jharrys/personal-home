// All examples are using RxJS v6+

/*
Subject - A special type of Observable which shares a single execution path among observers.
The variants of Subject have two goals: sharing and remembering values.

Remember the sharing part ... mostly used for multicasting.
 */
console.clear();
import {Subject} from 'rxjs';

const sub = new Subject();

sub.next(1);    // Note: no output 'Subscriber A 1' - no subscriber yet
sub.subscribe(x => {
  console.log('Subscriber A', x);
});
sub.next(2); // OUTPUT => Subscriber A 2
sub.subscribe(x => {
  console.log('Subscriber B', x);
});
sub.next(3); // OUTPUT => Subscriber A 3, Subscriber B 3 (logged from both subscribers)

///////////////////////////////////////////////////////////////////////////////

/*
BehaviorSubject - created with an initial value; new subscribers get the
last value submitted before their subscription, plus ongoing.
 */
console.clear();
import {BehaviorSubject} from 'rxjs';

const subject = new BehaviorSubject(123);

//two new subscribers will get initial value => output: 123, 123
subject.subscribe(console.log);
subject.subscribe(console.log);

//two subscribers will get new value => output: 456, 456
subject.next(456);

//new subscriber will get latest value (456) => output: 456
subject.subscribe(console.log);

//all three subscribers will get new value => output: 789, 789, 789
subject.next(789);

// output: 123, 123, 456, 456, 456, 789, 789, 789

///////////////////////////////////////////////////////////////////////////////

/*
ReplaySubject - "Replays" or emits the last X  old values to new subscribers.

Note the replays behave as if the lambda was played for each one of them.

Also see the operator shareReplay (underlying implementation uses ReplaySubject)
https://www.learnrxjs.io/learn-rxjs/operators/multicasting/sharereplay
https://github.com/ReactiveX/rxjs/blob/b25db9f369b07f26cf2fc11714ec1990b78a4536/src/internal/operators/shareReplay.ts#L26-L37
 */
console.clear();
import {ReplaySubject} from 'rxjs';

const sub = new ReplaySubject(3); // 3: # of previous values to emit w/ new sub.

sub.next(1);
sub.next(2);
sub.subscribe(console.log); // OUTPUT => 1,2
sub.next(3); // OUTPUT => 3
sub.next(4); // OUTPUT => 4
sub.subscribe(console.log); // OUTPUT => 2,3,4 (log of last 3 values from new subscriber)
sub.next(5); // OUTPUT => 5,5 (log from both subscribers)

///////////////////////////////////////////////////////////////////////////////

/*
AsyncSubject - Emits its last value on completion.
Rarely used, mostly want a BehaviorSubject or ReplaySubject.

Use case: AsyncSubject are for heavy computations that *eventually* results in
a value. It's kind of like a Promise.

Subjects have two essential goals: sharing and remembering.
All subjects share. Some remember.

AsyncSubject does both, but only remembers the very last thing.

So for each observer, the heavy computation doesn't need to be redone. The
result of the heavy computation is remembered and provided to each observer.

One might say that a Subject using the operator last could effect the same thing.
However, Subject's are used primarily for multicasting, so a Subject won't effect
the same behaviour for late subscribers. With AsyncSubject, late subscribers will
still get the final result of a heavy computation. (there are details on
the multicast behavior: https://medium.com/angular-in-depth/rxjs-understanding-subjects-5c585188c3e1)
 */
import {AsyncSubject} from 'rxjs';

const sub = new AsyncSubject();

sub.subscribe(console.log);

sub.next(123); //nothing logged

sub.subscribe(console.log);

sub.next(456); //nothing logged
sub.complete(); //456, 456 logged by both subscribers
console.log('after complete')
sub.subscribe(console.log);

///////////////////////////////////////////////////////////////////////////////

/*
debounceTime - delay events coming in faster than x (keyup event combines them)
distinctUntilChanged - skips any repeats right after each other (===)
tap - side effects like console.log without affecting the value
distinctUntilChange((prev, curr) => prev.name === curr.name) - to override comparer
 */
console.clear();
import {fromEvent, of} from 'rxjs';
import {
  debounceTime,
  distinctUntilChanged,
  map,
  switchMap,
  tap
} from 'rxjs/operators';

const getContinents = keys => [
  'africa',
  'antarctica',
  'asia',
  'australia',
  'europe',
  'north america',
  'south america'
].filter(e => e.indexOf(keys.toLowerCase()) > -1);

const fakeContinentsRequest = keys => of(getContinents(keys))
.pipe(
    tap(_ => console.log(`API CALL at ${new Date()} with ${keys}`))
);

fromEvent(document.getElementById('type-ahead'), 'keyup')
.pipe(
    map((e: any) => e.target.value), // before debounce map happens immediately - can remove, i added it for understanding
    tap(k => console.log('keyup: ' + k)), // logs immediate mapped keyup - i added to show
    debounceTime(1000), // drops all events if done inside of 1000ms
    distinctUntilChanged(), // keyups on shift or non-printing keys (control, cmd, etc) would send same letters already typed, this ignores those
    tap(d => console.log('after debounce: ' + d)),
    switchMap(fakeContinentsRequest),
    tap(c => document.getElementById('output').innerText = c.join('\n'))
).subscribe();
