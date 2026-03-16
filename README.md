# Mini Katalog Uygulaması

A beginner-level Flutter mobile app that demonstrates core Flutter concepts through a simple product catalog experience.

## Features

- **Home Screen** — Browse products in a 2-column grid, search by name, see cart item count in the app bar
- **Detail Screen** — View full product info (image, description, specs) and add to cart
- **Cart Screen** — Review added items, remove individual items, and checkout

## Tech Stack

- Flutter (latest stable) + Dart
- `material.dart` only — no third-party packages
- `dart:io` HttpClient for network requests
- `InheritedWidget` for cart state management

## Data Source

Products are fetched from [dummyjson.com/products](https://dummyjson.com/products) — a free public test API, no authentication required.

## Project Structure

```
lib/
├── main.dart                  # App entry point + CartState (InheritedWidget)
├── models/
│   └── product.dart           # Product data model
├── screens/
│   ├── home_screen.dart       # Product grid + search
│   ├── detail_screen.dart     # Product detail + add to cart
│   └── cart_screen.dart       # Cart list + checkout
└── widgets/
    └── product_card.dart      # Reusable product grid card
```

## Getting Started

```bash
flutter pub get
flutter run
```

> Requires an Android device or emulator. Internet connection needed to load products.
