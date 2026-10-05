# Cosmic Arena

Offline-first deterministic mobile battle laboratory.

## What this is
- Flutter Android-first, portrait.
- Deterministic 60 Hz battle sim (pure Dart, seeded RNG).
- Flame for arena runtime, flutter_animate for HUD feedback, dotlottie for VFX bursts, render for clip export.

## Build & test (cloud)
Push to GitHub. CI runs:
1. `flutter create . --platforms=android` — fills the android/ scaffold.
2. `flutter pub get`
3. `flutter analyze`
4. `flutter test`
5. `flutter build apk --debug` and uploads the APK.

## Local dev (requires Flutter SDK)
```
flutter pub get
flutter run
flutter test
```

## First milestone
Setup screen → deterministic battle with pause + 0.5x/1x/2x → result screen with seed, stats, rematch/randomize/save.
