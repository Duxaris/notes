# mergePresets.js

A flexible utility function for merging objects with preset configurations. Particularly useful for handling default settings, user preferences, and configuration objects.

## The Function

```javascript
/**
 * Merges multiple objects with smart handling of nested properties
 * @param {...Object} objects - Objects to merge (later objects override earlier ones)
 * @returns {Object} - Merged object with all properties combined
 */
function mergePresets(...objects) {
  // Helper function to check if value is a plain object
  const isObject = (obj) => 
    obj !== null && 
    typeof obj === 'object' && 
    !Array.isArray(obj) && 
    !(obj instanceof Date) && 
    !(obj instanceof RegExp);

  // Recursive merge function
  const deepMerge = (target, source) => {
    const result = { ...target };

    for (const key in source) {
      if (source.hasOwnProperty(key)) {
        if (isObject(result[key]) && isObject(source[key])) {
          // Both are objects - merge recursively
          result[key] = deepMerge(result[key], source[key]);
        } else {
          // Override with source value
          result[key] = source[key];
        }
      }
    }

    return result;
  };

  // Start with empty object and merge all arguments
  return objects.reduce((merged, current) => {
    if (isObject(current)) {
      return deepMerge(merged, current);
    }
    return merged;
  }, {});
}
```

## Usage Examples

### Basic Configuration Merging
```javascript
const defaultConfig = {
  theme: 'light',
  language: 'en',
  features: {
    notifications: true,
    analytics: false,
    autoSave: true
  },
  ui: {
    sidebar: true,
    toolbar: 'top'
  }
};

const userPreferences = {
  theme: 'dark',
  features: {
    analytics: true
  }
};

const finalConfig = mergePresets(defaultConfig, userPreferences);

console.log(finalConfig);
// {
//   theme: 'dark',              // Overridden by user
//   language: 'en',             // From default
//   features: {
//     notifications: true,      // From default
//     analytics: true,          // Overridden by user
//     autoSave: true           // From default
//   },
//   ui: {
//     sidebar: true,           // From default
//     toolbar: 'top'           // From default
//   }
// }
```

### Multiple Preset Layers
```javascript
const systemDefaults = {
  performance: {
    cacheSize: 100,
    timeout: 5000
  },
  security: {
    encryption: true,
    tokenExpiry: 3600
  }
};

const appPresets = {
  performance: {
    cacheSize: 200
  },
  features: {
    experimental: false
  }
};

const userSettings = {
  performance: {
    timeout: 10000
  },
  features: {
    experimental: true
  }
};

const finalSettings = mergePresets(systemDefaults, appPresets, userSettings);

console.log(finalSettings);
// {
//   performance: {
//     cacheSize: 200,          // From app presets
//     timeout: 10000           // From user settings
//   },
//   security: {
//     encryption: true,        // From system defaults
//     tokenExpiry: 3600        // From system defaults
//   },
//   features: {
//     experimental: true       // From user settings
//   }
// }
```

### API Configuration Builder
```javascript
const baseApiConfig = {
  baseURL: 'https://api.example.com',
  timeout: 5000,
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  },
  retry: {
    attempts: 3,
    delay: 1000
  }
};

const authConfig = {
  headers: {
    'Authorization': 'Bearer token123'
  }
};

const customConfig = {
  timeout: 10000,
  headers: {
    'X-Custom-Header': 'custom-value'
  },
  retry: {
    attempts: 5
  }
};

const apiConfig = mergePresets(baseApiConfig, authConfig, customConfig);

console.log(apiConfig.headers);
// {
//   'Content-Type': 'application/json',
//   'Accept': 'application/json',
//   'Authorization': 'Bearer token123',
//   'X-Custom-Header': 'custom-value'
// }
```

### Theme Configuration
```javascript
function createTheme(baseTheme, ...customizations) {
  const defaultTheme = {
    colors: {
      primary: '#007bff',
      secondary: '#6c757d',
      success: '#28a745',
      warning: '#ffc107',
      error: '#dc3545'
    },
    typography: {
      fontFamily: 'Arial, sans-serif',
      fontSize: {
        small: '12px',
        medium: '16px',
        large: '20px'
      }
    },
    spacing: {
      small: '8px',
      medium: '16px',
      large: '24px'
    }
  };

  return mergePresets(defaultTheme, baseTheme, ...customizations);
}

// Usage
const darkTheme = {
  colors: {
    primary: '#0d6efd',
    background: '#1a1a1a',
    text: '#ffffff'
  }
};

const companyBranding = {
  colors: {
    primary: '#ff6b35'
  },
  typography: {
    fontFamily: 'Roboto, sans-serif'
  }
};

const finalTheme = createTheme(darkTheme, companyBranding);
```

