# Section 9: Data Structures, Modern Operators and Strings

## Key Concepts

- **Destructuring Assignment**

  - Extract values from arrays and objects into variables
  - **Array destructuring**: `const [a, b] = array`
  - **Object destructuring**: `const {name, age} = object`
  - Default values, variable renaming, nested destructuring
  - Swapping variables, function parameters
  - **Why useful**: Cleaner code, less repetition, easier data extraction from complex structures

- **Spread Operator (...)**

  - Expands arrays/objects into individual elements
  - **Array spreading**: `[...array1, ...array2]`
  - **Object spreading**: `{...obj1, ...obj2}`
  - Function arguments, copying arrays/objects
  - Since ES2018: works with objects too
  - **Mental model**: Like unpacking a suitcase - takes everything out and spreads it

- **Rest Pattern (...)**

  - Collects multiple elements into an array/object
  - **Rest in destructuring**: `const [a, ...others] = array`
  - **Rest parameters**: `function(...args)`
  - Always last element, opposite of spread
  - **Memory trick**: REST = collect the REST of the elements

- **Short-Circuiting (&& and ||)**

  - **OR (||)**: Returns first truthy value or last value (great for default values)
  - **AND (&&)**: Returns first falsy value or last value (perfect for conditional execution)
  - **Nullish Coalescing (??)**: Only null/undefined are falsy (more precise than ||)
  - Useful for default values and conditional execution
  - **Performance benefit**: Stops evaluating as soon as result is determined

- **Sets and Maps**
  - **Set**: Collection of unique values (like a bag that automatically removes duplicates)
  - **Map**: Key-value pairs with any data type as keys (more flexible than objects)
  - Methods: add, delete, has, clear, size
  - Iteration with for-of loops
  - **When to use**: Sets for uniqueness, Maps when you need non-string keys or ordered data

## Code Patterns

### Destructuring Arrays

```js
// Basic array destructuring - extract values by position
const arr = [2, 3, 4];
const [x, y, z] = arr; // x gets first, y gets second, z gets third
console.log(x, y, z); // 2, 3, 4

// Skipping elements - use empty space for elements you don't need
const [first, , third] = arr; // Skip the middle element
console.log(first, third); // 2, 4

// Default values - fallback if array doesn't have enough elements
const [p = 1, q = 1, r = 1] = [8, 9]; // r gets default value since only 2 elements
console.log(p, q, r); // 8, 9, 1

// Switching variables - elegant way to swap values
let [main, secondary] = ['Italian', 'Spanish'];
[main, secondary] = [secondary, main]; // No temp variable needed!
console.log(main, secondary); // Spanish, Italian

// Nested destructuring - destructure arrays inside arrays
const nested = [2, 4, [5, 6]];
const [i, , [j, k]] = nested; // Go deeper into the nested array
console.log(i, j, k); // 2, 5, 6

// Restaurant example
const restaurant = {
  name: 'Classico Italiano',
  categories: ['Italian', 'Pizzeria', 'Vegetarian', 'Organic'],
  starterMenu: ['Focaccia', 'Bruschetta', 'Garlic Bread'],
  mainMenu: ['Pizza', 'Pasta', 'Risotto'],

  order: function (starterIndex, mainIndex) {
    return [this.starterMenu[starterIndex], this.mainMenu[mainIndex]];
  },
};

// Destructuring function return
const [starter, mainCourse] = restaurant.order(2, 0);
console.log(starter, mainCourse); // Garlic Bread, Pizza
```

### Destructuring Objects

