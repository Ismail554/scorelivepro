# Merge iOS & Main Branches Into Single Codebase

Unify two divergent branches (`main` and `origin/iOS`) into one codebase using `PlatformUtils` runtime guards, eliminating dual-branch maintenance.

## User Review Required

> [!IMPORTANT]
> **Deleted files** — Per user decision, these files will be **deleted**:
> - ✅ `terms_conditon_view.dart` — Remove + clean imports from settings_screen.dart
> - ✅ `widget_premium_upgrade_card.dart` — Remove + clean usage from leagues_screen.dart
> - ✅ `widget_premium_notification_card.dart` — Remove (already unused)
> - `android/app/src/main/res/drawable/app_logo.png` — **Keep for Android.**

> [!WARNING]
> **iOS branch has regressions vs main** — Several places where iOS branch removed valuable code that main has:
> 1. **Auth validation removed** — Login & signup lost email regex validation, password length checks, confirm-password matching. Main's version better.
> 2. **Leagues caching removed** — iOS removed debounce search, cache layer, connectivity-aware errors, RefreshIndicator. Main's version better.
> 3. **Team provider error handling removed** — `errorMessage`, `_activeFetchId` (stale-request guard) stripped out. Main's version better.
> 4. **Edit profile validation removed** — field-empty checks, password-length checks stripped. Main's version better.
> 5. **Date parsing safety** — Main uses `DateTime.tryParse` with null check, iOS uses bare `DateTime.parse` (crash on bad data). Main's version safer.
> 6. **BannerAd widget** — Main has `mounted` checks preventing setState-after-dispose crashes. iOS removed them. Main's version safer.

> [!CAUTION]
> I recommend **cherry-picking only the good iOS changes** instead of `git merge`, since iOS branch has many regressions we don't want. A merge would bring all regressions in and require reverting each one. Cherry-pick approach = less work, less risk.

## Open Questions

1. **String sanitizer on Android?** — iOS needs FIFA/UEFA names sanitized (Apple 5.2.1). Should Android also sanitize, or show original names? Current plan: guard with `PlatformUtils.isIOS`.
2. **Team/League logos on iOS** — iOS replaced all `Image.network(logo)` with `Image.asset(soccer_icon)`. Is this Apple's requirement (no third-party team logos), or was it a quick fix? If required, we guard with `PlatformUtils`.
3. **Notification toggle API** — iOS changed from `PUT /auth/profile/settings/` to `PATCH` with new endpoint method `notificationToggle()`. Which is correct backend endpoint?
4. **WebSocket URL** — iOS changed default from `https://` to `wss://`. The `wss://` is correct for WebSockets. Should be kept.

## Proposed Changes

### Phase 1: Apply iOS-Only Features (Cherry-Pick Good Changes)

Instead of `git merge`, we manually apply only beneficial iOS changes to main.

---

#### [NEW] [att_service.dart](file:///d:/Ismail_flutter/scorelivepro/lib/services/att_service.dart)
- Copy from iOS branch. Already has `Platform.isIOS` guard — safe no-op on Android.
- Add `app_tracking_transparency` to `pubspec.yaml`.

#### [MODIFY] [main.dart](file:///d:/Ismail_flutter/scorelivepro/lib/main.dart)
- Add ATT request **before** `MobileAds.instance.initialize()` (iOS requirement).
- Keep main's orientation lock placement (already works).

---

#### [NEW] [string_sanitizer.dart](file:///d:/Ismail_flutter/scorelivepro/lib/core/utils/string_sanitizer.dart)
- Copy from iOS branch.

#### [MODIFY] [league_model.dart](file:///d:/Ismail_flutter/scorelivepro/lib/models/league_model.dart)
- Wrap sanitizer call with `PlatformUtils.isIOS` guard:
```dart
name: PlatformUtils.isIOS 
    ? StringSanitizer.sanitize(json['name']) 
    : json['name'],
```

#### [MODIFY] [live_ws_model.dart](file:///d:/Ismail_flutter/scorelivepro/lib/models/live_ws_model.dart)
- Same `PlatformUtils.isIOS` guard for league name sanitization.

---

### Phase 2: Add Platform Guards for Logo Display

These widgets need `PlatformUtils.isIOS` to conditionally show network images (Android) vs asset fallback (iOS):

#### [MODIFY] [widget_favorite_team_card.dart](file:///d:/Ismail_flutter/scorelivepro/lib/widget/favorites/widget_favorite_team_card.dart)
```dart
child: PlatformUtils.isIOS
    ? Image.asset(IconAssets.soccer_icon, fit: BoxFit.contain)
    : (logoUrl != null
        ? Image.network(logoUrl!, fit: BoxFit.contain,
            errorBuilder: (c, e, s) => Image.asset(IconAssets.soccer_icon, fit: BoxFit.contain))
        : Image.asset(IconAssets.soccer_icon, fit: BoxFit.contain)),
```

#### [MODIFY] [widget_favorite_league_card.dart](file:///d:/Ismail_flutter/scorelivepro/lib/widget/favorites/widget_favorite_league_card.dart)
- Same pattern: iOS → icon fallback, Android → network image with error fallback.

#### [MODIFY] [widget_team_browse_card.dart](file:///d:/Ismail_flutter/scorelivepro/lib/widget/favorites/widget_team_browse_card.dart)
- Same pattern.

#### [MODIFY] [widget_league_card.dart](file:///d:/Ismail_flutter/scorelivepro/lib/widget/leagues/widget_league_card.dart)
- Same pattern: iOS → emoji_events icon, Android → `CachedNetworkImage`.

