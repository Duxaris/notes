# Section 11: Working with Arrays

## Key Concepts

- **Array Methods Overview**
  - JavaScript provides powerful built-in methods for array manipulation
  - Methods can be categorized as: mutating vs non-mutating, accessor vs iterator
  - Understanding method chaining for clean, functional code
  - **Why important**: Modern JavaScript heavily relies on array methods for data processing

- **forEach Method**
  - Executes a function for each array element
  - Does not return anything (undefined)
  - Cannot break out of the loop (use for...of for that)
  - **Syntax**: `array.forEach((element, index, array) => {})`
  - **Use case**: When you need to perform side effects for each element

- **map Method**
  - Creates a new array with results of calling a function on every element
  - Returns a new array of the same length
  - Does not mutate the original array
  - **Mental model**: Transform each element and collect results
  - **Syntax**: `array.map((element, index, array) => newElement)`

- **filter Method**
  - Creates a new array with elements that pass a test condition
  - Returns a new array (potentially shorter than original)
  - Does not mutate the original array
  - **Mental model**: Keep only elements that meet the criteria
  - **Syntax**: `array.filter((element, index, array) => boolean)`

- **reduce Method**
  - Reduces an array to a single value
  - Most powerful and flexible array method
  - Takes an accumulator and current element
  - **Mental model**: Combine all elements into one result
  - **Syntax**: `array.reduce((accumulator, element, index, array) => newAccumulator, initialValue)`

## Array Method Chaining

```javascript
// Example: Calculate total deposits over 1000
const totalLargeDeposits = movements
  .filter(mov => mov > 0)           // Keep only deposits
  .filter(mov => mov > 1000)        // Keep only large deposits  
  .reduce((acc, mov) => acc + mov, 0); // Sum them up
```

**Key Points:**

- Each method returns a new array (except reduce)
- Chain methods for readable, functional code
- Debug by checking intermediate results
- Order matters - optimize by putting cheaper operations first

## find and findIndex Methods

- **find Method**
  - Returns the **first element** that satisfies the condition
  - Returns `undefined` if no element is found
  - **Use case**: Finding a specific object in an array
  - **Syntax**: `array.find(element => condition)`

- **findIndex Method**
  - Returns the **index** of the first element that satisfies the condition
  - Returns `-1` if no element is found
  - **Use case**: Finding position to remove or modify an element
  - **Syntax**: `array.findIndex(element => condition)`

```javascript
// Example
const account = accounts.find(acc => acc.owner === 'Jonas Schmedtmann');
const index = accounts.findIndex(acc => acc.owner === 'Jonas Schmedtmann');
```

## some and every Methods

- **some Method**
  - Tests if **at least one** element passes the condition
  - Returns `true` or `false`
  - **Mental model**: "Is there any element that...?"
  - **Use case**: Checking if any element meets criteria

- **every Method**
  - Tests if **all** elements pass the condition
  - Returns `true` or `false`
  - **Mental model**: "Do all elements...?"
  - **Use case**: Validation - ensuring all elements meet requirements

```javascript
// Examples
const anyDeposits = movements.some(mov => mov > 0);
const allDeposits = movements.every(mov => mov > 0);
```

## flat and flatMap Methods

- **flat Method**
  - Flattens nested arrays by specified depth
  - Default depth is 1
  - **Syntax**: `array.flat(depth)`
  - **Use case**: Working with nested array structures

- **flatMap Method**
  - Combines `map` and `flat` in one step
  - Only flattens by 1 level
  - **Use case**: Mapping that results in arrays, then flattening

```javascript
// Examples
const nested = [[1, 2], [3, 4], [5, 6]];
const flattened = nested.flat(); // [1, 2, 3, 4, 5, 6]

const mapped = arr.flatMap(x => [x, x * 2]); // map then flat
```

## Sorting Arrays

- **sort Method**
  - Mutates the original array!
  - Default: converts to strings and sorts alphabetically
  - **For numbers**: Must provide compare function
  - **Syntax**: `array.sort((a, b) => a - b)` (ascending)

```javascript
// Number sorting
movements.sort((a, b) => a - b);        // Ascending
movements.sort((a, b) => b - a);        // Descending

// String sorting (default behavior)
owners.sort(); // Alphabetical
```

## Array Creation and Fill

- **Array Constructor**
  - `new Array(7)` creates array with 7 empty slots
  - `new Array(1, 2, 3)` creates `[1, 2, 3]`
  - Empty slots behave differently than `undefined`

- **Array.from Method**
  - Creates array from array-like objects or iterables
  - Can take a mapping function as second argument
  - **Use case**: Converting NodeLists, creating ranges

- **fill Method**
  - Fills array with static value
  - Mutates the original array
  - Can specify start and end indices

```javascript
// Examples
const arr = new Array(7);
arr.fill(1, 3, 5); // Fill with 1 from index 3 to 5

const range = Array.from({ length: 7 }, (_, i) => i + 1); // [1,2,3,4,5,6,7]
```

## Practical Applications

### Banking App Example

The Bankist app demonstrates many array methods in practice:

1. **Display Movements**: Using `forEach` to create DOM elements
2. **Calculate Balance**: Using `reduce` to sum all movements
3. **Calculate Summary**: Using `filter` and `reduce` for deposits/withdrawals
4. **User Login**: Using `find` to locate user account
5. **Transfer Money**: Using `findIndex` to locate recipient
6. **Delete Account**: Using `findIndex` and `splice`
7. **Loan Approval**: Using `some` to check deposit history

### Common Patterns

```javascript
// Pattern 1: Transform then aggregate
const totalUSD = movements
  .map(mov => mov * exchangeRate)
  .reduce((acc, mov) => acc + mov, 0);

// Pattern 2: Filter then transform
const largeTradingFees = movements
  .filter(mov => Math.abs(mov) > 1000)
  .map(mov => mov * 0.01);

// Pattern 3: Conditional processing
const processedData = data
  .filter(item => item.isValid)
  .map(item => ({
    ...item,
    processed: true,
    timestamp: Date.now()
  }));
```

## Best Practices

1. **Prefer array methods over for loops** for functional style
2. **Chain methods** for readable, declarative code
3. **Use `const`** when creating new arrays (methods don't mutate original)
4. **Consider performance** - methods create new arrays
5. **Use appropriate method** for the task:
   - `forEach`: Side effects, no return value needed
   - `map`: Transform each element
   - `filter`: Select subset of elements  
   - `reduce`: Aggregate to single value
   - `find`: Locate specific element
   - `some/every`: Boolean tests

## Common Gotchas

- **Mutating methods**: `sort`, `reverse`, `splice`, `fill` change original array
- **Empty array slots**: Created by Array constructor behave unexpectedly
- **Chaining order**: `filter` before `map` is usually more efficient
- **Arrow function returns**: `array.map(x => x * 2)` vs `array.map(x => { return x * 2 })`
- **Callback parameters**: Remember the order is `(element, index, array)`

## When to Use Each Method

| Method | Use When You Want To... |
|--------|------------------------|
| `forEach` | Execute code for each element (side effects) |
| `map` | Transform each element into something new |
| `filter` | Select elements that meet criteria |
| `reduce` | Combine all elements into single value |
| `find` | Get first element matching condition |
| `findIndex` | Get position of first element matching condition |
| `some` | Check if any element meets condition |
| `every` | Check if all elements meet condition |
| `sort` | Reorder elements |
| `flat` | Flatten nested arrays |