```js
// Basic object destructuring
const { name, categories, openingHours } = restaurant;
console.log(name, categories, openingHours);

// Variable renaming
const { name: restaurantName, categories: tags } = restaurant;
console.log(restaurantName, tags);

// Default values
const { menu = [], starterMenu: starters = [] } = restaurant;
console.log(menu, starters);

// Mutating variables
let a = 111;
let b = 999;
const obj = { a: 23, b: 7, c: 14 };
({ a, b } = obj); // Need parentheses!
console.log(a, b); // 23, 7

// Nested objects
const restaurant2 = {
  openingHours: {
    thu: { open: 12, close: 22 },
    fri: { open: 11, close: 23 },
    sat: { open: 0, close: 24 },
  },
};

const {
  fri: { open: o, close: c },
} = restaurant2.openingHours;
console.log(o, c); // 11, 23

// Function parameters
const orderDelivery = function ({
  starterIndex = 1,
  mainIndex = 0,
  time = '20:00',
  address,
}) {
  console.log(
    `Order received! ${starterIndex}, ${mainIndex}, ${time}, ${address}`
  );
};

restaurant.orderDelivery({
  time: '22:30',
  address: 'Via del Sole, 21',
  mainIndex: 2,
  starterIndex: 2,
});
```

### Spread Operator

```js
// Array spreading - unpack array elements
const arr = [7, 8, 9];
const badNewArr = [1, 2, arr[0], arr[1], arr[2]]; // Manual way (tedious!)
const newArr = [1, 2, ...arr]; // Spread operator - much cleaner!
console.log(newArr); // [1, 2, 7, 8, 9]

// Copying arrays - creates a shallow copy, not a reference
const mainMenuCopy = [...restaurant.mainMenu]; // Safe to modify without affecting original

// Joining arrays - combine multiple arrays elegantly
const menu = [...restaurant.starterMenu, ...restaurant.mainMenu];
console.log(menu); // All menu items in one array

// Iterables: arrays, strings, maps, sets. NOT objects (until ES2018)
const str = 'Jonas';
const letters = [...str, ' ', 'S.']; // Spread string into individual characters
console.log(letters); // ['J', 'o', 'n', 'a', 's', ' ', 'S.']

// Real-world example: function arguments (spread array into parameters)
const ingredients = [
  prompt("Let's make pasta! Ingredient 1?"),
  prompt('Ingredient 2?'),
  prompt('Ingredient 3'),
];

restaurant.orderPasta(...ingredients);

// Objects (ES2018)
const newRestaurant = {
  foundedIn: 1998,
  ...restaurant,
  founder: 'Giuseppe',
};

// Shallow copy of objects
const restaurantCopy = { ...restaurant };
restaurantCopy.name = 'Ristorante Roma';
console.log(restaurantCopy.name); // 'Ristorante Roma'
console.log(restaurant.name); // 'Classico Italiano' (unchanged)
```

### Rest Pattern

```js
// Rest in destructuring
const [a, b, ...others] = [1, 2, 3, 4, 5];
console.log(a, b, others); // 1, 2, [3, 4, 5]

// Rest with skipping
const [pizza, , risotto, ...otherFood] = [
  ...restaurant.mainMenu,
  ...restaurant.starterMenu,
];
console.log(pizza, risotto, otherFood);

// Rest in objects (collect remaining properties)
const { sat, ...weekdays } = restaurant.openingHours;
console.log(weekdays); // All days except Saturday

// Rest parameters in functions (variable number of arguments)
const add = function (...numbers) {
  // Collect all arguments into an array
  let sum = 0;
  for (let i = 0; i < numbers.length; i++) {
    sum += numbers[i];
  }
  return sum;
};

console.log(add(2, 3)); // 5 - works with any number of arguments
console.log(add(5, 3, 7, 2)); // 17
console.log(add(8, 2, 5, 3, 2, 1, 4)); // 25

// Using spread with rest parameters (spread array into individual arguments)
const x = [23, 5, 7];
console.log(add(...x)); // 35 - spread array elements as separate arguments

// Restaurant order function with rest (first parameter + collect the rest)
restaurant.orderPizza = function (mainIngredient, ...otherIngredients) {
  console.log(mainIngredient); // First argument
  console.log(otherIngredients); // Array of remaining arguments
};

restaurant.orderPizza('mushrooms', 'onion', 'olives', 'spinach');
// mushrooms
// ['onion', 'olives', 'spinach']
```

### Short-Circuiting

