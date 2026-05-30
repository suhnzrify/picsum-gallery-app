# Picsum Gallery

Simple Flutter app that fetches a list of images from https://picsum.photos/v2/list and displays them in a clean list UI.

Features

- Infinite scrolling pagination
- Search by author or photo ID
- Favorite/bookmark images
- Detail screen with full image and metadata

Quick start

1. Install Flutter SDK (if not installed): https://flutter.dev/docs/get-started/install
2. From the project root run:

```bash
flutter pub get
flutter run
```

Files of interest

- `lib/main.dart`
- `lib/providers/photo_provider.dart`
- `lib/services/api_service.dart`
- `lib/models/photo.dart`
- `lib/widgets/photo_tile.dart`
