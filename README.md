# BudgetByte

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://docs.flutter.dev/)
[![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Windows%20%7C%20macOS%20%7C%20Linux-lightgrey)](#supported-platforms)
[![Version](https://img.shields.io/badge/version-1.0.0%2B1-blue)](pubspec.yaml)

BudgetByte is a cross-platform Flutter app for planning and shopping for a PC peripheral setup. Browse curated keyboards, mice, monitors, audio gear, cameras, and accessories; compare specifications; save builds; and manage a shopping cart in one focused interface.

## Features

- Browse products by category and view brand, pricing, stock, ratings, reviews, specifications, and color options.
- Build a custom setup with real-time pricing and saved build configurations.
- Add products or complete builds to a persistent shopping cart.
- Track orders, save favorites, and manage the demo user profile.
- Complete a first-run onboarding flow and choose light or dark themes.
- Use the app offline with locally stored preferences, builds, cart contents, favorites, and orders.
- Receive an in-app connectivity notice when the device goes offline.

## Supported platforms

BudgetByte contains Flutter platform runners for:

- Android
- iOS
- Web
- Windows
- macOS
- Linux

The available functionality may vary by platform runner.

## Getting started

### Prerequisites

- Flutter SDK with Dart support
- A configured emulator, simulator, browser, or desktop target
- Platform toolchains needed by the target you choose

Check the installed toolchain before running the app:

```sh
flutter doctor
```

### Install and run

Clone the repository and open it as a Flutter project:

```sh
git clone https://github.com/zidvsd/BudgetByte.git
cd BudgetByte
flutter pub get
flutter run
```

To select a target explicitly, list the available devices and run on one:

```sh
flutter devices
flutter run -d <device-id>
```

For example, run the web or Windows builds with:

```sh
flutter run -d chrome
flutter run -d windows
```

## Development

Analyze the codebase:

```sh
flutter analyze
```

Run the widget tests:

```sh
flutter test
```

Format Dart source files:

```sh
dart format lib test
```

## Application flow

1. First-time users complete the onboarding flow.
2. The Home tab displays products and featured shopping content.
3. The Builder tab lets users assemble components from the available categories.
4. The Cart tab calculates items, tax, shipping, and the total.
5. The Profile tab provides account, saved-build, order, settings, and theme options.

Application state is managed with `provider`. Cart, builds, favorites, orders, theme settings, and onboarding state are persisted on-device through `SharedPreferences`. The bundled catalog is maintained by `ComponentDataService`; authentication and user data are handled locally by `AuthService`.

> This repository is a client-side application. It does not require or include a configured remote API, cloud database, or production payment backend.

## Project structure

```text
lib/
├── main.dart                 # App initialization and providers
├── models/                   # Products, builds, carts, and orders
├── providers/                # State management
├── screens/                  # Home, builder, cart, checkout, and profile UI
├── services/                 # Catalog, persistence, auth, and themes
├── theme/                    # Colors and typography
└── widgets/                  # Shared UI components
assets/
└── images/                   # Image assets used by the app
test/
└── widget_test.dart          # Flutter widget tests
```

## Help and support

- Review the [Flutter documentation](https://docs.flutter.dev/) for SDK setup and platform tooling.
- Search existing [BudgetByte issues](https://github.com/zidvsd/BudgetByte/issues).
- Report a bug or request a feature by opening an [issue](https://github.com/zidvsd/BudgetByte/issues/new).

## Contributing

Contributions are welcome. Before submitting a change:

1. Create a focused branch from the repository's default branch.
2. Keep the change small and consistent with the existing architecture.
3. Run `dart format lib test` and `flutter analyze`.
4. Run `flutter test` and verify the affected platform when applicable.
5. Open a pull request with a clear description, screenshots for UI changes, and relevant issue links.

See the project repository and its issue tracker for current discussions and maintainers:

- [BudgetByte repository](https://github.com/zidvsd/BudgetByte)
- [Open pull requests](https://github.com/zidvsd/BudgetByte/pulls)

## Maintainers

BudgetByte is maintained by [zidvsd](https://github.com/zidvsd) and the upstream [BudgetByte community](https://github.com/zhyvelrain/BudgetByte).
