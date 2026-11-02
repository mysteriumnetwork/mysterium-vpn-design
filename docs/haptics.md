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
| `impact` | a consequential commit | connect, disconnect, switch country |
| `selection` | a value changes | location pick, favourite on/off, checkbox, radio, plan select |
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

## Silent by decision

These surfaces are deliberately silent. Listed so a future reader can tell
silence-by-design from silence-by-oversight:

- All navigation — `BottomNavBar`, `NavRail`, `NavItem`, `IntentTab`, `NewsTab`
- Settings rows (`SettingsCard` / `GroupedCardShell`) — they navigate
- Expand/collapse chevrons — `ExpandableIpCardHeader`, `PlanCard` features
- Close, back and dismiss buttons in modals, headers and the preview bar
- `RefreshIconButton`, `FloatingButton`, connection-details chevron
- `NewsCard`, `PromoBar`, `SearchField`, `InfoPopover`, `MinimalAlert`

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

[apple]: https://developer.apple.com/design/human-interface-guidelines/playing-haptics
[android]: https://developer.android.com/develop/ui/views/haptics/haptics-principles
