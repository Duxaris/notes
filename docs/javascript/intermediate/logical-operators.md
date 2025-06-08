# Logical Operators in JavaScript

Logical operators are used to combine or modify boolean expressions. JavaScript provides powerful logical operators that go beyond simple true/false operations, including short-circuiting behavior that's very useful in real-world applications.

## The Three Main Logical Operators

### AND Operator (`&&`)

Returns `true` only if **both** operands are truthy.

```javascript
// Basic boolean logic
console.log(true && true); // true
console.log(true && false); // false
console.log(false && true); // false
console.log(false && false); // false

// With variables
let isLoggedIn = true;
let hasPermission = true;
console.log(isLoggedIn && hasPermission); // true
```

### OR Operator (`||`)

Returns `true` if **at least one** operand is truthy.

```javascript
// Basic boolean logic
console.log(true || true); // true
console.log(true || false); // true
console.log(false || true); // true
console.log(false || false); // false

// With variables
let hasLocalData = false;
let hasServerData = true;
console.log(hasLocalData || hasServerData); // true
```

### NOT Operator (`!`)

**Inverts** the boolean value.

```javascript
// Basic negation
console.log(!true); // false
console.log(!false); // true

// Double negation (converts to boolean)
console.log(!!'hello'); // true
console.log(!!0); // false
console.log(!!undefined); // false
console.log(!![]); // true
```

## Short-Circuit Evaluation

JavaScript uses **short-circuit evaluation** - it stops evaluating as soon as the result is determined.

### AND Short-Circuiting

If the first operand is falsy, the second operand is **never evaluated**.

```javascript
// Function that won't be called
function expensiveOperation() {
  console.log('This is expensive!');
  return true;
}

// Short-circuit: expensiveOperation() is never called
false && expensiveOperation(); // false (no console output)

// Real-world example: conditional execution
let user = { name: 'Alice', isAdmin: true };

// Only call showAdminPanel if user.isAdmin is true
user.isAdmin && showAdminPanel();

function showAdminPanel() {
  console.log('Showing admin panel');
}
```

### OR Short-Circuiting

If the first operand is truthy, the second operand is **never evaluated**.

```javascript
// Short-circuit: second function never called
true || expensiveOperation(); // true (no console output)

// Real-world example: default values
let userPreference = 'dark';
let theme = userPreference || 'light'; // "dark"

userPreference = '';
theme = userPreference || 'light'; // "light" (empty string is falsy)
```

## Practical Patterns

### Default Values with OR (`||`)

```javascript
// Function parameters
function greet(name) {
  name = name || 'Guest';
  return `Hello, ${name}!`;
}

console.log(greet('Alice')); // "Hello, Alice!"
console.log(greet()); // "Hello, Guest!"

// Object properties
function createUser(options) {
  options = options || {};

  return {
    name: options.name || 'Anonymous',
    theme: options.theme || 'light',
    notifications: options.notifications || true,
  };
}

const user1 = createUser({ name: 'Bob' });
// { name: "Bob", theme: "light", notifications: true }

const user2 = createUser();
// { name: "Anonymous", theme: "light", notifications: true }
```

### Conditional Execution with AND (`&&`)

```javascript
// Execute function only if condition is true
let isLoggedIn = true;
let user = { name: 'Alice' };

isLoggedIn && console.log(`Welcome back, ${user.name}!`);

// Multiple conditions
let hasPermission = true;
let isVerified = true;

isLoggedIn && hasPermission && isVerified && performSensitiveOperation();

function performSensitiveOperation() {
  console.log('Performing sensitive operation...');
}

// React-style conditional rendering
function UserProfile({ user, showDetails }) {
  return (
    <div>
      <h1>{user.name}</h1>
      {showDetails && (
        <div>
          <p>Email: {user.email}</p>
          <p>Phone: {user.phone}</p>
        </div>
      )}
    </div>
  );
}
```

### Guard Clauses

```javascript
// Early return patterns
function processUser(user) {
  // Guard clauses using &&
  !user && console.log("No user provided") && return;
  !user.id && console.log("Invalid user ID") && return;
  !user.email && console.log("Email required") && return;

  // Main logic here
  console.log(`Processing user: ${user.name}`);
}

// Object method calling
let api = {
  endpoint: "/users",
  fetch: function() { return "data"; }
};

// Safe method calling
api && api.fetch && api.fetch();
```

## Advanced Patterns

### Nullish Coalescing (`??`)

The nullish coalescing operator returns the right operand when the left is `null` or `undefined` (but not other falsy values).

```javascript
// Difference between || and ??
let value1 = 0;
let value2 = '';
let value3 = false;
let value4 = null;
let value5 = undefined;

// Using || (checks for falsy values)
console.log(value1 || 'default'); // "default" (0 is falsy)
console.log(value2 || 'default'); // "default" ("" is falsy)
console.log(value3 || 'default'); // "default" (false is falsy)

// Using ?? (only checks for null/undefined)
console.log(value1 ?? 'default'); // 0 (0 is not null/undefined)
console.log(value2 ?? 'default'); // "" ("" is not null/undefined)
console.log(value3 ?? 'default'); // false (false is not null/undefined)
console.log(value4 ?? 'default'); // "default" (null triggers ??)
console.log(value5 ?? 'default'); // "default" (undefined triggers ??)
```

### Logical Assignment Operators (ES2021)

