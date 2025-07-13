# JavaScript Quick Reference & Cheat Sheet

A quick reference guide for JavaScript syntax, terminology, and common patterns.

## Essential Syntax

| Syntax                   | Name                       | What it does                          | Example                          |
| ------------------------ | -------------------------- | ------------------------------------- | -------------------------------- |
| `? :`                    | **Ternary operator**       | Shorthand `if/else` expression        | `age >= 18 ? 'adult' : 'minor'`  |
| `` `text ${variable}` `` | **Template literal**       | Embeds variables inside strings       | `` `Hello ${name}!` ``           |
| `&&`, `\|\|`, `??`       | **Logical operators**      | Short-circuiting logic                | `user && user.name \|\| 'Guest'` |
| `...`                    | **Spread/Rest operator**   | Copies or collects values             | `[...array1, ...array2]`         |
| `{ key: value }`         | **Object literal**         | Creates objects                       | `{ name: 'John', age: 30 }`      |
| `()`                     | **Function call/grouping** | Calls functions or groups expressions | `myFunction()` or `(a + b) * c`  |
| `=>`                     | **Arrow function**         | Shorthand function syntax             | `(x) => x * 2`                   |
| `?.`                     | **Optional chaining**      | Safe property access                  | `user?.address?.street`          |
| `??=`                    | **Nullish assignment**     | Assigns if null/undefined             | `value ??= 'default'`            |

## Variables & Data Types

```js
// Variable declarations
let name = 'John'; // Reassignable, block-scoped
const age = 30; // Immutable reference, block-scoped
var old = 'avoid'; // Function-scoped (avoid)

// Data types
const num = 42; // Number
const str = 'Hello'; // String
const bool = true; // Boolean
const arr = [1, 2, 3]; // Array (object)
const obj = { a: 1 }; // Object
let empty; // undefined
const nothing = null; // null
```

## Functions

```js
// Function declaration (hoisted)
function greet(name) {
  return `Hello, ${name}!`;
}

// Function expression (not hoisted)
const greet = function (name) {
  return `Hello, ${name}!`;
};

// Arrow function (lexical this)
const greet = (name) => `Hello, ${name}!`;
const add = (a, b) => a + b;

// Method in object
const user = {
  name: 'John',
  greet() {
    // ES6 method shorthand
    return `Hello, I'm ${this.name}`;
  },
};
```

## Arrays

```js
const fruits = ['apple', 'banana', 'orange'];

// Access
fruits[0]; // 'apple'
fruits.length; // 3

// Add/Remove
fruits.push('grape'); // Add to end
fruits.pop(); // Remove from end
fruits.unshift('mango'); // Add to beginning
fruits.shift(); // Remove from beginning

// Search
fruits.indexOf('banana'); // 1 (index)
fruits.includes('apple'); // true

// Transform (return new array)
fruits.map((f) => f.toUpperCase()); // ['APPLE', 'BANANA']
fruits.filter((f) => f.length > 5); // ['banana', 'orange']
fruits.find((f) => f.startsWith('a')); // 'apple'

// Get index and value together
fruits.entries(); // Iterator of [index, value] pairs
for (const [i, fruit] of fruits.entries()) {
  console.log(`${i}: ${fruit}`); // 0: apple, 1: banana, 2: orange
}

// Convert entries to array to see structure
console.log([...fruits.entries()]); // [[0, 'apple'], [1, 'banana'], [2, 'orange']]
```

## Objects

```js
const person = {
  name: 'John',
  age: 30,
  address: {
    city: 'New York',
    zip: 10001,
  },
};

// Access properties
person.name; // Dot notation
person['name']; // Bracket notation
person.address.city; // Nested access
person?.address?.city; // Safe access (optional chaining)

// Add/modify
person.email = 'john@example.com';
person['phone'] = '123-456-7890';

// Object methods
Object.keys(person); // ['name', 'age', 'address']
Object.values(person); // ['John', 30, {...}]
Object.entries(person); // [['name', 'John'], ...]
```

## Destructuring

```js
// Array destructuring
const [first, second, ...rest] = [1, 2, 3, 4, 5];
// first = 1, second = 2, rest = [3, 4, 5]

// Object destructuring
const { name, age, city = 'Unknown' } = person;
// Extracts name and age, defaults city to 'Unknown'

// Renaming while destructuring
const { name: fullName, age: years } = person;

