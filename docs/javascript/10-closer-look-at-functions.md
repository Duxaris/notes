# Section 10: A Closer Look at Functions

## Key Concepts

- **Default Parameters**

  - ES6 feature allowing function parameters to have default values
  - Prevents `undefined` errors when arguments are missing
  - Can use expressions and reference other parameters
  - **Why useful**: Makes functions more robust and user-friendly

- **Passing Arguments: Value vs Reference**

  - **Primitives**: Passed by value (copies are made)
  - **Objects**: Passed by reference (same object in memory)
  - JavaScript doesn't have "pass by reference" for primitives
  - **Key insight**: Functions can't change primitive values but can mutate objects

- **First-Class Functions**

  - Functions are treated as values in JavaScript
  - Can be stored in variables, passed as arguments, returned from functions
  - Enables functional programming patterns
  - **Mental model**: Functions are just another type of object

- **Higher-Order Functions**

  - Functions that receive other functions as arguments OR return functions
  - Examples: `forEach`, `map`, `filter`, event listeners
  - Enable powerful abstractions and code reuse
  - **Pattern**: Separate what we do from how we do it

- **The `call`, `apply`, and `bind` Methods**

  - Manually set the `this` keyword in function calls
  - **`call()`**: Calls function with specified `this` and arguments
  - **`apply()`**: Like `call()` but takes array of arguments
  - **`bind()`**: Returns new function with `this` permanently bound
  - **Use case**: Borrowing methods between objects

- **Immediately Invoked Function Expressions (IIFE)**

  - Functions that execute immediately after definition
  - Creates private scope, prevents variable pollution
  - Pattern: `(function() { /* code */ })()`
  - **Modern alternative**: Block scope with `let`/`const`

- **Closures**
  - Function has access to variables from its outer scope even after outer function returns
  - **"Backpack"**: Function carries its environment with it
  - Enables data privacy and factory functions
  - **Key rule**: Inner function has access to outer function's variables

## Code Patterns

### Default Parameters

```js
// ES6 default parameters
const bookings = [];

const createBooking = function (
  flightNum,
  numPassengers = 1,
  price = 199 * numPassengers // Can use expressions and other parameters
) {
  // ES5 way (before default parameters)
  // numPassengers = numPassengers || 1;
  // price = price || 199;

  const booking = {
    flightNum,
    numPassengers,
    price,
  };

  console.log(booking);
  bookings.push(booking);
};

createBooking('LH123'); // Uses defaults
createBooking('LH123', 2); // price = 199 * 2 = 398
createBooking('LH123', 2, 800); // All parameters provided

// Skipping parameters (use undefined)
createBooking('LH123', undefined, 1000); // Skip numPassengers, keep default
```

### Passing Arguments: Value vs Reference

```js
const flight = 'LH234';
const jonas = {
  name: 'Jonas Schmedtmann',
  passport: 24739479284,
};

const checkIn = function (flightNum, passenger) {
  flightNum = 'LH999'; // Changes only the copy
  passenger.name = 'Mr. ' + passenger.name; // Changes the original object

  if (passenger.passport === 24739479284) {
    console.log('Checked in');
  } else {
    console.log('Wrong passport!');
  }
};

checkIn(flight, jonas);
console.log(flight); // Still 'LH234' (primitive not changed)
console.log(jonas); // Name changed to 'Mr. Jonas Schmedtmann' (object mutated)

// Another function modifying the same object
const newPassport = function (person) {
  person.passport = Math.trunc(Math.random() * 100000000000);
};

newPassport(jonas);
checkIn(flight, jonas); // Now fails because passport changed

// Key lesson: Be careful when multiple functions manipulate the same object
```

### Higher-Order Functions

```js
// Functions that accept other functions
const oneWord = function (str) {
  return str.replace(/ /g, '').toLowerCase();
};

const upperFirstWord = function (str) {
  const [first, ...others] = str.split(' ');
  return [first.toUpperCase(), ...others].join(' ');
};

// Higher-order function
const transformer = function (str, fn) {
  console.log(`Original string: ${str}`);
  console.log(`Transformed string: ${fn(str)}`);
  console.log(`Transformed by: ${fn.name}`); // Functions have name property
};

transformer('JavaScript is the best!', upperFirstWord);
transformer('JavaScript is the best!', oneWord);

// Built-in higher-order functions
const high5 = function () {
  console.log('👋');
};

document.body.addEventListener('click', high5); // addEventListener is higher-order
['Jonas', 'Martha', 'Adam'].forEach(high5); // forEach is higher-order

// Functions returning other functions
const greet = function (greeting) {
  return function (name) {
    console.log(`${greeting} ${name}`);
  };
};

const greeterHey = greet('Hey');
greeterHey('Jonas'); // Hey Jonas
greeterHey('Steven'); // Hey Steven

// One-liner arrow function version
const greetArr = (greeting) => (name) => console.log(`${greeting} ${name}`);
greetArr('Hi')('Jonas'); // Hi Jonas
```

