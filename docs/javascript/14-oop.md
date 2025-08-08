# Section 14: Object-Oriented Programming (OOP)

## Section Overview

This section covers Object-Oriented Programming in JavaScript, exploring different ways to implement OOP concepts:

1. **What is Object-Oriented Programming?** - OOP fundamentals and principles
2. **OOP in JavaScript: Prototypes** - How JavaScript implements OOP differently
3. **Constructor Functions and the new Operator** - Traditional way to create objects
4. **Prototypes and Prototypal Inheritance** - Understanding JavaScript's prototype chain
5. **Prototypal Inheritance on Built-In Objects** - Extending native objects
6. **ES6 Classes** - Modern syntax for object creation
7. **Setters and Getters** - Accessor properties for computed values
8. **Static Methods** - Methods attached to constructor/class, not instances
9. **Object.create** - Alternative way to create objects with specific prototypes
10. **Inheritance Between Classes** - Constructor functions, ES6 classes, Object.create
11. **Encapsulation: Private Class Fields and Methods** - Data privacy in classes
12. **Chaining Methods** - Creating fluent interfaces

## What is Object-Oriented Programming?

### OOP Fundamentals

Object-Oriented Programming is a programming paradigm based on the concept of objects. Objects contain data (properties) and code (methods) that work together.

### The 4 Fundamental OOP Principles

```javascript
// 1. ABSTRACTION
// Hide complex implementation details, show only essential features
class Car {
  start() {
    // Complex engine starting logic hidden
    this._igniteEngine();
    this._activateSystems();
    console.log('Car started!');
  }

  _igniteEngine() {
    /* internal complexity */
  }
  _activateSystems() {
    /* internal complexity */
  }
}

// 2. ENCAPSULATION
// Keep properties and methods private inside the class
class BankAccount {
  #balance = 0; // Private field

  deposit(amount) {
    this.#balance += amount; // Controlled access
  }

  getBalance() {
    return this.#balance; // Controlled access
  }
}

// 3. INHERITANCE
// Child classes inherit properties and methods from parent classes
class Animal {
  move() {
    console.log('Moving...');
  }
}

class Dog extends Animal {
  bark() {
    console.log('Woof!');
  }
}

// 4. POLYMORPHISM
// Child classes can override parent methods
class Bird extends Animal {
  move() {
    console.log('Flying...');
  } // Override parent method
}
```

### Benefits of OOP

- **Modularity**: Code organized in self-contained objects
- **Reusability**: Classes can be reused and extended
- **Maintainability**: Easier to modify and debug
- **Flexibility**: Polymorphism allows flexible code design

## OOP in JavaScript: Prototypes

### JavaScript's Unique Approach

Unlike classical OOP languages, JavaScript uses **prototypal inheritance**:

```javascript
// Classical OOP (Java, C++): Classes → Objects
// JavaScript: Objects → Objects (via prototypes)

// Every object has a prototype
const person = {
  name: 'John',
  age: 30,
};

// person has a prototype: Object.prototype
console.log(person.__proto__ === Object.prototype); // true
```

### Lesson 223: Prototypal Inheritance and the Prototype Chain

Prototypal inheritance means objects delegate property/method lookups to their prototype. The prototype chain is the linked list of prototypes followed during lookup until null.

Key points:

- Every object has an internal [[Prototype]] (accessible via `__proto__` or `Object.getPrototypeOf`).
- Methods and properties are found by walking up the chain when not on the instance.
- `Function.prototype`, `Array.prototype`, and `Object.prototype` sit in the chain; the top is `Object.prototype` → `null`.
- Use `isPrototypeOf` and constructor checks to reason about relationships.

```javascript
const arr = [1, 2, 3];

// Prototypes in the chain
console.log(Object.getPrototypeOf(arr) === Array.prototype); // true
console.log(Object.getPrototypeOf(Array.prototype) === Object.prototype); // true
console.log(Object.getPrototypeOf(Object.prototype)); // null

// Method lookup through the chain
arr.push(4); // Found on Array.prototype
arr.toString(); // Found on Object.prototype (inherited by arrays)

// Inspecting and checking relationships
console.log(Array.prototype.isPrototypeOf(arr)); // true
console.log(Object.prototype.isPrototypeOf(arr)); // true
console.log(arr.hasOwnProperty('push')); // false (comes from prototype)
```

