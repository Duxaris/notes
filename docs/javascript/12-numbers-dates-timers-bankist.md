# Section 12: Numbers, Dates, Timers and Bankist

## Section Overview

This section enhances the Bankist application with:

1. **Converting and Checking Numbers** - Number parsing, validation, and type checking
2. **Math and Rounding** - Mathematical operations and precision control
3. **The Remainder Operator** - Modulo operations and practical applications
4. **Numeric Separators** - Improving number readability with underscores
5. **Working with BigInt** - Handling very large integers
6. **Creating Dates** - Date object construction and manipulation
7. **Operations with Dates** - Date calculations and comparisons
8. **Internationalizing Dates (Intl)** - Locale-specific date formatting
9. **Internationalizing Numbers (Intl)** - Currency and number formatting
10. **Timers: setTimeout and setInterval** - Asynchronous timing functions

## Enhanced Bankist App Features

### New Data Structure

The enhanced Bankist app includes:

```javascript
const account1 = {
  owner: 'Jonas Schmedtmann',
  movements: [200, 455.23, -306.5, 25000, -642.21, -133.9, 79.97, 1300],
  interestRate: 1.2,
  pin: 1111,

  // NEW: Movement dates for each transaction
  movementsDates: [
    '2019-11-18T21:31:17.178Z',
    '2019-12-23T07:42:02.383Z',
    '2020-01-28T09:15:04.904Z',
    '2020-04-01T10:17:24.185Z',
    '2020-05-08T14:11:59.604Z',
    '2020-07-26T17:01:17.194Z',
    '2020-07-28T23:36:17.929Z',
    '2020-08-01T10:51:36.790Z',
  ],

  // NEW: Currency and locale for internationalization
  currency: 'EUR',
  locale: 'pt-PT',
};
```

### Key Enhancements

- **Date Display**: Show relative dates (Today, Yesterday, X days ago)
- **Currency Formatting**: Format numbers according to locale and currency
- **Logout Timer**: Automatic logout after inactivity
- **Loan Processing**: Simulate delay with setTimeout
- **Current Date/Time**: Display current date and time on login

## Converting and Checking Numbers

### Type Conversion and Coercion

```javascript
// Numbers in JavaScript are always floating point
console.log(23 === 23.0); // true

// JavaScript uses binary base (0,1), which can cause precision issues
console.log(0.1 + 0.2); // 0.30000000000000004
console.log(0.1 + 0.2 === 0.3); // false

// Number conversion methods
console.log(Number('23')); // 23
console.log(+'23'); // 23 (shorter conversion)

// Parsing integers and floats
console.log(Number.parseInt('30px', 10)); // 30 (radix 10)
console.log(Number.parseInt('e23', 10)); // NaN

console.log(Number.parseFloat('2.5rem')); // 2.5
console.log(Number.parseInt('2.5rem')); // 2

// Global functions (not recommended)
// console.log(parseFloat('2.5rem')); // Works but use Number.parseFloat
```

### Number Validation Methods

```javascript
// Check for NaN (Not a Number)
console.log(Number.isNaN(20)); // false
console.log(Number.isNaN('20')); // false
console.log(Number.isNaN(+'20X')); // true
console.log(Number.isNaN(23 / 0)); // false (Infinity is not NaN)

// Check if value is a finite number (BEST method for validation)
console.log(Number.isFinite(20)); // true
console.log(Number.isFinite('20')); // false
console.log(Number.isFinite(+'20X')); // false
console.log(Number.isFinite(23 / 0)); // false

// Check if value is integer
console.log(Number.isInteger(23)); // true
console.log(Number.isInteger(23.0)); // true
console.log(Number.isInteger(23.5)); // false
console.log(Number.isInteger(23 / 0)); // false
```

### Practical Input Validation

```javascript
// Validate user input for transfers
const validateAmount = (input) => {
  const amount = +input;
  return Number.isFinite(amount) && amount > 0;
};

// Enhanced loan button with validation
btnLoan.addEventListener('click', function (e) {
  e.preventDefault();
  const amount = Math.floor(inputLoanAmount.value); // Remove decimals

  if (
    amount > 0 &&
    currentAccount.movements.some((mov) => mov >= amount * 0.1)
  ) {
    // Simulate loan processing delay
    setTimeout(function () {
      currentAccount.movements.push(amount);
      currentAccount.movementsDates.push(new Date().toISOString());
      updateUI(currentAccount);
    }, 2500);
  }
  inputLoanAmount.value = '';
});
```