### The call, apply, and bind Methods

```js
const lufthansa = {
  airline: 'Lufthansa',
  iataCode: 'LH',
  bookings: [],

  book(flightNum, name) {
    console.log(
      `${name} booked a seat on ${this.airline} flight ${this.iataCode}${flightNum}`
    );
    this.bookings.push({ flight: `${this.iataCode}${flightNum}`, name });
  },
};

lufthansa.book(239, 'Jonas Schmedtmann');
lufthansa.book(635, 'John Smith');

const eurowings = {
  airline: 'Eurowings',
  iataCode: 'EW',
  bookings: [],
};

// Extract method (loses this binding)
const book = lufthansa.book;

// book(23, 'Sarah Williams'); // TypeError: Cannot read property 'airline' of undefined

// Call method - manually set this keyword
book.call(eurowings, 23, 'Sarah Williams');
console.log(eurowings);

book.call(lufthansa, 239, 'Mary Cooper');
console.log(lufthansa);

const swiss = {
  airline: 'Swiss Air Lines',
  iataCode: 'LX',
  bookings: [],
};

book.call(swiss, 583, 'Mary Cooper');

// Apply method - takes array of arguments
const flightData = [583, 'George Cooper'];
book.apply(swiss, flightData);

// Modern way: use call with spread operator
book.call(swiss, ...flightData);

// Bind method - returns new function with this bound
const bookEW = book.bind(eurowings);
const bookLH = book.bind(lufthansa);
const bookLX = book.bind(swiss);

bookEW(23, 'Steven Williams');

// Partial application with bind
const bookEW23 = book.bind(eurowings, 23); // Pre-set flight number
bookEW23('Jonas Schmedtmann'); // Only need to pass name
bookEW23('Martha Cooper');

// Bind with event listeners
lufthansa.planes = 300;
lufthansa.buyPlane = function () {
  console.log(this);
  this.planes++;
  console.log(this.planes);
};

// Without bind, this would be the button element
document
  .querySelector('.buy')
  .addEventListener('click', lufthansa.buyPlane.bind(lufthansa));

// Partial application pattern
const addTax = (rate, value) => value + value * rate;
console.log(addTax(0.1, 200)); // 220

// Create specialized functions
const addVAT = addTax.bind(null, 0.23); // null because we don't care about this
// Same as: addVAT = value => value + value * 0.23;

console.log(addVAT(100)); // 123
console.log(addVAT(23)); // 28.29

// Function returning function approach
const addTaxRate = function (rate) {
  return function (value) {
    return value + value * rate;
  };
};
const addVAT2 = addTaxRate(0.23);
console.log(addVAT2(100)); // 123
```

### Immediately Invoked Function Expressions (IIFE)

```js
// Normal function
const runOnce = function () {
  console.log('This will run again');
};
runOnce();

// IIFE - runs immediately and can't be called again
(function () {
  console.log('This will never run again');
  const isPrivate = 23; // Private variable
})();

// console.log(isPrivate); // ReferenceError

// Arrow function IIFE
(() => console.log('This will ALSO never run again'))();

// Modern way: block scope
{
  const isPrivate = 23;
  var notPrivate = 46;
}

// console.log(isPrivate); // ReferenceError
console.log(notPrivate); // 46 (var is function-scoped, not block-scoped)

// Use case: Execute code immediately without polluting global scope
(function () {
  // Initialization code that runs once
  const app = {
    init() {
      console.log('App initialized');
    },
  };
  app.init();
})();
```

### Closures

