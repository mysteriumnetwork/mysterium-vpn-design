import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Width reserved on the trailing edge of an [IpCardListItem] so its Plus
/// badge aligns vertically with the Plus badge in its parent
/// [ExpandableIpCardHeader]. Equals Material's `IconButton` enforced tap-
/// target column (48 px) plus the gap between content and chevron
/// (12 px / `spacing.ms`).
const double _chevronColumnWidth = 60;

// ─── Status ───────────────────────────────────────────────────────────────────

/// Connection-state variants shared across all IP card widgets.
///
/// Hover is an internal UI concern handled by each widget via [MouseRegion].
enum IpCardStatus {
  /// Node is available and idle — no active or pending connection.
  idle,

  /// A connection to this location is active.
  connected,

  /// A connection attempt to this location is in progress.
  connecting,

  /// The row is non-interactive (e.g. requires a Plus upgrade).
  disabled,

  /// Data required to determine availability is still loading.
  /// Renders normally but non-interactive, with a trailing loading indicator.
  loading,

  /// This IP address is currently selected (used by [IpCardListItem] only).
  selected,
}

// ─── Item data ────────────────────────────────────────────────────────────────

/// Data for a single city/IP row inside an [ExpandableIpCard].
class IpCardItem {
  const IpCardItem({
    required this.name,
    required this.subtitle,
    this.status = IpCardStatus.idle,
    this.plusUpgrade = false,
    this.onTap,
  });

  final String name;
  final String subtitle;
  final IpCardStatus status;
  final bool plusUpgrade;
  final VoidCallback? onTap;
}

// ─── ExpandableIpCard (composite) ────────────────────────────────────────────

/// A composite expandable card that supports both controlled and uncontrolled
/// expansion state.
///
/// **Uncontrolled** (default): omit [expanded]. The widget self-manages state,
/// seeded by [initiallyExpanded]. Use [onExpansionChanged] to observe changes.
///
/// **Controlled**: provide [expanded]. The widget reflects exactly this value
/// and never mutates its own state — the caller is responsible for updating it
/// in response to [onExpansionChanged].
///
/// Tapping the chevron area expands/collapses. Tapping the content area calls
/// [onConnect], matching the Figma interaction spec.
class ExpandableIpCard extends StatefulWidget {
  const ExpandableIpCard({
    required this.name,
    required this.subtitle,
    required this.countryIcon,
    required this.items,
    this.status = IpCardStatus.idle,
    this.plusUpgrade = false,
    this.expanded,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
    this.onConnect,
    this.searchHighlight,
    super.key,
  });

  final String name;
  final String subtitle;
  final Widget countryIcon;
  final List<IpCardItem> items;
  final IpCardStatus status;
  final bool plusUpgrade;

  /// When non-empty, every case-insensitive occurrence of this string in [name]
  /// (and in each child item's name) is rendered with a highlighted pill.
  final String? searchHighlight;

  /// Controlled expanded state. When non-null the widget is fully controlled
  /// and [initiallyExpanded] is ignored.
  final bool? expanded;

  /// Initial expanded state used only in uncontrolled mode ([expanded] is null).
  final bool initiallyExpanded;

  /// Called when the user taps the chevron. Argument is the new desired state.
  /// In controlled mode the caller must update [expanded]; in uncontrolled mode
  /// the widget updates itself automatically.
  final ValueChanged<bool>? onExpansionChanged;

  /// Called when the user taps the content area (not the chevron).
  final VoidCallback? onConnect;

  bool get _isControlled => expanded != null;

  @override
  State<ExpandableIpCard> createState() => _ExpandableIpCardState();
}

