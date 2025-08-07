# Section 13: Advanced DOM and Events

## Section Overview

This section covers advanced DOM manipulation and event handling while building the Bankist marketing website. Topics include:

1. **Selecting, Creating, and Deleting Elements** - DOM element manipulation
2. **Styles, Attributes, and Classes** - Programmatic styling and attribute management
3. **Implementing Smooth Scrolling** - Modern scrolling techniques
4. **Types of Events and Event Handlers** - Different ways to handle events
5. **Event Propagation** - Bubbling, capturing, and event delegation
6. **DOM Traversing** - Moving through the DOM tree
7. **Lifecycle DOM Events** - Page loading and unloading events
8. **Intersection Observer API** - Efficient scroll-based animations
9. **Lazy Loading Images** - Performance optimization technique
10. **Building a Tabbed Component** - Interactive UI components
11. **Building a Slider Component** - Touch and keyboard navigation

## Project: Bankist Marketing Website

The Bankist marketing website demonstrates modern web development techniques with:

- **Modal windows** for account opening
- **Smooth scrolling navigation** between sections
- **Tabbed interface** for banking operations
- **Image lazy loading** for performance
- **Intersection Observer** for scroll animations
- **Sticky navigation** that appears on scroll
- **Interactive slider** with dots navigation
- **Hover effects** with fade animations

## Selecting, Creating, and Deleting Elements

### Selecting Elements

```javascript
// Document elements
console.log(document.documentElement); // <html>
console.log(document.head); // <head>
console.log(document.body); // <body>

// Single elements
const header = document.querySelector('.header');
const section1 = document.getElementById('section--1');

// Multiple elements
const allSections = document.querySelectorAll('.section');
const allButtons = document.getElementsByTagName('button'); // HTMLCollection (live)
const allBtnClass = document.getElementsByClassName('btn'); // HTMLCollection (live)

console.log(allSections); // NodeList (static)
console.log(allButtons); // HTMLCollection (updates automatically)
```

### Creating and Inserting Elements

```javascript
// Create new element
const message = document.createElement('div');
message.classList.add('cookie-message');
message.innerHTML = `
  We use cookies for improved functionality and analytics. 
  <button class="btn btn--close-cookie">Got it!</button>
`;

// Insert methods
const header = document.querySelector('.header');

header.prepend(message); // Add as first child
header.append(message); // Add as last child
header.append(message.cloneNode(true)); // Clone and append

header.before(message); // Add before element
header.after(message); // Add after element

// Element can only exist in one place, so it moves when inserted again
```

### insertAdjacentHTML Method

The `insertAdjacentHTML()` method is a powerful alternative for inserting HTML content at specific positions relative to an element:

```javascript
const header = document.querySelector('.header');

// Four position options:
// 'beforebegin' - Before the element itself
// 'afterbegin'  - Just inside the element, before its first child
// 'beforeend'   - Just inside the element, after its last child
// 'afterend'    - After the element itself

header.insertAdjacentHTML('beforebegin', '<div>Before header</div>');
header.insertAdjacentHTML('afterbegin', '<div>Start of header</div>');
header.insertAdjacentHTML('beforeend', '<div>End of header</div>');
header.insertAdjacentHTML('afterend', '<div>After header</div>');

// Practical example: Adding notifications
const addNotification = (message, type = 'info') => {
  const notification = `
    <div class="notification notification--${type}">
      <span>${message}</span>
      <button class="notification__close">&times;</button>
    </div>
  `;

  document.body.insertAdjacentHTML('afterbegin', notification);

  // Auto-remove after 3 seconds
  setTimeout(() => {
    document.querySelector('.notification').remove();
  }, 3000);
};

// Usage
addNotification('Account created successfully!', 'success');
addNotification('Please check your email', 'warning');
```

**Advantages of insertAdjacentHTML:**

- More performant than innerHTML for adding content
- Doesn't destroy existing event listeners
- Precise positioning control
- Cleaner syntax for complex HTML insertion

### When to Use Which HTML Insertion Method

| Method                   | Use Case                      | Performance             | Event Listeners       | Position Control         |
| ------------------------ | ----------------------------- | ----------------------- | --------------------- | ------------------------ |
| `innerHTML`              | Replace all content           | ⚠️ Slow (re-parses all) | ❌ Destroys existing  | ❌ Limited               |
| `insertAdjacentHTML`     | Add HTML at specific position | ✅ Fast                 | ✅ Preserves existing | ✅ Precise (4 positions) |
| `createElement + append` | Create single elements        | ✅ Fast                 | ✅ Preserves existing | ✅ Good                  |
| `textContent`            | Add plain text only           | ✅ Very fast            | ✅ Preserves existing | ❌ Limited               |
| `appendChild`            | Move existing elements        | ✅ Fast                 | ✅ Preserves existing | ✅ Good                  |

