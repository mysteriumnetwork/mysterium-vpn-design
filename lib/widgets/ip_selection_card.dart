import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

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
    super.key,
  });

  final String name;
  final String subtitle;
  final Widget countryIcon;
  final List<IpCardItem> items;
  final IpCardStatus status;
  final bool plusUpgrade;

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

  /// Tapping the chevron icon — toggles expanded/collapsed.
  final VoidCallback? onChevronTap;

  /// Tapping anywhere outside the chevron — triggers the connect action.
  final VoidCallback? onContentTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = expanded
        ? const BorderRadius.only(topLeft: Radius.kS, topRight: Radius.kS)
        : const BorderRadius.all(Radius.kS);
    final hasChevron = onChevronTap != null;
    return _IpCardShell(
      status: status,
      borderRadius: borderRadius,
      rightPadding: hasChevron ? 16 : 60,
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onContentTap,
              child: Row(
                spacing: 12,
                children: [
                  _CountryLeadingIcon(status: status, countryIcon: countryIcon),
                  Expanded(
                    child: _TextColumn(
                      name: name,
                      subtitle: subtitle,
                      disabled: status == IpCardStatus.disabled,
                    ),
                  ),
                  if (plusUpgrade &&
                      (status == IpCardStatus.idle ||
                          status == IpCardStatus.connected ||
                          status == IpCardStatus.connecting))
                    const _PlusBadge(disabled: false),
                  if (plusUpgrade && status == IpCardStatus.disabled)
                    const _PlusBadge(disabled: true),
                ],
              ),
            ),
          ),
          // Chevron is its own tap target per Figma spec.
          // Hidden when there are no child items to expand.
          if (onChevronTap != null)
            IconButton(
              onPressed: onChevronTap,
              icon: Icon(
                expanded ? UntitledUI.chevron_up : UntitledUI.chevron_down,
                size: 24,
                color: status == IpCardStatus.disabled
                    ? Theme.of(context).palette.textDisabled
                    : Theme.of(context).palette.textPrimary,
              ),
            ),
        ],
      ),
    );
  }
}

// ─── IpCardListItem ───────────────────────────────────────────────────────────

/// A leaf-level IP address row inside an expanded [ExpandableIpCardHeader].
///
/// Shows a marker-pin circle (idle/hovered) or a green check circle (selected).
/// Set [lastInList] to true for the final item in a group.
class IpCardListItem extends StatelessWidget {
  const IpCardListItem({
    required this.name,
    required this.subtitle,
    required this.status,
    this.lastInList = false,
    this.plusUpgrade = false,
    this.onTap,
    super.key,
  });

  final String name;
  final String subtitle;
  final IpCardStatus status;
  final bool lastInList;
  final bool plusUpgrade;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = lastInList
        ? const BorderRadius.only(bottomLeft: Radius.kS, bottomRight: Radius.kS)
        : BorderRadius.zero;
    return _IpCardShell(
      status: status,
      borderRadius: borderRadius,
      borderTop: true,
      // 44px right reserved area (no trailing icon)
      rightPadding: 60,
      onTap: onTap,
      child: Row(
        spacing: 12,
        children: [
          _ListItemMarker(status: status),
          Expanded(
            child: _TextColumn(
              name: name,
              subtitle: subtitle,
              disabled: status == IpCardStatus.disabled,
            ),
          ),
          if (plusUpgrade) _PlusBadge(disabled: status == IpCardStatus.disabled),
        ],
      ),
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
    this.rightPadding = 16,
    this.onTap,
  });

  final IpCardStatus status;
  final BorderRadius borderRadius;
  final bool borderTop;

  /// Right padding. Defaults to 16 (header with trailing chevron).
  /// Pass 60 for rows without a trailing icon (16 + 44 reserved area).
  final double rightPadding;

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
    final palette = Theme.of(context).palette;
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
            padding: EdgeInsets.fromLTRB(16, 12, widget.rightPadding, 12),
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
  const _TextColumn({required this.name, required this.subtitle, required this.disabled});

  final String name;
  final String subtitle;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final nameColor = disabled ? palette.textDisabled : palette.textPrimary;
    final subtitleColor = disabled ? palette.textDisabled : palette.textTertiary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(name, style: theme.textStyles.textMd.semibold.copyWith(color: nameColor)),
        Text(subtitle, style: theme.textStyles.textXs.regular.copyWith(color: subtitleColor)),
      ],
    );
  }
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
      spacing: 4,
      children: [
        Icon(UntitledUI.stars_02, size: 16, color: color),
        Text('Plus', style: Theme.of(context).textStyles.textXs.medium.copyWith(color: color)),
      ],
    );
  }
}
