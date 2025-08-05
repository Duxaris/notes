# Section 11: Working with Arrays

## Section Roadmap

This section covers all the essential array methods and patterns used in modern JavaScript:

1. **Simple Array Methods** - slice, splice, reverse, concat, join
2. **The new `at` Method** - Modern way to access array elements
3. **Looping Arrays with forEach** - Functional approach to iteration
4. **forEach with Maps and Sets** - Beyond just arrays
5. **Bankist App Project** - Real-world application
6. **Data Transformations** - map, filter, reduce trio
7. **Method Chaining** - Combining operations elegantly
8. **Finding Elements** - find, findIndex, findLast, findLastIndex
9. **Testing Arrays** - some, every methods
10. **Flattening Arrays** - flat, flatMap
11. **Sorting Arrays** - Custom sort logic
12. **Creating Arrays** - Array.from, fill, and more
13. **New Non-Destructive Methods** - toReversed, toSorted, etc.

## Simple Array Methods

### SLICE Method

- **Purpose**: Extract part of an array without mutating original
- **Returns**: New array with extracted elements
- **Syntax**: `array.slice(startIndex, endIndex)`

```javascript
let arr = ['a', 'b', 'c', 'd', 'e'];

console.log(arr.slice(2)); // ['c', 'd', 'e']
console.log(arr.slice(2, 4)); // ['c', 'd']
console.log(arr.slice(-2)); // ['d', 'e']
console.log(arr.slice(-1)); // ['e']
console.log(arr.slice(1, -2)); // ['b', 'c']
console.log(arr.slice()); // ['a', 'b', 'c', 'd', 'e'] - shallow copy
console.log([...arr]); // Alternative shallow copy
```

### SPLICE Method

- **Purpose**: Remove/add elements from array (MUTATES original!)
- **Returns**: Array of removed elements
- **Syntax**: `array.splice(startIndex, deleteCount, ...itemsToAdd)`

```javascript
let arr = ['a', 'b', 'c', 'd', 'e'];

arr.splice(-1); // Removes last element
console.log(arr); // ['a', 'b', 'c', 'd']

arr.splice(1, 2); // Remove 2 elements starting at index 1
console.log(arr); // ['a', 'd']
```

### REVERSE Method

- **Purpose**: Reverse array elements (MUTATES original!)
- **Returns**: The reversed array (same reference)

```javascript
const arr2 = ['j', 'i', 'h', 'g', 'f'];
console.log(arr2.reverse()); // ['f', 'g', 'h', 'i', 'j']
console.log(arr2); // Original is also reversed!
```

### CONCAT Method

- **Purpose**: Combine arrays without mutating originals
- **Returns**: New array with combined elements

```javascript
const arr = ['a', 'b', 'c', 'd', 'e'];
const arr2 = ['f', 'g', 'h', 'i', 'j'];

const letters = arr.concat(arr2);
console.log(letters); // ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j']
console.log([...arr, ...arr2]); // Alternative using spread
```

### JOIN Method

- **Purpose**: Convert array to string with separator
- **Returns**: String representation

```javascript
console.log(letters.join(' - ')); // "a - b - c - d - e - f - g - h - i - j"
```

## The New `at` Method

Modern alternative to bracket notation, especially useful for negative indices:

```javascript
const arr = [23, 11, 64];

// Traditional ways
console.log(arr[0]); // 23
console.log(arr[arr.length - 1]); // 64 (last element)
console.log(arr.slice(-1)[0]); // 64 (last element)

// Modern at method
console.log(arr.at(0)); // 23
console.log(arr.at(-1)); // 64 (last element)

// Works on strings too!
console.log('jonas'.at(0)); // 'j'
console.log('jonas'.at(-1)); // 's'
```

**When to use `at`:**

- When you need the last element: `arr.at(-1)`
- When working with negative indices
- For method chaining: `arr.slice(1, 3).at(-1)`

## Looping Arrays: forEach

### Basic forEach Syntax

```javascript
const movements = [200, 450, -400, 3000, -650, -130, 70, 1300];

// Traditional for...of loop
for (const [i, movement] of movements.entries()) {
  if (movement > 0) {
    console.log(`Movement ${i + 1}: You deposited ${movement}`);
  } else {
    console.log(`Movement ${i + 1}: You withdrew ${Math.abs(movement)}`);
  }
}

// forEach method
movements.forEach(function (mov, i, arr) {
  if (mov > 0) {
    console.log(`Movement ${i + 1}: You deposited ${mov}`);
  } else {
    console.log(`Movement ${i + 1}: You withdrew ${Math.abs(mov)}`);
  }
});
```

### forEach Parameters

1. **Current element** - The value being processed
2. **Current index** - Position in array
3. **Entire array** - Reference to the whole array

### Key Differences from for...of

- **Cannot break** out of forEach loop
- **Cannot continue** to next iteration
- **Always loops** through entire array
- **No return value** (always returns undefined)

## forEach with Maps and Sets

### With Maps

```javascript
const currencies = new Map([
  ['USD', 'United States dollar'],
  ['EUR', 'Euro'],
  ['GBP', 'Pound sterling'],
]);

currencies.forEach(function (value, key, map) {
  console.log(`${key}: ${value}`);
});
// USD: United States dollar
// EUR: Euro
// GBP: Pound sterling
```

### With Sets

```javascript
const currenciesUnique = new Set(['USD', 'GBP', 'USD', 'EUR', 'EUR']);

currenciesUnique.forEach(function (value, _, set) {
  console.log(`${value}: ${value}`);
});
// Note: Sets don't have keys, so value is repeated
// The underscore (_) indicates unused parameter
```

## PROJECT: Bankist App

The Bankist app demonstrates real-world array method usage:

- **Display movements**: forEach to create DOM elements
- **Calculate balance**: reduce to sum all transactions
- **Calculate summaries**: filter for deposits/withdrawals, then reduce
- **Create usernames**: map to transform names, then join
- **Find accounts**: find method for login functionality
- **Transfer money**: findIndex to locate accounts
- **Sort movements**: sort method with custom comparator

## Creating DOM Elements

Example from Bankist app:

```javascript
const displayMovements = function (movements, sort = false) {
  containerMovements.innerHTML = '';

  const movs = sort ? movements.slice().sort((a, b) => a - b) : movements;

  movs.forEach(function (mov, i) {
    const type = mov > 0 ? 'deposit' : 'withdrawal';

    const html = `
      <div class="movements__row">
        <div class="movements__type movements__type--${type}">${
      i + 1
    } ${type}</div>
        <div class="movements__value">${mov}€</div>
      </div>
    `;

    containerMovements.insertAdjacentHTML('afterbegin', html);
  });
};
```

## Data Transformations: map, filter, reduce

The three most important array methods for data transformation:

- **map**: Transform each element → new array (same length)
- **filter**: Select elements that pass test → new array (≤ length)
- **reduce**: Reduce all elements to single value → single value

## The map Method