```js
// Basic closure example
const secureBooking = function () {
  let passengerCount = 0; // Private variable

  return function () {
    passengerCount++; // Has access to outer variable
    console.log(`${passengerCount} passengers`);
  };
};

const booker = secureBooking();
booker(); // 1 passengers
booker(); // 2 passengers
booker(); // 3 passengers

// Even though secureBooking finished executing,
// booker still has access to passengerCount

// Closure inspection
console.dir(booker); // Shows [[Scopes]] in browser console

// More closure examples
let f;

const g = function () {
  const a = 23;
  f = function () {
    console.log(a * 2); // Closure over 'a'
  };
};

const h = function () {
  const b = 777;
  f = function () {
    console.log(b * 2); // New closure over 'b'
  };
};

g();
f(); // 46
console.dir(f);

// Re-assign f variable
h();
f(); // 1554
console.dir(f); // New closure

// Timer example
const boardPassengers = function (n, wait) {
  const perGroup = n / 3;

  setTimeout(function () {
    console.log(`We are now boarding all ${n} passengers`);
    console.log(`There are 3 groups, each with ${perGroup} passengers`);
  }, wait * 1000);

  console.log(`Will start boarding in ${wait} seconds`);
};

const perGroup = 1000; // This is ignored due to closure
boardPassengers(180, 3);

// Factory function using closures
const createCounter = function (start = 0) {
  let count = start;

  return {
    increment() {
      count++;
      return count;
    },
    decrement() {
      count--;
      return count;
    },
    get() {
      return count;
    },
  };
};

const counter1 = createCounter(10);
const counter2 = createCounter();

console.log(counter1.increment()); // 11
console.log(counter1.increment()); // 12
console.log(counter2.increment()); // 1
console.log(counter1.get()); // 12
console.log(counter2.get()); // 1

// Each counter has its own closure over 'count'
```

## Practical Exercises

### Coding Challenge: Poll Application

```js
const poll = {
  question: 'What is your favourite programming language?',
  options: ['0: JavaScript', '1: Python', '2: Rust', '3: C++'],
  answers: new Array(4).fill(0),

  registerNewAnswer() {
    // Get answer
    const answer = Number(
      prompt(
        `${this.question}\n${this.options.join('\n')}\n(Write option number)`
      )
    );

    // Register answer
    typeof answer === 'number' &&
      answer < this.answers.length &&
      this.answers[answer]++;

    this.displayResults();
    this.displayResults('string');
  },

  displayResults(type = 'array') {
    if (type === 'array') {
      console.log(this.answers);
    } else if (type === 'string') {
      console.log(`Poll results are ${this.answers.join(', ')}`);
    }
  },
};

// Event listener using bind
document
  .querySelector('.poll')
  .addEventListener('click', poll.registerNewAnswer.bind(poll));

// Bonus: Use displayResults with different data
poll.displayResults.call({ answers: [5, 2, 3] }, 'string');
poll.displayResults.call({ answers: [1, 5, 3, 9, 6, 1] });
```

### Function Challenge: Closure Practice

```js
// Challenge: Create a function that keeps track of how many times it's called
const createCallTracker = function () {
  let callCount = 0;

  return function (message = 'Function called') {
    callCount++;
    console.log(`${message} - Call #${callCount}`);
    return callCount;
  };
};

const tracker1 = createCallTracker();
const tracker2 = createCallTracker();

tracker1('First call'); // First call - Call #1
tracker1('Second call'); // Second call - Call #2
tracker2('Different tracker'); // Different tracker - Call #1
tracker1(); // Function called - Call #3

// Each tracker maintains its own count due to closures
```

## Advanced Patterns

### Function Composition

```js
// Compose functions together
const add = (x) => (y) => x + y;
const multiply = (x) => (y) => x * y;
const subtract = (x) => (y) => y - x;

// Function composition utility
const compose =
  (...fns) =>
  (value) =>
    fns.reduceRight((acc, fn) => fn(acc), value);
const pipe =
  (...fns) =>
  (value) =>
    fns.reduce((acc, fn) => fn(acc), value);

// Usage
const addFive = add(5);
const multiplyByTwo = multiply(2);
const subtractThree = subtract(3);

const calculate = pipe(addFive, multiplyByTwo, subtractThree);
console.log(calculate(10)); // (10 + 5) * 2 - 3 = 27
```

### Memoization with Closures

```js
// Cache expensive function results
const memoize = function (fn) {
  const cache = {};

  return function (...args) {
    const key = args.toString();
    if (cache[key]) {
      console.log('From cache');
      return cache[key];
    }

    console.log('Calculating...');
    const result = fn.apply(this, args);
    cache[key] = result;
    return result;
  };
};

// Expensive function
const factorial = memoize(function (n) {
  if (n <= 1) return 1;
  return n * factorial(n - 1);
});

console.log(factorial(5)); // Calculating... 120
console.log(factorial(5)); // From cache 120
```

## Key Takeaways

1. **Default parameters** make functions more robust and user-friendly
2. **Objects are passed by reference** - be careful about mutations
3. **Higher-order functions** enable powerful abstractions
4. **`bind()` is crucial** for setting `this` context
5. **Closures provide data privacy** and enable powerful patterns
6. **IIFE creates immediate private scope** (though blocks are more modern)
7. **Functions are first-class citizens** - treat them as values

---

_Understanding these function concepts unlocks advanced JavaScript patterns! 🚀_
