# sessionTimerUtils.js

A comprehensive set of utilities for managing user sessions, activity tracking, and timer functionality. Perfect for implementing session timeouts, activity monitoring, and auto-logout features.

## Core Timer Class

```javascript
/**
 * SessionTimer - Manages user session timeouts with activity tracking
 */
class SessionTimer {
  constructor(options = {}) {
    this.timeoutDuration = options.timeoutDuration || 30 * 60 * 1000; // 30 minutes default
    this.warningDuration = options.warningDuration || 5 * 60 * 1000;  // 5 minutes default
    this.onWarning = options.onWarning || (() => {});
    this.onTimeout = options.onTimeout || (() => {});
    this.onActivity = options.onActivity || (() => {});
    this.onTick = options.onTick || (() => {});
    
    this.timeoutId = null;
    this.warningId = null;
    this.tickId = null;
    this.lastActivity = Date.now();
    this.isActive = false;
    this.isWarningShown = false;
    
    // Events that constitute user activity
    this.activityEvents = options.activityEvents || [
      'mousedown', 'mousemove', 'keypress', 'scroll', 'touchstart', 'click'
    ];
    
    this.bindMethods();
  }

  bindMethods() {
    this.handleActivity = this.handleActivity.bind(this);
    this.checkSession = this.checkSession.bind(this);
  }

  /**
   * Start monitoring session activity
   */
  start() {
    if (this.isActive) return;
    
    this.isActive = true;
    this.lastActivity = Date.now();
    this.isWarningShown = false;
    
    // Add activity listeners
    this.activityEvents.forEach(event => {
      document.addEventListener(event, this.handleActivity, true);
    });
    
    // Start the session check timer
    this.scheduleNext();
    
    // Optional: Start tick timer for countdown displays
    if (this.onTick) {
      this.startTicking();
    }
  }

  /**
   * Stop monitoring session activity
   */
  stop() {
    if (!this.isActive) return;
    
    this.isActive = false;
    
    // Remove activity listeners
    this.activityEvents.forEach(event => {
      document.removeEventListener(event, this.handleActivity, true);
    });
    
    // Clear all timers
    this.clearTimers();
  }

  /**
   * Reset the session timer (call when user activity is detected)
   */
  reset() {
    if (!this.isActive) return;
    
    this.lastActivity = Date.now();
    this.isWarningShown = false;
    this.clearTimers();
    this.scheduleNext();
  }

  /**
   * Get remaining time until timeout
   */
  getRemainingTime() {
    const elapsed = Date.now() - this.lastActivity;
    const remaining = this.timeoutDuration - elapsed;
    return Math.max(0, remaining);
  }

  /**
   * Get remaining time until warning
   */
  getTimeUntilWarning() {
    const elapsed = Date.now() - this.lastActivity;
    const warningTime = this.timeoutDuration - this.warningDuration;
    const remaining = warningTime - elapsed;
    return Math.max(0, remaining);
  }

  /**
   * Check if session should show warning or timeout
   */
  checkSession() {
    const now = Date.now();
    const elapsed = now - this.lastActivity;
    
    if (elapsed >= this.timeoutDuration) {
      this.handleTimeout();
    } else if (elapsed >= (this.timeoutDuration - this.warningDuration) && !this.isWarningShown) {
      this.handleWarning();
    }
  }

  /**
   * Handle user activity
   */
  handleActivity() {
    if (!this.isActive) return;
    
    const now = Date.now();
    const timeSinceLastActivity = now - this.lastActivity;
    
    // Throttle activity detection to avoid excessive resets
    if (timeSinceLastActivity > 1000) { // 1 second throttle
      this.reset();
      this.onActivity(now);
    }
  }

  /**
   * Handle session warning
   */
  handleWarning() {
    this.isWarningShown = true;
    const remainingTime = this.getRemainingTime();
    this.onWarning(remainingTime);
  }

  /**
   * Handle session timeout
   */
  handleTimeout() {
    this.stop();
    this.onTimeout();
  }

  /**
   * Schedule the next session check
   */
  scheduleNext() {
    this.clearTimers();
    
    const timeUntilWarning = this.getTimeUntilWarning();
    const remainingTime = this.getRemainingTime();
    
    if (timeUntilWarning > 0) {
      // Schedule warning
      this.warningId = setTimeout(() => this.checkSession(), timeUntilWarning);
    } else if (remainingTime > 0) {
      // Schedule timeout
      this.timeoutId = setTimeout(() => this.checkSession(), remainingTime);
    } else {
      // Already timed out
      this.handleTimeout();
    }
  }

  /**
   * Start the tick timer for countdown updates
   */
  startTicking() {
    this.stopTicking();
    this.tickId = setInterval(() => {
      if (this.isActive) {
        const remaining = this.getRemainingTime();
        this.onTick(remaining);
        
        if (remaining === 0) {
          this.stopTicking();
        }
      }
    }, 1000);
  }

  /**
   * Stop the tick timer
   */
  stopTicking() {
    if (this.tickId) {
      clearInterval(this.tickId);
      this.tickId = null;
    }
  }

  /**
   * Clear all timers
   */
  clearTimers() {
    if (this.timeoutId) {
      clearTimeout(this.timeoutId);
      this.timeoutId = null;
    }
    if (this.warningId) {
      clearTimeout(this.warningId);
      this.warningId = null;
    }
  }
}
```