## Math and Rounding

### Basic Math Operations

```javascript
// Square root
console.log(Math.sqrt(25)); // 5
console.log(25 ** (1 / 2)); // 5 (alternative)
console.log(8 ** (1 / 3)); // 2 (cube root)

// Max and Min
console.log(Math.max(5, 18, 23, 11, 2)); // 23
console.log(Math.max(5, 18, '23', 11, 2)); // 23 (coercion works)
console.log(Math.max(5, 18, '23px', 11, 2)); // NaN (parsing fails)

console.log(Math.min(5, 18, 23, 11, 2)); // 2

// Constants
console.log(Math.PI); // 3.141592653589793

// Calculate area of circle
const radius = Number.parseFloat('10px');
const area = Math.PI * radius ** 2;
console.log(area); // 314.1592653589793
```

### Random Numbers

```javascript
// Basic random number (0 to 1)
console.log(Math.random());

// Random integer between 1 and 6 (dice roll)
console.log(Math.trunc(Math.random() * 6) + 1);

// Generic random integer function
const randomInt = (min, max) =>
  Math.floor(Math.random() * (max - min + 1)) + min;

console.log(randomInt(10, 20)); // Random between 10-20
console.log(randomInt(0, 3)); // Random between 0-3

// Use cases
const generateTransactionId = () => randomInt(100000, 999999);
const simulateNetworkDelay = () => randomInt(1000, 3000);
```

### Rounding Methods

```javascript
// Rounding integers
console.log(Math.round(23.3)); // 23
console.log(Math.round(23.9)); // 24

console.log(Math.ceil(23.3)); // 24 (always rounds up)
console.log(Math.ceil(23.9)); // 24

console.log(Math.floor(23.3)); // 23 (always rounds down)
console.log(Math.floor(23.9)); // 23

console.log(Math.trunc(23.3)); // 23 (removes decimal part)

// Difference with negative numbers
console.log(Math.trunc(-23.3)); // -23
console.log(Math.floor(-23.3)); // -24 (floor goes to more negative)

// Rounding decimals (returns string!)
console.log((2.7).toFixed(0)); // '3'
console.log((2.7).toFixed(3)); // '2.700'
console.log((2.345).toFixed(2)); // '2.35'
console.log(+(2.345).toFixed(2)); // 2.35 (convert back to number)
```

### Practical Banking Applications

```javascript
// Round currency to 2 decimal places
const formatCurrency = (value) => +(Math.round(value * 100) / 100).toFixed(2);

// Calculate interest with proper rounding
const calcInterest = (deposit, rate) => {
  const interest = (deposit * rate) / 100;
  return Math.round(interest * 100) / 100; // Round to cents
};

// Loan amount validation (round down to prevent over-lending)
const validateLoanAmount = (amount) => Math.floor(amount);
```

## The Remainder Operator (%)

### Basic Remainder Operations

```javascript
console.log(5 % 2); // 1 (5 = 2 * 2 + 1)
console.log(8 % 3); // 2 (8 = 2 * 3 + 2)
console.log(6 % 2); // 0 (6 = 3 * 2 + 0)

// Check if number is even or odd
const isEven = (n) => n % 2 === 0;
const isOdd = (n) => n % 2 === 1;

console.log(isEven(8)); // true
console.log(isOdd(23)); // true
console.log(isEven(514)); // true
```

### Practical Applications

