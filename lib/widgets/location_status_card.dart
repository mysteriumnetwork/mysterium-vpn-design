import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// A card summarising the current location with a live connection status
/// label, used as the header of the connection details view.
///
/// The status colour and icon follow [status] ([BarStatus]); the label text is
/// caller-supplied so it stays localizable.
class LocationStatusCard extends StatelessWidget {
  const LocationStatusCard({
    required this.country,
    required this.countryIcon,
    required this.status,
    required this.statusLabel,
    this.city,
    super.key,
  });

  /// Country name, e.g. "Germany".
  final String country;

  /// Leading flag widget, rendered at 36×36.
  final Widget countryIcon;

  /// Optional city shown beneath [country]. The line's space is always
  /// reserved — an empty city renders invisible — so the card height stays
  /// stable when the location changes.
  final String? city;

  /// Connection lifecycle state — drives the trailing icon and colour.
  final BarStatus status;

  /// Localized status text, e.g. "Connected" / "Getting IP address...".
  final String statusLabel;

  Color _statusColor(Palette palette) => switch (status) {
    BarStatus.connected => palette.textSuccessTertiary,
    BarStatus.disconnected => palette.textErrorPrimary,
    _ => palette.textWarningPrimary,
  };

  Widget _statusIcon(Color color) => switch (status) {
    BarStatus.connected => Icon(UntitledUI.lock_02, size: 16, color: color),
    BarStatus.disconnected => Icon(UntitledUI.lock_unlocked_01, size: 16, color: color),
    _ => LoadingIndicator(size: 16, color: color),
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final statusColor = _statusColor(palette);
    return GroupedCardShell(
      position: SettingsCardPosition.single,
      minHeight: 0,
      padding: EdgeInsets.symmetric(horizontal: theme.spacing.md, vertical: theme.spacing.ms),
      child: Row(
        spacing: theme.spacing.ms,
        children: [
          SizedBox(width: 36, height: 36, child: countryIcon),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: theme.spacing.xs,
              children: [
                Text(
                  country,
                  style: theme.textStyles.textMd.semibold.copyWith(color: palette.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // An empty Text still reserves its line, keeping the height stable.
                Text(
                  city ?? '',
                  style: theme.textStyles.textXs.regular.copyWith(color: palette.textTertiary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Row(
            spacing: theme.spacing.xs,
            children: [
              _statusIcon(statusColor),
              Text(statusLabel, style: theme.textStyles.textXs.medium.copyWith(color: statusColor)),
            ],
          ),
        ],
      ),
    );
  }
}
