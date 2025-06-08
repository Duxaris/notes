# Variables in JavaScript

Variables are containers for storing data values. In JavaScript, you can declare variables using `var`, `let`, or `const`.

## Declaration Methods

### `let` - Block Scoped Variable

```javascript
let userName = 'John';
let age = 25;

// Can be reassigned
age = 26;
```

### `const` - Block Scoped Constant

```javascript
const PI = 3.14159;
const apiUrl = 'https://api.example.com';

// Cannot be reassigned (will throw error)
// PI = 3.14; // TypeError: Assignment to constant variable
```

### `var` - Function Scoped (Legacy)

```javascript
var oldStyle = 'avoid using var';
// Function scoped, can lead to unexpected behavior
```

## Scope Examples

### Block Scope

```javascript
{
  let blockScoped = "I'm only available in this block";
  const alsoBlockScoped = 'Me too!';
  var functionScoped = "I'm available in the entire function";
}

// console.log(blockScoped); // ReferenceError
// console.log(alsoBlockScoped); // ReferenceError
console.log(functionScoped); // Works (but not recommended)
```

### Function Scope

```javascript
function exampleFunction() {
  let localVar = "I'm local to this function";

  if (true) {
    let blockVar = "I'm only in this if block";
    console.log(localVar); // Accessible
  }

  // console.log(blockVar); // ReferenceError
}
```

## Naming Conventions

### Good Variable Names

```javascript
// Use camelCase
const firstName = 'John';
const totalPrice = 99.99;
const isUserLoggedIn = true;

// Be descriptive
const userAccountBalance = 1500;
const maxRetryAttempts = 3;
```

### Avoid These Patterns

```javascript
// Too short/unclear
const n = 'John'; // What is 'n'?
const d = new Date(); // What kind of date?

// Using reserved words
// const class = "user"; // SyntaxError
// const function = "test"; // SyntaxError
```

## Best Practices

!!! tip "Variable Declaration Tips" 1. **Use `const` by default** - Only use `let` when you need to reassign 2. **Avoid `var`** - Use `let` or `const` instead 3. **Use descriptive names** - Code should be self-documenting 4. **Initialize variables** - Declare and assign in one statement when possible

### Examples of Good Practice

```javascript
// Good: Descriptive and properly scoped
const maxLoginAttempts = 3;
let currentAttempts = 0;

function validateLogin(username, password) {
  currentAttempts++;

  if (currentAttempts > maxLoginAttempts) {
    throw new Error('Too many login attempts');
  }

  // Login logic here...
}
```

## Common Patterns

### Object Destructuring with Variables

```javascript
const user = {
  name: 'Alice',
  email: 'alice@example.com',
  age: 30,
};

// Extract to variables
const { name, email } = user;
console.log(name); // "Alice"
```

### Default Values

```javascript
let userName = userInput || 'Guest';
const config = userConfig ?? defaultConfig;
```

---

## Summary

- Use `const` for values that won't change
- Use `let` for values that will be reassigned
- Avoid `var` in modern JavaScript
- Choose descriptive variable names
- Understand scope to avoid unexpected behavior
