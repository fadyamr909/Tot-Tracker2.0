# TotTracker

Flutter app. To run locally in VS Code:

1. Install Flutter 3.x SDK and Android Studio tooling.
2. Open this folder in VS Code.
3. Run these commands:
   - `flutter pub get`
   - `flutter run` (select device: Android emulator, iOS simulator, or Chrome)

Firebase
- Add your own `android/app/google-services.json` if you want Firebase to work.
- Or run `flutterfire configure` to generate `lib/firebase_options.dart`.

Android config
- Android Gradle plugin 7.4.2, Gradle 7.5, Kotlin 1.7.10
- compileSdk 33, targetSdk 33, minSdk 21
