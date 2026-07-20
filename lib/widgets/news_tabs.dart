import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

// ─── NewsTabItem ──────────────────────────────────────────────────────────────

/// A single entry in a [NewsTabs] row.
class NewsTabItem {
  const NewsTabItem({required this.icon, required this.label});

  /// 16px glyph shown before [label]. Tint follows selection state.
  final IconData icon;

  /// Tab caption. Also used as the accessibility label.
  final String label;
}

// ─── NewsTabs ─────────────────────────────────────────────────────────────────

/// A single-select, horizontally-scrollable row of [NewsTab]s used to filter
/// the news center (e.g. "All", "Incidents", "News", "Offers").
///
/// The tab at [selectedIndex] is highlighted; tapping another calls
/// [onSelected] with its index. Selection is controlled — the parent owns
/// [selectedIndex]. The row scrolls horizontally when it overflows.
///
/// ```dart
/// NewsTabs(
///   selectedIndex: index,
///   onSelected: (i) => setState(() => index = i),
///   items: const [
///     NewsTabItem(icon: UntitledUI.inbox_01, label: 'All'),
///     NewsTabItem(icon: UntitledUI.alert_triangle, label: 'Incidents'),
///     NewsTabItem(icon: UntitledUI.file_06, label: 'News'),
///     NewsTabItem(icon: UntitledUI.tag_01, label: 'Offers'),
///   ],
/// )
/// ```
class NewsTabs extends StatelessWidget {
  const NewsTabs({
    required this.items,
    required this.selectedIndex,
    this.onSelected,
    this.enabled = true,
    super.key,
  });

  /// Tabs rendered left-to-right.
  final List<NewsTabItem> items;

  /// Index of the currently active tab.
  final int selectedIndex;

  /// Called with the tapped tab's index. The row is non-interactive when null.
  final ValueChanged<int>? onSelected;

  /// When false every tab renders in the disabled state and taps are ignored
  /// (e.g. when there's nothing to filter).
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    assert(
      items.isEmpty || (selectedIndex >= 0 && selectedIndex < items.length),
      'selectedIndex must point to a valid item',
    );

    final theme = Theme.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: theme.spacing.s,
        children: [
          for (var i = 0; i < items.length; i++)
            NewsTab(
              icon: items[i].icon,
              label: items[i].label,
              status: !enabled
                  ? NewsTabStatus.disabled
                  : (i == selectedIndex ? NewsTabStatus.selected : NewsTabStatus.idle),
              onTap: (!enabled || onSelected == null) ? null : () => onSelected!(i),
            ),
        ],
      ),
    );
  }
}
