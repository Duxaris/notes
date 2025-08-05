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

console.log(arr.slice(2));        // ['c', 'd', 'e']
console.log(arr.slice(2, 4));     // ['c', 'd'] 
console.log(arr.slice(-2));       // ['d', 'e']
console.log(arr.slice(-1));       // ['e']
console.log(arr.slice(1, -2));    // ['b', 'c']
console.log(arr.slice());         // ['a', 'b', 'c', 'd', 'e'] - shallow copy
console.log([...arr]);            // Alternative shallow copy
```

### SPLICE Method
- **Purpose**: Remove/add elements from array (MUTATES original!)
- **Returns**: Array of removed elements
- **Syntax**: `array.splice(startIndex, deleteCount, ...itemsToAdd)`

```javascript
let arr = ['a', 'b', 'c', 'd', 'e'];

arr.splice(-1);          // Removes last element
console.log(arr);        // ['a', 'b', 'c', 'd']

arr.splice(1, 2);        // Remove 2 elements starting at index 1
console.log(arr);        // ['a', 'd']
```

### REVERSE Method
- **Purpose**: Reverse array elements (MUTATES original!)
- **Returns**: The reversed array (same reference)

```javascript
const arr2 = ['j', 'i', 'h', 'g', 'f'];
console.log(arr2.reverse());  // ['f', 'g', 'h', 'i', 'j']
console.log(arr2);            // Original is also reversed!
```

### CONCAT Method
- **Purpose**: Combine arrays without mutating originals
- **Returns**: New array with combined elements

```javascript
const arr = ['a', 'b', 'c', 'd', 'e'];
const arr2 = ['f', 'g', 'h', 'i', 'j'];

const letters = arr.concat(arr2);
console.log(letters);           // ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j']
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
console.log(arr[0]);                    // 23
console.log(arr[arr.length - 1]);      // 64 (last element)
console.log(arr.slice(-1)[0]);         // 64 (last element)

// Modern at method
console.log(arr.at(0));                 // 23
console.log(arr.at(-1));                // 64 (last element)

// Works on strings too!
console.log('jonas'.at(0));             // 'j'
console.log('jonas'.at(-1));            // 's'
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
        <div class="movements__type movements__type--${type}">${i + 1} ${type}</div>
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

// Convert EUR to USD
const movementsUSD = movements.map(mov => mov * eurToUsd);
console.log(movementsUSD);

// Compare with for loop approach
const movementsUSDfor = [];
for (const mov of movements) movementsUSDfor.push(mov * eurToUsd);

// Create descriptions
const movementsDescriptions = movements.map((mov, i) =>
  `Movement ${i + 1}: You ${mov > 0 ? 'deposited' : 'withdrew'} ${Math.abs(mov)}`
);
```

**Key Points:**
- Always returns new array of same length
- Does not mutate original array
- Great for transforming data
- Can access element, index, and full array

## Computing Usernames

Real example from Bankist app:

```javascript
const createUsernames = function (accs) {
  accs.forEach(function (acc) {
    acc.username = acc.owner
      .toLowerCase()
      .split(' ')
      .map(name => name[0])
      .join('');
  });
};

// Creates usernames like: 'Jonas Schmedtmann' → 'js'
```

## The filter Method

**Purpose**: Select elements that pass a test condition

```javascript
const movements = [200, 450, -400, 3000, -650, -130, 70, 1300];

// Get only deposits (positive movements)
const deposits = movements.filter(function (mov) {
  return mov > 0;
});
console.log(deposits); // [200, 450, 3000, 70, 1300]

// Arrow function version
const withdrawals = movements.filter(mov => mov < 0);
console.log(withdrawals); // [-400, -650, -130]

// Compare with for loop
const depositsFor = [];
for (const mov of movements) if (mov > 0) depositsFor.push(mov);
```

## The reduce Method

**Purpose**: Reduce array to a single value (most powerful method!)

```javascript
const movements = [200, 450, -400, 3000, -650, -130, 70, 1300];

// Sum all movements (balance)
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
```

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
```

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
const account = accounts.find(acc => acc.owner === 'Jessica Davis');
console.log(account);