```javascript
// Color every nth row (zebra striping)
labelBalance.addEventListener('click', function () {
  [...document.querySelectorAll('.movements__row')].forEach(function (row, i) {
    // Color every 2nd row
    if (i % 2 === 0) row.style.backgroundColor = 'orangered';

    // Color every 3rd row
    if (i % 3 === 0) row.style.backgroundColor = 'blue';
  });
});

// Pagination logic
const itemsPerPage = 10;
const getPageNumber = (itemIndex) => Math.floor(itemIndex / itemsPerPage) + 1;
const isFirstItemOnPage = (itemIndex) => itemIndex % itemsPerPage === 0;

// Progress indicators
const getProgressPercentage = (current, total) =>
  Math.round((current / total) * 100);

// Time calculations
const formatTime = (seconds) => {
  const mins = Math.floor(seconds / 60);
  const secs = seconds % 60;
  return `${mins}:${secs.toString().padStart(2, '0')}`;
};

// Batch processing
const processBatch = (items, batchSize) => {
  return items.filter((item, index) => index % batchSize === 0);
};
```

## Numeric Separators

### Improving Number Readability

```javascript
// Large numbers with underscores for readability
const diameter = 287_460_000_000; // 287,460,000,000
console.log(diameter); // 287460000000

const price = 345_99; // $345.99
const transferFee1 = 15_00; // $15.00
const transferFee2 = 1_500; // $1,500

// Scientific notation alternative
const earthRadius = 6_371_000; // 6,371 km
const lightSpeed = 299_792_458; // 299,792,458 m/s

// PI with separators (not recommended for decimals)
const PI = 3.1415; // Better than 3.14_15

// Rules for numeric separators
// ✅ Can use in integers and decimals
// ✅ Can use multiple underscores
// ❌ Cannot start or end with underscore
// ❌ Cannot have consecutive underscores
// ❌ Cannot use in strings

console.log(Number('230_000')); // NaN
console.log(parseInt('230_000')); // 230
```

### Best Practices

```javascript
// Financial calculations
const annualSalary = 85_000;
const monthlyPayment = 1_200_50;
const bigDeal = 1_000_000;

// Configuration values
const maxFileSize = 50_000_000; // 50MB
const cacheTimeout = 300_000; // 5 minutes in ms
const maxRetries = 3_000;

// Avoid in these cases
const phoneNumber = '555_123_4567'; // Use string
const version = '2_1_0'; // Use string
const decimal = 3.14_15; // Confusing, avoid
```

## Working with BigInt

### When to Use BigInt

```javascript
// JavaScript's safe integer limit
console.log(Number.MAX_SAFE_INTEGER); // 9007199254740991
console.log(2 ** 53 - 1); // 9007199254740991

// Beyond safe limit, precision is lost
console.log(2 ** 53 + 1); // 9007199254740992
console.log(2 ** 53 + 2); // 9007199254740994 (should be ...93)
console.log(2 ** 53 + 3); // 9007199254740996 (should be ...94)

// BigInt for very large integers
console.log(4838430248342043823408394839483204n);
console.log(BigInt(48384302)); // Convert to BigInt
```

### BigInt Operations

```javascript
// Basic operations
console.log(10000n + 10000n); // 20000n
console.log(36286372637263726376237263726372632n * 10000000n);

// Cannot mix BigInt with regular numbers
const huge = 20289830237283728378237n;
const num = 23;
console.log(huge * BigInt(num)); // Must convert

// Math functions don't work with BigInt
// console.log(Math.sqrt(16n)); // TypeError

// Comparisons work
console.log(20n > 15); // true
console.log(20n === 20); // false (different types)
console.log(20n == '20'); // true (coercion)
console.log(typeof 20n); // "bigint"

// String concatenation
console.log(huge + ' is REALLY big!!!');

// Division truncates decimals
console.log(11n / 3n); // 3n (not 3.666...)
console.log(10 / 3); // 3.3333333333333335
```

### Practical BigInt Usage

```javascript
// Cryptocurrency calculations (wei, satoshi)
const weiPerEther = 1_000_000_000_000_000_000n;
const calculateWei = (ether) => BigInt(ether) * weiPerEther;

// Large database IDs
const generateLargeId = () =>
  BigInt(Date.now()) * 1000000n + BigInt(Math.floor(Math.random() * 1000000));

// Scientific calculations
const avogadroNumber = 602_214_076_000_000_000_000_000n;
const calculateMolecules = (moles) => BigInt(moles) * avogadroNumber;

// Financial calculations requiring extreme precision
const microDollar = 1_000_000n; // $1 = 1,000,000 micro-dollars
const preciseCurrency = (dollars) => BigInt(Math.round(dollars * 1000000));
```

