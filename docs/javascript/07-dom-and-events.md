# Section 7: JavaScript in the Browser - DOM and Events

## Key Concepts

- **Document Object Model (DOM)**

  - Tree-like representation of HTML document
  - JavaScript can read, change, and manipulate HTML elements
  - Each HTML element is a DOM node
  - DOM is not part of JavaScript language, it's a Web API

- **Selecting Elements**

  - `document.querySelector()`: Select first matching element
  - `document.querySelectorAll()`: Select all matching elements
  - `document.getElementById()`: Select by ID
  - `document.getElementsByClassName()`: Select by class name
  - `document.getElementsByTagName()`: Select by tag name

- **Manipulating Elements**

  - `textContent`: Get/set text content
  - `innerHTML`: Get/set HTML content
  - `value`: Get/set input values
  - `style`: Modify CSS styles
  - `classList`: Add/remove/toggle CSS classes
  - `setAttribute()`: Set HTML attributes

- **Events and Event Handling**
  - Events: Actions that happen on the webpage
  - Event listeners: Functions that respond to events
  - Common events: click, keydown, load, submit, mouseover
  - `addEventListener()`: Modern way to handle events
  - Event object: Contains information about the event

## Code Patterns

### DOM Selection and Manipulation

```js
// Selecting elements
const message = document.querySelector('.message');
const score = document.querySelector('.score');
const number = document.querySelector('.number');
const guess = document.querySelector('.guess');
const checkBtn = document.querySelector('.check');

// Reading content
console.log(message.textContent); // Get text content
console.log(guess.value); // Get input value

// Modifying content
message.textContent = 'Correct Number!';
score.textContent = 20;
number.textContent = 13;

// Modifying styles
message.style.color = '#60b347';
number.style.width = '30rem';
document.querySelector('body').style.backgroundColor = '#60b347';

// Working with CSS classes
message.classList.add('success');
message.classList.remove('error');
message.classList.toggle('highlight');
message.classList.contains('success'); // returns boolean
```

### Event Handling

```js
// Basic event listener
document.querySelector('.check').addEventListener('click', function () {
  const guess = Number(document.querySelector('.guess').value);
  console.log(guess, typeof guess);

  if (!guess) {
    document.querySelector('.message').textContent = 'No number!';
  }
});

// Event listener with named function
function handleCheck() {
  const guess = Number(document.querySelector('.guess').value);

  if (!guess) {
    document.querySelector('.message').textContent = 'No number!';
  } else if (guess === secretNumber) {
    document.querySelector('.message').textContent = 'Correct Number!';
  } else if (guess > secretNumber) {
    document.querySelector('.message').textContent = 'Too high!';
  } else if (guess < secretNumber) {
    document.querySelector('.message').textContent = 'Too low!';
  }
}

document.querySelector('.check').addEventListener('click', handleCheck);

// Keyboard events
document.addEventListener('keydown', function (event) {
  console.log(event.key); // Which key was pressed

  if (event.key === 'Escape') {
    // Handle escape key
    closeModal();
  }
});

// Multiple event listeners
const btnAgain = document.querySelector('.again');
btnAgain.addEventListener('click', function () {
  // Reset game logic
  score = 20;
  secretNumber = Math.trunc(Math.random() * 20) + 1;

  document.querySelector('.message').textContent = 'Start guessing...';
  document.querySelector('.score').textContent = score;
  document.querySelector('.number').textContent = '?';
  document.querySelector('.guess').value = '';

  // Reset styles
  document.querySelector('body').style.backgroundColor = '#222';
  document.querySelector('.number').style.width = '15rem';
});
```

### Complete Game Example: Number Guessing Game

```js
// Game state
let secretNumber = Math.trunc(Math.random() * 20) + 1;
let score = 20;
let highscore = 0;

// Helper function for displaying messages
const displayMessage = function (message) {
  document.querySelector('.message').textContent = message;
};

// Check button event listener
document.querySelector('.check').addEventListener('click', function () {
  const guess = Number(document.querySelector('.guess').value);

  // When there is no input
  if (!guess) {
    displayMessage('⛔ No number!');

    // When player wins
  } else if (guess === secretNumber) {
    displayMessage('🎉 Correct Number!');
    document.querySelector('.number').textContent = secretNumber;

    document.querySelector('body').style.backgroundColor = '#60b347';
    document.querySelector('.number').style.width = '30rem';

    if (score > highscore) {
      highscore = score;
      document.querySelector('.highscore').textContent = highscore;
    }

    // When guess is wrong
  } else if (guess !== secretNumber) {
    if (score > 1) {
      displayMessage(guess > secretNumber ? '📈 Too high!' : '📉 Too low!');
      score--;
      document.querySelector('.score').textContent = score;
    } else {
      displayMessage('💥 You lost the game!');
      document.querySelector('.score').textContent = 0;
    }
  }
});

// Again button event listener
document.querySelector('.again').addEventListener('click', function () {
  score = 20;
  secretNumber = Math.trunc(Math.random() * 20) + 1;

  displayMessage('Start guessing...');
  document.querySelector('.score').textContent = score;
  document.querySelector('.number').textContent = '?';
  document.querySelector('.guess').value = '';

  document.querySelector('body').style.backgroundColor = '#222';
  document.querySelector('.number').style.width = '15rem';
});
```