**Purpose**: Transform each array element using a function

```javascript
const movements = [200, 450, -400, 3000, -650, -130, 70, 1300];
const eurToUsd = 1.1;

// Basic transformation - Convert EUR to USD
const movementsUSD = movements.map((mov) => mov * eurToUsd);
console.log(movementsUSD);
// [220, 495, -440, 3300, -715, -143, 77, 1430]

// Compare with traditional for loop approach
const movementsUSDfor = [];
for (const mov of movements) movementsUSDfor.push(mov * eurToUsd);

// Create descriptive strings
const movementsDescriptions = movements.map(
  (mov, i) =>
    `Movement ${i + 1}: You ${mov > 0 ? 'deposited' : 'withdrew'} ${Math.abs(
      mov
    )}`
);
console.log(movementsDescriptions);
// ['Movement 1: You deposited 200', 'Movement 2: You deposited 450', ...]

// More complex transformations
const accounts = [
  { owner: 'Jonas Schmedtmann', movements: [200, 450, -400] },
  { owner: 'Jessica Davis', movements: [5000, 3400, -150] },
  { owner: 'Steven Williams', movements: [200, -200, 340] },
];

// Extract owner names
const owners = accounts.map((acc) => acc.owner);
console.log(owners); // ['Jonas Schmedtmann', 'Jessica Davis', 'Steven Williams']

// Calculate balances
const balances = accounts.map((acc) =>
  acc.movements.reduce((sum, mov) => sum + mov, 0)
);
console.log(balances); // [250, 8250, 340]

// Create summary objects
const accountSummaries = accounts.map((acc) => ({
  owner: acc.owner,
  balance: acc.movements.reduce((sum, mov) => sum + mov, 0),
  deposits: acc.movements.filter((mov) => mov > 0).length,
  withdrawals: acc.movements.filter((mov) => mov < 0).length,
}));

// Transform nested data
const products = [
  { name: 'Laptop', price: 1000, category: 'Electronics' },
  { name: 'Phone', price: 500, category: 'Electronics' },
  { name: 'Book', price: 20, category: 'Education' },
];

// Add tax and format
const productsWithTax = products.map((product) => ({
  ...product,
  priceWithTax: (product.price * 1.2).toFixed(2),
  displayName: `${product.name} (${product.category})`,
}));

// Date transformations
const dates = ['2023-01-15', '2023-02-20', '2023-03-10'];
const formattedDates = dates.map((dateStr) => {
  const date = new Date(dateStr);
  return date.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  });
});
console.log(formattedDates);
// ['January 15, 2023', 'February 20, 2023', 'March 10, 2023']

// Working with indices
const numberedItems = ['apple', 'banana', 'cherry'].map(
  (item, index) => `${index + 1}. ${item.toUpperCase()}`
);
console.log(numberedItems); // ['1. APPLE', '2. BANANA', '3. CHERRY']
```

**Key Points:**

- Always returns new array of same length
- Does not mutate original array
- Perfect for data transformation and formatting
- Can access element, index, and full array
- Chainable with other array methods

## Computing Usernames

Real example from Bankist app:

```javascript
const createUsernames = function (accs) {
  accs.forEach(function (acc) {
    acc.username = acc.owner
      .toLowerCase() // 'jonas schmedtmann'
      .split(' ') // ['jonas', 'schmedtmann']
      .map((name) => name[0]) // ['j', 's']
      .join(''); // 'js'
  });
};

// Alternative functional approach (returns new array)
const getUsernames = (accs) =>
  accs.map((acc) => ({
    ...acc,
    username: acc.owner
      .toLowerCase()
      .split(' ')
      .map((name) => name[0])
      .join(''),
  }));

// More username variations
const createInitials = (name) =>
  name
    .split(' ')
    .map((word) => word[0].toUpperCase())
    .join('');

const createSlug = (name) => name.toLowerCase().split(' ').join('-');

const examples = [
  'Jonas Schmedtmann',
  'Jessica Davis',
  'Steven Thomas Williams',
];

examples.forEach((name) => {
  console.log(`${name} → ${createInitials(name)} → ${createSlug(name)}`);
});
// Jonas Schmedtmann → JS → jonas-schmedtmann
// Jessica Davis → JD → jessica-davis
// Steven Thomas Williams → STW → steven-thomas-williams
```

## The filter Method

**Purpose**: Select elements that pass a test condition

```javascript
const movements = [200, 450, -400, 3000, -650, -130, 70, 1300];

// Basic filtering - Get only deposits (positive movements)
const deposits = movements.filter(function (mov) {
  return mov > 0;
});
console.log(deposits); // [200, 450, 3000, 70, 1300]

// Arrow function version - Get withdrawals
const withdrawals = movements.filter((mov) => mov < 0);
console.log(withdrawals); // [-400, -650, -130]

// Compare with traditional for loop
const depositsFor = [];
for (const mov of movements) if (mov > 0) depositsFor.push(mov);

// Complex filtering conditions
const largeDeposits = movements.filter((mov) => mov > 0 && mov >= 1000);
console.log(largeDeposits); // [3000, 1300]

const moderateTransactions = movements.filter(
  (mov) => Math.abs(mov) >= 100 && Math.abs(mov) <= 500
);
console.log(moderateTransactions); // [200, 450, -400, -130]

// Filter with index
const earlyTransactions = movements.filter((mov, i) => i < 3);
console.log(earlyTransactions); // [200, 450, -400]

// Real-world examples
const products = [
  { name: 'Laptop', price: 1000, inStock: true, category: 'Electronics' },
  { name: 'Phone', price: 500, inStock: false, category: 'Electronics' },
  { name: 'Book', price: 20, inStock: true, category: 'Education' },
  { name: 'Tablet', price: 300, inStock: true, category: 'Electronics' },
  { name: 'Pen', price: 5, inStock: true, category: 'Stationery' },
];

// Available electronics under $600
const availableElectronics = products.filter(
  (product) =>
    product.category === 'Electronics' && product.inStock && product.price < 600
);

// Budget items (under $50)
const budgetItems = products.filter((product) => product.price <= 50);

// User data filtering
const users = [
  { name: 'John', age: 25, active: true, role: 'user' },
  { name: 'Jane', age: 35, active: true, role: 'admin' },
  { name: 'Bob', age: 17, active: false, role: 'user' },
  { name: 'Alice', age: 28, active: true, role: 'moderator' },
];

// Active adult users
const activeAdults = users.filter((user) => user.active && user.age >= 18);

// Admin and moderator roles
const privilegedUsers = users.filter((user) =>
  ['admin', 'moderator'].includes(user.role)
);

// Search functionality
const searchProducts = (products, searchTerm) =>
  products.filter((product) =>
    product.name.toLowerCase().includes(searchTerm.toLowerCase())
  );

console.log(searchProducts(products, 'la')); // Laptop
console.log(searchProducts(products, 'book')); // Book

// Date filtering
const events = [
  { name: 'Meeting', date: new Date('2023-12-15') },
  { name: 'Conference', date: new Date('2023-11-20') },
  { name: 'Workshop', date: new Date('2024-01-10') },
];

const futureEvents = events.filter((event) => event.date > new Date());
const pastEvents = events.filter((event) => event.date < new Date());

// Removing duplicates with filter
const numbers = [1, 2, 2, 3, 4, 4, 5];
const unique = numbers.filter((num, index, arr) => arr.indexOf(num) === index);
console.log(unique); // [1, 2, 3, 4, 5]
```