Practical notes:

- Prefer `Object.getPrototypeOf` over `__proto__` for readability and standards.
- Don’t modify `Object.prototype`; be cautious extending built-ins to avoid collisions.
- Instances share prototype methods (memory-efficient), while own properties live on the instance.

## Constructor Functions and the new Operator

### Creating Objects with Constructor Functions

```javascript
const Person = function (firstName, birthYear) {
  // Instance properties
  this.firstName = firstName;
  this.birthYear = birthYear;

  // Never create methods inside constructor (bad practice)
  // this.calcAge = function () {
  //   console.log(2037 - this.birthYear);
  // };
};

const jonas = new Person('Jonas', 1991);
const matilda = new Person('Matilda', 2017);

console.log(jonas instanceof Person); // true
```

### What Happens with the `new` Operator

```javascript
// When calling: new Person('Jonas', 1991)

// 1. New empty object {} is created
// 2. Function is called, this = newly created object
// 3. Object is linked to prototype (Person.prototype)
// 4. Function automatically returns the object

const Person = function (firstName, birthYear) {
  // Step 2: this = {} (new empty object)
  this.firstName = firstName;
  this.birthYear = birthYear;
  // Step 4: return this (happens automatically)
};
```

### Static Methods on Constructor Functions

```javascript
const Person = function (firstName, birthYear) {
  this.firstName = firstName;
  this.birthYear = birthYear;
};

// Static method (attached to constructor, not instances)
Person.hey = function () {
  console.log('Hey there 👋');
  console.log(this); // Points to Person constructor
};

Person.hey(); // Works
// jonas.hey(); // Error: not available on instances
```

## Prototypes and Prototypal Inheritance

### Adding Methods to Prototype

```javascript
const Person = function (firstName, birthYear) {
  this.firstName = firstName;
  this.birthYear = birthYear;
};

// Add methods to prototype (shared by all instances)
Person.prototype.calcAge = function () {
  console.log(2037 - this.birthYear);
};

Person.prototype.species = 'Homo Sapiens';

const jonas = new Person('Jonas', 1991);
jonas.calcAge(); // 46

// Checking prototype relationships
console.log(jonas.__proto__ === Person.prototype); // true
console.log(Person.prototype.isPrototypeOf(jonas)); // true
console.log(Person.prototype.isPrototypeOf(Person)); // false
```

### Property Lookup and hasOwnProperty

```javascript
const jonas = new Person('Jonas', 1991);

console.log(jonas.firstName); // Own property
console.log(jonas.species); // Inherited from prototype

console.log(jonas.hasOwnProperty('firstName')); // true
console.log(jonas.hasOwnProperty('species')); // false
```

### Practical Prototype Example

```javascript
const Calculator = function () {};

Calculator.prototype.add = function (a, b) {
  return a + b;
};

Calculator.prototype.multiply = function (a, b) {
  return a * b;
};

Calculator.prototype.memory = 0;

Calculator.prototype.memorize = function (value) {
  this.memory = value;
  return this;
};

const calc1 = new Calculator();
const calc2 = new Calculator();

console.log(calc1.add(5, 3)); // 8
console.log(calc2.multiply(4, 2)); // 8

// Shared prototype methods, separate instances
calc1.memorize(10);
console.log(calc1.memory); // 10
console.log(calc2.memory); // 0 (separate instances)
```

## Prototypal Inheritance on Built-In Objects

### Exploring Built-in Prototypes

```javascript
const arr = [3, 6, 6, 5, 6, 9, 9];

// Array prototype chain
console.log(arr.__proto__ === Array.prototype); // true
console.log(arr.__proto__.__proto__ === Object.prototype); // true
console.log(arr.__proto__.__proto__.__proto__); // null

// Function prototype
console.dir((x) => x + 1); // Shows function's prototype chain
```