### Modal Window Implementation

```js
// Select elements
const modal = document.querySelector('.modal');
const overlay = document.querySelector('.overlay');
const btnCloseModal = document.querySelector('.close-modal');
const btnsOpenModal = document.querySelectorAll('.show-modal');

// Functions
const openModal = function () {
  modal.classList.remove('hidden');
  overlay.classList.remove('hidden');
};

const closeModal = function () {
  modal.classList.add('hidden');
  overlay.classList.add('hidden');
};

// Event listeners for opening modal
for (let i = 0; i < btnsOpenModal.length; i++) {
  btnsOpenModal[i].addEventListener('click', openModal);
}

// Event listeners for closing modal
btnCloseModal.addEventListener('click', closeModal);
overlay.addEventListener('click', closeModal);

// Close modal with Escape key
document.addEventListener('keydown', function (event) {
  if (event.key === 'Escape' && !modal.classList.contains('hidden')) {
    closeModal();
  }
});
```

### Pig Game Implementation (Dice Game)

```js
// Game elements
const player0El = document.querySelector('.player--0');
const player1El = document.querySelector('.player--1');
const score0El = document.querySelector('#score--0');
const score1El = document.querySelector('#score--1');
const current0El = document.querySelector('#current--0');
const current1El = document.querySelector('#current--1');

const diceEl = document.querySelector('.dice');
const btnNew = document.querySelector('.btn--new');
const btnRoll = document.querySelector('.btn--roll');
const btnHold = document.querySelector('.btn--hold');

// Game state
let scores, currentScore, activePlayer, playing;

// Initialize game
const init = function () {
  scores = [0, 0];
  currentScore = 0;
  activePlayer = 0;
  playing = true;

  score0El.textContent = 0;
  score1El.textContent = 0;
  current0El.textContent = 0;
  current1El.textContent = 0;

  diceEl.classList.add('hidden');
  player0El.classList.remove('player--winner');
  player1El.classList.remove('player--winner');
  player0El.classList.add('player--active');
  player1El.classList.remove('player--active');
};

// Switch player function
const switchPlayer = function () {
  document.querySelector(`#current--${activePlayer}`).textContent = 0;
  currentScore = 0;
  activePlayer = activePlayer === 0 ? 1 : 0;
  player0El.classList.toggle('player--active');
  player1El.classList.toggle('player--active');
};

// Roll dice functionality
btnRoll.addEventListener('click', function () {
  if (playing) {
    // Generate random dice roll
    const dice = Math.trunc(Math.random() * 6) + 1;

    // Display dice
    diceEl.classList.remove('hidden');
    diceEl.src = `dice-${dice}.png`;

    // Check for rolled 1
    if (dice !== 1) {
      // Add dice to current score
      currentScore += dice;
      document.querySelector(`#current--${activePlayer}`).textContent =
        currentScore;
    } else {
      // Switch to next player
      switchPlayer();
    }
  }
});

// Hold functionality
btnHold.addEventListener('click', function () {
  if (playing) {
    // Add current score to active player's score
    scores[activePlayer] += currentScore;
    document.querySelector(`#score--${activePlayer}`).textContent =
      scores[activePlayer];

    // Check if player's score is >= 100
    if (scores[activePlayer] >= 100) {
      // Finish the game
      playing = false;
      diceEl.classList.add('hidden');

      document
        .querySelector(`.player--${activePlayer}`)
        .classList.add('player--winner');
      document
        .querySelector(`.player--${activePlayer}`)
        .classList.remove('player--active');
    } else {
      // Switch to the next player
      switchPlayer();
    }
  }
});

// New game functionality
btnNew.addEventListener('click', init);

// Initialize game on page load
init();
```

## DOM Manipulation Best Practices

### Performance Considerations

```js
// Cache DOM selections
const scoreElement = document.querySelector('.score');
const messageElement = document.querySelector('.message');

// Batch DOM updates
function updateGameState(score, message, isWinner) {
  scoreElement.textContent = score;
  messageElement.textContent = message;

  if (isWinner) {
    document.body.classList.add('winner');
  }
}

// Use DocumentFragment for multiple elements
const fragment = document.createDocumentFragment();
for (let i = 0; i < 100; i++) {
  const li = document.createElement('li');
  li.textContent = `Item ${i}`;
  fragment.appendChild(li);
}
document.querySelector('ul').appendChild(fragment);
```

### Event Delegation

```js
// Instead of adding listeners to each button
document
  .querySelector('.button-container')
  .addEventListener('click', function (e) {
    if (e.target.classList.contains('btn')) {
      // Handle button click
      console.log('Button clicked:', e.target.textContent);
    }
  });
```

## Key Takeaways

1. **DOM manipulation is powerful** but should be used thoughtfully
2. **Cache DOM selections** to improve performance
3. **Use event delegation** for dynamic content
4. **Separate logic from DOM manipulation** for cleaner code
5. **Always check if elements exist** before manipulating them
6. **Use semantic HTML** to make DOM selection easier

---

_Master DOM manipulation to build interactive web applications! 🎮_
