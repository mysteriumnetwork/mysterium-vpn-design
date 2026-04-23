import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

// ─── Status ───────────────────────────────────────────────────────────────────

/// State variants for [LocationCard].
///
/// Hover is an internal UI concern handled by [LocationCard] via [MouseRegion].
enum LocationCardStatus {
  /// Card is visible and interactive.
  idle,

  /// This location is the active connection.
  selected,

  /// Card is non-interactive.
  disabled,
}

// ─── LocationCard ─────────────────────────────────────────────────────────────

/// A compact card for a single location entry in a horizontal scroll list.
///
/// Displays a country [icon], location [name], and [subtitle].
/// Hover state is managed internally via [MouseRegion].
class LocationCard extends StatefulWidget {
  const LocationCard({
    required this.icon,
    required this.name,
    required this.subtitle,
    this.status = LocationCardStatus.idle,
    this.onTap,
    super.key,
  });

  final Widget icon;
  final String name;
  final String subtitle;
  final LocationCardStatus status;
  final VoidCallback? onTap;

  @override
  State<LocationCard> createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {
  bool _hovered = false;

  Color _bgColor(Palette palette) => switch (widget.status) {
    LocationCardStatus.disabled => palette.bgSecondaryDisabled,
    _ => _hovered ? palette.bgPrimaryHover : palette.bgPrimary,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final isDisabled = widget.status == LocationCardStatus.disabled;
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 208, maxWidth: 258),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: isDisabled ? null : widget.onTap,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _bgColor(palette),
              borderRadius: const BorderRadius.all(Radius.kS),
              boxShadow: [
                BoxShadow(color: palette.shadowXs, blurRadius: 2, offset: const Offset(0, 1)),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacing.md,
                vertical: theme.spacing.ms,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: theme.spacing.ms,
                children: [
                  _LeadingIcon(status: widget.status, icon: widget.icon),
                  Flexible(
                    child: _TextColumn(
                      name: widget.name,
                      subtitle: widget.subtitle,
                      disabled: isDisabled,
                    ),
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

// ─── Leading icon ─────────────────────────────────────────────────────────────

class _LeadingIcon extends StatelessWidget {
  const _LeadingIcon({required this.status, required this.icon});

  final LocationCardStatus status;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    if (status == LocationCardStatus.selected) {
      return Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(color: Palette.success, shape: BoxShape.circle),
        child: const Center(child: Icon(UntitledUI.wifi, size: 16, color: Palette.white)),
      );
    }
    return Opacity(
      opacity: status == LocationCardStatus.disabled ? 0.5 : 1.0,
      child: SizedBox(width: 24, height: 24, child: icon),
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
      mainAxisSize: MainAxisSize.min,
      spacing: theme.spacing.xs,
      children: [
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textStyles.textMd.semibold.copyWith(color: nameColor),
        ),
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textStyles.textXs.regular.copyWith(color: subtitleColor),
        ),
      ],
    );
  }
}