**Quick Decision Guide:**

- **Need to add HTML at specific position?** → Use `insertAdjacentHTML`
- **Replacing all content?** → Use `innerHTML` (but consider performance)
- **Adding plain text only?** → Use `textContent`
- **Creating complex elements programmatically?** → Use `createElement`
- **Moving existing elements?** → Use `appendChild` or `append`

### Deleting Elements

```javascript
// Modern way
document
  .querySelector('.btn--close-cookie')
  .addEventListener('click', function () {
    message.remove();
  });

// Old way (DOM traversing)
document
  .querySelector('.btn--close-cookie')
  .addEventListener('click', function () {
    message.parentElement.removeChild(message);
  });
```

### Practical Example: Cookie Banner

```javascript
const createCookieBanner = function () {
  const message = document.createElement('div');
  message.classList.add('cookie-message');
  message.innerHTML = `
    We use cookies for improved functionality and analytics. 
    <button class="btn btn--close-cookie">Got it!</button>
  `;

  document.body.append(message);

  // Add close functionality
  document
    .querySelector('.btn--close-cookie')
    .addEventListener('click', () => message.remove());
};

// Usage
createCookieBanner();
```

## Styles, Attributes, and Classes

### Styling Elements

```javascript
const message = document.querySelector('.cookie-message');

// Inline styles
message.style.backgroundColor = '#37383d';
message.style.width = '120%';

// Reading styles (only works for inline styles)
console.log(message.style.backgroundColor); // rgb(55, 56, 61)
console.log(message.style.color); // '' (empty - not set inline)

// Get computed styles
console.log(getComputedStyle(message).color);
console.log(getComputedStyle(message).height);

// Modify computed style
message.style.height =
  Number.parseFloat(getComputedStyle(message).height) + 30 + 'px';

// CSS custom properties (CSS variables)
document.documentElement.style.setProperty('--color-primary', 'orangered');
```

### Working with Attributes

```javascript
const logo = document.querySelector('.nav__logo');

// Standard attributes
console.log(logo.alt); // Get alt attribute
console.log(logo.src); // Absolute URL
console.log(logo.className); // Class attribute

logo.alt = 'Beautiful minimalist logo'; // Set attribute

// Non-standard attributes
console.log(logo.designer); // undefined
console.log(logo.getAttribute('designer')); // Custom attribute value
logo.setAttribute('company', 'Bankist');

// Relative vs absolute URLs
console.log(logo.src); // http://127.0.0.1:8080/img/logo.png
console.log(logo.getAttribute('src')); // img/logo.png

// Data attributes
// HTML: <img data-version-number="3.0">
console.log(logo.dataset.versionNumber); // 3.0 (camelCase conversion)
```

### Managing Classes

```javascript
const logo = document.querySelector('.nav__logo');

// Multiple class operations
logo.classList.add('nav__logo--special', 'highlight');
logo.classList.remove('nav__logo--special', 'highlight');
logo.classList.toggle('hidden');
logo.classList.contains('nav__logo'); // true (not 'includes')

// Don't use (overwrites all classes)
// logo.className = 'nav__logo';
```

### Practical Styling Example

```javascript
const themeToggle = function () {
  const toggleBtn = document.querySelector('.theme-toggle');
  const body = document.body;

  toggleBtn.addEventListener('click', function () {
    body.classList.toggle('dark-theme');

    // Update button text
    const isDark = body.classList.contains('dark-theme');
    this.textContent = isDark ? '☀️ Light' : '🌙 Dark';

    // Save preference
    localStorage.setItem('theme', isDark ? 'dark' : 'light');
  });

  // Load saved theme
  const savedTheme = localStorage.getItem('theme');
  if (savedTheme === 'dark') {
    body.classList.add('dark-theme');
    toggleBtn.textContent = '☀️ Light';
  }
};
```

## Implementing Smooth Scrolling

### Modern Smooth Scrolling

