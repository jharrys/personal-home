// create scaffolding for new react app using npx
npx create-react-app my-app
cd my-app
npm start

// functional composition in js (currying)
// here is a generic compose function using reduce and spread operator
// ...fns becomes basically an array of functions passed into compose
// reduce is a method on arrays
// https://www.w3schools.com/jsref/jsref_reduce.asp#:~:text=
const compose = (...fns) =>
    fns.reduce((f, g) => (...args) => f(g(...args)));

// Example to use compose
// curriedSubstring is a simple example of functional composition
const curriedSubstring = start => length => str => str.substr(start, length);

const curriedLowerCase = str => str.toLowerCase ();

const toAscii = str => str.charCodeAt(0);

// ...fns resolves to the array of functions
// ...args resolves to the arguments (initially it's "Johnnie", but then it's the results of each applied function
const compose = (...fns) =>
    fns.reduce((f, g) => (...args) => f(g(...args)));

const getNewComposedFirstCharacterAsLower
    = compose (toAscii, curriedLowerCase, curriedSubstring (0) (1));

console.log(getNewComposedFirstCharacterAsLower('Johnnie'))
// output will be int 106 of lowercase 'j'
