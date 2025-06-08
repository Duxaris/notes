# Destructuring in JavaScript

Destructuring is a convenient way to extract values from arrays and objects into distinct variables. It provides a clean syntax for unpacking values.

## Array Destructuring

### Basic Array Destructuring

```javascript
// Traditional way
const colors = ['red', 'green', 'blue'];
const first = colors[0];
const second = colors[1];
const third = colors[2];

// With destructuring
const [firstColor, secondColor, thirdColor] = colors;
console.log(firstColor); // "red"
console.log(secondColor); // "green"
console.log(thirdColor); // "blue"
```

### Skipping Elements

```javascript
const numbers = [1, 2, 3, 4, 5];

// Skip elements with empty slots
const [first, , third, , fifth] = numbers;
console.log(first); // 1
console.log(third); // 3
console.log(fifth); // 5
```

### Rest Pattern in Arrays

```javascript
const fruits = ['apple', 'banana', 'orange', 'grape', 'kiwi'];

// Get first two and rest
const [primary, secondary, ...others] = fruits;
console.log(primary); // "apple"
console.log(secondary); // "banana"
console.log(others); // ["orange", "grape", "kiwi"]
```

### Default Values in Arrays

```javascript
// Handle undefined values
const [a = 1, b = 2, c = 3] = [10];
console.log(a); // 10 (from array)
console.log(b); // 2 (default)
console.log(c); // 3 (default)

// Practical example: coordinates
const getCoordinates = () => [100, 200]; // might return undefined z
const [x, y, z = 0] = getCoordinates();
console.log(`x: ${x}, y: ${y}, z: ${z}`); // x: 100, y: 200, z: 0
```

## Object Destructuring

### Basic Object Destructuring

```javascript
// Traditional way
const person = {
  name: 'Alice',
  age: 30,
  city: 'New York',
};

const name = person.name;
const age = person.age;
const city = person.city;

// With destructuring
const { name, age, city } = person;
console.log(name); // "Alice"
console.log(age); // 30
console.log(city); // "New York"
```

### Renaming Variables

```javascript
const user = {
  firstName: 'John',
  lastName: 'Doe',
  email: 'john@example.com',
};

// Rename while destructuring
const { firstName: fName, lastName: lName, email: userEmail } = user;

console.log(fName); // "John"
console.log(lName); // "Doe"
console.log(userEmail); // "john@example.com"
```

### Default Values in Objects

```javascript
const config = {
  host: 'localhost',
  port: 3000,
  // ssl property is missing
};

// Provide defaults for missing properties
const { host, port, ssl = false, timeout = 5000 } = config;

console.log(host); // "localhost"
console.log(port); // 3000
console.log(ssl); // false (default)
console.log(timeout); // 5000 (default)
```

### Nested Object Destructuring

```javascript
const user = {
  id: 1,
  name: 'Alice',
  address: {
    street: '123 Main St',
    city: 'Boston',
    country: 'USA',
  },
  preferences: {
    theme: 'dark',
    language: 'en',
  },
};

// Destructure nested objects
const {
  name,
  address: { city, country },
  preferences: { theme },
} = user;

console.log(name); // "Alice"
console.log(city); // "Boston"
console.log(country); // "USA"
console.log(theme); // "dark"

// Note: 'address' and 'preferences' variables are not created
// console.log(address); // ReferenceError
```

### Rest Pattern in Objects

```javascript
const product = {
  id: 1,
  name: 'Laptop',
  price: 999,
  category: 'Electronics',
  brand: 'TechCorp',
  warranty: '2 years',
};

// Extract specific properties and collect the rest
const { id, name, ...details } = product;

console.log(id); // 1
console.log(name); // "Laptop"
console.log(details); // { price: 999, category: "Electronics", brand: "TechCorp", warranty: "2 years" }
```

## Practical Examples

### Function Parameters

```javascript
// Without destructuring
function createUser(userObj) {
  const name = userObj.name;
  const email = userObj.email;
  const age = userObj.age || 18;

  // ... function logic
}

// With destructuring
function createUser({ name, email, age = 18 }) {
  console.log(`Creating user: ${name}, ${email}, age ${age}`);
  // ... function logic
}

// Usage
createUser({
  name: 'Bob',
  email: 'bob@example.com',
  // age will default to 18
});
```

