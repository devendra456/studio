# Studio

A cross-platform image gallery application built with Flutter that displays and manages random images from the Lorem Picsum API.

![Studio App](https://picsum.photos/200/300) <!-- Replace with actual app screenshot -->

## Features

- **Image Gallery**: Browse through a collection of high-quality random images
- **Infinite Scrolling**: Continuously load new images as you scroll
- **Image Customization**: Adjust image parameters:
  - Width and height settings
  - Grayscale filter option
  - Blur effect with adjustable intensity
  - Square aspect ratio option
- **Image Viewing**: View images with zoom and pan capabilities
- **Sharing Options**: Share images as links or files
- **Offline Support**: View previously loaded images when offline
- **Cross-Platform**: Works on Android, iOS, Web, and desktop platforms
- **Material You**: Dynamic theming that adapts to your device's color scheme

## Architecture

This project follows Clean Architecture principles with a clear separation of concerns:

- **Presentation Layer**: UI components using Flutter BLoC for state management
- **Domain Layer**: Business logic with use cases and repository interfaces
- **Data Layer**: Repository implementations with remote and local data sources
- **Application Layer**: Core utilities, network handling, and dependency injection

## Technology Stack

- **State Management**: Flutter BLoC
- **Dependency Injection**: GetIt
- **Networking**: Dio HTTP client
- **Caching**: Flutter Cache Manager and Shared Preferences
- **Image Loading**: Cached Network Image
- **Error Handling**: Dartz for functional error handling
- **Firebase**: Firebase Core for analytics and services

## Getting Started

### Prerequisites

- Flutter SDK (version 3.0.6 or higher)
- Dart SDK (version 3.0.6 or higher)
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/studio.git
   ```

2. Navigate to the project directory:
   ```
   cd studio
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Run the app:
   ```
   flutter run
   ```

## Project Structure

```
lib/
├── application/         # Core utilities and services
│   ├── core/            # Core functionality
│   ├── network/         # Network handling
│   ├── preferences/     # App preferences
│   └── routes/          # Route definitions
├── data/                # Data layer
│   ├── data_source/     # Remote and local data sources
│   └── repos/           # Repository implementations
├── domain/              # Domain layer
│   ├── entities/        # Business entities
│   ├── repos/           # Repository interfaces
│   └── use_cases/       # Business use cases
├── presentation/        # UI layer
│   ├── image_viewer/    # Image viewing screen
│   ├── on_boarding/     # Main gallery screen
│   └── settings/        # Settings screen
└── main.dart            # Application entry point
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [Lorem Picsum](https://picsum.photos) for providing the image API
- [Flutter](https://flutter.dev/) team for the amazing framework
- All the package authors that made this project possible