## Creating Dates

### Date Construction Methods

```javascript
// Current date and time
const now = new Date();
console.log(now);

// Parse date strings
console.log(new Date('Aug 02 2020 18:05:41'));
console.log(new Date('December 24, 2015'));
console.log(new Date('2020-06-19T14:30:00.000Z')); // ISO string

// Constructor with parameters (month is 0-indexed!)
console.log(new Date(2037, 10, 19, 15, 23, 5)); // Nov 19, 2037
console.log(new Date(2037, 10, 31)); // Nov 31 becomes Dec 1

// Unix timestamp (milliseconds since Jan 1, 1970)
console.log(new Date(0)); // Jan 1, 1970
console.log(new Date(3 * 24 * 60 * 60 * 1000)); // 3 days later
```

### Working with Date Components

```javascript
const future = new Date(2037, 10, 19, 15, 23);

// Getters
console.log(future.getFullYear()); // 2037
console.log(future.getMonth()); // 10 (November, 0-indexed)
console.log(future.getDate()); // 19 (day of month)
console.log(future.getDay()); // 4 (day of week, 0=Sunday)
console.log(future.getHours()); // 15
console.log(future.getMinutes()); // 23
console.log(future.getSeconds()); // 0

// ISO string and timestamp
console.log(future.toISOString()); // '2037-11-19T21:23:00.000Z'
console.log(future.getTime()); // 2142256980000 (timestamp)

// Create date from timestamp
console.log(new Date(2142256980000));

// Current timestamp
console.log(Date.now());

// Setters
future.setFullYear(2040);
console.log(future); // Year changed to 2040
```

### Enhanced Bankist Date Display

```javascript
const formatMovementDate = function (date, locale) {
  const calcDaysPassed = (date1, date2) =>
    Math.round(Math.abs(date2 - date1) / (1000 * 60 * 60 * 24));

  const daysPassed = calcDaysPassed(new Date(), date);

  if (daysPassed === 0) return 'Today';
  if (daysPassed === 1) return 'Yesterday';
  if (daysPassed <= 7) return `${daysPassed} days ago`;

  return new Intl.DateTimeFormat(locale).format(date);
};

// Usage in displayMovements
const displayDate = formatMovementDate(new Date(movementDate), acc.locale);
```

## Operations with Dates

### Date Arithmetic

```javascript
const future = new Date(2037, 10, 19, 15, 23);

// Convert to timestamp for calculations
console.log(+future); // 2142256980000

// Calculate days between dates
const calcDaysPassed = (date1, date2) =>
  Math.abs(date2 - date1) / (1000 * 60 * 60 * 24);

const days1 = calcDaysPassed(new Date(2037, 3, 4), new Date(2037, 3, 14));
console.log(days1); // 10

// More date calculations
const calcHoursPassed = (date1, date2) =>
  Math.abs(date2 - date1) / (1000 * 60 * 60);

const calcMinutesPassed = (date1, date2) =>
  Math.abs(date2 - date1) / (1000 * 60);

// Add/subtract time
const addDays = (date, days) => {
  const result = new Date(date);
  result.setDate(result.getDate() + days);
  return result;
};

const addWeeks = (date, weeks) => addDays(date, weeks * 7);
const addMonths = (date, months) => {
  const result = new Date(date);
  result.setMonth(result.getMonth() + months);
  return result;
};
```

### Practical Date Operations

```javascript
// Transaction date handling in Bankist
btnTransfer.addEventListener('click', function (e) {
  e.preventDefault();
  // ... validation logic

  if (/* valid transfer */) {
    // Add movements
    currentAccount.movements.push(-amount);
    receiverAcc.movements.push(amount);

    // Add current date to both accounts
    const now = new Date().toISOString();
    currentAccount.movementsDates.push(now);
    receiverAcc.movementsDates.push(now);

    updateUI(currentAccount);
  }
});

// Age calculation
const calcAge = (birthDate) => {
  const today = new Date();
  const birth = new Date(birthDate);
  let age = today.getFullYear() - birth.getFullYear();

  if (today.getMonth() < birth.getMonth() ||
      (today.getMonth() === birth.getMonth() && today.getDate() < birth.getDate())) {
    age--;
  }

  return age;
};

// Business day calculations
const isWeekend = (date) => {
  const day = date.getDay();
  return day === 0 || day === 6; // Sunday or Saturday
};

const addBusinessDays = (date, days) => {
  const result = new Date(date);
  let addedDays = 0;

  while (addedDays < days) {
    result.setDate(result.getDate() + 1);
    if (!isWeekend(result)) {
      addedDays++;
    }
  }

  return result;
};
```

