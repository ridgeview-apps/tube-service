## Localization (PresentationViews)

All localized strings in PresentationViews use Xcode String Catalogs (`Localizable.xcstrings`), which auto-synthesize `LocalizedStringResource` extensions at compile time. Never use raw string literals or `"string \(interpolation)"` directly in SwiftUI modifiers.

- **Non-parameterized strings:** add a key to `Localizable.xcstrings` with `extractionState: manual` and an `en` translation, then use the synthesized `static var` — e.g. `.globalRemove` passed to `Button(_, role:)` or `Text(...)`.
- **Parameterized strings:** include `%@` (String) or `%lld` (Int) in the key name itself — e.g. `"notifications.line.schedule.remove.title %@"` with value `"Remove %@?"`. Xcode synthesises a `static func(_ arg: String) -> LocalizedStringResource`. Use as `String(localized: .keyName(someString))`.
- **File location:** `Packages/PresentationViews/Sources/PresentationViews/Resources/Localizable.xcstrings`. Keys are alphabetically sorted — insert new keys in the correct position.
- **Build note:** new accessors won't appear in live Xcode diagnostics until the next build. A "no member" error immediately after adding a key is expected and will resolve on build.
- **`L10n.swift`** (`StyleGuide/L10n.swift`) is a public enum that re-exports `LocalizedStringResource` values for use outside the PresentationViews package. Only add a key there if it is needed by the main app target or another package. Strings used only within PresentationViews views must NOT appear in `L10n.swift`.

## SwiftUI View Actions

When a SwiftUI view needs more than one callback, group them into a nested `Action` enum with a single `onAction: (Action) -> Void` parameter. The parent handles it with a `private func handleAction(_ action: SomeView.Action)` containing a switch.

```swift
// In the view:
enum Action {
    case save(Settings)
    case cancel
    case openSettings
}
let onAction: (Action) -> Void

// In the parent screen:
private func handleAction(_ action: SomeView.Action) {
    switch action {
    case .save(let settings): ...
    case .cancel: ...
    case .openSettings: ...
    }
}
```

Apply retroactively if editing a view that already has multiple separate `on*` callbacks.

## Data Layer Naming (DataStores)

API clients describe the server; data stores describe what the caller wants. Don't let one layer's vocabulary leak into the other.

**API clients** are named after the operation on the resource, and return the server's response:

| Operation | Verb | Example |
|---|---|---|
| GET | `fetch` | `fetchSystemStatus()`, `fetchJourneyResults(for:)` |
| Create / register | `register` | `registerDevice(deviceId:pushToken:appVersion:)` |
| PUT (replaces the whole resource) | `replaceAll` | `replaceAllPreferences(deviceId:with:)` |
| PATCH (changes part of it) | `update` | `updatePreferences(deviceId:with:)` |
| DELETE | `delete` | `deleteDevice(deviceId:)` |
| Action endpoints | the action | `enableDevice(deviceId:)`, `disableDevice(deviceId:)` |

**Data stores** update their own state and return nothing for reads. Never use `fetch` or HTTP verbs (`patch`, `put`) in a store's API.

- **`refresh`** brings data the store already holds up to date. Use a pair of named methods rather than a `forced:` flag: `refreshXIfStale()` skips the request while the data is fresh, and `refreshX()` always requests. E.g. `refreshSystemStatusIfStale()` / `refreshSystemStatus()`, `refreshIfStale(for:)` / `refresh(for:)`.
- **`load`** produces new results for a request rather than refreshing held data. E.g. `loadJourneys(modeIDs:)`, `loadMoreJourneys(_:modeIDs:)`.
- **Writes** are named after the caller's intent. E.g. `updateLinePreferences(with:)`, `completeOnboarding(with:)`, `enableDevice()`.

Keep lower-level helpers that only exist for tests `internal`, not `public`; tests reach them through `@testable import`.

## UI Tests (TubeServiceUITests)

UI tests drive the app through page objects in `TubeServiceUITests/Pages/`, one per screen, built on the generic `TubeServiceUITests/Support/` layer.

- **Naming:** the `Page` suffix is reserved for UI test page objects, e.g. `JourneyPlannerPage`. App views are named `…Screen` (main target) or `…View` (PresentationViews), never `…Page`.
- **What a page holds:** element queries, actions that return the page they lead to (`lineStatus.openLine("elizabeth") -> LineDetailPage`), and a `rootElement` that `waitingToAppear(in:)` waits for. Pages don't assert on content; tests do.
- **Finding elements:** by `AccessibilityID` (`Shared/UITesting/AccessibilityID.swift`), never by display text, so tests survive copy changes and localization. Add an identifier only when a page needs it. Put a screen's root identifier on its `List` or `ScrollView`, not on a wrapping container, where it spreads to every child element.
- **Waiting:** use the `Support/` helpers (`waitToExist`, `tapWhenHittable`, …). They fail the test with a clear message rather than silently skipping a step.
- Add pages and actions only when a test needs them.