class _ExpandableIpCardState extends State<ExpandableIpCard> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  bool get _effectiveExpanded => widget._isControlled ? widget.expanded! : _expanded;

  void _handleChevronTap() {
    final next = !_effectiveExpanded;
    if (!widget._isControlled) {
      setState(() => _expanded = next);
    }
    widget.onExpansionChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ExpandableIpCardHeader(
        name: widget.name,
        subtitle: widget.subtitle,
        countryIcon: widget.countryIcon,
        status: widget.status,
        expanded: _effectiveExpanded,
        plusUpgrade: widget.plusUpgrade,
        searchHighlight: widget.searchHighlight,
        onChevronTap: widget.items.isEmpty ? null : _handleChevronTap,
        onContentTap: widget.onConnect,
      ),
      if (_effectiveExpanded)
        for (int i = 0; i < widget.items.length; i++)
          IpCardListItem(
            name: widget.items[i].name,
            subtitle: widget.items[i].subtitle,
            status: widget.items[i].status,
            lastInList: i == widget.items.length - 1,
            plusUpgrade: widget.items[i].plusUpgrade,
            searchHighlight: widget.searchHighlight,
            reservesChevronColumn: true,
            onTap: widget.items[i].onTap,
          ),
    ],
  );
}

// ─── ExpandableIpCardHeader ───────────────────────────────────────────────────

/// The collapsible header row for a group of IP address list items.
///
/// Always renders a chevron. The chevron tap expands/collapses; the content
/// area tap triggers the connection action.
class ExpandableIpCardHeader extends StatelessWidget {
  const ExpandableIpCardHeader({
    required this.name,
    required this.subtitle,
    required this.countryIcon,
    required this.status,
    this.expanded = false,
    this.plusUpgrade = false,
    this.searchHighlight,
    this.onChevronTap,
    this.onContentTap,
    super.key,
  });

  final String name;
  final String subtitle;
  final Widget countryIcon;
  final IpCardStatus status;
  final bool expanded;
  final bool plusUpgrade;
  final String? searchHighlight;

  /// Tapping the chevron icon — toggles expanded/collapsed.
  final VoidCallback? onChevronTap;