## Internationalizing Dates (Intl)

### Basic Date Formatting

```javascript
const now = new Date();

// Different locales
console.log(new Intl.DateTimeFormat('en-US').format(now));
console.log(new Intl.DateTimeFormat('en-GB').format(now));
console.log(new Intl.DateTimeFormat('ar-SY').format(now));
console.log(new Intl.DateTimeFormat('pt-PT').format(now));

// Auto-detect user's locale
const userLocale = navigator.language;
console.log(new Intl.DateTimeFormat(userLocale).format(now));
```

### Advanced Date Formatting Options

```javascript
const now = new Date();

const options = {
  hour: 'numeric',
  minute: 'numeric',
  day: 'numeric',
  month: 'numeric', // or 'long', 'short', '2-digit'
  year: 'numeric', // or '2-digit'
  weekday: 'long', // or 'short', 'narrow'
};

console.log(new Intl.DateTimeFormat('en-US', options).format(now));
// "Thursday, 8/5/2025, 10:30 AM"

console.log(new Intl.DateTimeFormat('de-DE', options).format(now));
// "Donnerstag, 5.8.2025, 10:30"

// Different month formats
const monthOptions = {
  year: 'numeric',
  month: 'long',
  day: 'numeric',
};

console.log(new Intl.DateTimeFormat('en-US', monthOptions).format(now));
// "August 5, 2025"

console.log(new Intl.DateTimeFormat('fr-FR', monthOptions).format(now));
// "5 août 2025"
```

### Bankist Login Date Display

```javascript
btnLogin.addEventListener('click', function (e) {
  e.preventDefault();

  if (currentAccount?.pin === +inputLoginPin.value) {
    // Display welcome and current date
    labelWelcome.textContent = `Welcome back, ${
      currentAccount.owner.split(' ')[0]
    }`;
    containerApp.style.opacity = 100;

    // Format current date according to user's locale
    const now = new Date();
    const options = {
      hour: 'numeric',
      minute: 'numeric',
      day: 'numeric',
      month: 'numeric',
      year: 'numeric',
    };

    labelDate.textContent = new Intl.DateTimeFormat(
      currentAccount.locale,
      options
    ).format(now);

    // Clear fields and update UI
    inputLoginUsername.value = inputLoginPin.value = '';
    inputLoginPin.blur();
    updateUI(currentAccount);
  }
});
```

## Internationalizing Numbers (Intl)

### Currency Formatting

```javascript
const num = 3884764.23;

const options = {
  style: 'currency',
  currency: 'EUR',
};

console.log('US:', new Intl.NumberFormat('en-US', options).format(num));
// US: €3,884,764.23

console.log('Germany:', new Intl.NumberFormat('de-DE', options).format(num));
// Germany: 3.884.764,23 €

console.log('Syria:', new Intl.NumberFormat('ar-SY', options).format(num));
// Syria: ٣٬٨٨٤٬٧٦٤٫٢٣ €

// Auto-detect user's locale
console.log(
  navigator.language,
  new Intl.NumberFormat(navigator.language, options).format(num)
);
```

### Different Number Styles

```javascript
const number = 1234567.89;

// Currency
console.log(
  new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
  }).format(number)
); // $1,234,567.89

// Percentage
console.log(
  new Intl.NumberFormat('en-US', {
    style: 'percent',
  }).format(0.85)
); // 85%

// Units
console.log(
  new Intl.NumberFormat('en-US', {
    style: 'unit',
    unit: 'mile-per-hour',
  }).format(65)
); // 65 mph

console.log(
  new Intl.NumberFormat('en-US', {
    style: 'unit',
    unit: 'celsius',
  }).format(23)
); // 23°C

// Decimal precision
console.log(
  new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(1234)
); // $1,234.00
```