```js
// OR operator (||) - returns first TRUTHY value or last value
console.log(3 || 'Jonas'); // 3 (first truthy value)
console.log('' || 'Jonas'); // 'Jonas' (empty string is falsy)
console.log(true || 0); // true (already truthy, stops here)
console.log(undefined || null); // null (both falsy, returns last)

// Practical use: default values (but watch out for 0!)
restaurant.numGuests = 0;
const guests1 = restaurant.numGuests ? restaurant.numGuests : 10; // Traditional ternary
const guests2 = restaurant.numGuests || 10; // Short-circuit OR
console.log(guests1, guests2); // 0, 10 (problematic! 0 is falsy but valid number)

// AND operator (&&) - returns first FALSY value or last value
console.log(0 && 'Jonas'); // 0 (first falsy value, stops here)
console.log(7 && 'Jonas'); // 'Jonas' (all truthy, returns last)
console.log('Hello' && 23 && null && 'jonas'); // null (first falsy value)

// Practical use: conditional execution (cleaner than if statements)
if (restaurant.orderPizza) {
  // Traditional way
  restaurant.orderPizza('mushrooms', 'spinach');
}

restaurant.orderPizza && restaurant.orderPizza('mushrooms', 'spinach'); // Short-circuit way
// Only calls the function if it exists (truthy)

// Nullish coalescing operator (??) - ES2020 - solves the || problem with 0 and ''
restaurant.numGuests = 0;
const guests3 = restaurant.numGuests ?? 10; // Only triggers for null/undefined
console.log(guests3); // 0 (correct! 0 is not nullish)

// Only null and undefined are falsy for ?? (more precise than ||)
console.log(null ?? 'default'); // 'default' (null is nullish)
console.log(undefined ?? 'default'); // 'default' (undefined is nullish)
console.log(0 ?? 'default'); // 0 (0 is NOT nullish)
console.log('' ?? 'default'); // '' (empty string is NOT nullish)
```

### Logical Assignment Operators (ES2021)

```js
const rest1 = {
  name: 'Capri',
  numGuests: 0, // This is a valid value, not missing!
};

const rest2 = {
  name: 'La Piazza',
  owner: 'Giovanni Rossi',
  // numGuests is missing (undefined)
};

// OR assignment operator (||=) - assigns if current value is falsy
rest1.numGuests = rest1.numGuests || 10; // Problem: 0 becomes 10!
rest2.numGuests = rest2.numGuests || 10; // Good: undefined becomes 10

// Same as:
rest1.numGuests ||= 10;
rest2.numGuests ||= 10;

// Nullish assignment operator (??=)
rest1.numGuests ??= 10; // Better for 0 values
rest2.numGuests ??= 10;

// AND assignment operator (&&=)
rest1.owner = rest1.owner && '<ANONYMOUS>';
rest2.owner = rest2.owner && '<ANONYMOUS>';

// Same as:
rest1.owner &&= '<ANONYMOUS>';
rest2.owner &&= '<ANONYMOUS>';
```

### For-of Loop

```js
const menu = [...restaurant.starterMenu, ...restaurant.mainMenu];

// Basic for-of
for (const item of menu) console.log(item);

// Getting index
for (const [i, el] of menu.entries()) {
  console.log(`${i + 1}: ${el}`);
}

// entries() returns array of [index, element]
console.log([...menu.entries()]);
```

### Looping Objects: Object Keys, Values, and Entries

