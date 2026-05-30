# Picsum Gallery

Picsum Gallery is a Flutter app that loads and displays images from the public Picsum API (`https://picsum.photos/v2/list`). It demonstrates a clean mobile-style UI, pagination, client-side search, favorites, and a detail view.

## Features

- Fetches photos from `https://picsum.photos/v2/list`
- Infinite scroll pagination with load-more behavior
- Search by photo author or photo ID
- Favorite/bookmark toggling for photos
- Detail view with full image display and metadata
- Clean UI built with provider state management

## Architecture

- `lib/main.dart` — App entry point, UI structure, app bar, search and favorites controls
- `lib/providers/photo_provider.dart` — State management with provider, fetch, pagination, search and favorites logic
- `lib/services/api_service.dart` — HTTP client for Picsum API requests
- `lib/models/photo.dart` — Photo model mapping API JSON to Dart objects
- `lib/widgets/photo_tile.dart` — Photo list item with image preview and favorite button
- `lib/screens/photo_detail.dart` — Detail screen for a selected photo

## Setup and Run

1. Install Flutter SDK: https://flutter.dev/docs/get-started/install
2. Open the project folder:

```bash
cd E:/internship/w3
```

3. Install dependencies:

```bash
flutter pub get
```

4. Run the app:

```bash
flutter run
```

## Notes for explanation

- The app uses `provider` for state management, keeping UI and data logic separated.
- The list uses `RefreshIndicator` and `ListView.builder` for a responsive scrolling experience.
- The detail page uses `Hero` animation for a smooth transition from the photo card.
- Favorite state is stored in memory and can be toggled for each photo.

## Useful commands

```bash
flutter pub get
flutter analyze
flutter run
```
