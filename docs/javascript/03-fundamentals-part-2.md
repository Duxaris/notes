# Section 3: JavaScript Fundamentals Part 2

## Key Concepts

- **Functions**
  - Reusable blocks of code that perform specific tasks
  - **Function declarations**: Hoisted, can be called before definition
  - **Function expressions**: Stored in variables, not hoisted
  - **Arrow functions**: Concise syntax, lexical `this` binding
  - **Parameters and arguments**: Input values for functions
  - **Return values**: Output from functions

- **Arrays**
  - Ordered collections of values (elements)
  - Zero-based indexing
  - Dynamic size - can grow and shrink
  - Can hold different data types
  - Many built-in methods for manipulation

- **Objects**
  - Key-value pairs (properties and methods)
  - Property access: dot notation vs bracket notation
  - Object methods: functions as object properties
  - `this` keyword refers to the object

- **Control Structures**
  - **Conditional statements**: `if`, `else if`, `else`
  - **Switch statements**: Multiple conditions
  - **Loops**: `for`, `while`, `do-while`
  - **Loop control**: `break`, `continue`

## Code Patterns

### Functions

```js
// Function declaration (hoisted)
function calcAge1(birthYear) {
    return 2024 - birthYear;
}

// Function expression (not hoisted)
const calcAge2 = function(birthYear) {
    return 2024 - birthYear;
}

// Arrow function (ES6)
const calcAge3 = birthYear => 2024 - birthYear;

// Arrow function with multiple parameters
const calcAge4 = (birthYear, currentYear) => currentYear - birthYear;

// Arrow function with multiple statements
const yearsUntilRetirement = (birthYear, firstName) => {
    const age = 2024 - birthYear;
    const retirement = 65 - age;
    return `${firstName} retires in ${retirement} years`;
}

// Functions calling other functions
function cutFruitPieces(fruit) {
    return fruit * 4;
}

function fruitProcessor(apples, oranges) {
    const applePieces = cutFruitPieces(apples);
    const orangePieces = cutFruitPieces(oranges);
    
    const juice = `Juice with ${applePieces} apple pieces and ${orangePieces} orange pieces.`;
    return juice;
}

console.log(fruitProcessor(2, 3));
```

### Arrays

```js
// Array creation
const friends = ['Michael', 'Steven', 'Peter'];
const years = new Array(1991, 1984, 2008, 2020);

// Array properties and methods
console.log(friends.length); // 3
console.log(friends[0]); // 'Michael'
console.log(friends[friends.length - 1]); // 'Peter'

// Mutating arrays (even with const)
friends[2] = 'Jay';
console.log(friends); // ['Michael', 'Steven', 'Jay']

// Array methods
friends.push('Jim'); // Add to end
friends.unshift('John'); // Add to beginning
friends.pop(); // Remove from end
friends.shift(); // Remove from beginning

console.log(friends.indexOf('Steven')); // 1
console.log(friends.includes('Steven')); // true

// Mixed data types
const john = ['John', 'Smith', 2024 - 1991, 'teacher', friends];

// Array exercises
const calcTip = function(bill) {
    return bill >= 50 && bill <= 300 ? bill * 0.15 : bill * 0.2;
}

const bills = [125, 555, 44];
const tips = [calcTip(bills[0]), calcTip(bills[1]), calcTip(bills[2])];
const totals = [bills[0] + tips[0], bills[1] + tips[1], bills[2] + tips[2]];
```

### Objects

```js
// Object literal
const john = {
    firstName: 'John',
    lastName: 'Smith',
    age: 2024 - 1991,
    job: 'teacher',
    friends: ['Michael', 'Peter', 'Steven']
};

// Accessing properties
console.log(john.lastName); // Dot notation
console.log(john['lastName']); // Bracket notation

// Dynamic property access
const nameKey = 'Name';
console.log(john['first' + nameKey]); // 'John'
console.log(john['last' + nameKey]); // 'Smith'

// Adding new properties
john.location = 'Portugal';
john['twitter'] = '@jonasschmedtman';

// Object methods
const john = {
    firstName: 'John',
    lastName: 'Smith',
    birthYear: 1991,
    job: 'teacher',
    friends: ['Michael', 'Peter', 'Steven'],
    hasDriversLicense: true,

    // Method (function as property)
    calcAge: function() {
        this.age = 2024 - this.birthYear;
        return this.age;
    },

    // Method with logic
    getSummary: function() {
        return `${this.firstName} is a ${this.calcAge()}-year old ${this.job}, and he has ${this.hasDriversLicense ? 'a' : 'no'} driver's license.`;
    }
};

