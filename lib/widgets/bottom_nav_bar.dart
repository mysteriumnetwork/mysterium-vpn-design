import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

// ─── BottomNavBarItem ─────────────────────────────────────────────────────────

/// A single tab rendered inside [BottomNavBar].
class BottomNavBarItem {
  const BottomNavBarItem({required this.icon, required this.label});

  /// 20 px icon shown above [label]. Tint is driven by selection state.
  final IconData icon;

  /// Short caption rendered below [icon] using `textXs.semibold`. Also used
  /// as the accessibility label.
  final String label;
}

// ─── BottomNavBar ─────────────────────────────────────────────────────────────

/// Horizontal bottom navigation bar with two or more evenly distributed
/// [items]. The bar fills its parent width.
///
/// Each cell's full slice (icon, label, and the gap between/around them) is
/// tappable. Cells show a [Palette.bgSidePanelHover] background on mouse
/// hover or keyboard focus when they are not already selected. No tooltips
/// are rendered.
///
/// The item at [selectedIndex] renders with [Palette.textPrimarySelected];
/// the rest use [Palette.textTertiary].
///
/// Content is wrapped in a [SafeArea] (top disabled) so cells clear the iOS
/// home indicator and Android gesture/system navigation. The background
/// still paints behind the inset.
///
/// ```dart
/// BottomNavBar(
///   selectedIndex: 0,
///   onDestinationSelected: (i) => ...,
///   items: const [
///     BottomNavBarItem(icon: UntitledUI.map_01,      label: 'Map'),
///     BottomNavBarItem(icon: UntitledUI.flag_01,     label: 'Locations'),
///     BottomNavBarItem(icon: UntitledUI.star_06,     label: 'Products'),
///     BottomNavBarItem(icon: UntitledUI.settings_01, label: 'Settings'),
///   ],
/// )
/// ```
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    required this.items,
    required this.selectedIndex,
    this.onDestinationSelected,
    super.key,
  });

  /// Items rendered left-to-right. Each takes an equal flex share.
  final List<BottomNavBarItem> items;

  /// Index of the currently active item.
  final int selectedIndex;

  /// Called with the tapped item's index. The bar is non-interactive when
  /// `null`.
  final ValueChanged<int>? onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    assert(items.length >= 2, 'BottomNavBar requires at least 2 items');
    assert(
      selectedIndex >= 0 && selectedIndex < items.length,
      'selectedIndex must point to a valid item',
    );

    final theme = Theme.of(context);
    final palette = theme.palette;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.bgSidePanel,
        border: Border(top: BorderSide(color: palette.borderSecondary)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            top: theme.spacing.s,
            bottom: theme.spacing.md,
            left: theme.spacing.s,
            right: theme.spacing.s,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _BottomNavBarCell(
                    item: items[i],
                    selected: i == selectedIndex,
                    onTap: onDestinationSelected == null ? null : () => onDestinationSelected!(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Internal cell ────────────────────────────────────────────────────────────

class _BottomNavBarCell extends StatefulWidget {
  const _BottomNavBarCell({required this.item, required this.selected, required this.onTap});

  final BottomNavBarItem item;
  final bool selected;
  final VoidCallback? onTap;

  @override
  State<_BottomNavBarCell> createState() => _BottomNavBarCellState();
}

class _BottomNavBarCellState extends State<_BottomNavBarCell> {
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
    final theme = Theme.of(context);
    final palette = theme.palette;
    final color = widget.selected ? palette.textPrimarySelected : palette.textTertiary;
    final interactive = widget.onTap != null;
    final showHighlight = interactive && !widget.selected && (_hovered || _focused);

    return Semantics(
      selected: widget.selected,
      button: interactive,
      enabled: interactive,
      label: widget.item.label,
      onTap: widget.onTap,
      excludeSemantics: true,
      child: FocusableActionDetector(
        enabled: interactive,
        mouseCursor: interactive ? SystemMouseCursors.click : MouseCursor.defer,
        onShowHoverHighlight: _setHovered,
        onShowFocusHighlight: _setFocused,
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onTap?.call();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: showHighlight ? palette.bgSidePanelHover : null,
              borderRadius: const BorderRadius.all(Radius.kS),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacing.s,
                vertical: theme.spacing.xs,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: theme.spacing.xs,
                children: [
                  Icon(widget.item.icon, size: 20, color: color),
                  Text(
                    widget.item.label,
                    style: theme.textStyles.textXs.semibold.copyWith(color: color),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