#### [MODIFY] [widget_league_header_card.dart](file:///d:/Ismail_flutter/scorelivepro/lib/widget/leagues/widget_league_header_card.dart)
- Same pattern: iOS → flag emoji only, Android → network image with flag fallback.

#### [MODIFY] [widget_standings_team_card.dart](file:///d:/Ismail_flutter/scorelivepro/lib/widget/leagues/widget_standings_team_card.dart)
- Same pattern.

#### [MODIFY] [detailed_leagues_screen.dart](file:///d:/Ismail_flutter/scorelivepro/lib/views/league_views/detailed_leagues_screen.dart)
- Team logo in detail view: same platform guard.

#### [MODIFY] [favorites_teams_screen.dart](file:///d:/Ismail_flutter/scorelivepro/lib/views/favorites_views/favorites_teams_screen.dart)
- Team browse card logo: same platform guard.

---

### Phase 3: Apply Universal Improvements from iOS

These changes are good for both platforms — no guard needed:

#### [MODIFY] [notification_service.dart](file:///d:/Ismail_flutter/scorelivepro/lib/services/notification_service.dart)
- Add `registerDevice()` and `updateNotificationSettings()` static methods from iOS.
- Remove debug print spam (`"📱 All Notifications in device"`).

#### [MODIFY] [notification_provider.dart](file:///d:/Ismail_flutter/scorelivepro/lib/provider/notification_provider.dart)
- Refactor `registerDevice` to call `NotificationService.registerDevice()`.
- Add `updateNotificationPreferences()` method.
- Keep main's `toggleNotificationSettings()` if backend still uses PUT endpoint.

#### [MODIFY] [api_service.dart](file:///d:/Ismail_flutter/scorelivepro/lib/services/api_service.dart)
- Add `notificationToggle()` endpoint.
- Clean up duplicate comment.

#### [MODIFY] [socket_service.dart](file:///d:/Ismail_flutter/scorelivepro/lib/services/socket_service.dart)
- Fix WebSocket URL default: `https://` → `wss://` (correct protocol).
- Truncate WebSocket log to 200 chars (reduce spam).
- Remove `print()` → use `debugPrint()`.

#### [MODIFY] [match_provider.dart](file:///d:/Ismail_flutter/scorelivepro/lib/provider/match_provider.dart)
- Remove `print()` calls, use `debugPrint()`.
- Remove `jsonEncode` import (unused after print removal).

#### [MODIFY] [mw_blinking_widget.dart](file:///d:/Ismail_flutter/scorelivepro/lib/widget/mini_widget/mw_blinking_widget.dart)
- Replace with iOS's improved multi-phase blink animation (better UX, both platforms).

#### [MODIFY] [firebase_service.dart](file:///d:/Ismail_flutter/scorelivepro/lib/services/firebase_service.dart)
- Keep existing Platform.isIOS guards (already correct).

#### [MODIFY] [favorites_screen.dart](file:///d:/Ismail_flutter/scorelivepro/lib/views/favorites_views/favorites_screen.dart)
- Add `FirebaseService.logScreenView()` call.
- Add floating banner ad.

#### [MODIFY] [settings_screen.dart](file:///d:/Ismail_flutter/scorelivepro/lib/views/settings/settings_screen.dart)
- Update notification toggle to use `updateNotificationPreferences()`.
- **Keep** main's Language Consumer with `LanguageManager.getLanguageName()` (iOS lost this).
- **Remove** Terms & Conditions import + navigation (file deleted).

---

### Phase 4: iOS Platform Config

#### [MODIFY] [ios/Runner/Info.plist](file:///d:/Ismail_flutter/scorelivepro/ios/Runner/Info.plist)
- Add ATT usage description key for `NSUserTrackingUsageDescription`.

#### [NEW] [ios/Runner/SceneDelegate.swift](file:///d:/Ismail_flutter/scorelivepro/ios/Runner/SceneDelegate.swift)
- Copy from iOS branch.

#### [MODIFY] [pubspec.yaml](file:///d:/Ismail_flutter/scorelivepro/pubspec.yaml)
- Add `app_tracking_transparency` dependency.

---

### What We DON'T Take from iOS Branch

| Change | Reason to keep main's version |
|---|---|
| Login email regex removal | Main validates properly |
| Signup validation stripping | Main has length/match/format checks |
| Edit profile validation stripping | Main validates empty fields, password length |
| Leagues caching + debounce removal | Main has better UX with cache + debounce |
| Team provider error handling removal | Main has `errorMessage` + stale-request guard |
| `DateTime.parse` (bare, no try) | Main's `tryParse` is crash-safe |
| `BannerAd` mounted-check removal | Main prevents setState-after-dispose |
| `RefreshIndicator` removal | Main allows pull-to-refresh (better UX) |
| `PremiumUpgradeCard` deletion | ✅ Confirmed delete + clean leagues_screen |
| `terms_conditon_view.dart` deletion | ✅ Confirmed delete + clean settings_screen |
| `widget_premium_notification_card.dart` deletion | ✅ Confirmed delete (unused) |

## Verification Plan

### Automated Tests
```bash
flutter analyze
flutter build apk --debug
flutter build ios --debug --no-codesign
```

### Manual Verification
- **Android**: Verify team/league logos load from network, league names show FIFA/UEFA, ATT is no-op.
- **iOS**: Verify ATT dialog appears before ads, logos show generic icon, league names are sanitized.
- **Both**: Verify notifications toggle, WebSocket connection, login/signup validation works.
