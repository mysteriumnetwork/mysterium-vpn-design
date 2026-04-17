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
/// Displays an [icon] in a skeuomorphic container alongside a [label].
/// Hover state is managed internally via [MouseRegion].
class IntentTab extends StatefulWidget {
  const IntentTab({
    required this.icon,
    required this.label,
    this.status = IntentTabStatus.idle,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final IntentTabStatus status;
  final VoidCallback? onTap;

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
    final palette = Theme.of(context).palette;
    final theme = Theme.of(context);
    final contentColor = _contentColor(palette);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.status == IntentTabStatus.disabled ? null : widget.onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _bgColor(palette),
            borderRadius: const BorderRadius.all(Radius.kS),
            boxShadow: [
              BoxShadow(color: palette.shadowXs, blurRadius: 2, offset: const Offset(0, 1)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                Icon(widget.icon, size: 20, color: contentColor),
                Text(
                  widget.label,
                  style: theme.textStyles.textMd.semibold.copyWith(color: contentColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