```js
// Sample opening hours object
const openingHours = {
  thu: {
    open: 12,
    close: 22,
  },
  fri: {
    open: 11,
    close: 23,
  },
  sat: {
    open: 0, // Open 24 hours
    close: 24,
  },
};

// Property NAMES (keys) - Object.keys()
const properties = Object.keys(openingHours);
console.log(properties); // ['thu', 'fri', 'sat']

// Building dynamic strings with keys
let openStr = `We are open on ${properties.length} days: `;
for (const day of properties) {
  openStr += `${day}, `;
}
console.log(openStr); // "We are open on 3 days: thu, fri, sat, "

// Property VALUES - Object.values()
const values = Object.values(openingHours);
console.log(values);
// [{ open: 12, close: 22 }, { open: 11, close: 23 }, { open: 0, close: 24 }]

// ENTIRE object entries - Object.entries()
const entries = Object.entries(openingHours);
console.log(entries);
// [
//   ['thu', { open: 12, close: 22 }],
//   ['fri', { open: 11, close: 23 }],
//   ['sat', { open: 0, close: 24 }]
// ]

// Destructuring in for-of loop with entries
for (const [day, { open, close }] of entries) {
  console.log(`On ${day} we open at ${open} and close at ${close}`);
}
// Output:
// On thu we open at 12 and close at 22
// On fri we open at 11 and close at 23
// On sat we open at 0 and close at 24

// Practical example: Restaurant hours checker
const days = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];

console.log('Restaurant Schedule:');
for (const day of days) {
  const hours = openingHours[day];
  if (hours) {
    console.log(`${day}: ${hours.open}:00 - ${hours.close}:00`);
  } else {
    console.log(`${day}: Closed`);
  }
}

// Converting objects for easier manipulation
const hoursArray = Object.entries(openingHours);
const totalHours = hoursArray.reduce((total, [day, { open, close }]) => {
  return total + (close - open);
}, 0);
console.log(`Total weekly hours: ${totalHours}`);

// Finding specific information
const busyDays = Object.entries(openingHours)
  .filter(([day, { open, close }]) => close - open > 12)
  .map(([day]) => day);
console.log('Busy days (open >12 hours):', busyDays);
```

### Enhanced Object Literals (ES6)

```js
const weekdays = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];

const openingHours = {
  [weekdays[3]]: {
    // Computed property names
    open: 12,
    close: 22,
  },
  [weekdays[4]]: {
    open: 11,
    close: 23,
  },
  [weekdays[5]]: {
    open: 0, // Open 24 hours
    close: 24,
  },
};

const restaurant3 = {
  name: 'Classico Italiano',

  // ES6 enhanced object literals
  openingHours, // Same as openingHours: openingHours

  // Method shorthand
  order(starterIndex, mainIndex) {
    // Instead of order: function()
    return [this.starterMenu[starterIndex], this.mainMenu[mainIndex]];
  },
};
```

### Optional Chaining (?.) - ES2020

```js
// Without optional chaining
if (restaurant.openingHours && restaurant.openingHours.mon) {
  console.log(restaurant.openingHours.mon.open);
}

// With optional chaining
console.log(restaurant.openingHours.mon?.open);
console.log(restaurant.openingHours?.mon?.open);

// Multiple optional chaining
const days = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];

for (const day of days) {
  const open = restaurant.openingHours[day]?.open ?? 'closed';
  console.log(`On ${day}, we open at ${open}`);
}

// Methods
console.log(restaurant.order?.(0, 1) ?? 'Method does not exist');
console.log(restaurant.orderRisotto?.(0, 1) ?? 'Method does not exist');

// Arrays
const users = [{ name: 'Jonas', email: 'hello@jonas.io' }];

console.log(users[0]?.name ?? 'User array empty');
console.log(users[2]?.name ?? 'User does not exist');
```

### Sets

