# RULES.md - Zahmet App Code Quality & Architecture Rules

## 1. State Management (Stop-Slop)
- NEVER use `setState` for complex logic or business workflows. Use Riverpod `Notifier` or `AsyncNotifier`.
- UI files (`.dart` files in `lib/screens/` or `lib/widgets/`) should strictly handle UI. All business logic goes to `lib/providers/` or `lib/services/`.

## 2. Global Error Handling
- Do not wrap `main()` logic in massive `try-catch` blocks that return a completely new `MaterialApp`.
- Use `FlutterError.onError` and `PlatformDispatcher.instance.onError`.
- Implement a custom `ErrorWidget.builder`.

## 3. UI/UX Design System (Taste-Skill - Minimalist Editorial)
- **Palette**: `#FAFAFA` (Off-white) for backgrounds. True `#000000` for primary text.
- **Typography**: Google Fonts Inter or similar clean, geometric sans-serif. Use high contrast in font weights (e.g., extremely bold titles, light body).
- **Spacing**: Use generous padding. Elements should breathe.
- **Animations**: Avoid generic `AnimatedSwitcher`. Use spring physics, staggered fades, and layout animations.
- **Inputs**: Input fields should look refined. Use subtle underlines or borderless inputs with typography-driven focus states.

## 4. Code Quality
- No "God Classes". Split files exceeding 250 lines if they contain mixed UI and logic.
- Avoid magic numbers (e.g., `_step = -99`). Use proper enums or sealed classes for states.
- Re-use `StorageService` instead of instantiating `FlutterSecureStorage` multiple times.
