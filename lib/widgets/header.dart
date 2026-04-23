import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:mysterium_vpn_design/widgets/icon_button.dart';

// ─── Header ───────────────────────────────────────────────────────────────────

/// A responsive app-bar header with symmetric horizontal padding.
///
/// Horizontal padding is 16 px on mobile and 32 px on desktop. Content is
/// vertically centred within a fixed height of 64 px.
///
/// Use the named factories for common configurations:
/// * [Header.logo] — logo in the title slot
/// * [Header.labeled] — centred text label
///
/// ```dart
/// Header.logo(actions: [helpButton])
/// Header.labeled(label: 'Theme', actions: [helpButton])
/// Header(backLabel: 'Back to home', actions: [helpButton])
/// ```
class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({
    this.centerTitle = false,
    this.title,
    this.actions,
    this.backgroundColor,
    this.showBackButton,
    this.backLabel,
    this.onBackPressed,
    super.key,
  });

  factory Header.logo({
    bool centerTitle = false,
    List<Widget>? actions,
    Color? backgroundColor,
    bool? showBackButton,
    VoidCallback? onBackPressed,
  }) => Header(
    title: const Logo(height: 24),
    centerTitle: centerTitle,
    actions: actions,
    backgroundColor: backgroundColor,
    showBackButton: showBackButton,
    onBackPressed: onBackPressed,
  );

  factory Header.labeled({
    required String label,
    bool centerTitle = true,
    List<Widget>? actions,
    Color? backgroundColor,
    bool? showBackButton,
    VoidCallback? onBackPressed,
  }) => Header(
    title: Text(label),
    actions: actions,
    centerTitle: centerTitle,
    backgroundColor: backgroundColor,
    showBackButton: showBackButton,
    onBackPressed: onBackPressed,
  );

  final Widget? title;
  final bool centerTitle;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final bool? showBackButton;

  /// Label shown next to the back-arrow when [title] is null and the navigator
  /// can pop. Defaults to `'Back to home'`.
  final String? backLabel;

  /// Called when the back button is tapped. Falls back to
  /// `Navigator.of(context).maybePop()` when null.
  final VoidCallback? onBackPressed;

  static const double _height = 64;

  @override
  Widget build(BuildContext context) {
    final canGoBack = Navigator.of(context).canPop();
    final isDesktop = ScreenType.of(context) >= ScreenType.tablet;
    final theme = Theme.of(context);
    final palette = theme.palette;
    final resolvedBg = backgroundColor ?? (isDesktop ? palette.bgSidePanel : palette.bgPrimary);
    final hPad = isDesktop ? theme.spacing.xl3 : theme.spacing.md;
    final showBack = showBackButton ?? canGoBack;

    final isBackLabel = showBack && title == null;
    var resolvedTitle = title;
    if (resolvedTitle == null && showBack) {
      resolvedTitle = Text(
        backLabel ?? 'Back to home',
        style: theme.textStyles.textMd.semibold.copyWith(color: palette.textPrimary),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
    final backAction = onBackPressed ?? () => Navigator.of(context).maybePop();

    return ColoredBox(
      color: resolvedBg,
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top, left: hPad, right: hPad),
        child: SizedBox(
          height: _height,
          child: Row(
            spacing: theme.spacing.s,
            children: [
              if (showBack)
                CustomIconButton(
                  onPressed: backAction,
                  minimumSize: const Size(32, 32),
                  icon: Icon(UntitledUI.arrow_narrow_left, size: 24, color: palette.iconPrimary),
                ),
              if (resolvedTitle != null)
                Expanded(
                  child: GestureDetector(
                    onTap: isBackLabel ? backAction : null,
                    behavior: isBackLabel ? HitTestBehavior.opaque : HitTestBehavior.deferToChild,
                    child: DefaultTextStyle(
                      style: theme.textStyles.textLg.medium.copyWith(color: palette.textPrimary),
                      child: centerTitle
                          ? Center(child: resolvedTitle)
                          : Align(alignment: Alignment.centerLeft, child: resolvedTitle),
                    ),
                  ),
                )
              else
                const Spacer(),
              if (actions != null) Row(spacing: theme.spacing.md, children: actions!),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(_height);
}