## The reduce Method

**Purpose**: Reduce array to a single value (most powerful method!)

### Basic reduce Syntax

```javascript
const movements = [200, 450, -400, 3000, -650, -130, 70, 1300];

// Sum all movements (calculate balance)
const balance = movements.reduce((acc, cur) => acc + cur, 0);
console.log(balance); // 2840

// More verbose version to understand the accumulator
const balanceVerbose = movements.reduce(function (acc, cur, i, arr) {
  console.log(`Iteration ${i}: ${acc}`);
  return acc + cur;
}, 0);

// Compare with traditional for loop
let balance2 = 0;
for (const mov of movements) balance2 += mov;
console.log(balance2); // Same result: 2840
```

### reduce Parameters

1. **Accumulator** - The "snowball" value that builds up
2. **Current element** - Current array element
3. **Current index** - Position in array
4. **Entire array** - Reference to whole array

### Advanced reduce Examples

```javascript
// Find maximum value
const max = movements.reduce((acc, mov) => {
  if (acc > mov) return acc;
  else return mov;
}, movements[0]);
console.log(max); // 3000

// Shorter version
const maximum = movements.reduce(
  (acc, mov) => (acc > mov ? acc : mov),
  movements[0]
);

// Find minimum value
const min = movements.reduce((acc, mov) => Math.min(acc, mov), movements[0]);
console.log(min); // -650

// Count elements
const positiveCount = movements.reduce(
  (count, mov) => (mov > 0 ? count + 1 : count),
  0
);
console.log(positiveCount); // 5

// Create objects with reduce
const summary = movements.reduce(
  (acc, mov) => {
    mov > 0 ? acc.deposits++ : acc.withdrawals++;
    acc.total += mov;
    return acc;
  },
  { deposits: 0, withdrawals: 0, total: 0 }
);

console.log(summary);
// { deposits: 5, withdrawals: 3, total: 2840 }

// Group array elements
const groupByType = movements.reduce((acc, mov) => {
  const key = mov > 0 ? 'deposits' : 'withdrawals';
  if (!acc[key]) acc[key] = [];
  acc[key].push(mov);
  return acc;
}, {});

console.log(groupByType);
// { deposits: [200, 450, 3000, 70, 1300], withdrawals: [-400, -650, -130] }

// Calculate average
const average = movements.reduce((sum, mov, i, arr) => {
  sum += mov;
  return i === arr.length - 1 ? sum / arr.length : sum;
}, 0);

// Alternative average calculation
const avg = movements.reduce((sum, mov) => sum + mov, 0) / movements.length;

// Working with objects
const expenses = [
  { description: 'Groceries', amount: 120, category: 'Food' },
  { description: 'Gas', amount: 60, category: 'Transport' },
  { description: 'Restaurant', amount: 85, category: 'Food' },
  { description: 'Movie', amount: 15, category: 'Entertainment' },
];

// Total expenses
const totalExpenses = expenses.reduce(
  (total, expense) => total + expense.amount,
  0
);
console.log(totalExpenses); // 280

// Group by category
const expensesByCategory = expenses.reduce((acc, expense) => {
  const category = expense.category;
  if (!acc[category]) acc[category] = [];
  acc[category].push(expense);
  return acc;
}, {});

// Category totals
const categoryTotals = expenses.reduce((acc, expense) => {
  const category = expense.category;
  acc[category] = (acc[category] || 0) + expense.amount;
  return acc;
}, {});

console.log(categoryTotals);
// { Food: 205, Transport: 60, Entertainment: 15 }

// Create lookup objects
const users = ['John', 'Jane', 'Bob'];
const userLookup = users.reduce((acc, user, index) => {
  acc[user.toLowerCase()] = { id: index + 1, name: user };
  return acc;
}, {});

console.log(userLookup);
// { john: {id: 1, name: 'John'}, jane: {id: 2, name: 'Jane'}, bob: {id: 3, name: 'Bob'} }

// Flatten arrays with reduce
const nested = [
  [1, 2],
  [3, 4],
  [5, 6],
];
const flattened = nested.reduce((acc, arr) => acc.concat(arr), []);
console.log(flattened); // [1, 2, 3, 4, 5, 6]

// Count occurrences
const fruits = ['apple', 'banana', 'apple', 'orange', 'banana', 'apple'];
const fruitCount = fruits.reduce((acc, fruit) => {
  acc[fruit] = (acc[fruit] || 0) + 1;
  return acc;
}, {});

console.log(fruitCount);
// { apple: 3, banana: 2, orange: 1 }

// Chain of operations with reduce
const processedData = [1, 2, 3, 4, 5].reduce((acc, num) => {
  // Square the number, then add to accumulator if even
  const squared = num * num;
  if (squared % 2 === 0) {
    acc.push(squared);
  }
  return acc;
}, []);

console.log(processedData); // [4, 16] (squares of 2 and 4)

// Build HTML with reduce
const items = ['apple', 'banana', 'cherry'];
const htmlList =
  items.reduce((html, item) => html + `<li>${item}</li>`, '<ul>') + '</ul>';

console.log(htmlList);
// <ul><li>apple</li><li>banana</li><li>cherry</li></ul>

// Running totals (cumulative sum)
const runningTotals = movements.reduce((acc, mov, i) => {
  const total = i === 0 ? mov : acc[i - 1] + mov;
  acc.push(total);
  return acc;
}, []);

console.log(runningTotals);
// [200, 650, 250, 3250, 2600, 2470, 2540, 3840]
```

### Common reduce Patterns

```javascript
// 1. Sum/Total
const sum = arr.reduce((acc, cur) => acc + cur, 0);

// 2. Product
const product = arr.reduce((acc, cur) => acc * cur, 1);

// 3. Maximum
const max = arr.reduce((acc, cur) => Math.max(acc, cur), -Infinity);

// 4. Minimum
const min = arr.reduce((acc, cur) => Math.min(acc, cur), Infinity);

// 5. Count conditions
const count = arr.reduce((acc, cur) => (condition ? acc + 1 : acc), 0);

// 6. Group by property
const groupBy = arr.reduce((acc, item) => {
  const key = item.property;
  (acc[key] = acc[key] || []).push(item);
  return acc;
}, {});

// 7. Create lookup/index
const lookup = arr.reduce((acc, item, index) => {
  acc[item.id] = index;
  return acc;
}, {});
```

const balance = movements.reduce((acc, cur) => acc + cur, 0);
console.log(balance); // 3840

