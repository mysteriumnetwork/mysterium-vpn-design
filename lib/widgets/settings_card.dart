import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

// ─── Position ─────────────────────────────────────────────────────────────────

/// Position of a settings card within a grouped card list.
///
/// Controls which corners are rounded and whether a bottom separator is drawn.
enum SettingsCardPosition {
  /// The only card in the group — all corners rounded, no border.
  single,

  /// First card in the group — top corners rounded, bottom border.
  top,

  /// Middle card in the group — no rounding, bottom border.
  middle,

  /// Last card in the group — bottom corners rounded, no border.
  bottom,
}

// ─── SettingsCard ─────────────────────────────────────────────────────────────

/// A responsive settings row that adapts its visual style to the current
/// [ScreenType].
///
/// On **desktop** (`tablet` breakpoint and above) the card is transparent and
/// flush — designed to sit inside a larger panel that supplies the background.
///
/// On **mobile** the card is a white surface with a drop shadow — designed to
/// float above the page background colour.
///
/// Stack multiple cards and set the correct [position] to form a grouped
/// settings list with rounded ends and inner separators.
///
/// ```dart
/// Column(
///   children: [
///     SettingsCard(
///       icon: Icon(UntitledUI.user_03, size: 20),
///       title: 'Account',
///       position: SettingsCardPosition.top,
///     ),
///     SettingsCard(
///       icon: Icon(UntitledUI.credit_card_01, size: 20),
///       title: 'My plan',
///       position: SettingsCardPosition.bottom,
///       trailing: GestureDetector(
///         onTap: onManage,
///         child: Text('Manage', style: ...),
///       ),
///     ),
///   ],
/// )
/// ```
class SettingsCard extends StatelessWidget {
  const SettingsCard({
    required this.title,
    this.icon,
    this.subtitle,
    this.subtitleWidget,
    this.trailing,
    this.position = SettingsCardPosition.single,
    super.key,
  });

  /// Optional icon displayed in a leading position.
  /// When `null`, the title fills the available space.
  final Widget? icon;

  /// Primary label for the setting.
  final String title;

  /// Optional secondary label shown beneath [title] in tertiary text colour.
  /// Ignored when [subtitleWidget] is provided.
  final String? subtitle;

  /// Optional widget shown beneath [title], replacing [subtitle].
  /// Use for interactive or specially-styled subtitles (e.g. a link).
  final Widget? subtitleWidget;

  /// Optional widget on the trailing end (e.g. a dropdown, text button,
  /// toggle, or chevron).
  final Widget? trailing;

  /// Controls which corners are rounded and whether a bottom separator is
  /// drawn. Defaults to [SettingsCardPosition.single].
  final SettingsCardPosition position;

  BorderRadius get _borderRadius => switch (position) {
    SettingsCardPosition.single => const BorderRadius.all(Radius.kS),
    SettingsCardPosition.top => const BorderRadius.vertical(top: Radius.kS),
    SettingsCardPosition.middle => BorderRadius.zero,
    SettingsCardPosition.bottom => const BorderRadius.vertical(bottom: Radius.kS),
  };

  bool get _showBottomBorder =>
      position == SettingsCardPosition.top || position == SettingsCardPosition.middle;

  @override
  Widget build(BuildContext context) {
    final isDesktop = ScreenType.of(context) >= ScreenType.tablet;
    final theme = Theme.of(context);
    final palette = theme.palette;
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Container(
          constraints: const BoxConstraints(minHeight: 70),
          decoration: BoxDecoration(
            color: isDesktop ? null : palette.bgPrimary,
            borderRadius: _borderRadius,
            boxShadow: isDesktop
                ? null
                : [BoxShadow(color: palette.shadowXs, blurRadius: 2, offset: const Offset(0, 1))],
          ),
          padding: isDesktop
              ? EdgeInsets.symmetric(vertical: theme.spacing.md)
              : EdgeInsets.all(theme.spacing.md),
          child: Row(
            spacing: theme.spacing.md,
            children: [
              ?icon,
              Expanded(
                child: _TextColumn(
                  title: title,
                  subtitle: subtitle,
                  subtitleWidget: subtitleWidget,
                ),
              ),
              ?trailing,
            ],
          ),
        ),
        if (_showBottomBorder)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(height: 1, color: palette.borderQuaternary),
          ),
      ],
    );
  }
}

// ─── Shared sub-widgets ───────────────────────────────────────────────────────

class _TextColumn extends StatelessWidget {
  const _TextColumn({required this.title, this.subtitle, this.subtitleWidget});

  final String title;
  final String? subtitle;
  final Widget? subtitleWidget;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: theme.spacing.xxs,
      children: [
        Text(
          title,
          style: theme.textStyles.textMd.regular.copyWith(color: palette.textPrimary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (subtitleWidget != null)
          subtitleWidget!
        else if (subtitle != null)
          Text(
            subtitle!,
            style: theme.textStyles.textXs.regular.copyWith(color: palette.textTertiary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }
}
