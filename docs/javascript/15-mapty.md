# Section 15: Mapty - Map Your Workouts

## Section Overview

This section covers building a complete workout tracking application called "Mapty" using Object-Oriented Programming, the Geolocation API, and external libraries. This project combines everything learned so far in a real-world application.

### What You'll Learn

1. **Project Overview** - Understanding the Mapty application requirements
2. **How to Plan a Web Project** - Project planning methodology and best practices
3. **Using the Geolocation API** - Accessing user's current location
4. **Displaying a Map Using Leaflet Library** - Integrating third-party mapping library
5. **Displaying Map Markers** - Adding interactive markers to the map
6. **Rendering Workout Input Form** - Creating dynamic forms for data entry
7. **Project Architecture** - Structuring code with OOP principles
8. **Refactoring for Project Architecture** - Organizing code into classes
9. **Managing Workout Data: Creating Classes** - Building workout data models
10. **Creating a New Workout** - Implementing workout creation functionality
11. **Rendering Workouts** - Displaying workout data in the UI
12. **Move to Marker On Click** - Implementing map navigation features
13. **Working with localStorage** - Persisting data across browser sessions
14. **Final Considerations** - Performance, error handling, and improvements

## 🎯 Project Architecture Overview

[![Mapty Architecture Final](../assets/images/Mapty-architecture-final.png)](../assets/images/Mapty-architecture-final.png)

**Key Architecture Components:**

- **🔴 App Class** → Main application controller
- **🔵 Workout Classes** → Data models for different workout types
- **🟡 Geolocation API** → Browser API for user location
- **🟢 Leaflet Library** → Third-party mapping library
- **🟠 Local Storage** → Browser storage for data persistence
- **🟪 Event Handlers** → User interaction management

## Project Overview

### What is Mapty?

Mapty is a workout tracking application that allows users to:

- **📍 Track Location** → Use GPS to mark workout locations on a map
- **🏃‍♂️ Log Workouts** → Record running and cycling sessions
- **📊 Store Data** → Save workout history using localStorage
- **🗺️ Interactive Map** → View all workouts on an interactive map
- **📱 Responsive Design** → Works on desktop and mobile devices

### Technologies Used

```javascript
// Core Technologies
- Vanilla JavaScript (ES6+ Classes)
- HTML5 & CSS3
- Geolocation API
- Local Storage API

// External Libraries
- Leaflet.js (Interactive Maps)
- Google Fonts (Typography)
```

## How to Plan a Web Project

### Jonas's Project Planning Framework

1. **📋 User Stories** → Define what users want to accomplish
2. **🎨 Features** → List specific functionalities needed
3. **📱 Flowchart** → Map user interactions and app flow
4. **🏗️ Architecture** → Plan code structure and organization
5. **🚀 Development** → Build features step by step

### 📊 Mapty Application Flowchart

[![Mapty Flowchart](../assets/images/Mapty-flowchart.png)](../assets/images/Mapty-flowchart.png)

**Flowchart Breakdown:**

- **🏁 Start** → User loads the application
- **📍 Get Location** → Request user's geolocation
- **🗺️ Load Map** → Display map centered on user location
- **👆 User Clicks** → User clicks on map to add workout
- **📝 Show Form** → Display workout input form
- **✅ Submit Form** → User fills and submits workout data
- **💾 Store Data** → Save workout to localStorage
- **🏃‍♂️ Display Workout** → Show workout on map and in list
- **🔄 Repeat** → User can add more workouts

### Mapty User Stories

```text
As a user, I want to:
1. Log my running workouts with location, distance, time, pace, cadence
2. Log my cycling workouts with location, distance, time, speed, elevation gain
3. See all my workouts on a map
4. See all my workouts in a list
5. Store my workout data in the browser
6. See my workouts when I return to the app
```

## Using the Geolocation API

### Getting User's Current Position