```javascript
const btnScrollTo = document.querySelector('.btn--scroll-to');
const section1 = document.querySelector('#section--1');

btnScrollTo.addEventListener('click', function (e) {
  // Get coordinates
  const s1coords = section1.getBoundingClientRect();
  console.log(s1coords);
  console.log('Current scroll (X/Y)', window.pageXOffset, window.pageYOffset);

  // Modern way (best approach)
  section1.scrollIntoView({ behavior: 'smooth' });
});
```

### Old School Scrolling Methods

```javascript
btnScrollTo.addEventListener('click', function (e) {
  const s1coords = section1.getBoundingClientRect();

  // Old way 1: window.scrollTo()
  window.scrollTo(
    s1coords.left + window.pageXOffset,
    s1coords.top + window.pageYOffset
  );

  // Old way 2: window.scrollTo() with options
  window.scrollTo({
    left: s1coords.left + window.pageXOffset,
    top: s1coords.top + window.pageYOffset,
    behavior: 'smooth',
  });
});
```

### Page Navigation with Event Delegation

```javascript
// Inefficient approach (attaches listener to each link)
// document.querySelectorAll('.nav__link').forEach(function (el) {
//   el.addEventListener('click', function (e) {
//     e.preventDefault();
//     const id = this.getAttribute('href');
//     document.querySelector(id).scrollIntoView({ behavior: 'smooth' });
//   });
// });

// Efficient approach using event delegation
document.querySelector('.nav__links').addEventListener('click', function (e) {
  e.preventDefault();

  // Matching strategy
  if (e.target.classList.contains('nav__link')) {
    const id = e.target.getAttribute('href');
    document.querySelector(id).scrollIntoView({ behavior: 'smooth' });
  }
});
```

### Advanced Scroll Utilities

```javascript
const scrollUtils = {
  // Get current scroll position
  getScrollPosition() {
    return {
      x: window.pageXOffset,
      y: window.pageYOffset,
    };
  },

  // Get element position relative to viewport
  getElementPosition(element) {
    return element.getBoundingClientRect();
  },

  // Check if element is in viewport
  isInViewport(element, threshold = 0) {
    const rect = element.getBoundingClientRect();
    const windowHeight =
      window.innerHeight || document.documentElement.clientHeight;
    const windowWidth =
      window.innerWidth || document.documentElement.clientWidth;

    return (
      rect.top >= -threshold &&
      rect.left >= -threshold &&
      rect.bottom <= windowHeight + threshold &&
      rect.right <= windowWidth + threshold
    );
  },

  // Smooth scroll to any position
  scrollToPosition(x, y, behavior = 'smooth') {
    window.scrollTo({ left: x, top: y, behavior });
  },

  // Scroll to top of page
  scrollToTop() {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  },
};
```

## Types of Events and Event Handlers

### Event Listener Methods

```javascript
const h1 = document.querySelector('h1');

// Modern approach (preferred)
const alertH1 = function (e) {
  alert('addEventListener: Great! You are reading the heading :D');
};

h1.addEventListener('mouseenter', alertH1);

// Remove event listener
setTimeout(() => h1.removeEventListener('mouseenter', alertH1), 3000);

// Old school approach
h1.onmouseenter = function (e) {
  alert('onmouseenter: Great! You are reading the heading :D');
};
```

### Event Object Properties

```javascript
document.addEventListener('click', function (e) {
  console.log('Event type:', e.type); // 'click'
  console.log('Target element:', e.target); // Element that triggered event
  console.log('Current target:', e.currentTarget); // Element with event listener
  console.log('Event phase:', e.eventPhase); // 1=capturing, 2=target, 3=bubbling
  console.log('Mouse position:', e.clientX, e.clientY);
  console.log('Key pressed:', e.key); // For keyboard events
  console.log('Modifier keys:', e.ctrlKey, e.altKey, e.shiftKey);
});
```

### Common Event Types

```javascript
const element = document.querySelector('.interactive');

// Mouse events
element.addEventListener('click', handleClick);
element.addEventListener('dblclick', handleDoubleClick);
element.addEventListener('mousedown', handleMouseDown);
element.addEventListener('mouseup', handleMouseUp);
element.addEventListener('mouseover', handleMouseOver);
element.addEventListener('mouseout', handleMouseOut);
element.addEventListener('mousemove', handleMouseMove);

// Keyboard events
document.addEventListener('keydown', handleKeyDown);
document.addEventListener('keyup', handleKeyUp);
document.addEventListener('keypress', handleKeyPress);

// Form events
const form = document.querySelector('form');
form.addEventListener('submit', handleSubmit);
form.addEventListener('change', handleChange);
form.addEventListener('input', handleInput);
form.addEventListener('focus', handleFocus);
form.addEventListener('blur', handleBlur);

// Window events
window.addEventListener('load', handleLoad);
window.addEventListener('resize', handleResize);
window.addEventListener('scroll', handleScroll);
```

