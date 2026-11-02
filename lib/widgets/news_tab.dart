import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

// ─── Status ───────────────────────────────────────────────────────────────────

/// State variants for [NewsTab].
///
/// Hover is an internal UI concern handled by [NewsTab] via
/// [FocusableActionDetector].
enum NewsTabStatus {
  /// Tab is visible and interactive but not chosen.
  idle,

  /// This tab is the active filter.
  selected,

  /// Tab is non-interactive.
  disabled,
}

// ─── NewsTab ──────────────────────────────────────────────────────────────────

/// A single pill-shaped filter tab (e.g. "All", "Incidents", "News").
///
/// Displays an [icon] next to a [label]. The selected tab is tinted with the
/// brand colour; hover and keyboard focus raise a subtle background on an
/// [NewsTabStatus.idle] tab. Compose several in a [NewsTabs] row, or use
/// directly for a standalone tab.
class NewsTab extends StatefulWidget {
  const NewsTab({
    required this.icon,
    required this.label,
    this.status = NewsTabStatus.idle,
    this.onTap,
    super.key,
  });

  /// Leading glyph. Rendered at 16px.
  final IconData icon;

  /// Tab caption. Also used as the accessibility label.
  final String label;

  /// Selection / interactivity state. Defaults to [NewsTabStatus.idle].
  final NewsTabStatus status;

  /// Called when the tab is tapped. Ignored when [status] is
  /// [NewsTabStatus.disabled] or when null.
  final VoidCallback? onTap;

  @override
  State<NewsTab> createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  static const _height = 36.0;

  // Built once: onInvoke reads widget.onTap lazily, so it stays correct across
  // rebuilds without re-allocating the map/action on every hover or focus tick.
  late final Map<Type, Action<Intent>> _actions = {
    ActivateIntent: CallbackAction<ActivateIntent>(
      onInvoke: (_) {
        widget.onTap?.call();
        return null;
      },
    ),
  };

  bool _hovered = false;
  bool _focused = false;

  bool get _interactive => widget.status != NewsTabStatus.disabled && widget.onTap != null;

  void _setHovered(bool value) {
    if (value != _hovered) {
      setState(() => _hovered = value);
    }
  }

  void _setFocused(bool value) {
    if (value != _focused) {
      setState(() => _focused = value);
    }
  }

  // Disabled uses the Figma `bg-disabled-CTA` background and the lighter
  // `icon-disabled`/`text-disabled` (#A4A7AE) content shade.
  Color _backgroundColor(Palette palette) => switch (widget.status) {
    NewsTabStatus.disabled => palette.bgDisabled,
    NewsTabStatus.selected => palette.bgSecondarySelected,
    NewsTabStatus.idle =>
      (_interactive && (_hovered || _focused)) ? palette.bgPrimaryHover : palette.bgPrimary,
  };

  Color _contentColor(Palette palette) => switch (widget.status) {
    NewsTabStatus.disabled => palette.iconDisabled,
    NewsTabStatus.selected => palette.textPrimarySelected,
    NewsTabStatus.idle => palette.textPrimary,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final contentColor = _contentColor(palette);
    final selected = widget.status == NewsTabStatus.selected;

    return Semantics(
      selected: selected,
      button: _interactive,
      enabled: _interactive,
      label: widget.label,
      onTap: _interactive ? widget.onTap : null,
      excludeSemantics: true,
      child: FocusableActionDetector(
        enabled: _interactive,
        mouseCursor: _interactive ? SystemMouseCursors.click : MouseCursor.defer,
        onShowHoverHighlight: _setHovered,
        onShowFocusHighlight: _setFocused,
        actions: _actions,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _interactive ? widget.onTap : null,
          child: Container(
            height: _height,
            padding: EdgeInsets.symmetric(horizontal: theme.spacing.ms),
            decoration: BoxDecoration(
              color: _backgroundColor(palette),
              borderRadius: const BorderRadius.all(Radius.kS),
              boxShadow: [
                BoxShadow(color: palette.shadowXs, blurRadius: 2, offset: const Offset(0, 1)),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: theme.spacing.xs,
              children: [
                Icon(widget.icon, size: 16, color: contentColor),
                Text(
                  widget.label,
                  maxLines: 1,
                  style: theme.textStyles.textXs.semibold.copyWith(color: contentColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