console.log(john.calcAge()); // 33
console.log(john.age); // 33 (stored as property)
console.log(john.getSummary());
```

### Loops

```js
// For loop
for (let rep = 1; rep <= 10; rep++) {
    console.log(`Lifting weights repetition ${rep}`);
}

// Looping arrays
const john = ['John', 'Smith', 2024 - 1991, 'teacher', ['Michael', 'Peter', 'Steven']];
const types = [];

for (let i = 0; i < john.length; i++) {
    console.log(john[i], typeof john[i]);
    
    // Filling types array
    types[i] = typeof john[i];
    // or types.push(typeof john[i]);
}

// Continue and break
for (let i = 0; i < john.length; i++) {
    if (typeof john[i] !== 'string') continue;
    console.log(john[i], typeof john[i]);
}

for (let i = 0; i < john.length; i++) {
    if (typeof john[i] === 'number') break;
    console.log(john[i], typeof john[i]);
}

// Looping backwards
for (let i = john.length - 1; i >= 0; i--) {
    console.log(i, john[i]);
}

// Nested loops
for (let exercise = 1; exercise < 4; exercise++) {
    console.log(`-------- Starting exercise ${exercise}`);
    
    for (let rep = 1; rep < 6; rep++) {
        console.log(`Exercise ${exercise}: Lifting weight repetition ${rep}`);
    }
}

// While loop
let rep = 1;
while (rep <= 10) {
    console.log(`Lifting weights repetition ${rep}`);
    rep++;
}

// While loop with random condition
let dice = Math.trunc(Math.random() * 6) + 1;
while (dice !== 6) {
    console.log(`You rolled a ${dice}`);
    dice = Math.trunc(Math.random() * 6) + 1;
    if (dice === 6) console.log('Loop is about to end...');
}
```

## Practical Exercises

### BMI Calculator
```js
const mark = {
    fullName: 'Mark Miller',
    mass: 78,
    height: 1.69,
    calcBMI: function() {
        this.bmi = this.mass / this.height ** 2;
        return this.bmi;
    }
};

const john = {
    fullName: 'John Smith',
    mass: 92,
    height: 1.95,
    calcBMI: function() {
        this.bmi = this.mass / this.height ** 2;
        return this.bmi;
    }
};

mark.calcBMI();
john.calcBMI();

if (mark.bmi > john.bmi) {
    console.log(`${mark.fullName}'s BMI (${mark.bmi}) is higher than ${john.fullName}'s BMI (${john.bmi})`);
} else if (john.bmi > mark.bmi) {
    console.log(`${john.fullName}'s BMI (${john.bmi}) is higher than ${mark.fullName}'s BMI (${mark.bmi})`);
}
```

### Tip Calculator with Arrays
```js
const calcTip = function(bill) {
    return bill >= 50 && bill <= 300 ? bill * 0.15 : bill * 0.2;
}

const bills = [22, 295, 176, 440, 37, 105, 10, 1100, 86, 52];
const tips = [];
const totals = [];

for (let i = 0; i < bills.length; i++) {
    const tip = calcTip(bills[i]);
    tips.push(tip);
    totals.push(tip + bills[i]);
}

console.log(bills, tips, totals);

// Bonus: Calculate average
const calcAverage = function(arr) {
    let sum = 0;
    for (let i = 0; i < arr.length; i++) {
        sum += arr[i];
    }
    return sum / arr.length;
}

console.log(calcAverage(totals));
```

## Key Takeaways

1. **Functions are the building blocks** of JavaScript applications
2. **Arrays and objects are fundamental data structures**
3. **Practice different ways to create and manipulate them**
4. **Understand when to use each loop type**
5. **Methods (`this` keyword) make objects powerful**
6. **Always think about reusability when writing functions**

---

*These fundamentals form the foundation of all JavaScript programming! 🔥*