## Event Propagation

### Understanding Event Flow

```javascript
// Event propagation demonstration
const randomInt = (min, max) =>
  Math.floor(Math.random() * (max - min + 1) + min);
const randomColor = () =>
  `rgb(${randomInt(0, 255)},${randomInt(0, 255)},${randomInt(0, 255)})`;

// Child element
document.querySelector('.nav__link').addEventListener('click', function (e) {
  this.style.backgroundColor = randomColor();
  console.log('LINK', e.target, e.currentTarget);
  console.log('currentTarget === this:', e.currentTarget === this);

  // Stop propagation (prevents bubbling)
  // e.stopPropagation();
});

// Parent element
document.querySelector('.nav__links').addEventListener('click', function (e) {
  this.style.backgroundColor = randomColor();
  console.log('CONTAINER', e.target, e.currentTarget);
});

// Grandparent element
document.querySelector('.nav').addEventListener('click', function (e) {
  this.style.backgroundColor = randomColor();
  console.log('NAV', e.target, e.currentTarget);
});

// Capturing phase (third parameter = true)
document.querySelector('.nav').addEventListener(
  'click',
  function (e) {
    console.log('NAV - CAPTURING', e.target, e.currentTarget);
  },
  true
);
```

### Event Delegation Pattern

```javascript
// Efficient event handling for dynamic content
const todoList = document.querySelector('.todo-list');

todoList.addEventListener('click', function (e) {
  // Delete button clicked
  if (e.target.classList.contains('delete-btn')) {
    e.target.closest('.todo-item').remove();
  }

  // Complete button clicked
  if (e.target.classList.contains('complete-btn')) {
    e.target.closest('.todo-item').classList.toggle('completed');
  }

  // Edit button clicked
  if (e.target.classList.contains('edit-btn')) {
    const todoItem = e.target.closest('.todo-item');
    const textElement = todoItem.querySelector('.todo-text');
    const currentText = textElement.textContent;

    const input = document.createElement('input');
    input.value = currentText;
    input.classList.add('edit-input');

    textElement.replaceWith(input);
    input.focus();

    input.addEventListener('blur', () => {
      textElement.textContent = input.value;
      input.replaceWith(textElement);
    });
  }
});
```

## DOM Traversing

### Moving Through the DOM Tree

```javascript
const h1 = document.querySelector('h1');

// Going downwards: children
console.log(h1.querySelectorAll('.highlight')); // All descendants with class
console.log(h1.childNodes); // All child nodes (including text)
console.log(h1.children); // Only element children (HTMLCollection)

h1.firstElementChild.style.color = 'white';
h1.lastElementChild.style.color = 'orangered';

// Going upwards: parents
console.log(h1.parentNode); // Direct parent node
console.log(h1.parentElement); // Direct parent element

// Find closest ancestor with class
h1.closest('.header').style.background = 'var(--gradient-secondary)';
h1.closest('h1').style.background = 'var(--gradient-primary)'; // Self

// Going sideways: siblings
console.log(h1.previousElementSibling);
console.log(h1.nextElementSibling);

console.log(h1.previousSibling); // Including text nodes
console.log(h1.nextSibling);

// Get all siblings
console.log(h1.parentElement.children);
[...h1.parentElement.children].forEach(function (el) {
  if (el !== h1) el.style.transform = 'scale(0.5)';
});
```

### Practical DOM Traversing

```javascript
const domUtils = {
  // Find all siblings of an element
  getSiblings(element) {
    return [...element.parentElement.children].filter(
      (child) => child !== element
    );
  },

  // Find next sibling with specific class
  getNextSiblingByClass(element, className) {
    let sibling = element.nextElementSibling;
    while (sibling) {
      if (sibling.classList.contains(className)) return sibling;
      sibling = sibling.nextElementSibling;
    }
    return null;
  },

  // Find all ancestors with specific selector
  getAncestors(element, selector) {
    const ancestors = [];
    let parent = element.parentElement;

    while (parent) {
      if (!selector || parent.matches(selector)) {
        ancestors.push(parent);
      }
      parent = parent.parentElement;
    }

    return ancestors;
  },

  // Get element depth in DOM
  getDepth(element) {
    let depth = 0;
    let parent = element.parentElement;

    while (parent) {
      depth++;
      parent = parent.parentElement;
    }

    return depth;
  },
};
```