```javascript
class App {
  constructor() {
    // Get user's position on app load
    this._getPosition();
  }

  _getPosition() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        this._loadMap.bind(this),
        function () {
          alert('Could not get your position');
        }
      );
    }
  }

  _loadMap(position) {
    const { latitude } = position.coords;
    const { longitude } = position.coords;
    console.log(`https://www.google.pt/maps/@${latitude},${longitude}`);

    const coords = [latitude, longitude];
    // Load map with user's coordinates
  }
}
```

### Key Concepts

- **🌍 Geolocation API** → Browser API for accessing location data
- **📍 Position Object** → Contains latitude, longitude, accuracy, etc.
- **🔄 Async Nature** → Geolocation requests are asynchronous
- **🛡️ User Permission** → Requires user consent for location access

## Displaying a Map Using Leaflet Library

### Including Leaflet

```html
<!-- Leaflet CSS -->
<link
  rel="stylesheet"
  href="https://unpkg.com/leaflet@1.6.0/dist/leaflet.css"
/>

<!-- Leaflet JavaScript -->
<script src="https://unpkg.com/leaflet@1.6.0/dist/leaflet.js"></script>
```

### Creating the Map

```javascript
class App {
  #map;
  #mapZoomLevel = 13;

  _loadMap(position) {
    const { latitude } = position.coords;
    const { longitude } = position.coords;
    const coords = [latitude, longitude];

    // Create map and set view
    this.#map = L.map('map').setView(coords, this.#mapZoomLevel);

    // Add tile layer (map appearance)
    L.tileLayer('https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png', {
      attribution:
        '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    }).addTo(this.#map);

    // Handle clicks on map
    this.#map.on('click', this._showForm.bind(this));
  }
}
```

### Understanding Leaflet

- **🗺️ L.map()** → Creates map instance
- **🧩 Tile Layers** → Map imagery from various providers
- **📍 Markers** → Interactive points on the map
- **🎯 Events** → Click, zoom, move handlers

## Displaying Map Markers

### Adding Markers to Map

```javascript
class App {
  #mapEvent;

  _showForm(mapE) {
    this.#mapEvent = mapE;
    form.classList.remove('hidden');
    inputDistance.focus();
  }

  _newWorkout(e) {
    e.preventDefault();

    // Get data from form
    // ... validation logic ...

    // Create marker
    this._renderWorkoutMarker(workout);
  }

  _renderWorkoutMarker(workout) {
    L.marker(workout.coords)
      .addTo(this.#map)
      .bindPopup(
        L.popup({
          maxWidth: 250,
          minWidth: 100,
          autoClose: false,
          closeOnClick: false,
          className: `${workout.type}-popup`,
        })
      )
      .setPopupContent(
        `${workout.type === 'running' ? '🏃‍♂️' : '🚴‍♀️'} ${workout.description}`
      )
      .openPopup();
  }
}
```

## Project Architecture with Classes

### 🏗️ Initial Architecture Planning

[![Mapty Architecture Part 1](../assets/images/Mapty-architecture-part-1.png)](../assets/images/Mapty-architecture-part-1.png)

**Architecture Evolution:**

- **📋 Phase 1** → Basic class structure and inheritance
- **🔄 Phase 2** → Event handling and user interactions  
- **💾 Phase 3** → Data persistence and localStorage
- **🎯 Final** → Complete application with all features

### Workout Base Class

```javascript
class Workout {
  date = new Date();
  id = (Date.now() + '').slice(-10);
  clicks = 0;

  constructor(coords, distance, duration) {
    this.coords = coords; // [lat, lng]
    this.distance = distance; // in km
    this.duration = duration; // in min
  }

  _setDescription() {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    this.description = `${this.type[0].toUpperCase()}${this.type.slice(1)} on ${
      months[this.date.getMonth()]
    } ${this.date.getDate()}`;
  }

  click() {
    this.clicks++;
  }
}
```

### Running Workout Class

```javascript
class Running extends Workout {
  type = 'running';

  constructor(coords, distance, duration, cadence) {
    super(coords, distance, duration);
    this.cadence = cadence;
    this.calcPace();
    this._setDescription();
  }

  calcPace() {
    // min/km
    this.pace = this.duration / this.distance;
    return this.pace;
  }
}
```

### Cycling Workout Class

```javascript
class Cycling extends Workout {
  type = 'cycling';

  constructor(coords, distance, duration, elevationGain) {
    super(coords, distance, duration);
    this.elevationGain = elevationGain;
    this.calcSpeed();
    this._setDescription();
  }

  calcSpeed() {
    // km/h
    this.speed = this.distance / (this.duration / 60);
    return this.speed;
  }
}
```

## Managing Application State

### App Class Structure

```javascript
class App {
  #map;
  #mapZoomLevel = 13;
  #mapEvent;
  #workouts = [];

  constructor() {
    // Get user's position
    this._getPosition();

    // Get data from local storage
    this._getLocalStorage();

    // Attach event handlers
    form.addEventListener('submit', this._newWorkout.bind(this));
    inputType.addEventListener('change', this._toggleElevationField);
    containerWorkouts.addEventListener('click', this._moveToPopup.bind(this));
  }

  // ... methods ...
}

// Initialize app
const app = new App();
```

## Working with localStorage

### Saving Data

```javascript
class App {
  _setLocalStorage() {
    localStorage.setItem('workouts', JSON.stringify(this.#workouts));
  }

  _getLocalStorage() {
    const data = JSON.parse(localStorage.getItem('workouts'));

    if (!data) return;

    this.#workouts = data;
    this.#workouts.forEach((work) => {
      this._renderWorkout(work);
    });
  }
}
```

### localStorage Considerations

- **📦 Storage Limit** → ~5-10MB per domain
- **🔤 String Only** → Must serialize objects to JSON
- **🔄 Persistence** → Data survives browser restarts
- **🚫 No Backup** → Data lost if user clears browser data

## Key Learning Points

### OOP Implementation

1. **📚 Class Inheritance** → Running and Cycling extend Workout
2. **🔒 Private Fields** → Using # for encapsulation
3. **🎯 Method Binding** → Proper `this` context in event handlers
4. **🏗️ Constructor Chaining** → Using `super()` in derived classes

### Real-World Development

1. **📋 Project Planning** → Structured approach to building apps
2. **📚 Third-party APIs** → Integrating external libraries
3. **💾 Data Persistence** → Using browser storage APIs
4. **🎨 User Experience** → Form validation and error handling

### Best Practices

1. **🔄 Event Delegation** → Efficient event handling
2. **🏷️ Data Attributes** → Linking DOM elements to data
3. **🎯 Method Binding** → Proper context management
4. **📝 Code Organization** → Logical class structure

## Potential Improvements

### Feature Enhancements

```javascript
// Ideas for extending the app:
- Edit workouts
- Delete workouts
- Sort workouts by date, distance, duration
- Rebuild objects from localStorage (restore prototype chain)
- Better error handling and user feedback
- Add weather data for workout locations
- Export workouts to external services
```

### Technical Improvements

1. **🏗️ Better Architecture** → Use MVC or similar pattern
2. **📚 Modern APIs** → Use async/await for geolocation
3. **🎨 Enhanced UI** → Better responsive design
4. **🔍 Data Validation** → More robust input validation
5. **🗄️ Better Storage** → Consider IndexedDB for larger datasets

## Summary

The Mapty project demonstrates:

- **🏗️ Real-world Architecture** → How to structure a complete application
- **📚 API Integration** → Using browser and third-party APIs
- **🎯 OOP in Practice** → Practical application of class inheritance
- **💾 Data Management** → Handling user data and persistence
- **🎨 User Experience** → Creating interactive and responsive interfaces

This project serves as a comprehensive example of modern JavaScript development, combining multiple concepts into a cohesive, functional application that users would actually want to use.