// Function parameters
function greet({ name, age }) {
  return `${name} is ${age} years old`;
}
```

## Spread & Rest

```js
// Spread (expand)
const arr1 = [1, 2, 3];
const arr2 = [...arr1, 4, 5]; // [1, 2, 3, 4, 5]
const newObj = { ...person, city: 'LA' };

// Rest (collect)
function sum(...numbers) {
  // Collect all args
  return numbers.reduce((a, b) => a + b, 0);
}

const [first, ...others] = [1, 2, 3, 4]; // first=1, others=[2,3,4]
```

## Loops

```js
// For loop
for (let i = 0; i < 5; i++) {
  console.log(i);
}

// For...of (values)
for (const item of array) {
  console.log(item);
}

// For...in (keys/indices)
for (const key in object) {
  console.log(key, object[key]);
}

// Array methods (functional)
array.forEach((item) => console.log(item));
array.map((item) => item * 2);
array.filter((item) => item > 0);
array.reduce((sum, item) => sum + item, 0);
```

## Conditionals

```js
// If statement
if (condition) {
  // do something
} else if (otherCondition) {
  // do something else
} else {
  // fallback
}

// Ternary operator
const result = condition ? 'yes' : 'no';

// Switch statement
switch (value) {
  case 'a':
    console.log('A');
    break;
  case 'b':
    console.log('B');
    break;
  default:
    console.log('Other');
}
```

## Short-Circuiting

```js
// OR (||) - returns first truthy value
const name = user.name || 'Guest';

// AND (&&) - conditional execution
user.isAdmin && console.log('Admin user');

// Nullish coalescing (??) - only null/undefined are falsy
const count = user.count ?? 0; // 0 is valid, only null/undefined get default

// Optional chaining (?.) - safe property access
const city = user?.address?.city;
```

## Common Patterns

```js
// Default parameters
function greet(name = 'World') {
  return `Hello, ${name}!`;
}

// Immediately Invoked Function Expression (IIFE)
(function () {
  console.log('Runs immediately');
})();

// Callback function
function processData(data, callback) {
  const result = data.map((x) => x * 2);
  callback(result);
}

// Promise (basic)
fetch('/api/data')
  .then((response) => response.json())
  .then((data) => console.log(data))
  .catch((error) => console.error(error));

// Async/await
async function getData() {
  try {
    const response = await fetch('/api/data');
    const data = await response.json();
    return data;
  } catch (error) {
    console.error(error);
  }
}
```

## Modern JavaScript Features

```js
// Template literals with expressions
const html = `
  <div class="${isActive ? 'active' : ''}">
    <h1>${title.toUpperCase()}</h1>
    <p>Total: ${price * quantity}</p>
  </div>
`;

// Enhanced object literals
const name = 'John';
const age = 30;
const person = {
  name, // Same as name: name
  age, // Same as age: age
  greet() {
    // Same as greet: function() {}
    return `Hi, I'm ${this.name}`;
  },
  [computedKey]: 'value', // Computed property names
};

// Set (unique values)
const uniqueNumbers = new Set([1, 2, 2, 3, 3, 4]); // {1, 2, 3, 4}

// Map (key-value pairs with any key type)
const userRoles = new Map();
userRoles.set(user1, 'admin');
userRoles.set(user2, 'user');
```

## Error Handling

```js
// Try-catch
try {
  const result = riskyOperation();
  console.log(result);
} catch (error) {
  console.error('Something went wrong:', error.message);
} finally {
  console.log('This always runs');
}

// Throwing errors
function divide(a, b) {
  if (b === 0) {
    throw new Error('Division by zero');
  }
  return a / b;
}
```

## Type Checking

```js
// typeof operator
typeof 42; // 'number'
typeof 'hello'; // 'string'
typeof true; // 'boolean'
typeof undefined; // 'undefined'
typeof null; // 'object' (quirk!)
typeof []; // 'object'
typeof {}; // 'object'

// Better type checking
Array.isArray([]); // true
Number.isInteger(42); // true
Number.isNaN(NaN); // true
```

## Quick Tips

- **Falsy values**: `false`, `0`, `''`, `null`, `undefined`, `NaN`
- **Truthy values**: Everything else (including `[]`, `{}`, `'0'`)
- **Use `===` not `==`** for comparisons (strict equality)
- **Arrow functions don't have their own `this`**
- **`const` prevents reassignment, not mutation** (`const arr = []; arr.push(1)` works)
- **Use `let` and `const`, avoid `var`**

---

_Bookmark this page for quick reference! 🔖_