## Intersection Observer API

### Basic Intersection Observer

```javascript
// Callback function
const obsCallback = function (entries, observer) {
  entries.forEach((entry) => {
    console.log(entry);
    console.log('Is intersecting:', entry.isIntersecting);
    console.log('Intersection ratio:', entry.intersectionRatio);
  });
};

// Options
const obsOptions = {
  root: null, // viewport
  threshold: [0, 0.2, 0.5, 1], // Multiple thresholds
  rootMargin: '10px', // Margin around root
};

// Create observer
const observer = new IntersectionObserver(obsCallback, obsOptions);
observer.observe(document.querySelector('#section--1'));
```

### Sticky Navigation Implementation

```javascript
const nav = document.querySelector('.nav');
const header = document.querySelector('.header');
const navHeight = nav.getBoundingClientRect().height;

const stickyNav = function (entries) {
  const [entry] = entries;

  if (!entry.isIntersecting) {
    nav.classList.add('sticky');
  } else {
    nav.classList.remove('sticky');
  }
};

const headerObserver = new IntersectionObserver(stickyNav, {
  root: null,
  threshold: 0,
  rootMargin: `-${navHeight}px`, // Start observer navHeight pixels before
});

headerObserver.observe(header);
```

### Reveal Sections on Scroll

```javascript
const allSections = document.querySelectorAll('.section');

const revealSection = function (entries, observer) {
  entries.forEach((entry) => {
    if (!entry.isIntersecting) return;

    entry.target.classList.remove('section--hidden');
    observer.unobserve(entry.target); // Stop observing after reveal
  });
};

const sectionObserver = new IntersectionObserver(revealSection, {
  root: null,
  threshold: 0.15, // Reveal when 15% visible
});

// Observe all sections and hide them initially
allSections.forEach(function (section) {
  sectionObserver.observe(section);
  section.classList.add('section--hidden');
});
```

## Lazy Loading Images

### Implementing Lazy Loading

```javascript
const imgTargets = document.querySelectorAll('img[data-src]');

const loadImg = function (entries, observer) {
  const [entry] = entries;

  if (!entry.isIntersecting) return;

  // Replace src with data-src
  entry.target.src = entry.target.dataset.src;

  // Remove blur effect after image loads
  entry.target.addEventListener('load', function () {
    entry.target.classList.remove('lazy-img');
  });

  observer.unobserve(entry.target);
};

const imgObserver = new IntersectionObserver(loadImg, {
  root: null,
  threshold: 0,
  rootMargin: '200px', // Load 200px before coming into view
});

imgTargets.forEach((img) => imgObserver.observe(img));
```

### HTML Structure for Lazy Loading

```html
<!-- Low quality placeholder with data-src for high quality -->
<img
  src="img/digital-lazy.jpg"
  data-src="img/digital.jpg"
  alt="Computer"
  class="features__img lazy-img"
/>
```

### CSS for Lazy Loading Effect

```css
.lazy-img {
  filter: blur(20px);
}
```

### Advanced Lazy Loading Utility

```javascript
const lazyLoader = {
  init(selector = 'img[data-src]', options = {}) {
    const defaultOptions = {
      rootMargin: '50px',
      threshold: 0,
      ...options,
    };

    const images = document.querySelectorAll(selector);

    const imageObserver = new IntersectionObserver((entries, observer) => {
      entries.forEach((entry) => {
        if (!entry.isIntersecting) return;

        const img = entry.target;

        // Create new image to preload
        const newImg = new Image();
        newImg.onload = () => {
          img.src = img.dataset.src;
          img.classList.remove('lazy-img');
          img.classList.add('lazy-img-loaded');
        };

        newImg.src = img.dataset.src;
        observer.unobserve(img);
      });
    }, defaultOptions);

    images.forEach((img) => imageObserver.observe(img));
  },
};

// Usage
lazyLoader.init();
```

## Building a Tabbed Component

### Tabbed Component Implementation

