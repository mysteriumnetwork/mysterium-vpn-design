import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

// ─── Header ───────────────────────────────────────────────────────────────────

/// A responsive app-bar header with symmetric horizontal padding.
///
/// Horizontal padding is 16 px on mobile and 32 px on desktop. Content is
/// vertically centred within a fixed height of 64 px.
///
/// ```dart
/// Header.logo(actions: [helpButton])
/// Header(backLabel: 'Back to home', actions: [helpButton])
/// ```
class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({
    this.title,
    this.actions,
    this.backgroundColor,
    this.showBackButton,
    this.backLabel,
    this.onBackPressed,
    super.key,
  });

  factory Header.logo({
    List<Widget>? actions,
    Color? backgroundColor,
    bool? showBackButton,
    VoidCallback? onBackPressed,
  }) => Header(
    title: const Logo(height: 24),
    actions: actions,
    backgroundColor: backgroundColor,
    showBackButton: showBackButton,
    onBackPressed: onBackPressed,
  );

  final Widget? title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final bool? showBackButton;

  /// Label shown next to the back-arrow when [title] is null. When `null`,
  /// only the back arrow is rendered (no label). Callers are responsible for
  /// providing a localised string.
  final String? backLabel;

  /// Called when the back button is tapped. Falls back to
  /// `Navigator.of(context).maybePop()` when null.
  final VoidCallback? onBackPressed;

  /// Visible header height in logical pixels (excluding any top safe-area inset).
  static const double height = 64;

  @override
  Widget build(BuildContext context) {
    final canGoBack = Navigator.of(context).canPop();
    final isDesktop = ScreenType.of(context) >= ScreenType.tablet;
    final theme = Theme.of(context);
    final palette = theme.palette;
    final resolvedBg =
        backgroundColor ??
        (isDesktop ? palette.bgSidePanel : palette.bgPrimary);
    final hPad = isDesktop ? theme.spacing.xl3 : theme.spacing.md;
    final showBack = showBackButton ?? canGoBack;

    final backAction = onBackPressed ?? () => Navigator.of(context).maybePop();

    return Material(
      color: resolvedBg,
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.paddingOf(context).top,
          left: hPad,
          right: hPad,
        ),
        child: SizedBox(
          height: height,
          child: Row(
            spacing: theme.spacing.s,
            children: [
              if (backLabel case final label? when showBack && title == null)
                TextButton.icon(
                  onPressed: backAction,
                  icon: const Icon(UntitledUI.arrow_narrow_left, size: 24),
                  label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
                  style: TextButton.styleFrom(
                    foregroundColor: palette.textPrimary,
                    iconColor: palette.iconPrimary,
                    textStyle: theme.textStyles.textMd.semibold,
                  ),
                )
              else if (showBack)
                IconButton(
                  onPressed: backAction,
                  icon: Icon(
                    UntitledUI.arrow_narrow_left,
                    size: 24,
                    color: palette.iconPrimary,
                  ),
                ),
              if (title case final t?)
                Expanded(
                  child: DefaultTextStyle(
                    style: theme.textStyles.textLg.medium.copyWith(
                      color: palette.textPrimary,
                    ),
                    child: Align(alignment: Alignment.centerLeft, child: t),
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
  Size get preferredSize => const Size.fromHeight(height);
}