```javascript
let config = {};

// Logical OR assignment (||=)
config.theme ||= 'light'; // Same as: config.theme = config.theme || "light"
config.timeout ||= 5000;

// Logical AND assignment (&&=)
let user = { isAdmin: true, permissions: ['read'] };
user.isAdmin &&= user.permissions.includes('admin'); // false

// Nullish coalescing assignment (??=)
let settings = { color: null, size: undefined, theme: 'dark' };
settings.color ??= 'blue'; // "blue" (was null)
settings.size ??= 'medium'; // "medium" (was undefined)
settings.theme ??= 'light'; // "dark" (already has value)
```

## Real-World Examples

### API Response Handling

```javascript
async function fetchUserData(userId) {
  try {
    const response = await fetch(`/api/users/${userId}`);
    const data = await response.json();

    // Safe property access with logical operators
    return {
      name: data.name || 'Unknown User',
      email: data.email || 'No email provided',
      avatar: data.profile?.avatar || '/default-avatar.png',
      isActive: data.status === 'active' && data.lastLogin,
      notifications: data.preferences?.notifications ?? true,
    };
  } catch (error) {
    console.error('Failed to fetch user data:', error);
    return null;
  }
}
```

### Form Validation

```javascript
function validateForm(formData) {
  const errors = [];

  // Required field validation using &&
  !formData.email && errors.push('Email is required');
  !formData.password && errors.push('Password is required');

  // Conditional validation using &&
  formData.email &&
    !formData.email.includes('@') &&
    errors.push('Invalid email format');

  formData.password &&
    formData.password.length < 8 &&
    errors.push('Password must be at least 8 characters');

  // Age validation with multiple conditions
  formData.birthYear &&
    new Date().getFullYear() - formData.birthYear < 13 &&
    errors.push('Must be at least 13 years old');

  return {
    isValid: errors.length === 0,
    errors,
  };
}
```

### Component State Management

```javascript
function useLocalStorage(key, defaultValue) {
  // Get initial value with fallbacks
  const getInitialValue = () => {
    try {
      const item = localStorage.getItem(key);
      return item ? JSON.parse(item) : defaultValue;
    } catch (error) {
      console.warn(`Error reading localStorage key "${key}":`, error);
      return defaultValue;
    }
  };

  const [value, setValue] = useState(getInitialValue);

  const setStoredValue = (newValue) => {
    try {
      setValue(newValue);
      // Only store if not null/undefined
      newValue != null && localStorage.setItem(key, JSON.stringify(newValue));
    } catch (error) {
      console.warn(`Error setting localStorage key "${key}":`, error);
    }
  };

  return [value, setStoredValue];
}
```

### Error Handling Patterns

```javascript
function safeApiCall(url, options = {}) {
  // Validate inputs
  if (!url) {
    console.error('URL is required');
    return Promise.reject(new Error('URL is required'));
  }

  const defaultOptions = {
    method: 'GET',
    timeout: 5000,
    retries: 3,
  };

  const config = {
    ...defaultOptions,
    ...options,
    headers: {
      'Content-Type': 'application/json',
      ...options.headers,
    },
  };

  return fetch(url, config)
    .then((response) => {
      // Use && for conditional error throwing
      !response.ok && Promise.reject(new Error(`HTTP ${response.status}`));
      return response.json();
    })
    .catch((error) => {
      // Log error if logging is enabled
      config.enableLogging && console.error('API call failed:', error);

      // Return default data or re-throw based on configuration
      return config.returnDefaultOnError ? {} : Promise.reject(error);
    });
}
```

## Common Pitfalls and Best Practices

### Avoid These Patterns

```javascript
// ❌ Don't rely on automatic type conversion in comparisons
if (user.age && user.age > 18) {
} // age could be "0" (string)

// ✅ Better: explicit checks
if (user.age != null && Number(user.age) > 18) {
}

// ❌ Don't chain too many logical operators
user &&
  user.profile &&
  user.profile.settings &&
  user.profile.settings.theme === 'dark';

// ✅ Better: use optional chaining
user?.profile?.settings?.theme === 'dark';
```

### Best Practices

```javascript
// ✅ Use meaningful variable names in logical expressions
const isValidUser = user && user.id && user.email;
const canEdit = isLoggedIn && (isOwner || isAdmin);
const shouldShowButton = isValidUser && canEdit && hasPermission;

// ✅ Use parentheses for complex expressions
const canAccess = (isLoggedIn || isGuest) && (hasPermission || isPublic);

// ✅ Extract complex logic into functions
function canUserEditPost(user, post) {
  return (
    user &&
    post &&
    (user.id === post.authorId || user.role === 'admin') &&
    post.status !== 'published'
  );
}
```

## Operator Precedence

```javascript
// Operator precedence (high to low):
// 1. NOT (!)
// 2. AND (&&)
// 3. OR (||)

// These are equivalent:
console.log((!false && true) || false); // true
console.log((!false && true) || false); // true

// Use parentheses for clarity:
const result = isLoggedIn && (isAdmin || isOwner) && !isBanned;
```

---

## Summary

JavaScript logical operators provide powerful tools for:

- **`&&`**: Conditional execution and guard clauses
- **`||`**: Default values and fallbacks
- **`!`**: Boolean negation and conversion
- **`??`**: Nullish coalescing for null/undefined checks
- **Short-circuiting**: Performance optimization and safe operations

Master these patterns to write more expressive, efficient, and safer JavaScript code!