```javascript
const tabs = document.querySelectorAll('.operations__tab');
const tabsContainer = document.querySelector('.operations__tab-container');
const tabsContent = document.querySelectorAll('.operations__content');

tabsContainer.addEventListener('click', function (e) {
  const clicked = e.target.closest('.operations__tab');

  // Guard clause
  if (!clicked) return;

  // Remove active classes
  tabs.forEach((t) => t.classList.remove('operations__tab--active'));
  tabsContent.forEach((c) => c.classList.remove('operations__content--active'));

  // Activate tab
  clicked.classList.add('operations__tab--active');

  // Activate content area
  document
    .querySelector(`.operations__content--${clicked.dataset.tab}`)
    .classList.add('operations__content--active');
});
```

### HTML Structure for Tabs

```html
<div class="operations">
  <div class="operations__tab-container">
    <button
      class="btn operations__tab operations__tab--1 operations__tab--active"
      data-tab="1"
    >
      <span>01</span>Instant Transfers
    </button>
    <button class="btn operations__tab operations__tab--2" data-tab="2">
      <span>02</span>Instant Loans
    </button>
    <button class="btn operations__tab operations__tab--3" data-tab="3">
      <span>03</span>Instant Closing
    </button>
  </div>

  <div
    class="operations__content operations__content--1 operations__content--active"
  >
    <div class="operations__icon operations__icon--1">
      <svg><use xlink:href="img/icons.svg#icon-upload"></use></svg>
    </div>
    <h5 class="operations__header">Transfer money instantly</h5>
    <p>Content for tab 1...</p>
  </div>

  <div class="operations__content operations__content--2">
    <div class="operations__icon operations__icon--2">
      <svg><use xlink:href="img/icons.svg#icon-home"></use></svg>
    </div>
    <h5 class="operations__header">Instant loans</h5>
    <p>Content for tab 2...</p>
  </div>
</div>
```

### Reusable Tab Component

```javascript
class TabComponent {
  constructor(container) {
    this.container = container;
    this.tabs = container.querySelectorAll('[data-tab]');
    this.contents = container.querySelectorAll('[data-content]');
    this.activeClass = 'active';

    this.init();
  }

  init() {
    this.container.addEventListener('click', (e) => {
      const tab = e.target.closest('[data-tab]');
      if (!tab) return;

      this.activateTab(tab.dataset.tab);
    });

    // Activate first tab by default
    if (this.tabs.length > 0) {
      this.activateTab(this.tabs[0].dataset.tab);
    }
  }

  activateTab(tabId) {
    // Remove active classes
    this.tabs.forEach((tab) => tab.classList.remove(this.activeClass));
    this.contents.forEach((content) =>
      content.classList.remove(this.activeClass)
    );

    // Add active classes
    const activeTab = this.container.querySelector(`[data-tab="${tabId}"]`);
    const activeContent = this.container.querySelector(
      `[data-content="${tabId}"]`
    );

    if (activeTab) activeTab.classList.add(this.activeClass);
    if (activeContent) activeContent.classList.add(this.activeClass);
  }
}

// Usage
const tabContainer = document.querySelector('.operations');
new TabComponent(tabContainer);
```

## Building a Slider Component

### Complete Slider Implementation

```javascript
const slider = function () {
  const slides = document.querySelectorAll('.slide');
  const btnLeft = document.querySelector('.slider__btn--left');
  const btnRight = document.querySelector('.slider__btn--right');
  const dotContainer = document.querySelector('.dots');

  let curSlide = 0;
  const maxSlide = slides.length;

  // Functions
  const createDots = function () {
    slides.forEach(function (_, i) {
      dotContainer.insertAdjacentHTML(
        'beforeend',
        `<button class="dots__dot" data-slide="${i}"></button>`
      );
    });
  };

  const activateDot = function (slide) {
    document
      .querySelectorAll('.dots__dot')
      .forEach((dot) => dot.classList.remove('dots__dot--active'));

    document
      .querySelector(`.dots__dot[data-slide="${slide}"]`)
      .classList.add('dots__dot--active');
  };

  const goToSlide = function (slide) {
    slides.forEach(
      (s, i) => (s.style.transform = `translateX(${100 * (i - slide)}%)`)
    );
  };

  // Navigation functions
  const nextSlide = function () {
    if (curSlide === maxSlide - 1) {
      curSlide = 0;
    } else {
      curSlide++;
    }

    goToSlide(curSlide);
    activateDot(curSlide);
  };

  const prevSlide = function () {
    if (curSlide === 0) {
      curSlide = maxSlide - 1;
    } else {
      curSlide--;
    }
    goToSlide(curSlide);
    activateDot(curSlide);
  };

  const init = function () {
    goToSlide(0);
    createDots();
    activateDot(0);
  };

  init();

  // Event handlers
  btnRight.addEventListener('click', nextSlide);
  btnLeft.addEventListener('click', prevSlide);

  // Keyboard navigation
  document.addEventListener('keydown', function (e) {
    if (e.key === 'ArrowLeft') prevSlide();
    e.key === 'ArrowRight' && nextSlide();
  });

  // Dot navigation
  dotContainer.addEventListener('click', function (e) {
    if (e.target.classList.contains('dots__dot')) {
      curSlide = Number(e.target.dataset.slide);
      goToSlide(curSlide);
      activateDot(curSlide);
    }
  });
};

slider();
```

