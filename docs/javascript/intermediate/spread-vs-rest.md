# Spread vs Rest Operators

The three dots (`...`) operator in JavaScript serves two different purposes: **spread** (expanding) and **rest** (collecting). Understanding when and how to use each is crucial for modern JavaScript development.

## The Spread Operator (`...`)

The spread operator **expands** or **spreads** elements from arrays, objects, or other iterables.

### Array Spread

#### Copying Arrays
```javascript
const original = [1, 2, 3];

// ❌ Shallow copy (same reference)
const copy1 = original;
copy1.push(4);
console.log(original); // [1, 2, 3, 4] - Original modified!

// ✅ True copy with spread
const copy2 = [...original];
copy2.push(5);
console.log(original); // [1, 2, 3] - Original unchanged
console.log(copy2);    // [1, 2, 3, 5]
```

#### Combining Arrays
```javascript
const fruits = ['apple', 'banana'];
const vegetables = ['carrot', 'lettuce'];
const dairy = ['milk', 'cheese'];

// Old way with concat
const groceries1 = fruits.concat(vegetables).concat(dairy);

// Modern way with spread
const groceries2 = [...fruits, ...vegetables, ...dairy];
console.log(groceries2); // ['apple', 'banana', 'carrot', 'lettuce', 'milk', 'cheese']

// Add items while spreading
const extendedList = ['bread', ...fruits, 'eggs', ...vegetables];
console.log(extendedList); // ['bread', 'apple', 'banana', 'eggs', 'carrot', 'lettuce']
```

#### Converting Iterables to Arrays
```javascript
// String to array
const letters = [..."hello"];
console.log(letters); // ['h', 'e', 'l', 'l', 'o']

// NodeList to array (in browser)
const divs = [...document.querySelectorAll('div')];

// Set to array
const uniqueNumbers = new Set([1, 2, 2, 3, 3]);
const numberArray = [...uniqueNumbers];
console.log(numberArray); // [1, 2, 3]
```

### Object Spread

#### Copying Objects
```javascript
const person = {
  name: 'Alice',
  age: 30,
  city: 'Boston'
};

// ❌ Shallow copy (same reference)
const copy1 = person;
copy1.age = 31;
console.log(person.age); // 31 - Original modified!

// ✅ True copy with spread
const copy2 = { ...person };
copy2.age = 32;
console.log(person.age); // 30 - Original unchanged
console.log(copy2.age);  // 32
```

#### Merging Objects
```javascript
const defaults = {
  theme: 'light',
  language: 'en',
  notifications: true
};

const userPrefs = {
  theme: 'dark',
  fontSize: 'large'
};

// Merge with spread (later properties override earlier ones)
const settings = { ...defaults, ...userPrefs };
console.log(settings);
// {
//   theme: 'dark',      // Overridden by userPrefs
//   language: 'en',     // From defaults
//   notifications: true, // From defaults
//   fontSize: 'large'   // From userPrefs
// }
```

#### Updating Objects Immutably
```javascript
const user = {
  id: 1,
  name: 'John',
  email: 'john@example.com',
  profile: {
    avatar: 'avatar1.jpg',
    bio: 'Developer'
  }
};

// Update top-level property
const updatedUser = {
  ...user,
  name: 'John Doe',
  lastLogin: new Date()
};

// Update nested property (careful: only shallow copy!)
const updatedProfile = {
  ...user,
  profile: {
    ...user.profile,
    bio: 'Senior Developer'
  }
};
```

### Function Call Spread
```javascript
const numbers = [1, 5, 3, 9, 2];

// Old way with apply
const max1 = Math.max.apply(null, numbers);

// Modern way with spread
const max2 = Math.max(...numbers);
console.log(max2); // 9

// Practical example
function greet(firstName, lastName, title) {
  return `Hello, ${title} ${firstName} ${lastName}`;
}

const nameData = ['John', 'Smith', 'Dr.'];
const greeting = greet(...nameData);
console.log(greeting); // "Hello, Dr. John Smith"
```

## The Rest Operator (`...`)

The rest operator **collects** multiple elements into an array or object.

### Function Parameters (Rest Parameters)

#### Basic Rest Parameters
```javascript
// Collect all arguments into an array
function sum(...numbers) {
  return numbers.reduce((total, num) => total + num, 0);
}

console.log(sum(1, 2, 3));          // 6
console.log(sum(1, 2, 3, 4, 5));    // 15
console.log(sum());                 // 0
```

#### Mixed Parameters
```javascript
// Regular parameters + rest parameters
function introduce(greeting, ...names) {
  const nameList = names.join(', ');
  return `${greeting} ${nameList}!`;
}

console.log(introduce('Hello', 'Alice'));           // "Hello Alice!"
console.log(introduce('Hi', 'Bob', 'Carol', 'Dave')); // "Hi Bob, Carol, Dave!"
```

#### Advanced Rest Parameter Patterns
```javascript
// Rest must be last parameter
function processData(action, options = {}, ...items) {
  console.log(`Action: ${action}`);
  console.log(`Options:`, options);
  console.log(`Processing ${items.length} items:`, items);
}

processData('backup', { compress: true }, 'file1.txt', 'file2.txt', 'file3.txt');
// Action: backup
// Options: { compress: true }
// Processing 3 items: ['file1.txt', 'file2.txt', 'file3.txt']
```

### Array Destructuring with Rest

#### Collecting Remaining Elements
```javascript
const colors = ['red', 'green', 'blue', 'yellow', 'purple'];

// Get first, second, and rest
const [primary, secondary, ...others] = colors;
console.log(primary);   // 'red'
console.log(secondary); // 'green'
console.log(others);    // ['blue', 'yellow', 'purple']

// Skip elements and collect rest
const [first, , third, ...remaining] = colors;
console.log(first);     // 'red'
console.log(third);     // 'blue'
console.log(remaining); // ['yellow', 'purple']
```