// With detailed logging
const balanceDetailed = movements.reduce(function (acc, cur, i, arr) {
console.log(`Iteration ${i}: ${acc}`);
return acc + cur;
}, 0);

// Find maximum value
const max = movements.reduce((acc, mov) => {
if (acc > mov) return acc;
else return mov;
}, movements[0]); // Start with first element
console.log(max); // 3000

````

**Parameters:**
1. **Accumulator** - The "snowball" value
2. **Current element** - Current array element
3. **Current index** - Position in array
4. **Full array** - Reference to entire array

**Second parameter**: Initial value for accumulator

## The Magic of Chaining Methods

Combine multiple array methods for powerful data processing:

```javascript
const eurToUsd = 1.1;

// PIPELINE: Filter deposits → Convert to USD → Sum total
const totalDepositsUSD = movements
  .filter(mov => mov > 0)                    // Keep only deposits
  .map(mov => mov * eurToUsd)                // Convert to USD
  .reduce((acc, mov) => acc + mov, 0);       // Sum everything

console.log(totalDepositsUSD);
````

**Chaining Rules:**

- Each method (except reduce) returns new array
- Can chain as many methods as needed
- Order matters for performance and logic
- Debug by checking intermediate results

**Best Practices:**

- Put `filter` before `map` when possible (process fewer elements)
- Don't overuse - sometimes readability suffers
- Consider performance with very large arrays

## The find Method

**Purpose**: Find the FIRST element that matches condition

```javascript
const accounts = [account1, account2, account3, account4];

// Find account by owner name
const account = accounts.find((acc) => acc.owner === 'Jessica Davis');
console.log(account);

// Returns undefined if not found
const nonExistent = accounts.find((acc) => acc.owner === 'Nobody');
console.log(nonExistent); // undefined
```

**Key Differences from filter:**

- `find` returns **element itself**
- `filter` returns **array** (even if one element)
- `find` stops at **first match**
- `filter` goes through **entire array**

## Implementing Login

Real Bankist app login using find:

```javascript
btnLogin.addEventListener('click', function (e) {
  e.preventDefault(); // Prevent form submission

  currentAccount = accounts.find(
    (acc) => acc.username === inputLoginUsername.value
  );

  if (currentAccount?.pin === Number(inputLoginPin.value)) {
    // Display UI and welcome message
    labelWelcome.textContent = `Welcome back, ${
      currentAccount.owner.split(' ')[0]
    }`;
    containerApp.style.opacity = 100;

    // Update UI
    updateUI(currentAccount);
  }
});
```

## Implementing Transfers

Using find to locate recipient account:

```javascript
btnTransfer.addEventListener('click', function (e) {
  e.preventDefault();

  const amount = Number(inputTransferAmount.value);
  const receiverAcc = accounts.find(
    (acc) => acc.username === inputTransferTo.value
  );

  if (
    amount > 0 &&
    receiverAcc &&
    currentAccount.balance >= amount &&
    receiverAcc?.username !== currentAccount.username
  ) {
    // Transfer money
    currentAccount.movements.push(-amount);
    receiverAcc.movements.push(amount);

    // Update UI
    updateUI(currentAccount);
  }
});
```

## The findIndex Method

**Purpose**: Find the INDEX of first element that matches condition

```javascript
const accounts = [account1, account2, account3, account4];

// Find index of account
const index = accounts.findIndex((acc) => acc.username === 'js');
console.log(index); // Returns index number or -1 if not found
```

**Use Case - Deleting Account:**

```javascript
btnClose.addEventListener('click', function (e) {
  e.preventDefault();

  if (
    inputCloseUsername.value === currentAccount.username &&
    Number(inputClosePin.value) === currentAccount.pin
  ) {
    const index = accounts.findIndex(
      (acc) => acc.username === currentAccount.username
    );

    // Delete account
    accounts.splice(index, 1);

    // Hide UI
    containerApp.style.opacity = 0;
  }
});
```

## The New findLast and findLastIndex Methods

**Purpose**: Find from the end of the array (newest browser feature)

```javascript
// findLast - gets last element that matches
const lastLargeMovement = movements.findLast((mov) => mov > 1000);

// findLastIndex - gets last index that matches
const lastLargeMovementIndex = movements.findLastIndex((mov) => mov > 1000);
```

**Use Cases:**

- Finding most recent transaction
- Getting latest matching record
- Working with time-ordered data

## some and every

### some Method

**Purpose**: Test if ANY element passes the condition

```javascript
const movements = [200, 450, -400, 3000, -650, -130, 70, 1300];

// Basic usage - Check if there are any deposits
const anyDeposits = movements.some((mov) => mov > 0);
console.log(anyDeposits); // true

// Check if any movement is greater than 5000
const anyLarge = movements.some((mov) => mov > 5000);
console.log(anyLarge); // false

// More practical examples
const users = [
  { name: 'John', age: 25, active: true, role: 'user' },
  { name: 'Jane', age: 17, active: false, role: 'admin' },
  { name: 'Bob', age: 30, active: true, role: 'moderator' },
];

// Check if any user is admin
const hasAdmin = users.some((user) => user.role === 'admin');
console.log(hasAdmin); // true

// Check if any user is underage
const hasMinor = users.some((user) => user.age < 18);
console.log(hasMinor); // true

// Check if any user is inactive
const hasInactive = users.some((user) => !user.active);
console.log(hasInactive); // true

// Shopping cart examples
const cart = [
  { name: 'Laptop', price: 1000, category: 'Electronics' },
  { name: 'Book', price: 20, category: 'Education' },
  { name: 'Phone', price: 500, category: 'Electronics' },
];

// Check if cart has expensive items (over $800)
const hasExpensiveItems = cart.some((item) => item.price > 800);
console.log(hasExpensiveItems); // true

// Check if cart has electronics
const hasElectronics = cart.some((item) => item.category === 'Electronics');
console.log(hasElectronics); // true

// Form validation examples
const formFields = [
  { name: 'email', value: 'user@email.com', required: true },
  { name: 'phone', value: '', required: false },
  { name: 'address', value: '', required: true },
];

// Check if any required field is empty
const hasEmptyRequired = formFields.some(
  (field) => field.required && field.value === ''
);
console.log(hasEmptyRequired); // true

// Task management
const tasks = [
  { title: 'Design UI', completed: true, priority: 'high' },
  { title: 'Write code', completed: false, priority: 'high' },
  { title: 'Test app', completed: false, priority: 'medium' },
];

// Check if any high-priority task is incomplete
const hasUrgentWork = tasks.some(
  (task) => task.priority === 'high' && !task.completed
);
console.log(hasUrgentWork); // true

// Array contains any specific values
const numbers = [1, 3, 5, 7, 9];
const hasEvenNumber = numbers.some((num) => num % 2 === 0);
console.log(hasEvenNumber); // false

// Check for duplicates using some
const hasDuplicates = (arr) =>
  arr.some((item, index) => arr.indexOf(item) !== index);

