# Section 16: Asynchronous JavaScript

## Table of Contents

1. [Introduction to Asynchronous JavaScript](#introduction-to-asynchronous-javascript)
2. [AJAX and XMLHttpRequest](#ajax-and-xmlhttprequest)
3. [Callback Hell](#callback-hell)
4. [Promises](#promises)
5. [Consuming Promises](#consuming-promises)
6. [Chaining Promises](#chaining-promises)
7. [Error Handling with Promises](#error-handling-with-promises)
8. [The Event Loop](#the-event-loop)
9. [Building Custom Promises](#building-custom-promises)
10. [Promisifying APIs](#promisifying-apis)
11. [Async/Await](#asyncawait)
12. [Error Handling with Async/Await](#error-handling-with-asyncawait)
13. [Running Promises in Parallel](#running-promises-in-parallel)
14. [Promise Combinators](#promise-combinators)
15. [Real-World Examples](#real-world-examples)

---

## Introduction to Asynchronous JavaScript

### What is Asynchronous Programming?

Asynchronous programming allows JavaScript to execute multiple operations simultaneously without blocking the main thread. This is crucial for:

- **API calls** → Fetching data from servers
- **File operations** → Reading/writing files
- **Timers** → setTimeout, setInterval
- **User interactions** → Event handlers
- **Database operations** → Querying databases

### Why is it Important?

JavaScript is **single-threaded**, meaning it can only execute one operation at a time. Without asynchronous programming:

- The UI would freeze during long operations
- Users couldn't interact with the page
- Performance would be terrible

---

## AJAX and XMLHttpRequest

### What is AJAX?

**AJAX** (Asynchronous JavaScript And XML) allows web pages to:

- Update content without reloading the page
- Request data from servers asynchronously
- Send data to servers in the background

### XMLHttpRequest - The Old Way

```javascript
const getCountryData = function (country) {
  const request = new XMLHttpRequest();
  request.open('GET', `https://restcountries.com/v2/name/${country}`);
  request.send();

  request.addEventListener('load', function () {
    const [data] = JSON.parse(this.responseText);
    console.log(data);

    // Render the country data
    const html = `
      <article class="country">
        <img class="country__img" src="${data.flag}" />
        <div class="country__data">
          <h3 class="country__name">${data.name}</h3>
          <h4 class="country__region">${data.region}</h4>
          <p class="country__row"><span>👫</span>${(
            +data.population / 1000000
          ).toFixed(1)} people</p>
          <p class="country__row"><span>🗣️</span>${data.languages[0].name}</p>
          <p class="country__row"><span>💰</span>${data.currencies[0].name}</p>
        </div>
      </article>
    `;
    countriesContainer.insertAdjacentHTML('beforeend', html);
  });
};
```

---

## Callback Hell

### The Problem

When you need to make multiple asynchronous operations that depend on each other, you end up with nested callbacks:

```javascript
const getCountryAndNeighbour = function (country) {
  // AJAX call country 1
  const request = new XMLHttpRequest();
  request.open('GET', `https://restcountries.com/v2/name/${country}`);
  request.send();

  request.addEventListener('load', function () {
    const [data] = JSON.parse(this.responseText);
    renderCountry(data);

    // Get neighbour country (2)
    const [neighbour] = data.borders;
    if (!neighbour) return;

    // AJAX call country 2
    const request2 = new XMLHttpRequest();
    request2.open('GET', `https://restcountries.com/v2/alpha/${neighbour}`);
    request2.send();

    request2.addEventListener('load', function () {
      const data2 = JSON.parse(this.responseText);
      renderCountry(data2, 'neighbour');
    });
  });
};
```

### Timer Callback Hell Example

```javascript
setTimeout(() => {
  console.log('1 second passed');
  setTimeout(() => {
    console.log('2 seconds passed');
    setTimeout(() => {
      console.log('3 seconds passed');
      setTimeout(() => {
        console.log('4 seconds passed');
      }, 1000);
    }, 1000);
  }, 1000);
}, 1000);
```

### Why Callback Hell is Bad

- **Hard to read** → Pyramid of doom
- **Hard to maintain** → Complex nesting
- **Error handling** → Difficult to manage
- **Debugging** → Challenging to trace

---

## Promises

### What are Promises?

A **Promise** is an object representing the eventual completion or failure of an asynchronous operation.

### Promise States

1. **Pending** → Initial state, neither fulfilled nor rejected
2. **Fulfilled** → Operation completed successfully
3. **Rejected** → Operation failed

### Creating Promises

```javascript
const myPromise = new Promise((resolve, reject) => {
  // Asynchronous operation
  if (/* operation successful */) {
    resolve(value); // Success
  } else {
    reject(error); // Failure
  }
});
```

---

## Consuming Promises

### Using .then()

```javascript
const getCountryData = function (country) {
  fetch(`https://restcountries.com/v2/name/${country}`)
    .then(function (response) {
      console.log(response);
      return response.json();
    })
    .then(function (data) {
      console.log(data);
      renderCountry(data[0]);
    });
};
```

### Simplified with Arrow Functions

```javascript
const getCountryData = function (country) {
  fetch(`https://restcountries.com/v2/name/${country}`)
    .then((response) => response.json())
    .then((data) => renderCountry(data[0]));
};
```

---

## Chaining Promises

### Sequential Operations

```javascript
const getCountryData = function (country) {
  // Country 1
  fetch(`https://restcountries.com/v2/name/${country}`)
    .then((response) => response.json())
    .then((data) => {
      renderCountry(data[0]);
      const neighbour = data[0].borders[0];

      if (!neighbour) return;

      // Country 2
      return fetch(`https://restcountries.com/v2/alpha/${neighbour}`);
    })
    .then((response) => response.json())
    .then((data) => renderCountry(data, 'neighbour'));
};
```

### Key Points

- **Always return** promises in `.then()`
- **Chain** instead of nesting
- **Flat structure** instead of pyramid

---

## Error Handling with Promises

### Using .catch()

```javascript
const getCountryData = function (country) {
  fetch(`https://restcountries.com/v2/name/${country}`)
    .then((response) => {
      if (!response.ok) {
        throw new Error(`Country not found (${response.status})`);
      }
      return response.json();
    })
    .then((data) => {
      renderCountry(data[0]);
      const neighbour = data[0].borders[0];

      if (!neighbour) throw new Error('No neighbour found!');

      return fetch(`https://restcountries.com/v2/alpha/${neighbour}`);
    })
    .then((response) => {
      if (!response.ok) {
        throw new Error(`Country not found (${response.status})`);
      }
      return response.json();
    })
    .then((data) => renderCountry(data, 'neighbour'))
    .catch((err) => {
      console.error(`${err} 💥💥💥`);
      renderError(`Something went wrong 💥💥 ${err.message}. Try again!`);
    })
    .finally(() => {
      countriesContainer.style.opacity = 1;
    });
};
```

### Helper Function for Cleaner Code

```javascript
const getJSON = function (url, errorMsg = 'Something went wrong') {
  return fetch(url).then((response) => {
    if (!response.ok) throw new Error(`${errorMsg} (${response.status})`);
    return response.json();
  });
};

const getCountryData = function (country) {
  getJSON(`https://restcountries.com/v2/name/${country}`, 'Country not found')
    .then((data) => {
      renderCountry(data[0]);
      const neighbour = data[0].borders[0];

      if (!neighbour) throw new Error('No neighbour found!');

      return getJSON(
        `https://restcountries.com/v2/alpha/${neighbour}`,
        'Country not found'
      );
    })
    .then((data) => renderCountry(data, 'neighbour'))
    .catch((err) => renderError(`💥 ${err.message}`))
    .finally(() => {
      countriesContainer.style.opacity = 1;
    });
};
```

---

## The Event Loop

### How JavaScript Handles Asynchronous Code

```javascript
console.log('Test start');
setTimeout(() => console.log('0 sec timer'), 0);
Promise.resolve('Resolved promise 1').then((res) => console.log(res));
Promise.resolve('Resolved promise 2').then((res) => {
  for (let i = 0; i < 1000000000; i++) {} // Heavy computation
  console.log(res);
});
console.log('Test end');
```

### Output Order

```text
Test start
Test end
Resolved promise 1
Resolved promise 2
0 sec timer
```

### Key Concepts

- **Call Stack** → Currently executing code
- **Web APIs** → setTimeout, DOM events, etc.
- **Callback Queue** → Regular callbacks
- **Microtask Queue** → Promises (higher priority)
- **Event Loop** → Manages execution order

### Priority Order

1. **Synchronous code** (Call Stack)
2. **Microtasks** (Promises)
3. **Macrotasks** (setTimeout, setInterval)

---

## Building Custom Promises

### Promise Constructor

```javascript
const lotteryPromise = new Promise(function (resolve, reject) {
  console.log('Lottery draw is happening 🔮');
  setTimeout(function () {
    if (Math.random() >= 0.5) {
      resolve('You WIN 💰');
    } else {
      reject(new Error('You lost your money 💩'));
    }
  }, 2000);
});

lotteryPromise
  .then((res) => console.log(res))
  .catch((err) => console.error(err));
```

### Promisifying setTimeout

```javascript
const wait = function (seconds) {
  return new Promise(function (resolve) {
    setTimeout(resolve, seconds * 1000);
  });
};

wait(1)
  .then(() => {
    console.log('1 second passed');
    return wait(1);
  })
  .then(() => {
    console.log('2 seconds passed');
    return wait(1);
  })
  .then(() => {
    console.log('3 seconds passed');
    return wait(1);
  })
  .then(() => console.log('4 seconds passed'));
```

### Immediately Resolved/Rejected Promises

```javascript
Promise.resolve('abc').then((x) => console.log(x));
Promise.reject(new Error('Problem!')).catch((x) => console.error(x));
```

---

## Promisifying APIs

### Geolocation API Example

```javascript
const getPosition = function () {
  return new Promise(function (resolve, reject) {
    navigator.geolocation.getCurrentPosition(resolve, reject);
  });
};

getPosition().then((pos) => console.log(pos));
```

### Using Promisified Geolocation

```javascript
const whereAmI = function () {
  getPosition()
    .then((pos) => {
      const { latitude: lat, longitude: lng } = pos.coords;

      return fetch(
        `https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=${lat}&longitude=${lng}`
      );
    })
    .then((res) => {
      if (!res.ok) throw new Error(`Problem with geocoding ${res.status}`);
      return res.json();
    })
    .then((data) => {
      console.log(`You are in ${data.city}, ${data.countryCode}`);
      return fetch(`https://restcountries.com/v2/name/${data.countryCode}`);
    })
    .then((res) => {
      if (!res.ok) throw new Error(`Country not found (${res.status})`);
      return res.json();
    })
    .then((data) => renderCountry(data[0]))
    .catch((err) => console.error(`${err.message} 💥`));
};
```

---

## Async/Await

### Modern Promise Syntax

```javascript
const whereAmI = async function () {
  try {
    // Geolocation
    const pos = await getPosition();
    const { latitude: lat, longitude: lng } = pos.coords;

    // Reverse geocoding
    const resGeo = await fetch(
      `https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=${lat}&longitude=${lng}`
    );
    if (!resGeo.ok) throw new Error('Problem getting location data');
    const dataGeo = await resGeo.json();

    // Country data
    const res = await fetch(
      `https://restcountries.com/v2/name/${dataGeo.countryCode}`
    );
    if (!res.ok) throw new Error('Problem getting country');
    const data = await res.json();

    renderCountry(data[0]);
    return `You are in ${dataGeo.city}, ${dataGeo.country}`;
  } catch (err) {
    console.error(`${err} 💥`);
    renderError(`💥 ${err.message}`);
    throw err; // Re-throw to reject the promise
  }
};
```

### Key Benefits

- **Cleaner syntax** → Looks like synchronous code
- **Better readability** → Easier to understand
- **Easier debugging** → Better stack traces

---

## Error Handling with Async/Await

### try...catch Blocks

```javascript
const whereAmI = async function () {
  try {
    const pos = await getPosition();
    const { latitude: lat, longitude: lng } = pos.coords;

    const resGeo = await fetch(
      `https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=${lat}&longitude=${lng}`
    );
    if (!resGeo.ok) throw new Error('Problem getting location data');
    const dataGeo = await resGeo.json();

    const res = await fetch(
      `https://restcountries.com/v2/name/${dataGeo.countryCode}`
    );
    if (!res.ok) throw new Error('Problem getting country');
    const data = await res.json();

    renderCountry(data[0]);
  } catch (err) {
    console.error(`${err} 💥`);
    renderError(`💥 ${err.message}`);
  }
};
```

### Returning Values from Async Functions

```javascript
console.log('1: Will get location');

// Method 1: Using .then()
whereAmI()
  .then((city) => console.log(`2: ${city}`))
  .catch((err) => console.error(`2: ${err.message} 💥`))
  .finally(() => console.log('3: Finished getting location'));

// Method 2: Using async IIFE
(async function () {
  try {
    const city = await whereAmI();
    console.log(`2: ${city}`);
  } catch (err) {
    console.error(`2: ${err.message} 💥`);
  }
  console.log('3: Finished getting location');
})();
```

---

## Running Promises in Parallel

### Sequential vs Parallel

```javascript
// ❌ Sequential (slower)
const get3Countries = async function (c1, c2, c3) {
  try {
    const [data1] = await getJSON(`https://restcountries.com/v2/name/${c1}`);
    const [data2] = await getJSON(`https://restcountries.com/v2/name/${c2}`);
    const [data3] = await getJSON(`https://restcountries.com/v2/name/${c3}`);
    console.log([data1.capital, data2.capital, data3.capital]);
  } catch (err) {
    console.error(err);
  }
};

// ✅ Parallel (faster)
const get3Countries = async function (c1, c2, c3) {
  try {
    const data = await Promise.all([
      getJSON(`https://restcountries.com/v2/name/${c1}`),
      getJSON(`https://restcountries.com/v2/name/${c2}`),
      getJSON(`https://restcountries.com/v2/name/${c3}`),
    ]);
    console.log(data.map((d) => d[0].capital));
  } catch (err) {
    console.error(err);
  }
};
```

---

## Promise Combinators

### Promise.all()

Waits for all promises to resolve. If one rejects, the whole thing rejects.

```javascript
const data = await Promise.all([
  getJSON(`https://restcountries.com/v2/name/portugal`),
  getJSON(`https://restcountries.com/v2/name/canada`),
  getJSON(`https://restcountries.com/v2/name/tanzania`),
]);
console.log(data.map((d) => d[0].capital));
```

### Promise.race()

Returns the first promise that settles (either resolves or rejects).

```javascript
(async function () {
  const res = await Promise.race([
    getJSON(`https://restcountries.com/v2/name/italy`),
    getJSON(`https://restcountries.com/v2/name/egypt`),
    getJSON(`https://restcountries.com/v2/name/mexico`),
  ]);
  console.log(res[0]);
})();
```

### Timeout Implementation

```javascript
const timeout = function (sec) {
  return new Promise(function (_, reject) {
    setTimeout(function () {
      reject(new Error('Request took too long!'));
    }, sec * 1000);
  });
};

Promise.race([
  getJSON(`https://restcountries.com/v2/name/tanzania`),
  timeout(5),
])
  .then((res) => console.log(res[0]))
  .catch((err) => console.error(err));
```

### Promise.allSettled()

Waits for all promises to settle (resolve or reject).

```javascript
Promise.allSettled([
  Promise.resolve('Success'),
  Promise.reject('ERROR'),
  Promise.resolve('Another success'),
]).then((res) => console.log(res));

// Output:
// [
//   { status: 'fulfilled', value: 'Success' },
//   { status: 'rejected', reason: 'ERROR' },
//   { status: 'fulfilled', value: 'Another success' }
// ]
```

### Promise.any() [ES2021]

Returns the first fulfilled promise, ignoring rejected ones.

```javascript
Promise.any([
  Promise.resolve('Success'),
  Promise.reject('ERROR'),
  Promise.resolve('Another success'),
])
  .then((res) => console.log(res)) // 'Success'
  .catch((err) => console.error(err));
```

---

## Real-World Examples

### Image Loading with Promises

```javascript
const createImage = function (imgPath) {
  return new Promise(function (resolve, reject) {
    const img = document.createElement('img');
    img.src = imgPath;

    img.addEventListener('load', function () {
      imgContainer.append(img);
      resolve(img);
    });

    img.addEventListener('error', function () {
      reject(new Error('Image not found'));
    });
  });
};

// Using Promises
let currentImg;
createImage('img/img-1.jpg')
  .then((img) => {
    currentImg = img;
    console.log('Image 1 loaded');
    return wait(2);
  })
  .then(() => {
    currentImg.style.display = 'none';
    return createImage('img/img-2.jpg');
  })
  .then((img) => {
    currentImg = img;
    console.log('Image 2 loaded');
    return wait(2);
  })
  .then(() => {
    currentImg.style.display = 'none';
  })
  .catch((err) => console.error(err));
```

### Image Loading with Async/Await

```javascript
const loadNPause = async function () {
  try {
    // Load image 1
    let img = await createImage('img/img-1.jpg');
    console.log('Image 1 loaded');
    await wait(2);
    img.style.display = 'none';

    // Load image 2
    img = await createImage('img/img-2.jpg');
    console.log('Image 2 loaded');
    await wait(2);
    img.style.display = 'none';
  } catch (err) {
    console.error(err);
  }
};
```

### Loading Multiple Images in Parallel

```javascript
const loadAll = async function (imgArr) {
  try {
    const imgs = imgArr.map(async (img) => await createImage(img));
    const imgsEl = await Promise.all(imgs);
    console.log(imgsEl);
    imgsEl.forEach((img) => img.classList.add('parallel'));
  } catch (err) {
    console.error(err);
  }
};

loadAll(['img/img-1.jpg', 'img/img-2.jpg', 'img/img-3.jpg']);
```

---

## Summary

### Core Concepts

1. **Asynchronous Programming** → Non-blocking code execution
2. **Promises** → Objects representing eventual completion/failure
3. **Async/Await** → Modern syntax for handling promises
4. **Error Handling** → try...catch and .catch()
5. **Promise Combinators** → all(), race(), allSettled(), any()
6. **Event Loop** → How JavaScript manages asynchronous operations

### Best Practices

- **Use async/await** for cleaner code
- **Handle errors** properly with try...catch
- **Run independent operations** in parallel
- **Use Promise combinators** for complex scenarios
- **Promisify callback-based APIs** when needed
- **Always handle rejections** to avoid unhandled promise rejections

### Evolution of Asynchronous JavaScript

1. **Callbacks** → Original method (callback hell)
2. **Promises** → Better error handling and chaining
3. **Async/Await** → Synchronous-looking asynchronous code

### When to Use What

- **Promises** → When you need complex chaining or combinators
- **Async/Await** → For most cases (cleaner and more readable)
- **Callbacks** → Avoid for new code (only for legacy APIs)