## Utility Functions

```javascript
/**
 * Format milliseconds into human-readable time
 * @param {number} ms - Milliseconds to format
 * @returns {string} - Formatted time string
 */
function formatTime(ms) {
  if (ms <= 0) return '0:00';
  
  const minutes = Math.floor(ms / 60000);
  const seconds = Math.floor((ms % 60000) / 1000);
  
  return `${minutes}:${seconds.toString().padStart(2, '0')}`;
}

/**
 * Format milliseconds into detailed time breakdown
 * @param {number} ms - Milliseconds to format
 * @returns {Object} - Object with hours, minutes, seconds
 */
function parseTime(ms) {
  if (ms <= 0) return { hours: 0, minutes: 0, seconds: 0 };
  
  const hours = Math.floor(ms / 3600000);
  const minutes = Math.floor((ms % 3600000) / 60000);
  const seconds = Math.floor((ms % 60000) / 1000);
  
  return { hours, minutes, seconds };
}

/**
 * Create a session storage manager
 */
const sessionStorage = {
  setItem(key, value) {
    try {
      const item = {
        value,
        timestamp: Date.now()
      };
      window.sessionStorage.setItem(key, JSON.stringify(item));
    } catch (error) {
      console.warn('Session storage not available:', error);
    }
  },

  getItem(key, maxAge = null) {
    try {
      const item = window.sessionStorage.getItem(key);
      if (!item) return null;
      
      const parsed = JSON.parse(item);
      
      if (maxAge && Date.now() - parsed.timestamp > maxAge) {
        this.removeItem(key);
        return null;
      }
      
      return parsed.value;
    } catch (error) {
      console.warn('Error reading from session storage:', error);
      return null;
    }
  },

  removeItem(key) {
    try {
      window.sessionStorage.removeItem(key);
    } catch (error) {
      console.warn('Error removing from session storage:', error);
    }
  },

  clear() {
    try {
      window.sessionStorage.clear();
    } catch (error) {
      console.warn('Error clearing session storage:', error);
    }
  }
};

/**
 * Activity tracker for detailed analytics
 */
class ActivityTracker {
  constructor() {
    this.activities = [];
    this.sessionStart = Date.now();
  }

  logActivity(type, details = {}) {
    this.activities.push({
      type,
      timestamp: Date.now(),
      details
    });
  }

  getActivitySummary() {
    const now = Date.now();
    const sessionDuration = now - this.sessionStart;
    
    const activityCounts = this.activities.reduce((counts, activity) => {
      counts[activity.type] = (counts[activity.type] || 0) + 1;
      return counts;
    }, {});

    const lastActivity = this.activities.length > 0 
      ? this.activities[this.activities.length - 1].timestamp 
      : this.sessionStart;

    return {
      sessionDuration,
      totalActivities: this.activities.length,
      activityCounts,
      lastActivity,
      idleTime: now - lastActivity
    };
  }

  clearActivities() {
    this.activities = [];
    this.sessionStart = Date.now();
  }
}
```

