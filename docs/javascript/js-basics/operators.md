# Operators in JavaScript

Operators are symbols that perform operations on operands (values and variables). JavaScript has several types of operators.

## Arithmetic Operators

### Basic Math Operations

```javascript
let a = 10;
let b = 3;

console.log(a + b); // 13 (Addition)
console.log(a - b); // 7  (Subtraction)
console.log(a * b); // 30 (Multiplication)
console.log(a / b); // 3.333... (Division)
console.log(a % b); // 1  (Modulus/Remainder)
console.log(a ** b); // 1000 (Exponentiation)
```

### Increment and Decrement

```javascript
let counter = 5;

// Pre-increment: increment first, then return
console.log(++counter); // 6, counter is now 6

// Post-increment: return first, then increment
console.log(counter++); // 6, counter becomes 7

// Pre-decrement: decrement first, then return
console.log(--counter); // 6, counter is now 6

// Post-decrement: return first, then decrement
console.log(counter--); // 6, counter becomes 5
```

## Assignment Operators

### Basic Assignment

```javascript
let x = 10;

// Compound assignment operators
x += 5; // x = x + 5;  (15)
x -= 3; // x = x - 3;  (12)
x *= 2; // x = x * 2;  (24)
x /= 4; // x = x / 4;  (6)
x %= 5; // x = x % 5;  (1)
x **= 3; // x = x ** 3; (1)
```

## Comparison Operators

### Equality and Inequality

```javascript
// Loose equality (type coercion)
console.log(5 == '5'); // true
console.log(0 == false); // true

// Strict equality (no type coercion)
console.log(5 === '5'); // false
console.log(0 === false); // false

// Inequality
console.log(5 != '6'); // true
console.log(5 !== '5'); // true (different types)
```

### Relational Operators

```javascript
let age = 25;

console.log(age > 18); // true
console.log(age < 30); // true
console.log(age >= 25); // true
console.log(age <= 20); // false
```

## Logical Operators

### AND, OR, NOT

```javascript
let isAdult = true;
let hasLicense = false;

// AND - both must be true
console.log(isAdult && hasLicense); // false

// OR - at least one must be true
console.log(isAdult || hasLicense); // true

// NOT - inverts the boolean
console.log(!isAdult); // false
console.log(!hasLicense); // true
```

### Short-Circuit Evaluation

```javascript
// AND short-circuit: stops at first falsy value
let result1 = false && expensiveFunction(); // expensiveFunction not called

// OR short-circuit: stops at first truthy value
let result2 = true || expensiveFunction(); // expensiveFunction not called

// Practical examples
const userName = user.name || 'Guest';
user.isAdmin && showAdminPanel();
```

## String Operators

### Concatenation

```javascript
let firstName = 'John';
let lastName = 'Doe';

// Using + operator
let fullName = firstName + ' ' + lastName; // "John Doe"

// Using += for building strings
let message = 'Hello ';
message += firstName; // "Hello John"
```

### Template Literals (ES6)

```javascript
const name = 'Alice';
const age = 30;

// Much cleaner than concatenation
const greeting = `Hello, my name is ${name} and I'm ${age} years old.`;
console.log(greeting);

// Multi-line strings
const html = `
  <div>
    <h1>${name}</h1>
    <p>Age: ${age}</p>
  </div>
`;
```

## Ternary Operator

### Conditional Assignment

```javascript
// Syntax: condition ? valueIfTrue : valueIfFalse
const age = 20;
const status = age >= 18 ? 'adult' : 'minor';

// Instead of if-else
let message;
if (user.isLoggedIn) {
  message = 'Welcome back!';
} else {
  message = 'Please log in';
}

// Can be written as:
const message = user.isLoggedIn ? 'Welcome back!' : 'Please log in';
```

### Nested Ternary (Use Sparingly)

```javascript
const score = 85;
const grade = score >= 90 ? 'A' : score >= 80 ? 'B' : score >= 70 ? 'C' : 'F';
```

## Nullish Coalescing (??)

### Default Values for null/undefined

```javascript
const userPreference = null;
const defaultTheme = 'light';

// Only null or undefined trigger the default
const theme = userPreference ?? defaultTheme; // "light"

// Different from || operator
const value1 = 0 || 'default'; // "default" (0 is falsy)
const value2 = 0 ?? 'default'; // 0 (0 is not null/undefined)
```

## Optional Chaining (?.)

### Safe Property Access

```javascript
const user = {
  name: 'John',
  address: {
    street: '123 Main St',
    city: 'Anytown',
  },
};

// Safe access to nested properties
const zipCode = user?.address?.zipCode; // undefined (no error)
const city = user?.address?.city; // "Anytown"

// Safe method calls
user?.updateProfile?.();

// Safe array access
const firstHobby = user?.hobbies?.[0];
```

## Operator Precedence

### Order of Operations

```javascript
// Multiplication before addition
let result = 2 + 3 * 4; // 14, not 20

// Use parentheses for clarity
let result2 = (2 + 3) * 4; // 20

// Common precedence levels (high to low):
// 1. Grouping: ()
// 2. Member access: . []
// 3. Function calls: ()
// 4. Exponentiation: **
// 5. Unary: ! - + ++ --
// 6. Multiplication/Division: * / %
// 7. Addition/Subtraction: + -
// 8. Comparison: < > <= >=
// 9. Equality: == != === !==
// 10. Logical AND: &&
// 11. Logical OR: ||
// 12. Ternary: ? :
// 13. Assignment: = += -= etc.
```

## Best Practices

!!! tip "Operator Best Practices" 1. **Use strict equality (`===`)** instead of loose equality (`==`) 2. **Use parentheses** to make complex expressions clear 3. **Prefer template literals** over string concatenation 4. **Use nullish coalescing (`??`)** for default values 5. **Use optional chaining (`?.`)** for safe property access

### Example: Clean Code with Modern Operators

```javascript
// Clean, modern JavaScript
const getUserDisplay = (user) => {
  const name = user?.name ?? 'Unknown User';
  const email = user?.email ?? 'No email provided';
  const isActive = user?.isActive ?? false;

  return `${name} (${email}) - ${isActive ? 'Active' : 'Inactive'}`;
};
```

---

## Summary

JavaScript operators provide powerful ways to manipulate data:

- **Arithmetic**: Basic math operations
- **Assignment**: Setting and updating values
- **Comparison**: Testing relationships between values
- **Logical**: Combining boolean expressions
- **String**: Working with text
- **Modern ES6+**: Nullish coalescing, optional chaining, template literals

Master these operators to write more expressive and safer JavaScript code!
