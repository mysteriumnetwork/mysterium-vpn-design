# CLAUDE.md

Guidance for working in this repo — the **Mysterium VPN design system** (`mysterium_vpn_design`), a Flutter package of reusable UI components plus a companion Widgetbook app for previewing them.

## Repository layout

```
lib/
  mysterium_vpn_design.dart     # package barrel (exports styles, icons, widgets, utils)
  widgets/                      # ← components live here, one file per component
    widgets.dart                # widgets barrel — every component is re-exported here
  styles/                       # design tokens (ThemeExtensions)
    colors/palette.dart         # Palette + PaletteLight + PaletteDark
    dimensions/spacing.dart     # Spacing (xxs..xl10)
    dimensions/radius.dart      # Radius (kXs, kS, kM, ... kFull, custom())
    typography/text_styles.dart # TextStyles (textXs..displayXlg × regular/medium/semibold/bold)
    design_system.dart          # DesignSystem.lightTheme / darkTheme
  icons/untitled_ui.dart        # UntitledUI.* — font-based icon set (snake_case names)
test/
  widgets/<name>_test.dart      # widget tests, one per component
  helpers/pump_widget.dart      # pumpWidget(...) test harness (themed MaterialApp)
widgetbook/                     # separate Flutter app (package: widgetbook_workspace)
  lib/widgets/<name>.dart       # @UseCase entries, one file per component
  lib/widgetbook_utils.dart     # WidgetbookUtils (shared knob helpers, icon maps)
  Makefile                      # `make generate` (build_runner codegen)
```

## Tooling

- **Flutter is pinned via FVM** (`.fvmrc` → 3.44.7). **Always prefix Dart/Flutter commands with `fvm`.**
- **Prefer existing Makefile targets over raw commands** where one exists (only `widgetbook/Makefile` today).
- There is **no root Makefile**. The root package and the `widgetbook/` app are analyzed/tested separately.

## Adding a new widget — the checklist

Every new component (or new state/variant of one) ships as **widget + Widgetbook use-case + tests + documentation**. Follow these steps in order:

1. **Create the component** — `lib/widgets/<name>.dart` (snake_case file, `PascalCase` class).
   - Mirror an existing sibling: e.g. `app_badge.dart` (simple), `intent_tab.dart` / `location_card.dart` (stateful + hover), `bottom_nav_bar.dart` (controlled selection with an item model).
   - Read tokens from the theme — **never hardcode colours, spacing, radii, or text styles**:
     ```dart
     final theme = Theme.of(context);
     final palette = theme.palette;
     // palette.textPrimary, theme.spacing.md, theme.radius.full,
     // theme.textStyles.textSm.semibold, ...
     ```
   - Must be **theme-aware** (correct in both light and dark).
   - Declare variant `enum`s in the same file, `PascalCase` name (component-prefixed) with doc comments; drive per-variant styling with `switch` expressions in private helpers.
   - Split large components into private `_SubWidget`s within the file.
   - Icons come from the font set: `UntitledUI.<name>` (e.g. `UntitledUI.file_06`).
   - **This is a design-system package — do not add localization.** All user-facing strings are passed in by the caller as parameters.

2. **Add design tokens if needed** — `lib/styles/`.
   - New colour → add to `lib/styles/colors/palette.dart`: an `abstract final Color` on `Palette` **and** an implementation in both `PaletteLight` and `PaletteDark` (reference a `PaletteColor` swatch shade where possible).
   - A colour that is identical in both themes → a `static const` on the base `Palette` (like `Palette.white` / `Palette.unreadIndicator`), not a themed getter.
   - Off-scale radius → `Radius.custom(value)`; otherwise use the scale (`Radius.kS` etc.).

3. **Export it** — add `export '<name>.dart';` to `lib/widgets/widgets.dart` (keep alphabetical).

4. **Add a Widgetbook use-case** — `widgetbook/lib/widgets/<name>.dart`.
   - Annotate builder functions with `@UseCase(name: '...', type: <Widget>)`; expose variants/state via `context.knobs`.
   - Reuse `WidgetbookUtils` (e.g. `WidgetbookUtils.newsCategoryIcons`) instead of re-declaring shared fixtures.
   - Use **`package:` imports** (widgetbook lints enforce `always_use_package_imports`), e.g. `import 'package:widgetbook_workspace/widgetbook_utils.dart';`.
   - Then regenerate the registry:
     ```bash
     cd widgetbook && make generate   # fvm dart run build_runner build --delete-conflicting-outputs
     ```
   - `widgetbook/lib/main.directories.g.dart` is generated (gitignored) — never edit it by hand; re-run `make generate` after adding/removing a `@UseCase`.

5. **Write tests** — `test/widgets/<name>_test.dart`.
   - Use the shared harness: `import '../helpers/pump_widget.dart';` then `await pumpWidget(tester, <widget>);` (pass `theme: DesignSystem.darkTheme` to cover dark mode).
   - Cover each variant/state, interactions (`onTap`, selection), and a dark-theme render.

6. **Document it** — dartdoc (`///`) on the public class and every public parameter: what it is, how to use it, and what each state/variant means. Add a ````dart` usage example for non-trivial components. Keep it well-documented and readable.

## Commands (quality gates)

Run before considering a change done — these mirror CI (`.github/workflows/ci.yml`):

```bash
# Root package (lib/ + test/)
fvm flutter pub get
fvm flutter analyze --fatal-infos      # MUST be clean — infos fail CI
fvm flutter test

# Widgetbook app (analyzed separately; excluded from the root analyzer)
cd widgetbook
fvm flutter pub get
make generate
fvm flutter analyze --fatal-infos
```

CI runs `analyze --fatal-infos` + `test` on the root package, and `make generate` + `analyze --fatal-infos` + `flutter build web` on the widgetbook app. **`--fatal-infos` means info-level lints (including unresolved dartdoc references like `[Foo]`) fail the build** — use backticks for symbols that aren't imported/in scope.

## Formatting

Format with a **100-column** line length before committing:

```bash
fvm dart format . --line-length 100
```

The code uses trailing commas (`require_trailing_commas` lint); the formatter respects them. Configure your editor's Dart formatter to line length 100 to match.

## Conventions recap

- `fvm` on every Dart/Flutter command.
- Tokens only — no hardcoded colours/spacing/radii/typography; theme-aware light + dark.
- One component per file; `snake_case` filename ↔ `PascalCase` class ↔ matching test and Widgetbook file names.
- A new widget or state variant **always** gets a Widgetbook use-case.
- No localization in this package — strings are caller-supplied.