## Usage Examples

### Basic Session Timer
```javascript
// Create a session timer with default settings
const sessionTimer = new SessionTimer({
  timeoutDuration: 15 * 60 * 1000, // 15 minutes
  warningDuration: 2 * 60 * 1000,  // 2 minutes warning
  
  onWarning: (remainingTime) => {
    const timeLeft = formatTime(remainingTime);
    showWarningModal(`Your session will expire in ${timeLeft}. Click to continue.`);
  },
  
  onTimeout: () => {
    logout();
    redirectToLogin();
  },
  
  onActivity: (timestamp) => {
    console.log('User activity detected at:', new Date(timestamp));
  }
});

// Start monitoring
sessionTimer.start();
```

### Advanced Session Management
```javascript
class SessionManager {
  constructor() {
    this.timer = null;
    this.warningModal = null;
    this.activityTracker = new ActivityTracker();
    this.heartbeatInterval = null;
    
    this.initializeTimer();
  }

  initializeTimer() {
    this.timer = new SessionTimer({
      timeoutDuration: 30 * 60 * 1000, // 30 minutes
      warningDuration: 5 * 60 * 1000,  // 5 minutes warning
      
      onWarning: (remainingTime) => this.showWarning(remainingTime),
      onTimeout: () => this.handleTimeout(),
      onActivity: (timestamp) => this.logActivity('user_interaction', { timestamp }),
      onTick: (remainingTime) => this.updateCountdown(remainingTime)
    });
  }

  start() {
    this.timer.start();
    this.startHeartbeat();
    this.activityTracker.logActivity('session_start');
  }

  stop() {
    this.timer.stop();
    this.stopHeartbeat();
    this.activityTracker.logActivity('session_end');
  }

  showWarning(remainingTime) {
    const timeLeft = formatTime(remainingTime);
    
    this.warningModal = {
      message: `Your session will expire in ${timeLeft}`,
      onExtend: () => this.extendSession(),
      onLogout: () => this.logout()
    };
    
    // Show modal in your UI framework
    showSessionWarningModal(this.warningModal);
  }

  extendSession() {
    this.timer.reset();
    this.closeWarningModal();
    this.activityTracker.logActivity('session_extended');
    
    // Optional: Make API call to extend server session
    this.extendServerSession();
  }

  handleTimeout() {
    this.activityTracker.logActivity('session_timeout');
    this.logout();
  }

  logout() {
    this.stop();
    
    // Clear session data
    sessionStorage.clear();
    
    // Redirect to login
    window.location.href = '/login';
  }

  updateCountdown(remainingTime) {
    if (this.warningModal) {
      const timeLeft = formatTime(remainingTime);
      updateWarningModalCountdown(timeLeft);
    }
  }

  logActivity(type, details) {
    this.activityTracker.logActivity(type, details);
  }

  startHeartbeat() {
    // Send periodic heartbeat to server
    this.heartbeatInterval = setInterval(() => {
      this.sendHeartbeat();
    }, 60000); // Every minute
  }

  stopHeartbeat() {
    if (this.heartbeatInterval) {
      clearInterval(this.heartbeatInterval);
      this.heartbeatInterval = null;
    }
  }

  async sendHeartbeat() {
    try {
      const summary = this.activityTracker.getActivitySummary();
      await fetch('/api/session/heartbeat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ summary })
      });
    } catch (error) {
      console.warn('Heartbeat failed:', error);
    }
  }

  async extendServerSession() {
    try {
      await fetch('/api/session/extend', { method: 'POST' });
    } catch (error) {
      console.warn('Failed to extend server session:', error);
    }
  }
}

// Initialize session management
const sessionManager = new SessionManager();
sessionManager.start();
```