```js
// Creating sets
const ordersSet = new Set([
  'Pasta',
  'Pizza',
  'Pizza',
  'Risotto',
  'Pasta',
  'Pizza',
]);

console.log(ordersSet); // Set(3) {"Pasta", "Pizza", "Risotto"}
console.log(new Set('Jonas')); // Set(5) {"J", "o", "n", "a", "s"}

// Set methods and properties
console.log(ordersSet.size); // 3
console.log(ordersSet.has('Pizza')); // true
console.log(ordersSet.has('Bread')); // false

ordersSet.add('Garlic Bread');
ordersSet.add('Garlic Bread'); // Won't be added (duplicate)
ordersSet.delete('Risotto');
console.log(ordersSet);

// Iterating sets
for (const order of ordersSet) console.log(order);

// Use case: Remove duplicates from arrays
const staff = ['Waiter', 'Chef', 'Waiter', 'Manager', 'Chef', 'Waiter'];
const staffUnique = [...new Set(staff)];
console.log(staffUnique);

// Count unique letters
console.log(new Set('jonasschmedtmann').size); // 11

// New Set Methods (ES2024) - Set operations
const italianFoods = new Set([
  'pasta',
  'gnocchi',
  'tomatoes',
  'olive oil',
  'garlic',
  'basil',
]);

const mexicanFoods = new Set([
  'tortillas',
  'beans',
  'rice',
  'tomatoes',
  'avocado',
  'garlic',
]);

// Intersection - common elements in both sets
const commonFoods = italianFoods.intersection(mexicanFoods);
console.log('Common foods:', [...commonFoods]); // ['tomatoes', 'garlic']

// Union - all unique elements from both sets
const allFoods = italianFoods.union(mexicanFoods);
console.log('All foods:', [...allFoods]);
// ['pasta', 'gnocchi', 'tomatoes', 'olive oil', 'garlic', 'basil', 'tortillas', 'beans', 'rice', 'avocado']

// Difference - elements in first set but not in second
const uniqueItalianFoods = italianFoods.difference(mexicanFoods);
console.log('Unique to Italian:', [...uniqueItalianFoods]); // ['pasta', 'gnocchi', 'olive oil', 'basil']

const uniqueMexicanFoods = mexicanFoods.difference(italianFoods);
console.log('Unique to Mexican:', [...uniqueMexicanFoods]); // ['tortillas', 'beans', 'rice', 'avocado']

// Symmetric Difference - elements in either set but not in both
const uniqueToEachCuisine = italianFoods.symmetricDifference(mexicanFoods);
console.log('Unique to each cuisine:', [...uniqueToEachCuisine]);
// ['pasta', 'gnocchi', 'olive oil', 'basil', 'tortillas', 'beans', 'rice', 'avocado']

// isDisjointFrom - check if sets have no common elements
console.log(
  'Cuisines share ingredients:',
  !italianFoods.isDisjointFrom(mexicanFoods)
); // true

const asianFoods = new Set(['rice', 'noodles', 'soy sauce']);
console.log(
  'Italian and Asian disjoint:',
  italianFoods.isDisjointFrom(asianFoods)
); // true

// isSubsetOf - check if all elements of one set are in another
const herbs = new Set(['basil', 'garlic']);
console.log('Herbs subset of Italian:', herbs.isSubsetOf(italianFoods)); // true

// isSupersetOf - check if set contains all elements of another set
console.log('Italian superset of herbs:', italianFoods.isSupersetOf(herbs)); // true

// Practical example: Menu analysis
const vegetarianOptions = new Set([
  'tomatoes',
  'beans',
  'rice',
  'avocado',
  'basil',
]);
const veggieItalian = italianFoods.intersection(vegetarianOptions);
const veggieMexican = mexicanFoods.intersection(vegetarianOptions);

console.log('Vegetarian Italian options:', [...veggieItalian]);
console.log('Vegetarian Mexican options:', [...veggieMexican]);
```

### Maps

```js
// Creating maps
const rest = new Map();
rest.set('name', 'Classico Italiano');
rest.set(1, 'Firenze, Italy');
rest.set(2, 'Lisbon, Portugal');

// Chaining set methods
rest
  .set('categories', ['Italian', 'Pizzeria', 'Vegetarian', 'Organic'])
  .set('open', 11)
  .set('close', 23)
  .set(true, 'We are open :D')
  .set(false, 'We are closed :(');

// Getting values
console.log(rest.get('name')); // 'Classico Italiano'
console.log(rest.get(true)); // 'We are open :D'
console.log(rest.get(1)); // 'Firenze, Italy'

// Clever use of boolean keys
const time = 21;
console.log(rest.get(time > rest.get('open') && time < rest.get('close')));

// Map methods
console.log(rest.has('categories')); // true
rest.delete(2);
console.log(rest.size); // 7
rest.clear();

// Maps with arrays/objects as keys
const arr = [1, 2];
rest.set(arr, 'Test');
rest.set(document.querySelector('h1'), 'Heading');

console.log(rest.get(arr)); // 'Test'

// Converting objects to maps
const hoursMap = new Map(Object.entries(openingHours));
console.log(hoursMap);

// Converting maps to arrays
console.log([...hoursMap]);
console.log([...hoursMap.keys()]);
console.log([...hoursMap.values()]);
```

### Working with Strings

