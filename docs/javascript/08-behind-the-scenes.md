# Section 8: How JavaScript Works Behind the Scenes

## Key Concepts

- **JavaScript Engine**

  - V8 (Chrome, Node.js), SpiderMonkey (Firefox), JavaScriptCore (Safari)
  - **Call stack**: Execution context stack (LIFO - Last In, First Out)
  - **Heap**: Memory allocation for objects
  - **Compilation vs Interpretation**: JS is interpreted and just-in-time compiled
  - **Mental model**: Think of the engine as a factory that processes your code line by line

- **Execution Context**

  - Environment where JavaScript code is executed
  - **Global Execution Context**: Created for top-level code (the main "room" where code runs)
  - **Function Execution Context**: Created for each function call (temporary "rooms" for functions)
  - Contains: Variable Environment, Scope Chain, `this` keyword
  - **Analogy**: Like different rooms in a house, each with their own environment and access rules

- **Hoisting**

  - Variables and function declarations are "moved" to the top
  - **Function declarations**: Fully hoisted (can call before declaration - like having a phone book)
  - **var variables**: Hoisted but initialized with `undefined` (placeholder exists but empty)
  - **let/const**: Hoisted but in "temporal dead zone" (exists but inaccessible until declaration)
  - **Function expressions/arrows**: Not hoisted (treated as variables)
  - **Why it matters**: Understanding hoisting prevents bugs and explains unexpected behavior

- **Scope and Scope Chain**

  - **Global scope**: Accessible everywhere (like public areas in a building)
  - **Function scope**: Accessible only within function (like private offices)
  - **Block scope**: `let`/`const` are block-scoped, `var` is not (like locked rooms vs open doors)
  - **Scope chain**: Inner scopes have access to outer scopes (like nested Russian dolls)
  - **Key rule**: Variables look "outward" for access, never "inward"

- **The `this` Keyword**
  - Refers to the object that is executing the current function
  - **Method**: `this` = object calling the method (the owner of the method)
  - **Simple function call**: `this` = undefined (strict mode) / window (non-strict)
  - **Arrow functions**: `this` = lexical `this` (inherits from parent scope - like a chameleon)
  - **Event listeners**: `this` = DOM element (the element that triggered the event)
  - **Remember**: `this` is determined by HOW a function is called, not WHERE it's defined

## Code Patterns

### Hoisting Examples

```js
// Function hoisting
console.log(addDeclaration(2, 3)); // Works! Returns 5

function addDeclaration(a, b) {
  return a + b;
}

// Variable hoisting
console.log(me); // undefined (not error!)
console.log(job); // ReferenceError: Cannot access 'job' before initialization
// Variable hoisting demonstration
console.log(me); // undefined (var is hoisted but not initialized)
console.log(job); // ReferenceError: Cannot access 'job' before initialization
console.log(year); // ReferenceError: Cannot access 'year' before initialization

var me = 'Jonas'; // var: hoisted with undefined value
let job = 'teacher'; // let: hoisted but in temporal dead zone
const year = 1991; // const: hoisted but in temporal dead zone

// Function expressions and hoisting (treated like variables)
console.log(addExpression); // undefined (var is hoisted)
console.log(addExpression(2, 3)); // TypeError: addExpression is not a function

var addExpression = function (a, b) {
  return a + b;
}; // Function expression: not hoisted like function declarations

// Arrow functions and hoisting (same as function expressions)
console.log(addArrow); // ReferenceError: Cannot access 'addArrow' before initialization

const addArrow = (a, b) => a + b; // Arrow function: follows const hoisting rules

// Hoisting gotcha - why var can be dangerous
if (!numProducts) deleteShoppingCart(); // This will run because numProducts is undefined!
// numProducts is hoisted as undefined, so !undefined = true

var numProducts = 10;

function deleteShoppingCart() {
  console.log('All products deleted!');
}
```

### Scope Chain Examples

