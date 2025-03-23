# Location Tracking App
This project tracks in real-time how long users stay at predefined locations in the system. The app is developed using Flutter with clean architecture principles, and Provider is used for state management.

## Project Structure

```
lib/
├── core/           # Common utilities, constants, and helpers
├── models/         # Data models and entities
├── providers/      # State management using Provider
├── screens/        # UI screens and pages
├── services/       # Business logic and services
```

## Key Features

• Real-time location tracking in both foreground and background  
• Users can save their current location for tracking.    
• State management using Provider  
• Local data caching with Hive  
• Basic error handling and management   
• Midnight transitions are properly handled to ensure accurate daily tracking.  
• Stationary user detection within a geo-fence is handled to maintain time accuracy across updates.

## Important Notes

• To ensure continuous location updates in the background, location permission must be set to **"Always"**.  
• For better battery optimization, `distanceFilter` and `timerPeriod` values can be increased.  
• A minimal UI has been developed to focus on core functionality.   
• Due to incompatibility with the latest Android versions, the `background_location` package has been patched and is used via a custom fork hosted on my GitHub.