console.log(hasDuplicates([1, 2, 3, 4])); // false
console.log(hasDuplicates([1, 2, 3, 2])); // true

// Permission checking
const permissions = ['read', 'write', 'delete'];
const canModify = permissions.some((perm) =>
  ['write', 'delete'].includes(perm)
);
console.log(canModify); // true

// Loan eligibility example from Bankist
const requestLoan = function (amount) {
  return movements.some((mov) => mov >= amount * 0.1);
};

console.log(requestLoan(1000)); // true (if any deposit >= 100)
```

### every Method

**Purpose**: Test if ALL elements pass the condition

```javascript
// Basic usage - Check if all movements are positive
const allPositive = movements.every((mov) => mov > 0);
console.log(allPositive); // false

// Check account with only positive movements
const account4 = { movements: [430, 1000, 700, 50, 90] };
const allDeposits = account4.movements.every((mov) => mov > 0);
console.log(allDeposits); // true

// User validation examples
const allAdults = users.every((user) => user.age >= 18);
console.log(allAdults); // false (Jane is 17)

const allActive = users.every((user) => user.active);
console.log(allActive); // false

// Form validation - all required fields filled
const allRequiredFilled = formFields.every(
  (field) => !field.required || field.value !== ''
);
console.log(allRequiredFilled); // false

// Product inventory checks
const products = [
  { name: 'Laptop', price: 1000, inStock: true },
  { name: 'Phone', price: 500, inStock: true },
  { name: 'Tablet', price: 300, inStock: false },
];

const allInStock = products.every((product) => product.inStock);
console.log(allInStock); // false

const allAffordable = products.every((product) => product.price <= 1500);
console.log(allAffordable); // true

// Task completion
const allTasksCompleted = tasks.every((task) => task.completed);
console.log(allTasksCompleted); // false

// Grade validation
const grades = [85, 92, 78, 96, 88];
const allPassing = grades.every((grade) => grade >= 70);
console.log(allPassing); // true

const allExcellent = grades.every((grade) => grade >= 90);
console.log(allExcellent); // false

// Array type checking
const allNumbers = [1, 2, 3, 4, 5].every((item) => typeof item === 'number');
console.log(allNumbers); // true

const mixedArray = [1, '2', 3, 4].every((item) => typeof item === 'number');
console.log(mixedArray); // false

// Date validation
const dates = ['2023-01-15', '2023-02-20', '2023-03-10'];
const allValidDates = dates.every((dateStr) => !isNaN(Date.parse(dateStr)));
console.log(allValidDates); // true

// Security permissions
const userPermissions = ['read', 'write'];
const hasAllPermissions = ['read', 'write', 'delete'].every((perm) =>
  userPermissions.includes(perm)
);
console.log(hasAllPermissions); // false

// Configuration validation
const config = {
  apiUrl: 'https://api.example.com',
  apiKey: 'abc123',
  timeout: 5000,
};

const requiredFields = ['apiUrl', 'apiKey', 'timeout'];
const configComplete = requiredFields.every(
  (field) => config[field] !== undefined && config[field] !== ''
);
console.log(configComplete); // true

// Range validation
const temperatures = [20, 22, 25, 23, 21];
const allComfortable = temperatures.every((temp) => temp >= 18 && temp <= 26);
console.log(allComfortable); // true