### API Response Handling

```javascript
// Common pattern for handling API responses
async function fetchUserData(userId) {
  const response = await fetch(`/api/users/${userId}`);
  const data = await response.json();

  // Extract needed data with defaults
  const {
    name,
    email,
    profile: { avatar = '/default-avatar.png', bio = 'No bio available' } = {},
    settings: { notifications = true, theme = 'light' } = {},
  } = data;

  return {
    name,
    email,
    avatar,
    bio,
    notifications,
    theme,
  };
}
```

### Swapping Variables

```javascript
// Traditional swapping (needs temporary variable)
let a = 1;
let b = 2;
let temp = a;
a = b;
b = temp;

// With destructuring (no temp variable needed)
let x = 1;
let y = 2;
[x, y] = [y, x];
console.log(x); // 2
console.log(y); // 1
```

### Working with Arrays of Objects

```javascript
const users = [
  { id: 1, name: 'Alice', role: 'admin' },
  { id: 2, name: 'Bob', role: 'user' },
  { id: 3, name: 'Carol', role: 'moderator' },
];

// Extract names using destructuring in map
const names = users.map(({ name }) => name);
console.log(names); // ["Alice", "Bob", "Carol"]

// Filter and destructure
const admins = users
  .filter(({ role }) => role === 'admin')
  .map(({ name, id }) => ({ name, id }));
```

### Mixed Destructuring

```javascript
const response = {
  status: 200,
  data: {
    users: [
      { name: 'Alice', age: 30 },
      { name: 'Bob', age: 25 },
    ],
    total: 2,
  },
};

// Complex destructuring
const {
  status,
  data: {
    users: [firstUser, ...otherUsers],
    total,
  },
} = response;

console.log(status); // 200
console.log(firstUser); // { name: "Alice", age: 30 }
console.log(otherUsers); // [{ name: "Bob", age: 25 }]
console.log(total); // 2
```

## Common Patterns

### Configuration Objects

```javascript
function initializeApp({
  apiUrl = 'https://api.example.com',
  timeout = 5000,
  retries = 3,
  features: { analytics = true, debugging = false } = {},
} = {}) {
  console.log(`API: ${apiUrl}, Timeout: ${timeout}ms`);
  console.log(`Analytics: ${analytics}, Debug: ${debugging}`);
}

// Can be called with partial or no config
initializeApp(); // Uses all defaults
initializeApp({
  apiUrl: 'https://custom.api.com',
  features: { debugging: true },
});
```

### React Props Destructuring

```javascript
// Common pattern in React components
function UserCard({ user: { name, email, avatar }, isOnline = false }) {
  return (
    <div className={`user-card ${isOnline ? 'online' : 'offline'}`}>
      <img src={avatar} alt={name} />
      <h3>{name}</h3>
      <p>{email}</p>
    </div>
  );
}
```

## Best Practices

!!! tip "Destructuring Best Practices" 1. **Use meaningful variable names** when renaming 2. **Provide defaults** for optional values 3. **Don't over-nest** - deep destructuring can be hard to read 4. **Use rest patterns** to group remaining properties 5. **Combine with function parameters** for cleaner APIs

### Good Examples

```javascript
// ✅ Good: Clear, with defaults
function processOrder({
  items,
  shipping = 'standard',
  discount = 0,
  customer: { name, email },
}) {
  // Implementation
}

// ✅ Good: Extracting what you need
const { data, error, isLoading } = useApiCall();

// ❌ Avoid: Too much nesting
const {
  a: {
    b: {
      c: {
        d: { e },
      },
    },
  },
} = complexObject;
```

---

## Summary

Destructuring provides a clean, readable way to extract values:

- **Array destructuring**: Position-based extraction with `[a, b, c]`
- **Object destructuring**: Property-based extraction with `{ name, age }`
- **Default values**: Handle missing values gracefully
- **Rest patterns**: Collect remaining items with `...rest`
- **Renaming**: Use `{ oldName: newName }` for clarity

Master destructuring to write more concise and expressive JavaScript code!
