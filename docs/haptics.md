# Haptics policy

When a design-system control should vibrate, and when it should stay silent.

## The rule

> **Fire a haptic when the tap changes state in the world or commits something.
> Stay silent when it only moves the user's view.**

Navigating somewhere is not a state change. Tabs, back buttons, close buttons,
chevrons and refresh are silent — they move the view and nothing else.

## Why these tiers

[Apple's HIG][apple] defines exactly three haptic categories, and none of them
is "a button was tapped":

| Category | Apple's meaning |
|---|---|
| Notification (success / warning / error) | "the outcome of a task or action" |
| Impact (light → heavy, rigid, soft) | "a physical metaphor… a view snaps into place" |
| Selection | "feedback while the **values** of a UI element are changing" |

It also warns that a haptic which "can feel just right when it happens
occasionally… become[s] tiresome when it plays frequently", and that the best
haptic is "one that people may not be conscious of, but miss when it's turned
off".

[Android's principles][android] are more permissive — they do sanction "click
feedback for a button press" — but add the rule Apple leaves implicit:
**correlate event importance and frequency with strength.** Frequent events
should be very subtle; "more important events, like refreshing a page or
submitting a form, should be stronger than changing a toggle or scrolling on a
list".

Taken together: reserve feedback for value changes and consequential commits,
and make the consequential ones feel stronger.

## Tiers

| `HapticLevel` | Fires on | Examples here |
|---|---|---|
| `success` / `warning` / `error` | the outcome of a task | tunnel came up; connection failed |
| `impact` | a consequential commit | connect, disconnect, switch country, refresh IP, confirming a warning dialog |
| `selection` | a value changes | location pick, server-preset pick, favourite on/off, checkbox, radio, plan select, picker-sheet option, settings toggle |
| `press` | an ordinary button, where a platform expects click feedback | opt-in only; no DS widget uses it by default |
| `none` | everything else | navigation, chevrons, close/dismiss, refresh, details |

Outcome tiers map to `UINotificationFeedbackGenerator` on iOS and to
`HapticFeedbackConstants.CONFIRM` / `REJECT` on Android (API 30+), via
Flutter's `HapticFeedback.successNotification()` and friends — no plugin
needed. Fire them from the state change itself, never from the button that
started it; the press and the outcome are separate events.

`Button` defaults to `none`. A button is silent unless its author decides the
action is consequential enough to opt in — that is the whole point of the
default. Reserve `impact` for connect/disconnect-class actions.

## Classify by behaviour, not by widget name

Two surfaces were mis-binned on the first pass because their names suggested
the wrong category, so check what a control *does* before filing it:

- `RefreshIconButton` reloads the locations **list** (silent), while the
  connection dialog's "Refresh" rebuilds the tunnel on a new IP (`impact`).
- `IntentTab` is not a tab — it picks a server preset and connects, the same
  act as tapping a location (`selection`).

A picker row is the same trap in reverse: the `SettingsCard` only *opens* the
sheet, so it is silent; the option tapped **inside** the sheet is the value
change, and that is where the feedback belongs.

## Silent by decision

These surfaces are deliberately silent. Listed so a future reader can tell
silence-by-design from silence-by-oversight:

- All navigation — `BottomNavBar`, `NavRail`, `NavItem`, `NewsTab`. Not
  `IntentTab`: despite the name it selects a server preset and connects,
  the same act as tapping a location.
- Settings rows (`SettingsCard` / `GroupedCardShell`) — they navigate
- Expand/collapse chevrons — `ExpandableIpCardHeader`, `PlanCard` features
- Close, back and dismiss buttons in modals, headers and the preview bar
- `RefreshIconButton` (reloads the locations *list* — unlike the connection
  dialog's Refresh, which rebuilds the tunnel and is `impact`), `FloatingButton`,
  connection-details chevron
- `NewsCard`, `PromoBar`, `SearchField`, `InfoPopover`, `MinimalAlert`
- Read-only settings rows — DNS, Kill switch, push-notification permission:
  they display OS-owned state and have no in-app toggle
- The rows that merely open a picker sheet or a confirmation dialog
- The locations datacenter/residential/favourite switcher — it filters which
  list you are browsing, not what you connect to

## Turning it off

`HapticLevel.enabled` is the master switch. The app owns the user-facing
setting (Settings → Haptic feedback) and mirrors it here, because Apple asks
that haptics be optional in-app and not only at the OS level.

It is read when feedback *fires*, not when a callback is wrapped, so flipping
it takes effect immediately rather than at the next rebuild.

## Platforms

Only Android and iOS. Flutter's `HapticFeedback` is unimplemented on the macOS,
Windows and Linux embedders, so `HapticLevel` gates on `defaultTargetPlatform`
and compiles to a pass-through elsewhere. macOS has real trackpad haptics via
Core Haptics, but Apple scopes Mac haptics to dragging and force-click, not
button taps.

## Known limitation: some Android devices feel nothing

Flutter asks Android for one specific `HapticFeedbackConstants` value per tier
and **discards the boolean that says whether it worked**, so when an OEM has
not implemented that constant the tap is silently dropped and there is no
fallback. Confirmed dead on a Galaxy A73; [flutter#73987][flutterbug] reports
the same on A33, M30, S10, S20 Ultra and an Oppo Reno 2F, so it is not
Samsung-only. Raising the system vibration intensity does not help.

Three of our six tiers are API 30+ constants (`CONFIRM` / `REJECT`), the least
consistently implemented, so the outcome tiers are the most exposed.

Diagnosing it is easy because of how the app is built: Material ink widgets
also play Android's touch *click sound*, raw `GestureDetector`s do not. A
tester hearing clicks on Connect and the map while the locations list stays
silent is hearing `Feedback.forTap`, not haptics — those two surfaces have
identical haptic configuration. **Sound-mode feedback is not a pass for this
feature.**

Decided 2026-11-03 not to work around it with a vibration plugin. Driving
`VibrationEffect` directly would bypass the user's system touch-feedback
setting below API 33, which `performHapticFeedback` honours for free, and that
costs more than the feature is worth. The failure mode is silence, not
misbehaviour. `HapticLevel.fire()` is the single call site if this is ever
revisited.

[flutterbug]: https://github.com/flutter/flutter/issues/73987

[apple]: https://developer.apple.com/design/human-interface-guidelines/playing-haptics
[android]: https://developer.android.com/develop/ui/views/haptics/haptics-principles