// Password strength validation
const passwords = ['StrongPass123!', 'weak', 'Another$tr0ng1'];
const allStrong = passwords.every(
  (password) =>
    password.length >= 8 &&
    /[A-Z]/.test(password) &&
    /[0-9]/.test(password) &&
    /[!@#$%^&*]/.test(password)
);
console.log(allStrong); // false
```

### Separate Callback Pattern

```javascript
// Reusable callback functions
const isPositive = (mov) => mov > 0;
const isNegative = (mov) => mov < 0;
const isLarge = (mov) => Math.abs(mov) > 1000;

// Use same callback with different methods
console.log(movements.some(isPositive)); // true - any positive?
console.log(movements.every(isPositive)); // false - all positive?
console.log(movements.filter(isPositive)); // [200, 450, 3000, 70, 1300]

console.log(movements.some(isLarge)); // true - any large movement?
console.log(movements.every(isLarge)); // false - all large movements?
console.log(movements.filter(isLarge)); // [3000]

// User validation functions
const isAdult = (user) => user.age >= 18;
const isActive = (user) => user.active;
const isAdmin = (user) => user.role === 'admin';

console.log(users.some(isAdmin)); // true - any admin?
console.log(users.every(isAdult)); // false - all adults?
console.log(users.filter(isActive)); // active users only
```

### Real-world Applications

```javascript
// E-commerce order validation
const validateOrder = (orderItems) => ({
  hasItems: orderItems.length > 0,
  allInStock: orderItems.every((item) => item.stock > 0),
  hasExpensiveItems: orderItems.some((item) => item.price > 100),
  totalUnder1000: orderItems.reduce((sum, item) => sum + item.price, 0) < 1000,
});

// Access control
const hasPermission = (userRoles, requiredRoles) =>
  requiredRoles.some((role) => userRoles.includes(role));

const hasAllPermissions = (userRoles, requiredRoles) =>
  requiredRoles.every((role) => userRoles.includes(role));

// Data quality checks
const validateDataset = (data) => ({
  hasData: data.length > 0,
  allComplete: data.every((record) =>
    Object.values(record).every((val) => val != null)
  ),
  hasOutliers: data.some((record) => record.value > 1000),
  consistent: data.every((record) => typeof record.id === 'number'),
});

// Feature availability
const browserSupport = ['fetch', 'Promise', 'arrow functions'];
const requiredFeatures = ['fetch', 'Promise'];

const isSupported = requiredFeatures.every((feature) =>
  browserSupport.includes(feature)
);
```

**Key Differences:**

- `some`: "Is there ANY element that...?" → returns `true`/`false`
- `every`: "Do ALL elements...?" → returns `true`/`false`
- `filter`: "Give me all elements that..." → returns array
- `find`: "Give me the first element that..." → returns element

**When to use:**

- `some`: Checking if condition exists (any admin user?, any errors?)
- `every`: Validation (all fields filled?, all items in stock?)
- Both stop early: `some` stops at first `true`, `every` stops at first `false`

// Loan approval (if any deposit >= 10% of loan)
const amount = 1000;
const canGetLoan = currentAccount.movements.some(mov => mov >= amount \* 0.1);

````

### every Method
**Purpose**: Test if ALL elements pass the condition

```javascript
// Check if all movements are deposits
const allDeposits = movements.every(mov => mov > 0);
console.log(allDeposits); // false

// Check if all movements are reasonable amounts
const allReasonable = movements.every(mov => Math.abs(mov) < 10000);
console.log(allReasonable); // true
````

**Mental Models:**

- `some`: "Is there ANY element that...?"
- `every`: "Do ALL elements...?"

## flat and flatMap

### flat Method

**Purpose**: Flatten nested arrays

```javascript
const nested = [
  [1, 2],
  [3, 4],
  [5, 6],
];
console.log(nested.flat()); // [1, 2, 3, 4, 5, 6]

// Deeper nesting
const deep = [[[1, 2]], [3, 4], [5, 6]];
console.log(deep.flat()); // [[1, 2], 3, 4, 5, 6] - only 1 level
console.log(deep.flat(2)); // [1, 2, 3, 4, 5, 6] - 2 levels deep
```

### flatMap Method

**Purpose**: Combine map and flat in one step (only goes 1 level deep)

```javascript
// Get all movements from all accounts
const allMovements = accounts.flatMap((acc) => acc.movements);

// Equivalent to:
const allMovements2 = accounts.map((acc) => acc.movements).flat();
```

**Use Cases:**

- Processing nested data structures
- Flattening results from mapping operations
- Working with arrays of arrays

## Sorting Arrays

**Purpose**: Reorder array elements (MUTATES original!)

```javascript
const movements = [200, 450, -400, 3000, -650, -130, 70, 1300];

// Default sort (converts to strings - weird for numbers!)
console.log(movements.sort()); // [-130, -400, -650, 1300, 200, 3000, 450, 70]

// Proper number sorting
// Ascending order
movements.sort((a, b) => a - b);
console.log(movements); // [-650, -400, -130, 70, 200, 450, 1300, 3000]

// Descending order
movements.sort((a, b) => b - a);
console.log(movements); // [3000, 1300, 450, 200, 70, -130, -400, -650]
```

**Compare Function Logic:**

- If return value < 0: `a` before `b`
- If return value > 0: `b` before `a`
- If return value = 0: keep original order

**Bankist App Sort Implementation:**

```javascript
let sorted = false;
btnSort.addEventListener('click', function (e) {
  e.preventDefault();
  displayMovements(currentAccount.movements, !sorted);
  sorted = !sorted;
});
```

## Array Grouping

**Purpose**: Group array elements by criteria (newer feature)

```javascript
// Group accounts by type
const groupedByType = Object.groupBy(accounts, (acc) => acc.type);
console.log(groupedByType);
// {
//   premium: [account1, account3],
//   standard: [account2],
//   basic: [account4]
// }

// Group movements by type
const groupedMovements = Object.groupBy(movements, (mov) =>
  mov > 0 ? 'deposits' : 'withdrawals'
);
console.log(groupedMovements);
// {
//   deposits: [200, 450, 3000, 70, 1300],
//   withdrawals: [-400, -650, -130]
// }
```

## More Ways of Creating and Filling Arrays

### Array Constructor

```javascript
// Creates array with 7 empty slots (not undefined!)
const x = new Array(7);
console.log(x); // [empty × 7]

// Only useful with fill method
x.fill(1);
console.log(x); // [1, 1, 1, 1, 1, 1, 1]

// Fill with parameters: value, start, end
x.fill(1, 3, 5);
console.log(x); // [empty, empty, empty, 1, 1, empty, empty]
```

### Array.from Method

```javascript
// Create array from length with mapping function
const y = Array.from({ length: 7 }, () => 1);
console.log(y); // [1, 1, 1, 1, 1, 1, 1]

// Create range of numbers
const z = Array.from({ length: 7 }, (_, i) => i + 1);
console.log(z); // [1, 2, 3, 4, 5, 6, 7]

// Convert NodeList to array
const movementsUI = Array.from(
  document.querySelectorAll('.movements__value'),
  (el) => Number(el.textContent.replace('€', ''))
);
```

## Non-Destructive Alternatives

New methods that don't mutate the original array:

```javascript
const arr = [1, 3, 2];

// Old (mutating) vs New (non-mutating)
arr.reverse(); // Mutates original
arr.toReversed(); // Returns new array

arr.sort(); // Mutates original
arr.toSorted(); // Returns new array

arr.splice(1, 1); // Mutates original
arr.toSpliced(1, 1); // Returns new array

arr[1] = 99; // Mutates original
arr.with(1, 99); // Returns new array
```

## Summary: Which Array Method to Use?

### I want to mutate the original array:

- **Add elements**: `push` (end), `unshift` (start)
- **Remove elements**: `pop` (end), `shift` (start), `splice` (any)
- **Others**: `reverse`, `sort`, `fill`

### I want a new array:

- **Computed from original**: `map` (transform elements)
- **Filtered using condition**: `filter`
- **Portion of original**: `slice`
- **Adding original to other**: `concat`
- **Flattening original**: `flat`, `flatMap`

### I want an array index:

- **Based on condition**: `findIndex`, `findLastIndex`
- **Based on value**: `indexOf`, `lastIndexOf`, `includes`

### I want an array element:

- **Based on condition**: `find`, `findLast`

### I want to know if array includes:

- **Based on condition**: `some`, `every`
- **Based on value**: `includes`

### I want a new string:

- **Based on separator**: `join`

### I want to transform to value:

- **Based on accumulator**: `reduce`

### I want to just loop array:

- **Based on callback**: `forEach` (no return value)

## Array Methods Practice

Common patterns and real-world examples from the course challenges:

### Challenge Examples

#### Dog Age Study (Challenge #1)

```javascript
// Julia and Kate's dog study - checking adults vs puppies
const checkDogs = function (dogsJulia, dogsKate) {
  // Remove cats (first and last 2) from Julia's data
  const dogsJuliaCorrected = dogsJulia.slice(1, -2);

  // Combine both datasets
  const allDogs = dogsJuliaCorrected.concat(dogsKate);

  // Check each dog
  allDogs.forEach(function (age, i) {
    const status =
      age >= 3 ? `an adult, and is ${age} years old` : 'still a puppy 🐶';
    console.log(`Dog number ${i + 1} is ${status}`);
  });
};

checkDogs([3, 5, 2, 12, 7], [4, 1, 15, 8, 3]);
```

#### Human Age Calculation (Challenge #2)

```javascript
// Convert dog ages to human ages and calculate average
const calcAverageHumanAge = function (ages) {
  const humanAges = ages.map((age) => (age <= 2 ? 2 * age : 16 + age * 4));
  const adults = humanAges.filter((age) => age >= 18);
  const average = adults.reduce((acc, age) => acc + age, 0) / adults.length;
  return average;
};

// Method chaining version
const calcAverageHumanAgeChain = (ages) =>
  ages
    .map((age) => (age <= 2 ? 2 * age : 16 + age * 4))
    .filter((age) => age >= 18)
    .reduce((acc, age, i, arr) => acc + age / arr.length, 0);

console.log(calcAverageHumanAge([5, 2, 4, 1, 15, 8, 3])); // 44
console.log(calcAverageHumanAge([16, 6, 10, 5, 6, 1, 4])); // 47.3
```

#### Dog Breed Activities (Challenge #4)

```javascript
const breeds = [
  {
    breed: 'German Shepherd',
    averageWeight: 32,
    activities: ['fetch', 'swimming'],
  },
  {
    breed: 'Dalmatian',
    averageWeight: 24,
    activities: ['running', 'fetch', 'agility'],
  },
  { breed: 'Labrador', averageWeight: 28, activities: ['swimming', 'fetch'] },
  { breed: 'Beagle', averageWeight: 12, activities: ['digging', 'fetch'] },
  {
    breed: 'Husky',
    averageWeight: 26,
    activities: ['running', 'agility', 'swimming'],
  },
  { breed: 'Bulldog', averageWeight: 36, activities: ['sleeping'] },
  { breed: 'Poodle', averageWeight: 18, activities: ['agility', 'fetch'] },
];

// 1. Find Husky weight
const huskyWeight = breeds.find(
  (breed) => breed.breed === 'Husky'
).averageWeight;

// 2. Find breed that likes both running and fetch
const dogBothActivities = breeds
  .filter(
    (b) => b.activities.includes('running') && b.activities.includes('fetch')
  )
  .map((d) => d.breed);

// 3. Get all activities
const allActivities = breeds.flatMap((d) => d.activities);

// 4. Get unique activities
const uniqueActivities = [...new Set(breeds.flatMap((d) => d.activities))];

// 5. Swimming adjacent activities
const swimmingAdjacent = [
  ...new Set(
    breeds
      .filter((b) => b.activities.includes('swimming'))
      .flatMap((d) => d.activities)
      .filter((activity) => activity !== 'swimming')
  ),
];

// 6. Check if all breeds >= 10kg
const allHeavy = breeds.every((b) => b.averageWeight >= 10);

// 7. Check if any breed is "active" (3+ activities)
const anyActive = breeds.some((b) => b.activities.length >= 3);

// 8. Heaviest breed that fetches
const heaviestFetcher = Math.max(
  ...breeds
    .filter((breed) => breed.activities.includes('fetch'))
    .map((breed) => breed.averageWeight)
);
```

#### Dog Food Analysis (Challenge #5)

```javascript
const dogs = [
  { weight: 22, curFood: 250, owners: ['Alice', 'Bob'] },
  { weight: 8, curFood: 200, owners: ['Matilda'] },
  { weight: 13, curFood: 275, owners: ['Sarah', 'John', 'Leo'] },
  { weight: 18, curFood: 244, owners: ['Joe'] },
  { weight: 32, curFood: 340, owners: ['Michael'] },
];

// 1. Add recommended food to each dog (mutate original array)
dogs.forEach((dog) => {
  dog.recFood = Math.trunc(dog.weight ** 0.75 * 28);
});

// 2. Find Sarah's dog and check eating habits
const sarahDog = dogs.find((dog) => dog.owners.includes('Sarah'));
console.log(
  `Sarah's dog is eating too ${
    sarahDog.curFood > sarahDog.recFood ? 'much' : 'little'
  }`
);

// 3. Group dogs by eating habits
const ownersTooMuch = dogs
  .filter((dog) => dog.curFood > dog.recFood)
  .flatMap((dog) => dog.owners);

const ownersTooLittle = dogs
  .filter((dog) => dog.curFood < dog.recFood)
  .flatMap((dog) => dog.owners);

// 4. Create strings
console.log(`${ownersTooMuch.join(' and ')}'s dogs eat too much!`);
console.log(`${ownersTooLittle.join(' and ')}'s dogs eat too little!`);