// Returns undefined if not found
const nonExistent = accounts.find(acc => acc.owner === 'Nobody');
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
    acc => acc.username === inputLoginUsername.value
  );
  
  if (currentAccount?.pin === Number(inputLoginPin.value)) {
    // Display UI and welcome message
    labelWelcome.textContent = `Welcome back, ${currentAccount.owner.split(' ')[0]}`;
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
    acc => acc.username === inputTransferTo.value
  );
  
  if (amount > 0 && 
      receiverAcc && 
      currentAccount.balance >= amount && 
      receiverAcc?.username !== currentAccount.username) {
    
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
const index = accounts.findIndex(acc => acc.username === 'js');
console.log(index); // Returns index number or -1 if not found
```

**Use Case - Deleting Account:**

```javascript
btnClose.addEventListener('click', function (e) {
  e.preventDefault();
  
  if (inputCloseUsername.value === currentAccount.username && 
      Number(inputClosePin.value) === currentAccount.pin) {
    
    const index = accounts.findIndex(
      acc => acc.username === currentAccount.username
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
const lastLargeMovement = movements.findLast(mov => mov > 1000);

// findLastIndex - gets last index that matches  
const lastLargeMovementIndex = movements.findLastIndex(mov => mov > 1000);
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

// Check if there are any deposits
const anyDeposits = movements.some(mov => mov > 0);
console.log(anyDeposits); // true

// Check if any movement is greater than 5000
const anyLarge = movements.some(mov => mov > 5000);
console.log(anyLarge); // false

// Loan approval (if any deposit >= 10% of loan)
const amount = 1000;
const canGetLoan = currentAccount.movements.some(mov => mov >= amount * 0.1);
```

### every Method
**Purpose**: Test if ALL elements pass the condition

```javascript
// Check if all movements are deposits
const allDeposits = movements.every(mov => mov > 0);
console.log(allDeposits); // false

// Check if all movements are reasonable amounts
const allReasonable = movements.every(mov => Math.abs(mov) < 10000);
console.log(allReasonable); // true
```

**Mental Models:**
- `some`: "Is there ANY element that...?"
- `every`: "Do ALL elements...?"

## flat and flatMap

### flat Method
**Purpose**: Flatten nested arrays

```javascript
const nested = [[1, 2], [3, 4], [5, 6]];
console.log(nested.flat()); // [1, 2, 3, 4, 5, 6]

// Deeper nesting
const deep = [[[1, 2]], [3, 4], [5, 6]];
console.log(deep.flat());    // [[1, 2], 3, 4, 5, 6] - only 1 level
console.log(deep.flat(2));   // [1, 2, 3, 4, 5, 6] - 2 levels deep
```

### flatMap Method
**Purpose**: Combine map and flat in one step (only goes 1 level deep)

```javascript
// Get all movements from all accounts
const allMovements = accounts
  .flatMap(acc => acc.movements);
  
// Equivalent to:
const allMovements2 = accounts
  .map(acc => acc.movements)
  .flat();
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
const groupedByType = Object.groupBy(accounts, acc => acc.type);
console.log(groupedByType);
// {
//   premium: [account1, account3],
//   standard: [account2],
//   basic: [account4]
// }

// Group movements by type
const groupedMovements = Object.groupBy(movements, mov => mov > 0 ? 'deposits' : 'withdrawals');
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
  el => Number(el.textContent.replace('€', ''))
);
```

## Non-Destructive Alternatives

New methods that don't mutate the original array:

```javascript
const arr = [1, 3, 2];

// Old (mutating) vs New (non-mutating)
arr.reverse();           // Mutates original
arr.toReversed();        // Returns new array

arr.sort();              // Mutates original  
arr.toSorted();          // Returns new array

arr.splice(1, 1);        // Mutates original
arr.toSpliced(1, 1);     // Returns new array

arr[1] = 99;             // Mutates original
arr.with(1, 99);         // Returns new array
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

Common patterns and real-world examples:

```javascript
// 1. Calculate total deposits
const totalDeposits = accounts
  .flatMap(acc => acc.movements)
  .filter(mov => mov > 0)
  .reduce((sum, deposit) => sum + deposit, 0);

// 2. Count deposits over 1000
const numDeposits1000 = accounts
  .flatMap(acc => acc.movements)
  .filter(mov => mov >= 1000).length;

// Alternative using reduce
const numDeposits1000v2 = accounts
  .flatMap(acc => acc.movements)
  .reduce((count, cur) => cur >= 1000 ? count + 1 : count, 0);

// 3. Create object with sums using reduce
const sums = accounts
  .flatMap(acc => acc.movements)
  .reduce(
    (sums, cur) => {
      sums[cur > 0 ? 'deposits' : 'withdrawals'] += cur;
      return sums;
    },
    { deposits: 0, withdrawals: 0 }
  );

// 4. Convert title case
const convertTitleCase = function (title) {
  const exceptions = ['a', 'an', 'and', 'the', 'but', 'or', 'on', 'in', 'with'];
  
  const titleCase = title
    .toLowerCase()
    .split(' ')
    .map(word => 
      exceptions.includes(word) ? word : word[0].toUpperCase() + word.slice(1)
    )
    .join(' ');
    
  return titleCase[0].toUpperCase() + titleCase.slice(1);
};
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