### Enhanced Bankist Currency Formatting

```javascript
const formatCur = function (value, locale, currency) {
  return new Intl.NumberFormat(locale, {
    style: 'currency',
    currency: currency,
  }).format(value);
};

// Update display functions to use formatting
const calcDisplayBalance = function (acc) {
  acc.balance = acc.movements.reduce((acc, mov) => acc + mov, 0);
  labelBalance.textContent = formatCur(acc.balance, acc.locale, acc.currency);
};

const calcDisplaySummary = function (acc) {
  const incomes = acc.movements
    .filter((mov) => mov > 0)
    .reduce((acc, mov) => acc + mov, 0);
  labelSumIn.textContent = formatCur(incomes, acc.locale, acc.currency);

  const out = Math.abs(
    acc.movements.filter((mov) => mov < 0).reduce((acc, mov) => acc + mov, 0)
  );
  labelSumOut.textContent = formatCur(out, acc.locale, acc.currency);

  const interest = acc.movements
    .filter((mov) => mov > 0)
    .map((deposit) => (deposit * acc.interestRate) / 100)
    .filter((int) => int >= 1)
    .reduce((acc, int) => acc + int, 0);
  labelSumInterest.textContent = formatCur(interest, acc.locale, acc.currency);
};

// Format movements with currency
const displayMovements = function (acc, sort = false) {
  // ... sorting logic

  combinedMovsDates.forEach(function (obj, i) {
    const { movement, movementDate } = obj;
    const type = movement > 0 ? 'deposit' : 'withdrawal';

    const date = new Date(movementDate);
    const displayDate = formatMovementDate(date, acc.locale);
    const formattedMov = formatCur(movement, acc.locale, acc.currency);

    const html = `
      <div class="movements__row">
        <div class="movements__type movements__type--${type}">
          ${i + 1} ${type}
        </div>
        <div class="movements__date">${displayDate}</div>
        <div class="movements__value">${formattedMov}</div>
      </div>
    `;

    containerMovements.insertAdjacentHTML('afterbegin', html);
  });
};
```

## Timers: setTimeout and setInterval

### setTimeout - Delayed Execution

```javascript
// Basic setTimeout
setTimeout(() => console.log('Here is your pizza 🍕'), 3000);
console.log('Waiting...'); // Executes immediately

// setTimeout with parameters
const ingredients = ['olives', 'spinach'];
const pizzaTimer = setTimeout(
  (ing1, ing2) => console.log(`Here is your pizza with ${ing1} and ${ing2} 🍕`),
  3000,
  ...ingredients
);

// Cancel timeout
if (ingredients.includes('spinach')) {
  clearTimeout(pizzaTimer);
  console.log('Order cancelled!');
}

// Practical examples
const delayedExecution = (callback, delay, ...args) => {
  return setTimeout(callback, delay, ...args);
};

const showNotification = (message, type = 'info') => {
  console.log(`[${type.toUpperCase()}] ${message}`);
};

// Schedule notification
delayedExecution(showNotification, 5000, 'Loan approved!', 'success');
```

### setInterval - Repeated Execution

```javascript
// Basic setInterval
const clockTimer = setInterval(() => {
  const now = new Date();
  console.log(now.toLocaleTimeString());
}, 1000);

// Stop interval after 10 seconds
setTimeout(() => {
  clearInterval(clockTimer);
  console.log('Clock stopped');
}, 10000);

// Practical countdown timer
const createCountdown = (duration, callback) => {
  let timeLeft = duration;

  const timer = setInterval(() => {
    const minutes = Math.floor(timeLeft / 60);
    const seconds = timeLeft % 60;

    console.log(`${minutes}:${seconds.toString().padStart(2, '0')}`);

    if (timeLeft === 0) {
      clearInterval(timer);
      callback && callback();
    }

    timeLeft--;
  }, 1000);

  return timer;
};

// Usage
createCountdown(10, () => console.log("Time's up!"));
```

### Bankist Logout Timer

