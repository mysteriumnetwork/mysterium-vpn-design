import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

// ─── NavRailItem ──────────────────────────────────────────────────────────────

/// A single icon-only entry rendered inside [NavRail].
class NavRailItem {
  const NavRailItem({required this.icon, this.onTap});

  /// 24 px icon. Tint is driven by selection state.
  final IconData icon;

  /// Called when the item is tapped. Item is non-interactive when `null`.
  final VoidCallback? onTap;
}

// ─── NavRail ──────────────────────────────────────────────────────────────────

/// Narrow vertical navigation rail, 48 px wide, used as the desktop
/// counterpart to [BottomNavBar]. Renders an icon-only column with the
/// selected entry highlighted by [Palette.bgSecondarySelected]. Non-selected
/// interactive items show [Palette.bgPrimaryHover] on mouse hover or
/// keyboard focus.
///
/// The rail expects loose width and bounded height from its parent — it
/// fills its parent's available height and sizes itself to 48 px wide.
/// Place it as a non-flex child of a [Row] alongside an [Expanded] main
/// content area inside a height-bounded ancestor (e.g. a [Scaffold]'s
/// body).
///
/// [NavRail.padding] inside the rail offsets the item column. Defaults to
/// `EdgeInsets.only(top: 86)` so items sit below a typical app header.
///
/// ```dart
/// NavRail(
///   currentIndex: 0,
///   items: [
///     NavRailItem(icon: UntitledUI.map_01,      onTap: () {}),
///     NavRailItem(icon: UntitledUI.star_06,     onTap: () {}),
///     NavRailItem(icon: UntitledUI.settings_01, onTap: () {}),
///   ],
/// )
/// ```
class NavRail extends StatelessWidget {
  const NavRail({
    required this.items,
    required this.currentIndex,
    this.padding = const EdgeInsets.only(top: 86),
    super.key,
  });

  /// Items rendered top-to-bottom with a 40 px gap between them.
  final List<NavRailItem> items;

  /// Index of the currently active item.
  final int currentIndex;

  /// Inner padding wrapping the item column. Defaults to 86 px of top
  /// padding so items sit below a typical app header.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    assert(items.length >= 2, 'NavRail requires at least 2 items');
    assert(
      currentIndex >= 0 && currentIndex < items.length,
      'currentIndex must point to a valid item',
    );

    final theme = Theme.of(context);
    final palette = theme.palette;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.bgPrimary,
        boxShadow: [
          BoxShadow(
            color: palette.shadowSm02,
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: -1,
          ),
          BoxShadow(color: palette.shadowSm01, offset: const Offset(0, 1), blurRadius: 3),
        ],
      ),
      child: SizedBox(
        width: 48,
        height: double.infinity,
        child: Padding(
          padding: padding.add(EdgeInsets.symmetric(horizontal: theme.spacing.s)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: theme.spacing.xl4,
            children: [
              for (var i = 0; i < items.length; i++)
                _NavRailButton(item: items[i], selected: i == currentIndex),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Internal button ──────────────────────────────────────────────────────────

class _NavRailButton extends StatefulWidget {
  const _NavRailButton({required this.item, required this.selected});

  final NavRailItem item;
  final bool selected;

  @override
  State<_NavRailButton> createState() => _NavRailButtonState();
}

class _NavRailButtonState extends State<_NavRailButton> {
  bool _hovered = false;
  bool _focused = false;

  void _setHovered(bool value) {
    if (value == _hovered) {
      return;
    }
    setState(() => _hovered = value);
  }

  void _setFocused(bool value) {
    if (value == _focused) {
      return;
    }
    setState(() => _focused = value);
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).palette;
    final color = widget.selected ? palette.textPrimarySelected : palette.iconTertiary;
    final interactive = widget.item.onTap != null;

    final Color? bg;
    if (widget.selected) {
      bg = palette.bgSecondarySelected;
    } else if (interactive && (_hovered || _focused)) {
      bg = palette.bgPrimaryHover;
    } else {
      bg = null;
    }

    return FocusableActionDetector(
      enabled: interactive,
      mouseCursor: interactive ? SystemMouseCursors.click : MouseCursor.defer,
      onShowHoverHighlight: _setHovered,
      onShowFocusHighlight: _setFocused,
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.item.onTap?.call();
            return null;
          },
        ),
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.item.onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(color: bg, borderRadius: const BorderRadius.all(Radius.kXxs)),
          child: SizedBox.square(
            dimension: 32,
            child: Center(child: Icon(widget.item.icon, size: 24, color: color)),
          ),
        ),
      ),
    );
  }
}
