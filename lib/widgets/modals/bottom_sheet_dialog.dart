import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

// ─── Show helper ─────────────────────────────────────────────────────────────

/// Presents content as a modal bottom sheet on mobile or a centred dialog on
/// desktop, with automatic design-system theme wrapping.
///
/// Takes a [WidgetBuilder] so the caller has access to the dialog's
/// [BuildContext] (and therefore providers, Navigator, etc.) without
/// needing `ProviderScope.containerOf`.
///
/// ```dart
/// showBottomSheetDialog<void>(
///   context,
///   builder: (context) => BottomSheetDialog(
///     title: 'What didn\'t you like?',
///     body: const Text('Select all that apply.'),
///     primaryButton: ButtonPrimary(
///       onPressed: () => Navigator.pop(context),
///       child: const Text('Submit'),
///     ),
///   ),
/// );
/// ```
FutureOr<T?> showBottomSheetDialog<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool allowDismiss = true,
  ScreenType? screenType,
  BoxConstraints? desktopConstraints,
  BoxConstraints? mobileConstraints,
}) {
  final resolvedScreenType = screenType ?? ScreenType.of(context);
  final isDesktop = resolvedScreenType >= ScreenType.tablet;

  final theme = Theme.of(context);
  final dsTheme = theme.isDesignSystem
      ? theme
      : switch (theme.brightness) {
          Brightness.dark => DesignSystem.darkTheme,
          Brightness.light => DesignSystem.lightTheme,
        };
  final palette = dsTheme.palette;

  Widget applyTheme(BuildContext context, Widget child) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.isDesignSystem
          ? theme
          : switch (theme.brightness) {
              Brightness.dark => DesignSystem.darkTheme,
              Brightness.light => DesignSystem.lightTheme,
            },
      child: child,
    );
  }

  if (isDesktop) {
    return showDialog<T>(
      context: context,
      barrierDismissible: allowDismiss,
      barrierColor: palette.barrierColor,
      builder: (ctx) => Builder(
        builder: (context) => applyTheme(
          context,
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: ConstrainedBox(
                constraints:
                    desktopConstraints ?? const BoxConstraints(maxWidth: 600, maxHeight: 700),
                child: Material(type: MaterialType.transparency, child: builder(ctx)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  return showModalBottomSheet<T>(
    context: context,
    isDismissible: allowDismiss,
    enableDrag: allowDismiss,
    showDragHandle: true,
    isScrollControlled: true,
    backgroundColor: palette.bgPrimary,
    barrierColor: palette.barrierColor,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.kXl)),
    constraints: mobileConstraints ?? const BoxConstraints(maxHeight: 600),
    builder: (ctx) => Builder(builder: (context) => applyTheme(context, builder(ctx))),
  );
}

// ─── BottomSheetDialog ────────────────────────────────────────────────────────

/// An adaptive dialog with a title, scrollable body, and up to two action
/// buttons (primary and secondary).
///
/// - **Mobile**: bottom sheet with a drag handle and rounded top corners.
/// - **Desktop**: centred modal with fully rounded corners and a close button.
///
/// Designed to be shown via [showBottomSheetDialog].
class BottomSheetDialog extends StatelessWidget {
  const BottomSheetDialog({
    required this.title,
    required this.body,
    this.primaryButton,
    this.secondaryButton,
    this.onBack,
    this.onClose,
    super.key,
  });

  final String title;
  final Widget body;

  /// Primary CTA. Mobile: top of stack. Desktop: right side of row.
  final Widget? primaryButton;

  /// Secondary CTA. Mobile: bottom of stack. Desktop: left side of row.
  final Widget? secondaryButton;

  /// Called when the mobile back button is tapped. Defaults to
  /// [Navigator.pop] when null.
  final VoidCallback? onBack;

  /// Called when the desktop close button is tapped. Defaults to
  /// [Navigator.pop] when null.
  final VoidCallback? onClose;

  bool get _hasButtons => primaryButton != null || secondaryButton != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = ScreenType.of(context) >= ScreenType.tablet;

    final column = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isDesktop)
          _DesktopHeader(title: title, onClose: onClose)
        else ...[
          _MobileHeader(title: title, onBack: onBack),
          Divider(color: theme.palette.borderQuaternary),
        ],
        Flexible(
          child: CustomScrollView(
            shrinkWrap: true,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  theme.spacing.xl2,
                  theme.spacing.md,
                  theme.spacing.xl2,
                  theme.spacing.s,
                ),
                sliver: SliverToBoxAdapter(child: body),
              ),
            ],
          ),
        ),
        if (_hasButtons)
          _Buttons(
            primaryButton: primaryButton,
            secondaryButton: secondaryButton,
            isDesktop: isDesktop,
          ),
        if (!isDesktop) SafeArea(top: false, child: SizedBox(height: theme.spacing.md)),
      ],
    );

    if (isDesktop) {
      return ClipRRect(
        borderRadius: BorderRadius.all(theme.radius.xl),
        child: ColoredBox(color: theme.palette.bgPrimary, child: column),
      );
    }

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.kXl),
      child: ColoredBox(color: theme.palette.bgPrimary, child: column),
    );
  }
}

// ─── Mobile header ────────────────────────────────────────────────────────────

class _MobileHeader extends StatelessWidget {
  const _MobileHeader({required this.title, this.onBack});

  final String title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(theme.spacing.md, 0, theme.spacing.md, theme.spacing.s),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack ?? Navigator.of(context).pop,
            icon: const Icon(UntitledUI.chevron_left),
            iconSize: 24,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
          ),
          Expanded(
            child: Text(title, style: theme.textStyles.textMd.medium, textAlign: TextAlign.center),
          ),
          const SizedBox(width: 40), // to balance the back button and keep title centered
        ],
      ),
    );
  }
}

// ─── Desktop header ───────────────────────────────────────────────────────────

class _DesktopHeader extends StatelessWidget {
  const _DesktopHeader({required this.title, this.onClose});

  final String title;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: theme.spacing.xl2, vertical: theme.spacing.xl2),
      child: Row(
        children: [
          const SizedBox(width: 28), // to balance the close button and keep title centered
          Expanded(
            child: Text(title, style: theme.textStyles.textMd.medium, textAlign: TextAlign.center),
          ),
          IconButton(
            onPressed: onClose ?? Navigator.of(context).pop,
            icon: const Icon(UntitledUI.x_close),
            iconSize: 24,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

// ─── Buttons ──────────────────────────────────────────────────────────────────

class _Buttons extends StatelessWidget {
  const _Buttons({required this.isDesktop, this.primaryButton, this.secondaryButton});

  final Widget? primaryButton;
  final Widget? secondaryButton;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        theme.spacing.xl2,
        theme.spacing.s,
        theme.spacing.xl2,
        theme.spacing.md,
      ),
      child: isDesktop ? _DesktopButtons(this) : _MobileButtons(this),
    );
  }
}

class _MobileButtons extends StatelessWidget {
  const _MobileButtons(this.data);
  final _Buttons data;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: Theme.of(context).spacing.s,
    children: [?data.primaryButton, ?data.secondaryButton],
  );
}

class _DesktopButtons extends StatelessWidget {
  const _DesktopButtons(this.data);
  final _Buttons data;

  @override
  Widget build(BuildContext context) => Row(
    spacing: Theme.of(context).spacing.s,
    children: [
      if (data.secondaryButton case final btn?) Expanded(child: btn),
      if (data.primaryButton case final btn?) Expanded(child: btn),
    ],
  );
}
