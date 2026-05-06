import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

// ─── Status ───────────────────────────────────────────────────────────────────

/// State variants for [IntentTab].
///
/// Hover is an internal UI concern handled by [IntentTab] via [MouseRegion].
enum IntentTabStatus {
  /// Tab is visible and interactive but not chosen.
  idle,

  /// This tab is the active preference.
  selected,

  /// Tab is non-interactive.
  disabled,
}

// ─── IntentTab ────────────────────────────────────────────────────────────────

/// A single preference-selection tab (e.g. "Low latency", "High privacy").
///
/// Displays a plain [Icon] alongside a [label].
/// Hover state is managed internally via [MouseRegion].
class IntentTab extends StatefulWidget {
  const IntentTab({
    required IconData this.icon,
    required String this.label,
    this.status = IntentTabStatus.idle,
    this.onTap,
    super.key,
  }) : isPlaceholder = false,
       width = null;

  /// Empty disabled-style frame used as a loading or unavailable state.
  ///
  /// Renders only the card surface (background, radius, shadow) at the
  /// same outer height as a populated tab. Pass [width] to mimic the
  /// width of the eventual content; otherwise the parent must constrain
  /// the horizontal size.
  const IntentTab.placeholder({this.width, super.key})
    : icon = null,
      label = null,
      status = IntentTabStatus.disabled,
      onTap = null,
      isPlaceholder = true;

  final IconData? icon;
  final String? label;
  final IntentTabStatus status;
  final VoidCallback? onTap;

  /// True when this is a [IntentTab.placeholder] instance.
  final bool isPlaceholder;

  /// Optional placeholder width. Only used by [IntentTab.placeholder].
  final double? width;

  @override
  State<IntentTab> createState() => _IntentTabState();
}

class _IntentTabState extends State<IntentTab> {
  bool _hovered = false;

  Color _bgColor(Palette palette) => switch (widget.status) {
    IntentTabStatus.disabled => palette.bgSecondaryDisabled,
    IntentTabStatus.selected => palette.bgSecondarySelected,
    _ => _hovered ? palette.bgPrimaryHover : palette.bgPrimary,
  };

  Color _contentColor(Palette palette) => switch (widget.status) {
    IntentTabStatus.disabled => palette.textDisabled,
    IntentTabStatus.selected => palette.textPrimarySelected,
    _ => palette.textPrimary,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;

    final surface = DecoratedBox(
      decoration: BoxDecoration(
        color: _bgColor(palette),
        borderRadius: const BorderRadius.all(Radius.kS),
        boxShadow: [BoxShadow(color: palette.shadowXs, blurRadius: 2, offset: const Offset(0, 1))],
      ),
      child: widget.isPlaceholder
          ? const SizedBox(height: 44)
          : Padding(
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacing.md,
                vertical: theme.spacing.lg,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: theme.spacing.xs,
                children: [
                  Icon(widget.icon, size: 20, color: _contentColor(palette)),
                  Text(
                    widget.label!,
                    style: theme.textStyles.textMd.semibold.copyWith(color: _contentColor(palette)),
                  ),
                ],
              ),
            ),
    );

    if (widget.isPlaceholder) {
      return SizedBox(width: widget.width, child: surface);
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.status == IntentTabStatus.disabled ? null : widget.onTap,
        child: surface,
      ),
    );
  }
}