### Extending Built-in Objects (Use with Caution)

```javascript
// Adding method to Array prototype
Array.prototype.unique = function () {
  return [...new Set(this)];
};

const numbers = [1, 2, 2, 3, 3, 4];
console.log(numbers.unique()); // [1, 2, 3, 4]

// Why this is generally not recommended:
// 1. Can break existing code
// 2. May conflict with future JS updates
// 3. Team confusion
// 4. Better to use utility functions instead
```

### Safer Alternative: Utility Functions

```javascript
// Instead of extending built-ins, create utility functions
const ArrayUtils = {
  unique(arr) {
    return [...new Set(arr)];
  },

  flatten(arr) {
    return arr.flat(Infinity);
  },

  groupBy(arr, key) {
    return arr.reduce((groups, item) => {
      const group = item[key];
      groups[group] = groups[group] || [];
      groups[group].push(item);
      return groups;
    }, {});
  },
};

// Usage
const numbers = [1, 2, 2, 3, 3, 4];
console.log(ArrayUtils.unique(numbers)); // [1, 2, 3, 4]
```

## ES6 Classes

### Class Declaration Syntax

```javascript
// Class declaration
class PersonCl {
  constructor(fullName, birthYear) {
    this.fullName = fullName;
    this.birthYear = birthYear;
  }

  // Instance methods (added to prototype)
  calcAge() {
    console.log(2037 - this.birthYear);
  }

  greet() {
    console.log(`Hey ${this.fullName}`);
  }
}

const jessica = new PersonCl('Jessica Davis', 1996);
jessica.calcAge(); // 41

// Classes are just syntactic sugar over constructor functions
console.log(jessica.__proto__ === PersonCl.prototype); // true
```

### Class Expression

```javascript
// Class expression
const PersonCl = class {
  constructor(name, birthYear) {
    this.name = name;
    this.birthYear = birthYear;
  }

  calcAge() {
    return 2037 - this.birthYear;
  }
};
```

### Important Notes About Classes

```javascript
// 1. Classes are NOT hoisted (cannot use before declaration)
// console.log(MyClass); // ReferenceError
// class MyClass {}

// 2. Classes are first-class citizens (can be passed as arguments)
function createInstance(ClassConstructor, ...args) {
  return new ClassConstructor(...args);
}

const person = createInstance(PersonCl, 'John', 1990);

// 3. Classes are always executed in strict mode
class StrictClass {
  constructor() {
    // This will be undefined in strict mode
    console.log(this); // PersonCl instance (not global object)
  }
}
```

## Setters and Getters

### Getters and Setters in Objects

```javascript
const account = {
  owner: 'Jonas',
  movements: [200, 530, 120, 300],

  // Getter - accessed like a property
  get latest() {
    return this.movements.slice(-1).pop();
  },

  // Setter - called when property is assigned
  set latest(mov) {
    this.movements.push(mov);
  },
};

console.log(account.latest); // 300 (calls getter)
account.latest = 50; // Calls setter
console.log(account.movements); // [200, 530, 120, 300, 50]
```

### Getters/Setters in Classes and Additional Notes

```javascript
class PersonCl {
  constructor(fullName, birthYear) {
    this.fullName = fullName; // triggers setter
    this.birthYear = birthYear;
  }

  get age() {
    return 2037 - this.birthYear;
  }

  set fullName(name) {
    if (name.includes(' ')) this._fullName = name;
    else console.log(`${name} is not a full name!`);
  }

  get fullName() {
    return this._fullName;
  }

  static hey() {
    console.log('Hey there 👋');
  }
}
```

## Static Methods

### Static Methods in Constructor Functions

```javascript
const Person = function (firstName, birthYear) {
  this.firstName = firstName;
  this.birthYear = birthYear;
};

// Static method
Person.hey = function () {
  console.log('Hey there 👋');
  console.log(this); // Points to Person constructor
};

Person.hey(); // Works - called on constructor
// jonas.hey(); // Error - not available on instances
```