  /// Tapping anywhere outside the chevron — triggers the connect action.
  final VoidCallback? onContentTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = expanded
        ? const BorderRadius.only(topLeft: Radius.kS, topRight: Radius.kS)
        : const BorderRadius.all(Radius.kS);
    final theme = Theme.of(context);
    final hasChevron = onChevronTap != null;
    final isLoading = status == IpCardStatus.loading;
    final showPlus = plusUpgrade && status != IpCardStatus.selected && !isLoading;
    return _IpCardShell(
      status: status,
      borderRadius: borderRadius,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onContentTap,
              child: Row(
                spacing: theme.spacing.ms,
                children: [
                  _CountryLeadingIcon(status: status, countryIcon: countryIcon),
                  Expanded(
                    child: _TextColumn(
                      name: name,
                      subtitle: subtitle,
                      disabled: status == IpCardStatus.disabled,
                      searchHighlight: searchHighlight,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading) ...[
            SizedBox(width: theme.spacing.ms),
            LoadingIndicator(size: 20, color: theme.palette.iconSecondary),
          ] else if (showPlus) ...[
            SizedBox(width: theme.spacing.ms),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onContentTap,
              child: _PlusBadge(disabled: status == IpCardStatus.disabled),
            ),
          ],
          // Chevron is its own tap target per Figma spec.
          // Hidden when there are no child items to expand.
          if (hasChevron) ...[
            SizedBox(width: theme.spacing.ms),
            IconButton(
              onPressed: isLoading ? null : onChevronTap,
              icon: Icon(
                expanded ? UntitledUI.chevron_up : UntitledUI.chevron_down,
                size: 24,
                color: status == IpCardStatus.disabled
                    ? theme.palette.textDisabled
                    : theme.palette.textPrimary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── IpCardListItem ───────────────────────────────────────────────────────────

/// A leaf-level IP address row inside an expanded [ExpandableIpCardHeader].
///
/// Shows a marker-pin circle (idle/hovered) or a green check circle (selected).
/// Set [lastInList] to true for the final item in a group. Set
/// [reservesChevronColumn] to true when this item lives under an
/// [ExpandableIpCardHeader] with a chevron — the trailing edge is then
/// padded by [_chevronColumnWidth] so the Plus badge aligns vertically
/// with the header's Plus badge.
class IpCardListItem extends StatelessWidget {
  const IpCardListItem({
    required this.name,
    required this.subtitle,
    required this.status,
    this.lastInList = false,
    this.plusUpgrade = false,
    this.searchHighlight,
    this.reservesChevronColumn = false,
    this.onTap,
    super.key,
  });

  final String name;
  final String subtitle;
  final IpCardStatus status;
  final bool lastInList;
  final bool plusUpgrade;
  final String? searchHighlight;
  final bool reservesChevronColumn;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoading = status == IpCardStatus.loading;
    final borderRadius = lastInList
        ? const BorderRadius.only(bottomLeft: Radius.kS, bottomRight: Radius.kS)
        : BorderRadius.zero;
    final row = Row(
      spacing: theme.spacing.ms,
      children: [
        _ListItemMarker(status: status),
        Expanded(
          child: _TextColumn(
            name: name,
            subtitle: subtitle,
            disabled: status == IpCardStatus.disabled,
            searchHighlight: searchHighlight,
          ),
        ),
        if (isLoading)
          LoadingIndicator(size: 20, color: theme.palette.iconSecondary)
        else if (plusUpgrade)
          _PlusBadge(disabled: status == IpCardStatus.disabled),
      ],
    );
    return _IpCardShell(
      status: status,
      borderRadius: borderRadius,
      borderTop: true,
      onTap: onTap,
      child: reservesChevronColumn
          ? Padding(
              padding: const EdgeInsets.only(right: _chevronColumnWidth),
              child: row,
            )
          : row,
    );
  }
}

// ─── Card shell ───────────────────────────────────────────────────────────────

class _IpCardShell extends StatefulWidget {
  const _IpCardShell({
    required this.status,
    required this.borderRadius,
    required this.child,
    this.borderTop = false,
    this.onTap,
  });

  final IpCardStatus status;
  final BorderRadius borderRadius;
  final bool borderTop;

  final VoidCallback? onTap;
  final Widget child;

  @override
  State<_IpCardShell> createState() => _IpCardShellState();
}

class _IpCardShellState extends State<_IpCardShell> {
  bool _hovered = false;

  Color _bgColor(Palette palette) => switch (widget.status) {
    IpCardStatus.disabled => palette.bgSecondaryDisabled,
    _ => _hovered ? palette.bgPrimaryHover : palette.bgPrimary,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _bgColor(palette),
            borderRadius: widget.borderRadius,
            border: widget.borderTop
                ? Border(top: BorderSide(color: palette.borderQuaternary))
                : null,
            boxShadow: const [
              BoxShadow(color: Color(0x0D0A0D12), blurRadius: 2, offset: Offset(0, 1)),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: theme.spacing.md, vertical: theme.spacing.ms),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

// ─── Leading icon for country header / default cards ─────────────────────────

class _CountryLeadingIcon extends StatelessWidget {
  const _CountryLeadingIcon({required this.status, required this.countryIcon});

  final IpCardStatus status;
  final Widget countryIcon;

  @override
  Widget build(BuildContext context) {
    if (status == IpCardStatus.connecting) {
      return LoadingIndicator(color: Theme.of(context).palette.iconPrimary);
    }
    if (status == IpCardStatus.connected) {
      return Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(color: Palette.success, shape: BoxShape.circle),
        child: const Center(child: Icon(UntitledUI.check, size: 16, color: Palette.white)),
      );
    }
    return Opacity(
      opacity: status == IpCardStatus.disabled ? 0.5 : 1.0,
      child: SizedBox(width: 24, height: 24, child: countryIcon),
    );
  }
}

// ─── Marker icon for list items ───────────────────────────────────────────────

class _ListItemMarker extends StatelessWidget {
  const _ListItemMarker({required this.status});

  final IpCardStatus status;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).palette;

    if (status == IpCardStatus.connecting) {
      return LoadingIndicator(color: palette.iconPrimary);
    }
    if (status == IpCardStatus.selected) {
      return Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(color: Palette.success, shape: BoxShape.circle),
        child: const Center(child: Icon(UntitledUI.check, size: 16, color: Palette.white)),
      );
    }
    return Opacity(
      opacity: status == IpCardStatus.disabled ? 0.5 : 1.0,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(color: palette.bgSecondary, shape: BoxShape.circle),
        child: Center(
          child: Icon(UntitledUI.marker_pin_01, size: 16, color: palette.iconSecondary),
        ),
      ),
    );
  }
}

// ─── Text column ─────────────────────────────────────────────────────────────

class _TextColumn extends StatelessWidget {
  const _TextColumn({
    required this.name,
    required this.subtitle,
    required this.disabled,
    this.searchHighlight,
  });

  final String name;
  final String subtitle;
  final bool disabled;
  final String? searchHighlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final nameColor = disabled ? palette.textDisabled : palette.textPrimary;
    final subtitleColor = disabled ? palette.textDisabled : palette.textTertiary;
    final nameStyle = theme.textStyles.textMd.semibold.copyWith(color: nameColor);
    final highlight = searchHighlight;
    final nameWidget = (highlight == null || highlight.isEmpty || disabled)
        ? Text(name, style: nameStyle)
        : Text.rich(
            TextSpan(
              children: _buildHighlightedNameSpans(
                name: name,
                highlight: highlight,
                baseStyle: nameStyle,
                highlightBg: palette.bgSecondarySelected,
                highlightFg: palette.textPrimarySelected,
              ),
            ),
          );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: theme.spacing.xs,
      children: [
        nameWidget,
        Text(subtitle, style: theme.textStyles.textXs.regular.copyWith(color: subtitleColor)),
      ],
    );
  }
}

List<InlineSpan> _buildHighlightedNameSpans({
  required String name,
  required String highlight,
  required TextStyle baseStyle,
  required Color highlightBg,
  required Color highlightFg,
}) {
  final lowerName = name.toLowerCase();
  final lowerHighlight = highlight.toLowerCase();
  final spans = <InlineSpan>[];
  var cursor = 0;
  while (cursor < name.length) {
    final matchStart = lowerName.indexOf(lowerHighlight, cursor);
    if (matchStart < 0) {
      spans.add(TextSpan(text: name.substring(cursor), style: baseStyle));
      break;
    }
    if (matchStart > cursor) {
      spans.add(TextSpan(text: name.substring(cursor, matchStart), style: baseStyle));
    }
    final matchEnd = matchStart + lowerHighlight.length;
    spans.add(
      WidgetSpan(
        alignment: PlaceholderAlignment.baseline,
        baseline: TextBaseline.alphabetic,
        child: _HighlightPill(
          text: name.substring(matchStart, matchEnd),
          textStyle: baseStyle.copyWith(color: highlightFg),
          backgroundColor: highlightBg,
        ),
      ),
    );
    cursor = matchEnd;
  }
  return spans;
}

class _HighlightPill extends StatelessWidget {
  const _HighlightPill({
    required this.text,
    required this.textStyle,
    required this.backgroundColor,
  });

  final String text;
  final TextStyle textStyle;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 2),
    decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(6)),
    child: Text(text, style: textStyle),
  );
}

// ─── Plus upgrade badge ───────────────────────────────────────────────────────

class _PlusBadge extends StatelessWidget {
  const _PlusBadge({required this.disabled});

  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).palette;
    final color = disabled ? palette.textDisabled : palette.textPrimarySelected;
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: Theme.of(context).spacing.xs,
      children: [
        Icon(UntitledUI.stars_02, size: 16, color: color),
        Text('Plus', style: Theme.of(context).textStyles.textXs.medium.copyWith(color: color)),
      ],
    );
  }
}
