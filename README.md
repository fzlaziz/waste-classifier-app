# Waste Classifier App

A mobile Flutter application that allows users to capture or upload images of waste and receive AI-powered classification results. This app communicates with a waste classifier API to help users identify different types of waste for proper disposal and recycling.

## Features

- 📸 **Camera Integration**: Take photos directly from the app using device camera
- 🖼️ **Image Upload**: Select images from device gallery
- 🤖 **AI Classification**: Get accurate waste classification using machine learning
- 🎨 **Modern UI**: Clean and intuitive Material 3 design
- 📱 **Cross-platform**: Runs on Android and iOS

## Screenshots

*Coming soon...*

## Getting Started

### Prerequisites

- Flutter SDK (^3.7.2)
- Dart
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd waste_classifier_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Dependencies

- **camera**: ^0.11.1 - Camera functionality
- **http**: ^1.4.0 - API communication
- **image_picker**: ^1.1.2 - Image selection from gallery

## Usage

1. **Launch the app** on your device
2. **Take a photo** using the camera button or **select an image** from your gallery
3. **Upload and classify** the waste image
4. **View the classification result** to learn about the waste type

## API Integration

This app requires a waste classifier API endpoint to function properly. Make sure to:

1. Set up your waste classifier API server
2. Update the API endpoint in the `ApiService` class
3. Ensure proper network permissions are configured

## Project Structure

```
lib/
├── main.dart              # App entry point
├── screens/
│   └── home_screen.dart   # Main screen with camera and classification
├── services/
│   └── api_service.dart   # API communication service
└── widgets/
    └── result_widget.dart # Classification result display
```