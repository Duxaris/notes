# Data Types in JavaScript

JavaScript is a dynamically typed language, meaning variables can hold different types of data and types are determined at runtime.

## Primitive Data Types

### Number

JavaScript has only one number type that represents both integers and floating-point numbers.

```javascript
// Integers
let age = 25;
let count = 0;

// Floating point
let price = 99.99;
let temperature = -15.5;

// Special numeric values
let infinity = Infinity;
let negativeInfinity = -Infinity;
let notANumber = NaN;

// Number operations
console.log(typeof 42); // "number"
console.log(Number.isInteger(42)); // true
console.log(Number.isInteger(42.5)); // false
console.log(Number.isNaN(NaN)); // true
```

### String

Strings represent text data and can be created with single quotes, double quotes, or backticks.

```javascript
// Different string declarations
let singleQuote = 'Hello World';
let doubleQuote = 'Hello World';
let backticks = `Hello World`;

// String with quotes inside
let message = "He said, 'Hello there!'";
let message2 = 'She replied, "Hi!"';

// Template literals (backticks)
let name = 'Alice';
let greeting = `Hello, ${name}! Today is ${new Date().toDateString()}`;

// Multi-line strings
let html = `
  <div>
    <h1>Title</h1>
    <p>Content here</p>
  </div>
`;
```

### Boolean

Represents logical values: `true` or `false`.

```javascript
let isActive = true;
let isComplete = false;

// Boolean conversion
console.log(Boolean(1)); // true
console.log(Boolean(0)); // false
console.log(Boolean('')); // false
console.log(Boolean('hello')); // true
console.log(Boolean(null)); // false
console.log(Boolean(undefined)); // false
```

### Undefined

A variable that has been declared but not assigned a value.

```javascript
let undeclaredVar;
console.log(undeclaredVar); // undefined
console.log(typeof undeclaredVar); // "undefined"

// Function with no return statement
function noReturn() {
  // some code
}
console.log(noReturn()); // undefined
```

### Null

Represents an intentional absence of value.

```javascript
let data = null; // Explicitly set to nothing
console.log(data); // null
console.log(typeof null); // "object" (this is a known JavaScript quirk)

// Difference between null and undefined
let a; // undefined (not assigned)
let b = null; // null (explicitly set to nothing)
```

### Symbol (ES6)

A unique primitive value, often used as object property keys.

```javascript
let sym1 = Symbol();
let sym2 = Symbol('description');
let sym3 = Symbol('description');

console.log(sym2 === sym3); // false (each Symbol is unique)

// Using Symbols as object keys
const MY_KEY = Symbol('myKey');
const obj = {
  [MY_KEY]: 'secret value',
};
```

### BigInt (ES2020)

For integers larger than the safe integer limit.

```javascript
// Regular number limit
console.log(Number.MAX_SAFE_INTEGER); // 9007199254740991

// BigInt for larger numbers
let bigNumber = 1234567890123456789012345678901234567890n;
let anotherBig = BigInt('9007199254740992');

console.log(typeof bigNumber); // "bigint"
```

## Non-Primitive (Reference) Types

### Object

Collections of key-value pairs.

```javascript
// Object literal
let person = {
  name: 'John',
  age: 30,
  isStudent: false,
  address: {
    street: '123 Main St',
    city: 'Anytown',
  },
};

// Accessing properties
console.log(person.name); // "John"
console.log(person['age']); // 30
console.log(person.address.city); // "Anytown"

// Adding/modifying properties
person.email = 'john@example.com';
person.age = 31;
```

### Array

Ordered lists of values.

```javascript
// Array literal
let numbers = [1, 2, 3, 4, 5];
let mixed = ['hello', 42, true, null, { name: 'object' }];

// Array methods
numbers.push(6); // Add to end
numbers.unshift(0); // Add to beginning
let last = numbers.pop(); // Remove from end
let first = numbers.shift(); // Remove from beginning

console.log(numbers.length); // 6
console.log(Array.isArray(numbers)); // true
```

### Function

Functions are first-class objects in JavaScript.