```js
// Global scope
const myName = 'Jonas';

function first() {
  // Function scope
  const age = 30;

  if (age >= 30) {
    // Block scope
    const decade = 3;
    var millenial = true;
  }

  function second() {
    // Function scope (nested)
    const job = 'teacher';

    // Scope chain in action
    console.log(`${myName} is a ${age}-year old ${job}`); // Works!
  }

  second();

  // console.log(job); // ReferenceError: job is not defined
  console.log(millenial); // Works! var is function-scoped
  // console.log(decade); // ReferenceError: decade is not defined
}

first();

// Variable lookup in scope chain
function calcAge(birthYear) {
  const age = 2037 - birthYear;

  function printAge() {
    let output = `${firstName}, you are ${age}, born in ${birthYear}`;
    console.log(output);

    if (birthYear >= 1981 && birthYear <= 1996) {
      var millenial = true;

      // Creating NEW variable with same name as outer scope's variable
      const firstName = 'Steven';

      // Reassigning outer scope's variable
      output = 'NEW OUTPUT!';

      const str = `Oh, and you're a millenial, ${firstName}`;
      console.log(str);

      function add(a, b) {
        return a + b;
      }
    }

    console.log(millenial); // Works! var is function-scoped
    // console.log(str); // ReferenceError: str is not defined
    console.log(output); // "NEW OUTPUT!"
  }

  printAge();
  return age;
}

const firstName = 'Jonas';
calcAge(1991);
```

### The `this` Keyword

```js
// Global this - in the global scope
console.log(this); // Window object (in browser) - the global object

// Function this - regular function call
const calcAge = function (birthYear) {
  console.log(2037 - birthYear);
  console.log(this); // undefined (strict mode) - no owner object
};
calcAge(1991); // Called as a regular function, not a method

// Arrow function this (lexical this) - inherits from parent scope
const calcAgeArrow = (birthYear) => {
  console.log(2037 - birthYear);
  console.log(this); // Window object (parent scope) - arrow functions don't have their own this
};
calcAgeArrow(1980); // Arrow function inherits this from surrounding context

// Method this - function called as a method of an object
const jonas = {
  year: 1991,
  calcAge: function () {
    console.log(this); // jonas object - the object that called the method
    console.log(2037 - this.year); // Access properties of the calling object
  },
};
jonas.calcAge(); // Called as jonas.calcAge(), so this = jonas

// Method borrowing - same function, different this
const matilda = {
  year: 2017,
};

matilda.calcAge = jonas.calcAge; // Copy the function to matilda
matilda.calcAge(); // Now this = matilda object (different owner!)
// Key point: this is determined by WHO calls the function, not where it's defined

// Function call
const f = jonas.calcAge;
f(); // this = undefined

// this in event listeners
document.querySelector('.btn').addEventListener('click', function () {
  console.log(this); // DOM element that triggered the event
  this.style.backgroundColor = 'red';
});

// Arrow functions don't get their own this
const jonas2 = {
  firstName: 'Jonas',
  year: 1991,
  calcAge: function () {
    console.log(this); // jonas2 object

    // Solution 1: Store this in variable
    const self = this;
    const isMillenial = function () {
      console.log(self.year >= 1981 && self.year <= 1996);
    };

    // Solution 2: Use arrow function
    const isMillenial2 = () => {
      console.log(this.year >= 1981 && this.year <= 1996); // Works!
    };

    isMillenial();
    isMillenial2();
  },

  // Never use arrow function as method!
  greet: () => {
    console.log(`Hey ${this.firstName}`); // undefined! this = window
  },
};

jonas2.greet(); // Hey undefined
jonas2.calcAge();
```

### Primitives vs Objects (Reference Types)

```js
// Primitives
let lastName = 'Williams';
let oldLastName = lastName;
lastName = 'Davis';

console.log(lastName, oldLastName); // Davis Williams

// Objects
const jessica = {
  firstName: 'Jessica',
  lastName: 'Williams',
  age: 27,
};

const marriedJessica = jessica; // Same reference!
marriedJessica.lastName = 'Davis';

console.log('Before marriage:', jessica); // lastName is 'Davis'!
console.log('After marriage:', marriedJessica);

// marriedJessica = {}; // TypeError: Assignment to constant variable

// Copying objects
const jessica2 = {
  firstName: 'Jessica',
  lastName: 'Williams',
  age: 27,
  family: ['Alice', 'Bob'],
};

// Shallow copy
const jessicaCopy = Object.assign({}, jessica2);
jessicaCopy.lastName = 'Davis';

console.log('Before marriage:', jessica2); // lastName still 'Williams'
console.log('After marriage:', jessicaCopy); // lastName is 'Davis'

// But nested objects are still referenced!
jessicaCopy.family.push('Mary');
console.log('Before marriage:', jessica2.family); // ['Alice', 'Bob', 'Mary']
console.log('After marriage:', jessicaCopy.family); // ['Alice', 'Bob', 'Mary']

// Deep clone (for nested objects)
const jessicaDeepCopy = JSON.parse(JSON.stringify(jessica2));
// Note: This doesn't work with functions, undefined, Symbol, etc.
```

### Call Stack Visualization

```js
// Example to understand call stack
const a = 'Hello!';
first();

