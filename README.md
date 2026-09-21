# Senior SDET Interview Coach

Offline-first Flutter app for a senior SDET / automation lead interview journey. Content is bundled under `assets/content/`; no backend is required.

## Current foundation

- Flutter 3.x with Material 3 light/dark themes
- Riverpod dependency injection and async content providers
- go_router responsive shell with bottom navigation on compact screens and a drawer on wide screens
- Hive local box initialized as `coach_progress` for future checklists, mock history, bookmarks, and drafts
- Typed `Skill` and `PlanDay` models behind `ContentRepository`
- Dashboard skill-gap view with ranked priorities loaded from JSON

## Run

```powershell
cd C:\Users\satya\Desktop\SeniorSdetInterviewCoach
flutter pub get
flutter run -d chrome
```

For Android or iOS, use `flutter devices` to select a connected device and then run `flutter run -d <device-id>`.

## Validate

```powershell
flutter analyze
flutter test
```

The app is being built in phases. Keep authored interview content in `assets/content/*.json` and keep UI state separate from the content repository.