### Enhanced Slider with Touch Support

```javascript
class TouchSlider {
  constructor(container) {
    this.container = container;
    this.slides = container.querySelectorAll('.slide');
    this.currentSlide = 0;
    this.startX = 0;
    this.currentX = 0;
    this.isDragging = false;

    this.init();
  }

  init() {
    this.setupSlides();
    this.attachEventListeners();
  }

  setupSlides() {
    this.slides.forEach((slide, index) => {
      slide.style.transform = `translateX(${index * 100}%)`;
    });
  }

  attachEventListeners() {
    // Touch events
    this.container.addEventListener(
      'touchstart',
      this.handleTouchStart.bind(this)
    );
    this.container.addEventListener(
      'touchmove',
      this.handleTouchMove.bind(this)
    );
    this.container.addEventListener('touchend', this.handleTouchEnd.bind(this));

    // Mouse events for desktop
    this.container.addEventListener(
      'mousedown',
      this.handleMouseDown.bind(this)
    );
    this.container.addEventListener(
      'mousemove',
      this.handleMouseMove.bind(this)
    );
    this.container.addEventListener('mouseup', this.handleMouseUp.bind(this));
  }

  handleTouchStart(e) {
    this.startX = e.touches[0].clientX;
    this.isDragging = true;
  }

  handleTouchMove(e) {
    if (!this.isDragging) return;
    e.preventDefault();
    this.currentX = e.touches[0].clientX;
  }

  handleTouchEnd() {
    if (!this.isDragging) return;
    this.isDragging = false;

    const diffX = this.startX - this.currentX;
    const threshold = 50;

    if (Math.abs(diffX) > threshold) {
      if (diffX > 0) {
        this.nextSlide();
      } else {
        this.prevSlide();
      }
    }
  }

  goToSlide(slideIndex) {
    this.slides.forEach((slide, index) => {
      slide.style.transform = `translateX(${(index - slideIndex) * 100}%)`;
    });
    this.currentSlide = slideIndex;
  }

  nextSlide() {
    const nextIndex =
      this.currentSlide === this.slides.length - 1 ? 0 : this.currentSlide + 1;
    this.goToSlide(nextIndex);
  }

  prevSlide() {
    const prevIndex =
      this.currentSlide === 0 ? this.slides.length - 1 : this.currentSlide - 1;
    this.goToSlide(prevIndex);
  }
}
```

## Menu Fade Animation

### Hover Effects with Opacity

```javascript
const nav = document.querySelector('.nav');

const handleHover = function (e) {
  if (e.target.classList.contains('nav__link')) {
    const link = e.target;
    const siblings = link.closest('.nav').querySelectorAll('.nav__link');
    const logo = link.closest('.nav').querySelector('img');

    siblings.forEach((el) => {
      if (el !== link) el.style.opacity = this;
    });
    logo.style.opacity = this;
  }
};

// Passing "argument" into handler using bind
nav.addEventListener('mouseover', handleHover.bind(0.5));
nav.addEventListener('mouseout', handleHover.bind(1));
```

### Advanced Hover Animation

