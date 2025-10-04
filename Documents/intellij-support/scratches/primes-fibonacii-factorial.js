// cool use of arrays
function getPrimes(number) {
  if (typeof number == "number") {
    if (number < 0) {
      return "negative integers can not be prime";
    }
    if (number === 0) {
      return "zero is not a prime number";
    }
    if (number === 1) {
      return "1 is not a prime number";
    }
    const nonprimes = [];  // Array of non prime numbers
    let i, j, primes = []; // Array of prime numbers
    for (i = 2; i <= number; ++i) {
      if (!nonprimes[i]) {
        // i has not been marked -- it is prime
        primes.push(i);
        for (j = i << 1; j <= number; j += i) {
          nonprimes[j] = true;
        }
      }
    }
    return primes;  // Array of prime numbers
  } else {
    return "invalid input";
  }
}

// Fibonacci sequence. Starting with 0 and 1, it is the previous two numbers
// added together.
function fibonacci(num) {
  if (num === 1 || num === 2) {
    return 1
  }
  return fibonacci(num - 1) + fibonacci(num - 2)
}

// How to print out fibonacci_series
const fibonacci_series = function (n) {
  if (n === 1) {
    return [0, 1];
  } else {
    console.log("n=" + n)
    const s = fibonacci_series(n - 1);
    s.push(s[s.length - 1] + s[s.length - 2]);
    console.log("n= " + n + ";s=" + s)
    return s;
  }
};
console.log(fibonacci_series(8))

// factorialize(5) = 5*4*3*2*1=120
function factorialize(num) {
  if (num < 0)
    return -1;
  else if (num == 0)
    return 1;
  else {
    return (num * factorialize(num - 1));
  }
}