```js
const airline = 'TAP Air Portugal';
const plane = 'A320';

// Getting characters
console.log(plane[0]); // 'A'
console.log(plane[1]); // '3'
console.log(plane[2]); // '2'
console.log('B737'[0]); // 'B'

// String length
console.log(airline.length); // 16
console.log('B737'.length); // 4

// String methods
console.log(airline.indexOf('r')); // 6
console.log(airline.lastIndexOf('r')); // 10
console.log(airline.indexOf('portugal')); // -1 (case sensitive)

// Slice method
console.log(airline.slice(4)); // 'Air Portugal'
console.log(airline.slice(4, 7)); // 'Air'

console.log(airline.slice(0, airline.indexOf(' '))); // 'TAP'
console.log(airline.slice(airline.lastIndexOf(' ') + 1)); // 'Portugal'

console.log(airline.slice(-2)); // 'al'
console.log(airline.slice(1, -1)); // 'AP Air Portuga'

// Practical functions
const checkMiddleSeat = function (seat) {
  // B and E are middle seats
  const s = seat.slice(-1);
  if (s === 'B' || s === 'E') {
    console.log('You got the middle seat 😬');
  } else {
    console.log('You got lucky 😎');
  }
};

checkMiddleSeat('11B'); // middle seat
checkMiddleSeat('23C'); // lucky
checkMiddleSeat('3E'); // middle seat

// Case conversion
console.log(airline.toLowerCase()); // 'tap air portugal'
console.log(airline.toUpperCase()); // 'TAP AIR PORTUGAL'

// Fix capitalization
const passenger = 'jOnAS'; // Should be 'Jonas'
const passengerLower = passenger.toLowerCase();
const passengerCorrect =
  passengerLower[0].toUpperCase() + passengerLower.slice(1);
console.log(passengerCorrect); // 'Jonas'

// Comparing emails
const email = 'hello@jonas.io';
const loginEmail = '  Hello@Jonas.Io \n';

const lowerEmail = loginEmail.toLowerCase();
const trimmedEmail = lowerEmail.trim(); // Also trimStart(), trimEnd()
console.log(trimmedEmail); // 'hello@jonas.io'

const normalizedEmail = loginEmail.toLowerCase().trim();
console.log(normalizedEmail === email); // true

// Replacing parts of strings
const priceGB = '288,97£';
const priceUS = priceGB.replace('£', '$').replace(',', '.');
console.log(priceUS); // '288.97$'

const announcement =
  'All passengers come to boarding door 23. Boarding door 23!';
console.log(announcement.replace('door', 'gate')); // Only first occurrence
console.log(announcement.replaceAll('door', 'gate')); // All occurrences

// Regular expressions
console.log(announcement.replace(/door/g, 'gate')); // Global flag

// Boolean methods
const plane2 = 'Airbus A320neo';
console.log(plane2.includes('A320')); // true
console.log(plane2.includes('Boeing')); // false
console.log(plane2.startsWith('Airb')); // true
console.log(plane2.endsWith('neo')); // true

// Practical example
if (plane2.startsWith('Airbus') && plane2.endsWith('neo')) {
  console.log('Part of the NEW Airbus family');
}

// Split and join
console.log('a+very+nice+string'.split('+')); // ['a', 'very', 'nice', 'string']
console.log('Jonas Schmedtmann'.split(' ')); // ['Jonas', 'Schmedtmann']

const [firstName, lastName] = 'Jonas Schmedtmann'.split(' ');

const newName = ['Mr.', firstName, lastName.toUpperCase()].join(' ');
console.log(newName); // 'Mr. Jonas SCHMEDTMANN'

// Capitalize names
const capitalizeName = function (name) {
  const names = name.split(' ');
  const namesUpper = [];

  for (const n of names) {
    // namesUpper.push(n[0].toUpperCase() + n.slice(1));
    namesUpper.push(n.replace(n[0], n[0].toUpperCase()));
  }
  console.log(namesUpper.join(' '));
};

capitalizeName('jessica ann smith davis'); // 'Jessica Ann Smith Davis'

// Padding
const message = 'Go to gate 23!';
console.log(message.padStart(20, '+').padEnd(30, '+'));
console.log('Jonas'.padStart(20, '+').padEnd(30, '+'));

// Credit card masking
const maskCreditCard = function (number) {
  const str = number + ''; // Convert to string
  const last = str.slice(-4);
  return last.padStart(str.length, '*');
};

console.log(maskCreditCard(64637836)); // '****7836'
console.log(maskCreditCard(43378463864647384)); // '*************7384'

// Repeat
const message2 = 'Bad weather... All Departures Delayed... ';
console.log(message2.repeat(5));

const planesInLine = function (n) {
  console.log(`There are ${n} planes in line ${'🛩'.repeat(n)}`);
};

planesInLine(5); // There are 5 planes in line 🛩🛩🛩🛩🛩
```