### Static Methods in Classes

```javascript
class PersonCl {
  constructor(fullName, birthYear) {
    this.fullName = fullName;
    this.birthYear = birthYear;
  }

  // Instance method
  calcAge() {
    console.log(2037 - this.birthYear);
  }

  // Static method
  static hey() {
    console.log('Hey there 👋');
    console.log(this); // Points to PersonCl class
  }

  static createAnonymous() {
    return new this('Anonymous', 2000);
  }
}

PersonCl.hey(); // Works
const anon = PersonCl.createAnonymous(); // Factory method
console.log(anon.fullName); // 'Anonymous'
```

### Practical Static Method Examples

```javascript
class MathUtils {
  static PI = 3.14159;

  static circleArea(radius) {
    return this.PI * radius * radius;
  }

  static rectangleArea(width, height) {
    return width * height;
  }

  static randomBetween(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }
}

console.log(MathUtils.circleArea(5)); // 78.54
console.log(MathUtils.randomBetween(1, 10)); // Random number 1-10

class User {
  constructor(name, email) {
    this.name = name;
    this.email = email;
    this.id = User.generateId();
  }

  static users = [];

  static generateId() {
    return Date.now().toString(36) + Math.random().toString(36).substr(2);
  }

  static findByEmail(email) {
    return this.users.find((user) => user.email === email);
  }

  static createAndRegister(name, email) {
    const user = new this(name, email);
    this.users.push(user);
    return user;
  }
}

const user1 = User.createAndRegister('John', 'john@example.com');
const found = User.findByEmail('john@example.com');
```

## Object.create

### Creating Objects with Object.create

```javascript
// Define prototype object
const PersonProto = {
  calcAge() {
    console.log(2037 - this.birthYear);
  },

  init(firstName, birthYear) {
    this.firstName = firstName;
    this.birthYear = birthYear;
  },
};

// Create object with specific prototype
const steven = Object.create(PersonProto);
steven.name = 'Steven';
steven.birthYear = 2002;
steven.calcAge(); // 35

console.log(steven.__proto__ === PersonProto); // true

// Using init method for cleaner creation
const sarah = Object.create(PersonProto);
sarah.init('Sarah', 1979);
sarah.calcAge(); // 58
```

### Object.create vs Constructor Functions vs Classes

```javascript
// 1. Constructor Function approach
const PersonConstructor = function (name, birthYear) {
  this.name = name;
  this.birthYear = birthYear;
};
PersonConstructor.prototype.calcAge = function () {
  return 2037 - this.birthYear;
};

// 2. ES6 Class approach
class PersonClass {
  constructor(name, birthYear) {
    this.name = name;
    this.birthYear = birthYear;
  }

  calcAge() {
    return 2037 - this.birthYear;
  }
}

// 3. Object.create approach
const PersonProto = {
  init(name, birthYear) {
    this.name = name;
    this.birthYear = birthYear;
  },

  calcAge() {
    return 2037 - this.birthYear;
  },
};

// All create objects with prototype-based inheritance
const person1 = new PersonConstructor('John', 1990);
const person2 = new PersonClass('Jane', 1992);
const person3 = Object.create(PersonProto);
person3.init('Bob', 1988);
```

## Inheritance Between Classes

### Inheritance with Constructor Functions

```javascript
// Parent constructor
const Person = function (firstName, birthYear) {
  this.firstName = firstName;
  this.birthYear = birthYear;
};

Person.prototype.calcAge = function () {
  console.log(2037 - this.birthYear);
};

// Child constructor
const Student = function (firstName, birthYear, course) {
  // Call parent constructor
  Person.call(this, firstName, birthYear);
  this.course = course;
};

// Link prototypes (inheritance)
Student.prototype = Object.create(Person.prototype);

// Add child-specific methods
Student.prototype.introduce = function () {
  console.log(`My name is ${this.firstName} and I study ${this.course}`);
};

// Fix constructor reference
Student.prototype.constructor = Student;

const mike = new Student('Mike', 2020, 'Computer Science');
mike.introduce(); // My name is Mike and I study Computer Science
mike.calcAge(); // 17 (inherited from Person)

console.log(mike instanceof Student); // true
console.log(mike instanceof Person); // true
console.log(mike instanceof Object); // true
```