```javascript
const startLogOutTimer = function () {
  const tick = function () {
    const min = String(Math.trunc(time / 60)).padStart(2, 0);
    const sec = String(time % 60).padStart(2, 0);

    // Display remaining time
    labelTimer.textContent = `${min}:${sec}`;

    // Check if time expired
    if (time === 0) {
      clearInterval(timer);
      labelWelcome.textContent = 'Log in to get started';
      containerApp.style.opacity = 0;
    }

    // Decrease time
    time--;
  };

  // Set initial time (5 minutes)
  let time = 300;

  // Start immediately and then every second
  tick();
  const timer = setInterval(tick, 1000);

  return timer;
};

// Usage in event handlers
let currentAccount, timer;

btnLogin.addEventListener('click', function (e) {
  e.preventDefault();

  if (currentAccount?.pin === +inputLoginPin.value) {
    // ... login logic

    // Start/restart timer
    if (timer) clearInterval(timer);
    timer = startLogOutTimer();

    updateUI(currentAccount);
  }
});

// Reset timer on user activity
btnTransfer.addEventListener('click', function (e) {
  // ... transfer logic

  if (/* valid transfer */) {
    // Reset timer on activity
    clearInterval(timer);
    timer = startLogOutTimer();
  }
});
```

### Advanced Timer Patterns

```javascript
// Debounced function execution
const debounce = (func, delay) => {
  let timeoutId;
  return function (...args) {
    clearTimeout(timeoutId);
    timeoutId = setTimeout(() => func.apply(this, args), delay);
  };
};

// Throttled function execution
const throttle = (func, delay) => {
  let lastCall = 0;
  return function (...args) {
    const now = Date.now();
    if (now - lastCall >= delay) {
      lastCall = now;
      func.apply(this, args);
    }
  };
};

// Retry mechanism with exponential backoff
const retry = async (fn, maxAttempts = 3, baseDelay = 1000) => {
  for (let attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      return await fn();
    } catch (error) {
      if (attempt === maxAttempts) throw error;

      const delay = baseDelay * Math.pow(2, attempt - 1);
      await new Promise((resolve) => setTimeout(resolve, delay));
    }
  }
};

// Animation timer
const animate = (duration, callback) => {
  const start = Date.now();

  const timer = setInterval(() => {
    const elapsed = Date.now() - start;
    const progress = Math.min(elapsed / duration, 1);

    callback(progress);

    if (progress === 1) {
      clearInterval(timer);
    }
  }, 16); // ~60fps

  return timer;
};

// Usage
animate(2000, (progress) => {
  const opacity = progress;
  document.body.style.opacity = opacity;
});
```

## Complete Enhanced Bankist Implementation

### Full Integration Example

```javascript
// Complete enhanced displayMovements function
const displayMovements = function (acc, sort = false) {
  containerMovements.innerHTML = '';

  // Combine movements with dates for sorting
  const combinedMovsDates = acc.movements.map((mov, i) => ({
    movement: mov,
    movementDate: acc.movementsDates.at(i),
  }));

  // Sort if requested
  if (sort) combinedMovsDates.sort((a, b) => a.movement - b.movement);

  combinedMovsDates.forEach(function (obj, i) {
    const { movement, movementDate } = obj;
    const type = movement > 0 ? 'deposit' : 'withdrawal';

    // Format date
    const date = new Date(movementDate);
    const displayDate = formatMovementDate(date, acc.locale);

    // Format currency
    const formattedMov = formatCur(movement, acc.locale, acc.currency);

    const html = `
      <div class="movements__row">
        <div class="movements__type movements__type--${type}">
          ${i + 1} ${type}
        </div>
        <div class="movements__date">${displayDate}</div>
        <div class="movements__value">${formattedMov}</div>
      </div>
    `;

    containerMovements.insertAdjacentHTML('afterbegin', html);
  });
};
```

This enhanced Bankist application demonstrates practical applications of:

- **Number formatting** for international currency display
- **Date manipulation** for transaction timestamps
- **Timers** for auto-logout functionality
- **Internationalization** for global user support
- **Precise calculations** for financial operations

The combination of these features creates a realistic banking application that handles real-world requirements like localization, security timeouts, and proper financial number formatting.