```javascript
// Function declaration
function greet(name) {
  return `Hello, ${name}!`;
}

// Function expression
let greet2 = function (name) {
  return `Hi, ${name}!`;
};

// Arrow function (ES6)
let greet3 = (name) => `Hey, ${name}!`;

// Functions are objects
console.log(typeof greet); // "function"
greet.customProperty = "I'm a function property";
```

## Type Checking

### typeof Operator

```javascript
console.log(typeof 42); // "number"
console.log(typeof 'hello'); // "string"
console.log(typeof true); // "boolean"
console.log(typeof undefined); // "undefined"
console.log(typeof null); // "object" (quirk!)
console.log(typeof {}); // "object"
console.log(typeof []); // "object"
console.log(typeof function () {}); // "function"
console.log(typeof Symbol()); // "symbol"
console.log(typeof 123n); // "bigint"
```

### More Specific Type Checking

```javascript
// Better array detection
Array.isArray([1, 2, 3]); // true
Array.isArray('not array'); // false

// Null check
let value = null;
console.log(value === null); // true

// Object vs Array vs null
function getType(value) {
  if (value === null) return 'null';
  if (Array.isArray(value)) return 'array';
  return typeof value;
}
```

## Type Conversion

### Implicit Conversion (Coercion)

JavaScript automatically converts types in certain situations.

```javascript
// String coercion
console.log('5' + 3); // "53" (number becomes string)
console.log('5' - 3); // 2 (string becomes number)
console.log('5' * '2'); // 10 (both become numbers)

// Boolean coercion
if ('hello') {
  // "hello" is truthy
  console.log('This runs');
}

if (0) {
  // 0 is falsy
  console.log("This doesn't run");
}
```

### Explicit Conversion

Convert types intentionally.

```javascript
// To Number
let str = '123';
let num1 = Number(str); // 123
let num2 = parseInt(str); // 123
let num3 = parseFloat('123.45'); // 123.45
let num4 = +str; // 123 (unary plus)

// To String
let num = 123;
let str1 = String(num); // "123"
let str2 = num.toString(); // "123"
let str3 = num + ''; // "123"

// To Boolean
let bool1 = Boolean(1); // true
let bool2 = Boolean(0); // false
let bool3 = !!1; // true (double negation)
```

## Truthy and Falsy Values

### Falsy Values

These values convert to `false` in boolean context:

```javascript
// All falsy values
console.log(Boolean(false)); // false
console.log(Boolean(0)); // false
console.log(Boolean(-0)); // false
console.log(Boolean(0n)); // false (BigInt zero)
console.log(Boolean('')); // false (empty string)
console.log(Boolean(null)); // false
console.log(Boolean(undefined)); // false
console.log(Boolean(NaN)); // false
```

### Truthy Values

Everything else is truthy:

```javascript
// Examples of truthy values
console.log(Boolean(1)); // true
console.log(Boolean(-1)); // true
console.log(Boolean('hello')); // true
console.log(Boolean('0')); // true (non-empty string)
console.log(Boolean([])); // true (empty array)
console.log(Boolean({})); // true (empty object)
console.log(Boolean(function () {})); // true
```

## Best Practices

!!! tip "Data Type Best Practices" 1. **Use strict equality (`===`)** to avoid type coercion issues 2. **Check for null explicitly** since `typeof null === "object"` 3. **Use `Array.isArray()`** to check for arrays 4. **Be aware of falsy values** when using if statements 5. **Use explicit conversion** when type conversion is needed

### Examples of Good Type Handling

```javascript
// Safe type checking
function processValue(value) {
  if (value === null) {
    return 'Value is null';
  }

  if (value === undefined) {
    return 'Value is undefined';
  }

  if (Array.isArray(value)) {
    return `Array with ${value.length} items`;
  }

  if (typeof value === 'object') {
    return 'Plain object';
  }

  return `${typeof value}: ${value}`;
}

// Safe number conversion
function safeToNumber(input) {
  const num = Number(input);
  return Number.isNaN(num) ? 0 : num;
}
```

---

## Summary

JavaScript has **7 primitive types**:

- `number`, `string`, `boolean`, `undefined`, `null`, `symbol`, `bigint`

And **reference types**:

- `object` (including arrays, functions, dates, etc.)

Understanding these types and how JavaScript handles type conversion is crucial for writing reliable code. Always use explicit type checking and conversion when precision matters!