### Inheritance with ES6 Classes

```javascript
// Parent class
class PersonCl {
  constructor(fullName, birthYear) {
    this.fullName = fullName;
    this.birthYear = birthYear;
  }

  calcAge() {
    console.log(2037 - this.birthYear);
  }

  greet() {
    console.log(`Hey ${this.fullName}`);
  }
}

// Child class
class StudentCl extends PersonCl {
  constructor(fullName, birthYear, course) {
    // Call parent constructor (must be first!)
    super(fullName, birthYear);
    this.course = course;
  }

  introduce() {
    console.log(`My name is ${this.fullName} and I study ${this.course}`);
  }

  // Override parent method
  calcAge() {
    console.log(
      `I'm ${
        2037 - this.birthYear
      } years old, but as a student I feel more like ${
        2037 - this.birthYear + 10
      }`
    );
  }
}

const martha = new StudentCl('Martha Jones', 2012, 'Computer Science');
martha.introduce(); // My name is Martha Jones and I study Computer Science
martha.calcAge(); // I'm 25 years old, but as a student I feel more like 35
```

### Inheritance with Object.create

```javascript
const PersonProto = {
  calcAge() {
    console.log(2037 - this.birthYear);
  },

  init(firstName, birthYear) {
    this.firstName = firstName;
    this.birthYear = birthYear;
  },
};

// Create student prototype that inherits from PersonProto
const StudentProto = Object.create(PersonProto);

StudentProto.init = function (firstName, birthYear, course) {
  PersonProto.init.call(this, firstName, birthYear);
  this.course = course;
};

StudentProto.introduce = function () {
  console.log(`My name is ${this.firstName} and I study ${this.course}`);
};

const jay = Object.create(StudentProto);
jay.init('Jay', 2010, 'Computer Science');
jay.introduce(); // My name is Jay and I study Computer Science
jay.calcAge(); // 27
```

## Encapsulation: Private Class Fields and Methods

### Public and Private Fields

```javascript
class Account {
  // 1) Public fields (instances)
  locale = navigator.language;

  // 2) Private fields (instances)
  #movements = [];
  #pin;

  constructor(owner, currency, pin) {
    this.owner = owner;
    this.currency = currency;
    this.#pin = pin;

    console.log(`Thanks for opening an account, ${owner}`);
  }

  // 3) Public methods (API)
  getMovements() {
    return this.#movements;
  }

  deposit(val) {
    this.#movements.push(val);
    return this; // For chaining
  }

  withdraw(val) {
    this.deposit(-val);
    return this; // For chaining
  }

  // 4) Private methods
  #approveLoan(val) {
    return true; // Simplified approval logic
  }

  requestLoan(val) {
    if (this.#approveLoan(val)) {
      this.deposit(val);
      console.log(`Loan approved`);
    }
    return this;
  }
}

const acc1 = new Account('Jonas', 'EUR', 1111);

acc1.deposit(250);
acc1.withdraw(140);
console.log(acc1.getMovements()); // [250, -140]

// These won't work (private):
// console.log(acc1.#movements); // SyntaxError
// console.log(acc1.#pin); // SyntaxError
// acc1.#approveLoan(1000); // SyntaxError
```

### Static Fields and Methods