// 5. Check if any dog eats exactly recommended amount
const exactAmount = dogs.some((dog) => dog.curFood === dog.recFood);

// 6. Check if all dogs eat okay amount (within 10%)
const okayAmount = (dog) =>
  dog.curFood > dog.recFood * 0.9 && dog.curFood < dog.recFood * 1.1;
const allOkay = dogs.every(okayAmount);

// 7. Dogs eating okay amount
const dogsOkay = dogs.filter(okayAmount);

// 8. Group by eating categories
const groupedByEating = Object.groupBy(dogs, (dog) => {
  if (dog.curFood === dog.recFood) return 'exact';
  if (dog.curFood > dog.recFood) return 'too-much';
  return 'too-little';
});

// 9. Group by number of owners
const groupedByOwners = Object.groupBy(dogs, (dog) => dog.owners.length);

// 10. Sort by recommended food (non-mutating)
const sortedDogs = dogs.slice().sort((a, b) => a.recFood - b.recFood);
```

### Banking Application Practice

#### Real-world Banking Examples

```javascript
// 1. Calculate total deposits across all accounts
const bankDepositSum = accounts
  .flatMap((acc) => acc.movements)
  .filter((mov) => mov > 0)
  .reduce((sum, deposit) => sum + deposit, 0);

// 2. Count deposits over $1000 using reduce
const numDeposits1000 = accounts
  .flatMap((acc) => acc.movements)
  .reduce((count, cur) => (cur >= 1000 ? count + 1 : count), 0);

// 3. Create object with sums using reduce
const { deposits, withdrawals } = accounts
  .flatMap((acc) => acc.movements)
  .reduce(
    (sums, cur) => {
      sums[cur > 0 ? 'deposits' : 'withdrawals'] += cur;
      return sums;
    },
    { deposits: 0, withdrawals: 0 }
  );

// 4. Title case converter
const convertTitleCase = function (title) {
  const exceptions = ['a', 'an', 'and', 'the', 'but', 'or', 'on', 'in', 'with'];

  const titleCase = title
    .toLowerCase()
    .split(' ')
    .map((word) =>
      exceptions.includes(word) ? word : word[0].toUpperCase() + word.slice(1)
    )
    .join(' ');

  return titleCase[0].toUpperCase() + titleCase.slice(1);
};

console.log(convertTitleCase('this is a nice title'));
// "This Is a Nice Title"
```

### Advanced Array Patterns

#### Complex Data Processing

```javascript
// Find accounts with high activity
const highActivityAccounts = accounts.filter(
  (acc) => acc.movements.length >= 8
);

// Calculate account summaries
const accountSummaries = accounts.map((acc) => ({
  owner: acc.owner,
  balance: acc.movements.reduce((sum, mov) => sum + mov, 0),
  deposits: acc.movements.filter((mov) => mov > 0).length,
  withdrawals: acc.movements.filter((mov) => mov < 0).length,
  avgMovement:
    acc.movements.reduce((sum, mov) => sum + mov, 0) / acc.movements.length,
}));

// Group accounts by activity level
const groupedByActivity = Object.groupBy(accounts, (account) => {
  const movementCount = account.movements.length;
  if (movementCount >= 8) return 'very active';
  if (movementCount >= 4) return 'active';
  if (movementCount >= 1) return 'moderate';
  return 'inactive';
});

// Find latest large movement index
const latestLargeMovementIndex = movements.findLastIndex(
  (mov) => Math.abs(mov) > 2000
);
const movementsAgo = movements.length - latestLargeMovementIndex;
console.log(`Your latest large movement was ${movementsAgo} movements ago`);
```

#### Array Creation Patterns

```javascript
// Create dice rolls
const diceRolls = Array.from(
  { length: 100 },
  () => Math.floor(Math.random() * 6) + 1
);

