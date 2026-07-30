import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// A compact key/value row for detail lists (e.g. the connection details
/// dialog).
///
/// Unlike [SettingsCard] it keeps the elevated card look on every
/// [ScreenType] and uses a denser 48px row height. Stack multiple rows and
/// set the correct [position] to form a grouped list with rounded ends and
/// inner separators.
///
/// ```dart
/// Column(
///   children: [
///     DetailCard(title: 'VPN IP', value: '195.285.15.404', position: SettingsCardPosition.top),
///     DetailCard(title: 'IP type', value: 'High-speed', position: SettingsCardPosition.bottom),
///   ],
/// )
/// ```
class DetailCard extends StatelessWidget {
  const DetailCard({
    required this.title,
    this.value,
    this.valueMuted = false,
    this.valueIcon,
    this.trailing,
    this.position = SettingsCardPosition.single,
    super.key,
  });

  /// Row label, rendered at the leading edge.
  final String title;

  /// Optional value text rendered at the trailing edge.
  final String? value;

  /// When true, [value] uses the tertiary text colour (e.g. "Hidden").
  final bool valueMuted;

  /// Optional icon rendered just before [value] (e.g. an eye-off icon).
  final Widget? valueIcon;

  /// Optional widget rendered after [value] (e.g. a refresh action).
  final Widget? trailing;

  /// Controls which corners are rounded and whether a bottom separator is
  /// drawn. Defaults to [SettingsCardPosition.single].
  final SettingsCardPosition position;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    return GroupedCardShell(
      position: position,
      minHeight: 48,
      padding: EdgeInsets.symmetric(horizontal: theme.spacing.md, vertical: theme.spacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: theme.spacing.s,
        children: [
          Flexible(
            child: Text(
              title,
              style: theme.textStyles.textMd.regular.copyWith(color: palette.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Loose flex so an overlong value ellipsizes instead of overflowing,
          // while short content keeps hugging the trailing edge.
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: theme.spacing.s,
              children: [
                ?valueIcon,
                if (value != null)
                  Flexible(
                    child: Text(
                      value!,
                      style: theme.textStyles.textMd.regular.copyWith(
                        color: valueMuted ? palette.textTertiary : palette.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ?trailing,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