### Object Destructuring with Rest

#### Collecting Remaining Properties
```javascript
const user = {
  id: 1,
  name: 'Alice',
  email: 'alice@example.com',
  age: 30,
  city: 'Boston',
  country: 'USA'
};

// Extract specific properties and collect the rest
const { id, name, ...details } = user;
console.log(id);      // 1
console.log(name);    // 'Alice'
console.log(details); // { email: 'alice@example.com', age: 30, city: 'Boston', country: 'USA' }
```

#### Excluding Properties
```javascript
const apiResponse = {
  data: { name: 'Product', price: 99 },
  meta: { timestamp: '2025-01-01' },
  _internal: 'secret',
  __debug: 'info'
};

// Remove internal properties
const { _internal, __debug, ...cleanData } = apiResponse;
console.log(cleanData); // { data: {...}, meta: {...} }
```

## Side-by-Side Comparison

### Spread vs Rest in Arrays
```javascript
// SPREAD: Expanding an array
const numbers = [1, 2, 3];
const moreNumbers = [0, ...numbers, 4, 5]; // [0, 1, 2, 3, 4, 5]
const max = Math.max(...numbers);           // 3

// REST: Collecting into an array
function average(...nums) {                 // Collecting parameters
  return nums.reduce((a, b) => a + b) / nums.length;
}

const [first, ...rest] = [1, 2, 3, 4];    // Collecting remaining elements
// first = 1, rest = [2, 3, 4]
```

### Spread vs Rest in Objects
```javascript
// SPREAD: Expanding an object
const defaults = { theme: 'light', size: 'medium' };
const userPrefs = { theme: 'dark' };
const config = { ...defaults, ...userPrefs }; // Merging objects

// REST: Collecting into an object
const settings = { theme: 'dark', size: 'large', color: 'blue', font: 'Arial' };
const { theme, ...otherSettings } = settings; // Extracting and collecting
// theme = 'dark', otherSettings = { size: 'large', color: 'blue', font: 'Arial' }
```

## Real-World Examples

### API Wrapper Function
```javascript
// Flexible API call function using rest parameters
async function apiCall(endpoint, method = 'GET', ...options) {
  const [headers, body, config] = options;
  
  const response = await fetch(endpoint, {
    method,
    headers: { 'Content-Type': 'application/json', ...headers },
    body: body ? JSON.stringify(body) : undefined,
    ...config
  });
  
  return response.json();
}

// Usage examples
apiCall('/users');                           // Simple GET
apiCall('/users', 'POST', {}, { name: 'Alice' }); // POST with body
apiCall('/users/1', 'PUT', { 'Auth': 'token' }, { name: 'Bob' }, { timeout: 5000 });
```

### Component Props Management
```javascript
// React component pattern
function Button({ variant = 'primary', size = 'medium', children, ...restProps }) {
  const baseClasses = 'btn';
  const variantClass = `btn-${variant}`;
  const sizeClass = `btn-${size}`;
  
  return (
    <button 
      className={`${baseClasses} ${variantClass} ${sizeClass}`}
      {...restProps}  // Spread remaining props (onClick, disabled, etc.)
    >
      {children}
    </button>
  );
}

// Usage
<Button 
  variant="secondary" 
  onClick={handleClick} 
  disabled={isLoading}
  data-testid="submit-btn"
>
  Submit
</Button>
```

### State Management
```javascript
// Redux-style reducer using spread
function todoReducer(state = { todos: [], filter: 'all' }, action) {
  switch (action.type) {
    case 'ADD_TODO':
      return {
        ...state,
        todos: [...state.todos, action.payload]
      };
    
    case 'UPDATE_TODO':
      return {
        ...state,
        todos: state.todos.map(todo =>
          todo.id === action.id
            ? { ...todo, ...action.updates }
            : todo
        )
      };
    
    case 'SET_FILTER':
      return {
        ...state,
        filter: action.filter
      };
    
    default:
      return state;
  }
}
```

## Best Practices

!!! tip "Spread vs Rest Best Practices"
    1. **Use spread for copying/merging** - Creates new objects/arrays
    2. **Use rest for collecting** - Groups multiple items
    3. **Remember shallow copy limitation** - Nested objects need special handling
    4. **Rest parameters must be last** - `function fn(a, b, ...rest)` ✅
    5. **Use meaningful names** - `...otherProps` vs `...rest`

### Good Examples
```javascript
// ✅ Good: Clear intent
const newUser = { ...defaultUser, ...formData };
const [primary, ...secondaryColors] = palette;

// ✅ Good: Immutable updates
const updatedUsers = users.map(user => 
  user.id === targetId 
    ? { ...user, lastActive: new Date() }
    : user
);

// ❌ Avoid: Deep nesting issues
const user = { profile: { settings: { theme: 'dark' } } };
const updated = { ...user }; // profile.settings.theme is still shared!

// ✅ Better: Handle nested updates properly
const updated = {
  ...user,
  profile: {
    ...user.profile,
    settings: {
      ...user.profile.settings,
      theme: 'light'
    }
  }
};
```

---

## Summary

| Context | Spread (`...`) | Rest (`...`) |
|---------|----------------|--------------|
| **Purpose** | Expands/spreads elements | Collects/groups elements |
| **Arrays** | `[...arr1, ...arr2]` | `[first, ...rest] = arr` |
| **Objects** | `{...obj1, ...obj2}` | `{prop, ...others} = obj` |
| **Functions** | `fn(...args)` | `function fn(...params)` |
| **When to use** | Copying, merging, passing | Collecting, extracting |

Master both patterns to write cleaner, more functional JavaScript code!
