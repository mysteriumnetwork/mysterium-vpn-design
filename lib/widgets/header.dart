import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:mysterium_vpn_design/widgets/icon_button.dart';

// ─── Header ───────────────────────────────────────────────────────────────────

/// A responsive app-bar header that maintains symmetric leading/trailing padding.
///
/// Horizontal padding is 16 px on mobile and 32 px on desktop. Vertical
/// padding is 12 px on mobile (total height 56) and 16 px on desktop (64).
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
    this.automaticallyImplyLeading,
    this.showBackButton,
    this.backLabel,
    super.key,
  });

  factory Header.logo({
    List<Widget>? actions,
    Color? backgroundColor,
    bool? automaticallyImplyLeading,
    bool? showBackButton,
  }) => Header(
    title: const Logo(height: 24),
    actions: actions,
    backgroundColor: backgroundColor,
    automaticallyImplyLeading: automaticallyImplyLeading,
    showBackButton: showBackButton,
  );

  factory Header.labeled({
    required String label,
    bool centerTitle = true,
    List<Widget>? actions,
    Color? backgroundColor,
    bool? automaticallyImplyLeading,
    bool? showBackButton,
  }) => Header(
    title: Text(label),
    actions: actions,
    centerTitle: centerTitle,
    backgroundColor: backgroundColor,
    automaticallyImplyLeading: automaticallyImplyLeading,
    showBackButton: showBackButton,
  );

  final Widget? title;
  final bool centerTitle;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final bool? automaticallyImplyLeading;
  final bool? showBackButton;

  /// Label shown next to the back-arrow when [title] is null and the navigator
  /// can pop. Defaults to `'Back to home'`.
  final String? backLabel;

  static const double _mobileHeight = 56;
  static const double _desktopHeight = 64;

  static bool _isDesktop(Size screenSize) =>
      ScreenType.fromSize(screenSize) >= ScreenType.tablet;

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
    final toolbarH = isDesktop ? _desktopHeight : _mobileHeight;
    final showBack = showBackButton ?? canGoBack;

    var resolvedTitle = title;
    if (resolvedTitle == null && canGoBack) {
      resolvedTitle = Text(
        backLabel ?? 'Back to home',
        style: theme.textStyles.textMd.semibold.copyWith(
          color: palette.textPrimary,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    return ColoredBox(
      color: resolvedBg,
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.paddingOf(context).top,
          left: hPad,
          right: hPad,
        ),
        child: SizedBox(
          height: toolbarH,
          child: Row(
            spacing: 8,
            children: [
              if (showBack)
                CustomIconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  minimumSize: const Size(32, 32),
                  icon: Icon(
                    UntitledUI.arrow_narrow_left,
                    size: 24,
                    color: palette.iconPrimary,
                  ),
                ),
              if (resolvedTitle != null)
                Expanded(
                  child: DefaultTextStyle(
                    style: theme.textStyles.textLg.medium.copyWith(
                      color: palette.textPrimary,
                    ),
                    child: centerTitle
                        ? Center(child: resolvedTitle)
                        : Align(
                            alignment: Alignment.centerLeft,
                            child: resolvedTitle,
                          ),
                  ),
                )
              else
                const Spacer(),
              if (actions != null) Row(spacing: 16, children: actions!),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize {
    final view = ScreenType.flutterView();
    if (view != null) {
      final size = view.physicalSize / view.devicePixelRatio;
      return Size.fromHeight(_isDesktop(size) ? _desktopHeight : _mobileHeight);
    }
    return const Size.fromHeight(_mobileHeight);
  }
}