```javascript
class HoverAnimation {
  constructor(container, options = {}) {
    this.container = container;
    this.options = {
      hoverOpacity: 0.5,
      transitionDuration: '0.3s',
      targetSelector: '.nav__link',
      ...options,
    };

    this.init();
  }

  init() {
    this.container.addEventListener(
      'mouseover',
      this.handleMouseOver.bind(this)
    );
    this.container.addEventListener('mouseout', this.handleMouseOut.bind(this));
  }

  handleMouseOver(e) {
    const target = e.target.closest(this.options.targetSelector);
    if (!target) return;

    const siblings = this.container.querySelectorAll(
      this.options.targetSelector
    );
    const logo = this.container.querySelector('img');

    siblings.forEach((el) => {
      if (el !== target) {
        el.style.opacity = this.options.hoverOpacity;
        el.style.transition = `opacity ${this.options.transitionDuration}`;
      }
    });

    if (logo) {
      logo.style.opacity = this.options.hoverOpacity;
      logo.style.transition = `opacity ${this.options.transitionDuration}`;
    }
  }

  handleMouseOut() {
    const elements = this.container.querySelectorAll(
      this.options.targetSelector
    );
    const logo = this.container.querySelector('img');

    elements.forEach((el) => {
      el.style.opacity = 1;
    });

    if (logo) {
      logo.style.opacity = 1;
    }
  }
}

// Usage
new HoverAnimation(document.querySelector('.nav'));
```

## Lifecycle DOM Events

### Page Loading Events

```javascript
// DOM content loaded (HTML parsed, DOM tree built)
document.addEventListener('DOMContentLoaded', function (e) {
  console.log('HTML parsed and DOM tree built!', e);
  // Safe to manipulate DOM here
});

// All resources loaded (images, stylesheets, scripts)
window.addEventListener('load', function (e) {
  console.log('Page fully loaded', e);
  // All resources including images are loaded
});

// Before page unload (user leaving page)
window.addEventListener('beforeunload', function (e) {
  e.preventDefault();
  console.log(e);
  e.returnValue = ''; // Show confirmation dialog
});
```

### Practical Application

```javascript
const pageLoader = {
  init() {
    this.showLoadingScreen();

    document.addEventListener('DOMContentLoaded', () => {
      this.domReady();
    });

    window.addEventListener('load', () => {
      this.pageFullyLoaded();
    });

    window.addEventListener('beforeunload', (e) => {
      this.beforeUnload(e);
    });
  },

  showLoadingScreen() {
    const loader = document.createElement('div');
    loader.className = 'page-loader';
    loader.innerHTML = '<div class="spinner"></div>';
    document.body.appendChild(loader);
  },

  domReady() {
    console.log('DOM is ready, initializing app...');

    // Initialize app components
    this.initializeComponents();

    // Start animations that depend on DOM
    this.startAnimations();
  },

  pageFullyLoaded() {
    console.log('Page fully loaded, hiding loader...');

    // Hide loading screen
    const loader = document.querySelector('.page-loader');
    if (loader) {
      loader.style.opacity = '0';
      setTimeout(() => loader.remove(), 300);
    }

    // Start heavy operations
    this.loadAnalytics();
  },

  beforeUnload(e) {
    // Check if user has unsaved changes
    const hasUnsavedChanges = this.checkUnsavedChanges();

    if (hasUnsavedChanges) {
      e.preventDefault();
      e.returnValue = '';
    }
  },

  initializeComponents() {
    // Initialize sliders, tabs, modals, etc.
  },

  startAnimations() {
    // Start CSS animations or JavaScript animations
  },

  loadAnalytics() {
    // Load analytics scripts after page is ready
  },

  checkUnsavedChanges() {
    // Check if user has unsaved form data
    return false;
  },
};

pageLoader.init();
```

## Complete Bankist Website Features

### Modal Window Implementation

```javascript
const modal = document.querySelector('.modal');
const overlay = document.querySelector('.overlay');
const btnCloseModal = document.querySelector('.btn--close-modal');
const btnsOpenModal = document.querySelectorAll('.btn--show-modal');

const openModal = function (e) {
  e.preventDefault();
  modal.classList.remove('hidden');
  overlay.classList.remove('hidden');
};

const closeModal = function () {
  modal.classList.add('hidden');
  overlay.classList.add('hidden');
};

// Open modal
btnsOpenModal.forEach((btn) => btn.addEventListener('click', openModal));

// Close modal
btnCloseModal.addEventListener('click', closeModal);
overlay.addEventListener('click', closeModal);

// Close with Escape key
document.addEventListener('keydown', function (e) {
  if (e.key === 'Escape' && !modal.classList.contains('hidden')) {
    closeModal();
  }
});
```

### Complete Website Integration

The Bankist marketing website demonstrates modern web development with:

- **Performance optimization** through lazy loading
- **Smooth user experience** with scroll animations
- **Accessibility** with keyboard navigation
- **Mobile responsiveness** with touch events
- **Modern JavaScript** with event delegation
- **Clean code structure** with modular components

This comprehensive implementation showcases how advanced DOM manipulation and event handling create engaging, performant web applications.