```javascript
class Account {
  // Static public field
  static numAccounts = 0;

  // Static private field
  static #bankName = 'Bankist Bank';

  constructor(owner, currency, pin) {
    this.owner = owner;
    this.currency = currency;
    this.pin = pin;

    // Increment account counter
    Account.numAccounts++;
  }

  // Static public method
  static getBankName() {
    return this.#bankName;
  }

  // Static private method
  static #validateAccountData(data) {
    return data.owner && data.currency && data.pin;
  }

  static createAccount(owner, currency, pin) {
    const accountData = { owner, currency, pin };

    if (this.#validateAccountData(accountData)) {
      return new this(owner, currency, pin);
    } else {
      throw new Error('Invalid account data');
    }
  }
}

console.log(Account.numAccounts); // 0
const acc1 = Account.createAccount('John', 'USD', 1234);
console.log(Account.numAccounts); // 1
console.log(Account.getBankName()); // 'Bankist Bank'
```

## Chaining Methods

### Implementing Method Chaining

```javascript
class Account {
  #movements = [];

  deposit(val) {
    this.#movements.push(val);
    return this; // Return 'this' to enable chaining
  }

  withdraw(val) {
    this.deposit(-val);
    return this; // Return 'this' to enable chaining
  }

  requestLoan(val) {
    if (this.#approveLoan(val)) {
      this.deposit(val);
      console.log(`Loan approved`);
    }
    return this; // Return 'this' to enable chaining
  }

  #approveLoan(val) {
    return true;
  }

  getMovements() {
    return this.#movements;
    // Note: getMovements doesn't return 'this' because it returns data
    // This breaks the chain, so it should be called last
  }
}

const acc1 = new Account('Jonas', 'EUR', 1111);

// Method chaining in action
const movements = acc1
  .deposit(300)
  .deposit(500)
  .withdraw(35)
  .requestLoan(25000)
  .withdraw(4000)
  .getMovements(); // Must be last (doesn't return 'this')

console.log(movements); // [300, 500, -35, 25000, -4000]
```

### Advanced Chaining Example

```javascript
class QueryBuilder {
  constructor(data) {
    this.data = data;
    this.result = [...data]; // Copy to avoid mutation
  }

  where(predicate) {
    this.result = this.result.filter(predicate);
    return this;
  }

  orderBy(key, direction = 'asc') {
    this.result.sort((a, b) => {
      if (direction === 'asc') {
        return a[key] > b[key] ? 1 : -1;
      } else {
        return a[key] < b[key] ? 1 : -1;
      }
    });
    return this;
  }

  select(keys) {
    this.result = this.result.map((item) => {
      const selected = {};
      keys.forEach((key) => (selected[key] = item[key]));
      return selected;
    });
    return this;
  }

  limit(count) {
    this.result = this.result.slice(0, count);
    return this;
  }

  execute() {
    return this.result; // Terminal method
  }
}

const users = [
  { name: 'John', age: 30, salary: 50000 },
  { name: 'Jane', age: 25, salary: 60000 },
  { name: 'Bob', age: 35, salary: 45000 },
  { name: 'Alice', age: 28, salary: 70000 },
];

const result = new QueryBuilder(users)
  .where((user) => user.age > 25)
  .orderBy('salary', 'desc')
  .select(['name', 'salary'])
  .limit(2)
  .execute();

console.log(result);
// [{ name: 'Alice', salary: 70000 }, { name: 'Jane', salary: 60000 }]
```

## Coding Challenges

### Challenge 1: Car Constructor Function

```javascript
const Car = function (make, speed) {
  this.make = make;
  this.speed = speed;
};

Car.prototype.accelerate = function () {
  this.speed += 10;
  console.log(`${this.make} is going at ${this.speed} km/h`);
};

Car.prototype.brake = function () {
  this.speed -= 5;
  console.log(`${this.make} is going at ${this.speed} km/h`);
};

const bmw = new Car('BMW', 120);
const mercedes = new Car('Mercedes', 95);

bmw.accelerate(); // BMW is going at 130 km/h
bmw.accelerate(); // BMW is going at 140 km/h
bmw.brake(); // BMW is going at 135 km/h
```

### Challenge 2: Car with ES6 Classes