function first() {
  console.log('Inside first function');
  second();
  console.log('Back in first function');
}

function second() {
  console.log('Inside second function');
  third();
  console.log('Back in second function');
}

function third() {
  console.log('Inside third function');
  console.log(a); // Variable lookup through scope chain
  console.log('End of third function');
}

// Call stack execution order:
// 1. Global Execution Context
// 2. first() execution context
// 3. second() execution context
// 4. third() execution context
// Then unwinding: third() -> second() -> first() -> global
```

### Understanding Execution Context

```js
// Example demonstrating execution context creation
var x = 1;
a();
b();
console.log(x);

function a() {
  var x = 10;
  console.log(x);
}

function b() {
  var x = 100;
  console.log(x);
}

// Execution:
// 1. Global EC: x = 1 (hoisted)
// 2. a() EC: x = 10 (new execution context)
// 3. b() EC: x = 100 (new execution context)
// 4. Back to Global EC: x = 1

// Variable Environment example
function outer() {
  var a = 1;

  function inner() {
    var b = 2;
    console.log(a + b); // 3 (can access outer scope)
  }

  inner();
  // console.log(b); // ReferenceError: b is not defined
}

outer();
```

## Advanced Concepts

### Temporal Dead Zone

```js
// Temporal Dead Zone for let/const
console.log(me); // undefined
// console.log(job); // ReferenceError: Cannot access before initialization
// console.log(year); // ReferenceError: Cannot access before initialization

var me = 'Jonas';
let job = 'teacher';
const year = 1991;

// Function in TDZ
// console.log(addExpression(2, 3)); // TypeError: Cannot read property of undefined
// console.log(addArrow(2, 3)); // ReferenceError: Cannot access before initialization

var addExpression = function (a, b) {
  return a + b;
};

const addArrow = (a, b) => a + b;

// Best practice: Declare variables at the top
function bestPractice() {
  // All declarations at top
  let x, y, z;
  const PI = 3.14159;

  // Then use them
  x = 10;
  y = 20;
  z = x + y;

  return z * PI;
}
```

### Memory Management

```js
// Understanding memory allocation
function createObjects() {
  // These objects will be created in the heap
  const obj1 = { name: 'Object 1' };
  const obj2 = { name: 'Object 2', ref: obj1 };

  return obj2;
}

let result = createObjects();
// obj1 is still accessible through obj2.ref
// Both objects remain in memory

result = null;
// Now both objects can be garbage collected

// Memory leak example (avoid this!)
function memoryLeak() {
  const element = document.getElementById('button');

  element.addEventListener('click', function () {
    // This creates a closure that keeps 'element' in memory
    console.log('Button clicked');
  });

  // Even if element is removed from DOM, it stays in memory
  // due to the event listener closure
}
```

## Debugging Behind the Scenes

```js
// Understanding the call stack in DevTools
function buggyFunction() {
  console.trace('Call stack trace'); // Shows call stack
  debugger; // Pauses execution in DevTools

  const result = someCalculation();
  return result;
}

function someCalculation() {
  const a = 10;
  const b = 0;
  return a / b; // Infinity - potential bug
}

// Using console.log to understand execution
function demonstrateExecution() {
  console.log('1. Function starts');

  setTimeout(() => {
    console.log('3. Timeout callback (async)');
  }, 0);

  console.log('2. Function ends');
}

demonstrateExecution();
// Output: 1, 2, 3 (demonstrates async nature)
```

## Best Practices

1. **Always use strict mode**: `'use strict';`
2. **Prefer `const` and `let`** over `var`
3. **Declare variables at the top** of their scope
4. **Use function declarations** for hoisting benefits when needed
5. **Understand `this` context** before using it
6. **Be careful with arrow functions** as methods
7. **Avoid creating global variables** accidentally

## Common Mistakes

```js
// Mistake 1: Accidental globals
function oops() {
  // Forgot var/let/const - creates global variable!
  accidentalGlobal = 'I am global now!';
}

// Mistake 2: this in arrow functions
const obj = {
  name: 'Test',
  getName: () => {
    return this.name; // undefined! Arrow function doesn't have its own 'this'
  },
};

// Mistake 3: Temporal Dead Zone
function mistake() {
  console.log(x); // ReferenceError
  let x = 5;
}

// Mistake 4: Variable shadowing confusion
let x = 1;
function shadow() {
  console.log(x); // ReferenceError: Cannot access 'x' before initialization
  let x = 2; // This shadows the outer x, but it's not yet initialized
}
```

---

_Understanding these concepts makes you a much better JavaScript developer! 🧠_