## Practical Exercises

### String Exercise: Camel Case Converter

```js
document.body.append(document.createElement('textarea'));
document.body.append(document.createElement('button'));

document.querySelector('button').addEventListener('click', function () {
  const text = document.querySelector('textarea').value;
  const rows = text.split('\n');

  for (const [i, row] of rows.entries()) {
    const [first, second] = row.toLowerCase().trim().split('_');
    const output = `${first}${second.replace(
      second[0],
      second[0].toUpperCase()
    )}`;
    console.log(`${output.padEnd(20)}${'✅'.repeat(i + 1)}`);
  }
});

// Input:
// underscore_case
// first_name
// Some_Variable
// calculate_AGE
// delayed_departure

// Output:
// underscoreCase     ✅
// firstName          ✅✅
// someVariable       ✅✅✅
// calculateAge       ✅✅✅✅
// delayedDeparture   ✅✅✅✅✅
```

### Array/Object Destructuring Challenge

```js
const game = {
  team1: 'Bayern Munich',
  team2: 'Borrussia Dortmund',
  players: [
    [
      'Neuer',
      'Pavard',
      'Martinez',
      'Alaba',
      'Davies',
      'Kimmich',
      'Goretzka',
      'Coman',
      'Muller',
      'Gnarby',
      'Lewandowski',
    ],
    [
      'Burki',
      'Schulz',
      'Hummels',
      'Akanji',
      'Hakimi',
      'Weigl',
      'Witsel',
      'Hazard',
      'Brandt',
      'Sancho',
      'Gotze',
    ],
  ],
  score: '4:0',
  scored: ['Lewandowski', 'Gnarby', 'Lewandowski', 'Hummels'],
  date: 'Nov 9th, 2037',
  odds: {
    team1: 1.33,
    x: 3.25,
    team2: 6.5,
  },
};

// 1. Create one player array for each team
const [players1, players2] = game.players;
console.log(players1, players2);

// 2. Create variables for goalkeeper and field players (team1)
const [gk, ...fieldPlayers] = players1;
console.log(gk, fieldPlayers);

// 3. Create array of all players
const allPlayers = [...players1, ...players2];
console.log(allPlayers);

// 4. Create final1 array with original team1 + 3 substitute players
const players1Final = [...players1, 'Thiago', 'Coutinho', 'Perisic'];

// 5. Create variables for odds
const {
  odds: { team1, x: draw, team2 },
} = game;
console.log(team1, draw, team2);

// 6. Function that receives unlimited number of player names
const printGoals = function (...players) {
  console.log(`${players.length} goals were scored`);
};

printGoals('Davies', 'Muller', 'Lewandowski', 'Kimmich');
printGoals(...game.scored);

// 7. Print winner (team with lower odd)
team1 < team2 && console.log('Team 1 is more likely to win');
team1 > team2 && console.log('Team 2 is more likely to win');
```

## Key Takeaways

1. **Destructuring** makes code cleaner and more readable
2. **Spread operator** is perfect for copying and combining arrays/objects
3. **Rest pattern** collects remaining elements
4. **Short-circuiting** provides elegant solutions for default values
5. **Sets** are great for unique values, **Maps** for complex key-value pairs
6. **String methods** are powerful for text manipulation
7. **Optional chaining** prevents errors when accessing nested properties

---

_These modern features make JavaScript code more concise and powerful! 🚀_
