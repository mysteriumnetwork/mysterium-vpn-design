import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

// ─── NavItem ──────────────────────────────────────────────────────────────────

/// A sidebar navigation item consisting of a leading [icon], a [label], and
/// an optional current/active state.
///
/// Hover is handled internally via [MouseRegion]. Set [current] to `true` to
/// render the item with the brand-selected background and text colour.
///
/// The widget fills its parent width — constrain from the outside (e.g. to
/// 272 px for a standard sidebar).
///
/// ```dart
/// NavItem(
///   icon: const Icon(UntitledUI.settings_03),
///   label: 'Settings',
///   current: true,
///   onTap: () => navigateTo(AppRoute.settings),
/// )
/// ```
class NavItem extends StatefulWidget {
  const NavItem({
    required this.icon,
    required this.label,
    this.current = false,
    this.onTap,
    this.trailing,
    super.key,
  });

  /// Icon widget tinted and themed at 24 px via [IconTheme].
  ///
  /// No fixed-size container is applied — the icon is only constrained by its
  /// own intrinsic size and the surrounding [IconThemeData.size].
  /// Colour is driven by [current]: brand icon when active, tertiary when not.
  /// Pass an [Icon] without an explicit colour to let [NavItem] tint it.
  final Widget icon;

  /// Navigation label shown next to the icon.
  final String label;

  /// Whether this item represents the currently active route.
  ///
  /// When `true` the item renders with [Palette.bgSecondarySelected] background
  /// and [Palette.textPrimarySelected] text/icon colour. Defaults to `false`.
  final bool current;

  /// Called when the item is tapped.
  final VoidCallback? onTap;

  /// Optional widget anchored to the trailing edge (e.g. an external-link icon).
  final Widget? trailing;

  @override
  State<NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> {
  bool _hovered = false;

  bool get _interactive => widget.onTap != null;

  Color _bgColor(Palette palette) {
    if (widget.current) {
      return palette.bgSecondarySelected;
    }
    if (_hovered && _interactive) {
      return palette.bgPrimaryHover;
    }
    return Palette.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final color = widget.current ? palette.textPrimarySelected : palette.textTertiary;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: theme.spacing.xs),
      child: MouseRegion(
        cursor: _interactive ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: _interactive ? (_) => setState(() => _hovered = true) : null,
        onExit: _interactive ? (_) => setState(() => _hovered = false) : null,
        child: GestureDetector(
          onTap: widget.onTap,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _bgColor(palette),
              borderRadius: const BorderRadius.all(Radius.kXs),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacing.ms,
                vertical: theme.spacing.s,
              ),
              child: Row(
                spacing: theme.spacing.s,
                children: [
                  _NavIcon(icon: widget.icon, color: color),
                  Flexible(
                    child: Text(
                      widget.label,
                      style: theme.textStyles.textMd.semibold.copyWith(color: color),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ?widget.trailing,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Nav icon ─────────────────────────────────────────────────────────────────

class _NavIcon extends StatelessWidget {
  const _NavIcon({required this.icon, required this.color});

  final Widget icon;
  final Color color;

  @override
  Widget build(BuildContext context) => IconTheme(
    data: IconThemeData(color: color, size: 24),
    child: icon,
  );
}
