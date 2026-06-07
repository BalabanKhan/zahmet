# CLAUDE.md - Zahmet App Agentic Workflow Guide

## Build & Run Commands
- Flutter Run: `flutter run`
- Flutter Test: `flutter test`
- Flutter Analyze: `flutter analyze`
- Generate Code: `flutter pub run build_runner build --delete-conflicting-outputs` (Run this when updating Isar models or Freezed classes)

## Environment
- SDK: Flutter ^3.4.0
- Architecture: Riverpod for state management, Isar for local database.

## Notes for AI Agents
- Check `RULES.md` for architectural and code quality guidelines.
- Never use magic strings for translations or user-facing messages. Always use `AppTexts`.
- Follow the Minimalist Editorial design system in the UI.
