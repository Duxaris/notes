# Section 2: JavaScript Fundamentals Part 1

## Key Concepts

- **Values and Variables**

  - Values: Pieces of data (numbers, strings, booleans)
  - Variables: Containers that store values
  - Naming conventions: camelCase, descriptive names
  - Reserved keywords cannot be used as variable names

- **Data Types**

  - **Primitive types**: Number, String, Boolean, Undefined, Null, Symbol, BigInt
  - **Dynamic typing**: Variables can change types
  - `typeof` operator to check data types
  - JavaScript has only one number type (floating point)

- **Variable Declarations**

  - `let`: Block-scoped, can be reassigned
  - `const`: Block-scoped, cannot be reassigned
  - `var`: Function-scoped, avoid in modern JavaScript
  - Always declare variables before using them

- **Operators**
  - **Arithmetic**: `+`, `-`, `*`, `/`, `%`, `**`
  - **Assignment**: `=`, `+=`, `-=`, `*=`, `/=`, `++`, `--`
  - **Comparison**: `>`, `<`, `>=`, `<=`, `===`, `!==`
  - **Logical**: `&&`, `||`, `!`

## Code Patterns

```js
// Variable declarations
let firstName = 'John';
const birthYear = 1990;
let currentYear = 2024;

// Data types
let age = 30; // Number
let fullName = 'John Doe'; // String
let isAdult = true; // Boolean
let children; // Undefined
let car = null; // Null

console.log(typeof age); // "number"
console.log(typeof fullName); // "string"
console.log(typeof isAdult); // "boolean"
console.log(typeof children); // "undefined"
console.log(typeof car); // "object" (quirk of JavaScript)

// Arithmetic operators
const ageJohn = currentYear - birthYear;
const ageSarah = currentYear - 1995;
console.log(ageJohn, ageSarah);

// Assignment operators
let x = 10 + 5; // 15
x += 10; // x = x + 10 = 25
x *= 4; // x = x * 4 = 100
x++; // x = x + 1 = 101
x--; // x = x - 1 = 100

// Comparison operators
console.log(ageJohn > ageSarah); // true
console.log(ageSarah >= 18); // true

// Template literals (ES6)
const john = "I'm John, and I'm " + age + ' years old.';
const johnNew = `I'm John, and I'm ${age} years old.`;

// Multiline strings
const multiLine = `String with
multiple
lines`;

// Type conversion and coercion
const inputYear = '1991';
console.log(Number(inputYear) + 18); // 2009
console.log(inputYear + 18); // '199118' (string concatenation)

// Truthy and falsy values
// 5 falsy values: 0, '', undefined, null, NaN
console.log(Boolean(0)); // false
console.log(Boolean('')); // false
console.log(Boolean('Hello')); // true
console.log(Boolean({})); // true

// Equality operators
const age1 = 18;
if (age1 === 18) console.log('You just became an adult! (strict)');
if (age1 == 18) console.log('You just became an adult! (loose)');

// Always use === (strict equality)
const favourite = Number(prompt("What's your favourite number?"));
if (favourite === 23) {
  console.log('Cool! 23 is an amazing number!');
}

// Logical operators
const hasDriversLicense = true;
const hasGoodVision = true;
const isTired = false;

console.log(hasDriversLicense && hasGoodVision); // true
console.log(hasDriversLicense || hasGoodVision); // true
console.log(!isTired); // true

if (hasDriversLicense && hasGoodVision && !isTired) {
  console.log('Sarah is able to drive!');
} else {
  console.log('Someone else should drive...');
}
```

## Important Notes

### Variable Naming Best Practices

```js
// Good
let firstName = 'John';
let currentYear = 2024;
let isAdult = true;

// Avoid
let n = 'John'; // Not descriptive
let year = 2024; // Could be birth year, current year, etc.
let PI = 3.1415; // Use const for constants
```

### Type Coercion Gotchas

```js
console.log('10' - '4' - '3' - 2 + '5'); // "15"
// Explanation: "10" - "4" - "3" = 3, 3 - 2 = 1, 1 + "5" = "15"

console.log(2 + 3 + 4 + '5'); // "95"
console.log('10' - '4' - '3' - 2 + '5'); // "15"
```

### Conditional (Ternary) Operator

```js
const age = 23;
const drink = age >= 18 ? 'wine' : 'water';
console.log(drink);

// In template literals
console.log(`I like to drink ${age >= 18 ? 'wine' : 'water'}`);
```

## Common Mistakes to Avoid

1. **Using `var` instead of `let`/`const`**
2. **Confusing `=` (assignment) with `===` (comparison)**
3. **Using `==` instead of `===`**
4. **Not understanding type coercion**
5. **Forgetting to declare variables**

---

_Master these fundamentals before moving to Part 2! 💪_