## Advanced Variations

### With Array Merging
```javascript
function mergePresetsWithArrays(...objects) {
  const isObject = (obj) => 
    obj !== null && 
    typeof obj === 'object' && 
    !Array.isArray(obj) && 
    !(obj instanceof Date) && 
    !(obj instanceof RegExp);

  const deepMerge = (target, source) => {
    const result = { ...target };

    for (const key in source) {
      if (source.hasOwnProperty(key)) {
        if (Array.isArray(source[key])) {
          // Merge arrays by concatenating and removing duplicates
          const targetArray = Array.isArray(result[key]) ? result[key] : [];
          result[key] = [...new Set([...targetArray, ...source[key]])];
        } else if (isObject(result[key]) && isObject(source[key])) {
          result[key] = deepMerge(result[key], source[key]);
        } else {
          result[key] = source[key];
        }
      }
    }

    return result;
  };

  return objects.reduce((merged, current) => {
    if (isObject(current)) {
      return deepMerge(merged, current);
    }
    return merged;
  }, {});
}

// Example with arrays
const config1 = {
  plugins: ['plugin1', 'plugin2'],
  features: { a: true }
};

const config2 = {
  plugins: ['plugin2', 'plugin3'],
  features: { b: true }
};

const merged = mergePresetsWithArrays(config1, config2);
// {
//   plugins: ['plugin1', 'plugin2', 'plugin3'],
//   features: { a: true, b: true }
// }
```

### With Custom Merge Strategies
```javascript
function mergePresetsCustom(mergeStrategies = {}, ...objects) {
  const isObject = (obj) => 
    obj !== null && 
    typeof obj === 'object' && 
    !Array.isArray(obj) && 
    !(obj instanceof Date) && 
    !(obj instanceof RegExp);

  const deepMerge = (target, source, path = '') => {
    const result = { ...target };

    for (const key in source) {
      if (source.hasOwnProperty(key)) {
        const currentPath = path ? `${path}.${key}` : key;
        const strategy = mergeStrategies[currentPath];

        if (strategy) {
          // Use custom merge strategy
          result[key] = strategy(result[key], source[key]);
        } else if (isObject(result[key]) && isObject(source[key])) {
          result[key] = deepMerge(result[key], source[key], currentPath);
        } else {
          result[key] = source[key];
        }
      }
    }

    return result;
  };

  return objects.reduce((merged, current) => {
    if (isObject(current)) {
      return deepMerge(merged, current);
    }
    return merged;
  }, {});
}

// Example with custom strategies
const strategies = {
  'performance.timeout': (target, source) => Math.max(target || 0, source),
  'features.plugins': (target, source) => [...(target || []), ...source]
};

const result = mergePresetsCustom(strategies, config1, config2);
```

## Error Handling

```javascript
function safemergePresets(...objects) {
  try {
    return mergePresets(...objects);
  } catch (error) {
    console.warn('Error merging presets:', error);
    return {};
  }
}

// Or with validation
function validateAndMerge(...objects) {
  const validObjects = objects.filter(obj => {
    if (obj === null || typeof obj !== 'object' || Array.isArray(obj)) {
      console.warn('Invalid object passed to mergePresets:', obj);
      return false;
    }
    return true;
  });

  return mergePresets(...validObjects);
}
```

## Use Cases

- **Configuration management** in applications
- **Theme customization** systems
- **API client configuration**
- **Build tool settings**
- **User preference handling**
- **Plugin system configuration**
- **Default parameter merging**

## Notes

- Performs **deep merge** for nested objects
- Later objects **override** earlier ones
- Handles **null** and **undefined** values safely
- Preserves **array references** (doesn't merge array contents by default)
- **Non-object arguments** are ignored
- Creates **new objects** (doesn't mutate inputs)

---

This utility is perfect for any scenario where you need to combine multiple configuration objects while preserving the nested structure and allowing for selective overrides.