```javascript
class CarCl {
  constructor(make, speed) {
    this.make = make;
    this.speed = speed;
  }

  accelerate() {
    this.speed += 10;
    console.log(`${this.make} is going at ${this.speed} km/h`);
  }

  brake() {
    this.speed -= 5;
    console.log(`${this.make} is going at ${this.speed} km/h`);
  }

  get speedUS() {
    return this.speed / 1.6;
  }

  set speedUS(speed) {
    this.speed = speed * 1.6;
  }
}

const ford = new CarCl('Ford', 120);
console.log(ford.speedUS); // 75
ford.accelerate(); // Ford is going at 130 km/h
ford.speedUS = 50;
console.log(ford.speed); // 80
```

### Challenge 3: Electric Car Inheritance

```javascript
const Car = function (make, speed) {
  this.make = make;
  this.speed = speed;
};

Car.prototype.accelerate = function () {
  this.speed += 10;
  console.log(`${this.make} is going at ${this.speed} km/h`);
};

Car.prototype.brake = function () {
  this.speed -= 5;
  console.log(`${this.make} is going at ${this.speed} km/h`);
};

const EV = function (make, speed, charge) {
  Car.call(this, make, speed);
  this.charge = charge;
};

// Link prototypes
EV.prototype = Object.create(Car.prototype);

EV.prototype.chargeBattery = function (chargeTo) {
  this.charge = chargeTo;
};

// Override accelerate method (polymorphism)
EV.prototype.accelerate = function () {
  this.speed += 20;
  this.charge--;
  console.log(
    `${this.make} is going at ${this.speed} km/h, with a charge of ${this.charge}%`
  );
};

const tesla = new EV('Tesla', 120, 23);
tesla.chargeBattery(90);
tesla.brake(); // Tesla is going at 115 km/h
tesla.accelerate(); // Tesla is going at 135 km/h, with a charge of 89%
```

### Challenge 4: ES6 Classes with Private Fields

```javascript
class CarCl {
  constructor(make, speed) {
    this.make = make;
    this.speed = speed;
  }

  accelerate() {
    this.speed += 10;
    console.log(`${this.make} is going at ${this.speed} km/h`);
    return this;
  }

  brake() {
    this.speed -= 5;
    console.log(`${this.make} is going at ${this.speed} km/h`);
    return this;
  }

  get speedUS() {
    return this.speed / 1.6;
  }

  set speedUS(speed) {
    this.speed = speed * 1.6;
  }
}

class EVCl extends CarCl {
  #charge;

  constructor(make, speed, charge) {
    super(make, speed);
    this.#charge = charge;
  }

  chargeBattery(chargeTo) {
    this.#charge = chargeTo;
    return this;
  }

  accelerate() {
    this.speed += 20;
    this.#charge--;
    console.log(
      `${this.make} is going at ${this.speed} km/h, with a charge of ${
        this.#charge
      }%`
    );
    return this;
  }
}

const rivian = new EVCl('Rivian', 120, 23);

// Method chaining
rivian
  .accelerate() // Rivian is going at 140 km/h, with a charge of 22%
  .accelerate() // Rivian is going at 160 km/h, with a charge of 21%
  .brake() // Rivian is going at 155 km/h
  .chargeBattery(50)
  .accelerate(); // Rivian is going at 175 km/h, with a charge of 49%
```

## Summary: When to Use Which OOP Pattern

### Constructor Functions vs Classes vs Object.create

**Constructor Functions:**

- **Use when**: Working with older codebases, need maximum compatibility
- **Pros**: Works everywhere, clear separation of prototype
- **Cons**: More verbose, easy to forget `new` operator

**ES6 Classes:**

- **Use when**: Modern projects, team prefers class syntax
- **Pros**: Clean syntax, familiar to developers from other languages
- **Cons**: Just syntactic sugar, some features still experimental

**Object.create:**

- **Use when**: Need fine control over prototype chain
- **Pros**: Direct prototype manipulation, no constructor needed
- **Cons**: Less common, can be confusing for team members

### Key Takeaways

- All three approaches achieve the same goal: prototypal inheritance
- ES6 classes are just syntactic sugar over constructor functions
- Private fields and methods provide true encapsulation
- Method chaining creates fluent, readable APIs
- Choose the approach that fits your project and team best