// Create number ranges
const range1to10 = Array.from({ length: 10 }, (_, i) => i + 1);
const evens = Array.from({ length: 5 }, (_, i) => (i + 1) * 2);

// Convert NodeList to array with transformation
const movementsUI = Array.from(
  document.querySelectorAll('.movements__value'),
  (el) => Number(el.textContent.replace('€', ''))
);

// Fill patterns
const arr = new Array(7);
arr.fill(1, 3, 5); // Fill positions 3-4 with 1
const filled = new Array(5).fill(0).map((_, i) => i * i); // [0,1,4,9,16]
```

### Method Chaining Mastery

#### Complex Pipelines

```javascript
// Multi-step data transformation
const processedMovements = movements
  .filter((mov) => Math.abs(mov) > 100) // Significant movements only
  .map((mov) => ({ amount: mov, type: mov > 0 ? 'deposit' : 'withdrawal' }))
  .filter((obj) => obj.type === 'deposit') // Deposits only
  .map((obj) => obj.amount * 1.1) // Convert EUR to USD
  .reduce((sum, amount) => sum + amount, 0); // Total

// Account analysis pipeline
const accountAnalysis = accounts
  .filter((acc) => acc.movements.length >= 4) // Active accounts
  .map((acc) => ({
    owner: acc.owner,
    balance: acc.movements.reduce((sum, mov) => sum + mov, 0),
    avgDeposit: acc.movements
      .filter((mov) => mov > 0)
      .reduce((sum, dep, i, arr) => sum + dep / arr.length, 0),
  }))
  .filter((acc) => acc.balance > 0) // Positive balance
  .sort((a, b) => b.balance - a.balance); // Sort by balance

// Transaction categorization
const categorizeTransactions = movements
  .map((mov, i) => ({
    amount: mov,
    index: i + 1,
    category:
      Math.abs(mov) > 1000 ? 'large' : Math.abs(mov) > 500 ? 'medium' : 'small',
    type: mov > 0 ? 'income' : 'expense',
  }))
  .reduce((categories, transaction) => {
    const key = `${transaction.category}_${transaction.type}`;
    if (!categories[key]) categories[key] = [];
    categories[key].push(transaction);
    return categories;
  }, {});
```

### Performance Considerations

#### Efficient Array Operations

```javascript
// Early termination with find vs filter
const firstLargeDeposit = movements.find((mov) => mov > 1000); // Stops at first match
const allLargeDeposits = movements.filter((mov) => mov > 1000); // Checks all elements

// Memory efficient with some/every vs filter
const hasLargeDeposit = movements.some((mov) => mov > 1000); // Returns boolean
const largeDeposits = movements.filter((mov) => mov > 1000); // Creates new array

// Reduce vs multiple iterations
// Less efficient - multiple passes
const totalDeposits = movements
  .filter((mov) => mov > 0)
  .reduce((sum, mov) => sum + mov, 0);
const totalWithdrawals = movements
  .filter((mov) => mov < 0)
  .reduce((sum, mov) => sum + mov, 0);

// More efficient - single pass
const totals = movements.reduce(
  (acc, mov) => {
    mov > 0 ? (acc.deposits += mov) : (acc.withdrawals += mov);
    return acc;
  },
  { deposits: 0, withdrawals: 0 }
);
```

### Real-world Applications

#### Data Analysis Examples

```javascript
// Sales data analysis
const salesData = [
  { month: 'Jan', sales: 1000, region: 'North' },
  { month: 'Feb', sales: 1200, region: 'North' },
  { month: 'Jan', sales: 800, region: 'South' },
  { month: 'Feb', sales: 950, region: 'South' },
];

// Group by region and calculate totals
const salesByRegion = Object.groupBy(salesData, (item) => item.region);
const regionTotals = Object.entries(salesByRegion).map(([region, sales]) => ({
  region,
  total: sales.reduce((sum, sale) => sum + sale.sales, 0),
  avgSale: sales.reduce((sum, sale) => sum + sale.sales, 0) / sales.length,
}));

// E-commerce order processing
const orders = [
  { id: 1, items: ['shirt', 'pants'], total: 75, status: 'completed' },
  { id: 2, items: ['shoes'], total: 120, status: 'pending' },
  { id: 3, items: ['hat', 'belt', 'wallet'], total: 95, status: 'completed' },
];

const orderAnalysis = {
  completedOrders: orders.filter((order) => order.status === 'completed'),
  pendingRevenue: orders
    .filter((order) => order.status === 'pending')
    .reduce((sum, order) => sum + order.total, 0),
  popularItems: orders
    .flatMap((order) => order.items)
    .reduce((count, item) => {
      count[item] = (count[item] || 0) + 1;
      return count;
    }, {}),
  averageOrderValue:
    orders.reduce((sum, order) => sum + order.total, 0) / orders.length,
};
```

### Error Handling and Edge Cases

#### Defensive Programming

```javascript
// Safe array operations
const safeFind = (arr, predicate) => {
  return Array.isArray(arr) ? arr.find(predicate) : undefined;
};

const safeReduce = (arr, reducer, initial) => {
  if (!Array.isArray(arr) || arr.length === 0) return initial;
  return arr.reduce(reducer, initial);
};

// Handling empty arrays
const movements = [];
const balance = movements.reduce((sum, mov) => sum + mov, 0); // Safe with initial value
const maxMovement =
  movements.length > 0
    ? movements.reduce((max, mov) => (mov > max ? mov : max), movements[0])
    : 0;

// Null/undefined safety
const accounts = [
  { owner: 'John', movements: [100, -50] },
  { owner: 'Jane', movements: null },
  { owner: 'Bob' }, // No movements property
];

const safeTotalBalance = accounts
  .filter((acc) => Array.isArray(acc.movements))
  .flatMap((acc) => acc.movements)
  .reduce((sum, mov) => sum + mov, 0);
```

## Best Practices and Common Gotchas

### Best Practices:

1. **Choose the right method** for the job
2. **Chain methods** for readable, functional code
3. **Prefer non-mutating methods** when possible
4. **Use `const`** for arrays you don't reassign
5. **Consider performance** with large datasets

### Common Gotchas:

- **Mutating methods**: `sort`, `reverse`, `splice`, `fill` change original
- **Empty array slots**: Behave differently than `undefined`
- **Default sort**: Converts to strings (weird for numbers)
- **Callback parameters**: Order is `(element, index, array)`
- **Arrow function returns**: `{}` needs explicit return
- **Method chaining order**: `filter` then `map` usually more efficient

### When NOT to use array methods:

- **Very large arrays**: Consider performance implications
- **Need to break early**: Use traditional loops instead of `forEach`
- **Complex logic**: Sometimes a simple loop is clearer
- **Mutating during iteration**: Can cause unexpected behavior