### React Integration
```javascript
import { useState, useEffect, useCallback } from 'react';

function useSessionTimer(options = {}) {
  const [remainingTime, setRemainingTime] = useState(null);
  const [showWarning, setShowWarning] = useState(false);
  const [timer, setTimer] = useState(null);

  const onWarning = useCallback((time) => {
    setShowWarning(true);
    setRemainingTime(time);
  }, []);

  const onTick = useCallback((time) => {
    setRemainingTime(time);
  }, []);

  const onTimeout = useCallback(() => {
    options.onTimeout?.();
  }, [options.onTimeout]);

  const onActivity = useCallback(() => {
    setShowWarning(false);
  }, []);

  useEffect(() => {
    const sessionTimer = new SessionTimer({
      ...options,
      onWarning,
      onTick,
      onTimeout,
      onActivity
    });

    sessionTimer.start();
    setTimer(sessionTimer);

    return () => {
      sessionTimer.stop();
    };
  }, []);

  const extendSession = useCallback(() => {
    timer?.reset();
    setShowWarning(false);
  }, [timer]);

  return {
    remainingTime,
    showWarning,
    extendSession,
    formattedTime: remainingTime ? formatTime(remainingTime) : null
  };
}

// Usage in React component
function App() {
  const { remainingTime, showWarning, extendSession, formattedTime } = useSessionTimer({
    timeoutDuration: 30 * 60 * 1000,
    warningDuration: 5 * 60 * 1000,
    onTimeout: () => {
      // Handle logout
      window.location.href = '/login';
    }
  });

  return (
    <div>
      <header>
        <div>My App</div>
        {formattedTime && (
          <div className="session-timer">
            Session: {formattedTime}
          </div>
        )}
      </header>

      {showWarning && (
        <SessionWarningModal
          remainingTime={formattedTime}
          onExtend={extendSession}
          onLogout={() => window.location.href = '/login'}
        />
      )}

      {/* Main app content */}
    </div>
  );
}
```

### Multiple Timer Management
```javascript
class MultiTimerManager {
  constructor() {
    this.timers = new Map();
  }

  createTimer(name, options) {
    if (this.timers.has(name)) {
      this.timers.get(name).stop();
    }

    const timer = new SessionTimer(options);
    this.timers.set(name, timer);
    return timer;
  }

  startTimer(name) {
    const timer = this.timers.get(name);
    if (timer) {
      timer.start();
    }
  }

  stopTimer(name) {
    const timer = this.timers.get(name);
    if (timer) {
      timer.stop();
    }
  }

  resetTimer(name) {
    const timer = this.timers.get(name);
    if (timer) {
      timer.reset();
    }
  }

  getTimerStatus(name) {
    const timer = this.timers.get(name);
    if (!timer) return null;

    return {
      isActive: timer.isActive,
      remainingTime: timer.getRemainingTime(),
      formattedTime: formatTime(timer.getRemainingTime())
    };
  }

  stopAllTimers() {
    this.timers.forEach(timer => timer.stop());
  }

  removeTimer(name) {
    const timer = this.timers.get(name);
    if (timer) {
      timer.stop();
      this.timers.delete(name);
    }
  }
}

// Usage for different session types
const timerManager = new MultiTimerManager();

// Main session timer
timerManager.createTimer('main', {
  timeoutDuration: 30 * 60 * 1000,
  onTimeout: () => logout()
});

// Form auto-save timer
timerManager.createTimer('autosave', {
  timeoutDuration: 60 * 1000, // 1 minute
  onTimeout: () => autoSaveForm()
});

// Notification reminder timer
timerManager.createTimer('reminder', {
  timeoutDuration: 10 * 60 * 1000, // 10 minutes
  onTimeout: () => showReminder()
});

// Start all timers
timerManager.startTimer('main');
timerManager.startTimer('autosave');
timerManager.startTimer('reminder');
```

## Use Cases

- **Session timeout management** for security
- **Auto-logout** for inactive users
- **Activity tracking** for analytics
- **Form auto-save** functionality
- **Periodic reminder** systems
- **Multi-tenant** session management
- **Offline detection** and handling

## Browser Compatibility

- **Modern browsers**: Full support
- **IE11+**: Requires polyfills for `Map` and `Set`
- **Mobile browsers**: Handles touch events properly
- **Background tabs**: Uses `visibilitychange` events when available

---

This comprehensive session timer utility provides everything needed for robust session management in web applications, from simple timeout handling to complex multi-timer scenarios.
