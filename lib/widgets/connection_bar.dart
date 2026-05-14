import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// VPN connection lifecycle state rendered by [ConnectionBar].
enum BarStatus {
  /// Fully connected — green.
  connected,

  /// Disconnected (no tunnel) — red.
  disconnected,

  /// Connection established, still fetching the new IP — amber + spinner.
  gettingIp,

  /// Tearing down the tunnel — amber + spinner.
  disconnecting,

  /// Establishing the tunnel — amber + spinner.
  connecting,
}

/// A full-width status bar shown above the app content that reflects the
/// current [BarStatus].
class ConnectionBar extends StatelessWidget {
  const ConnectionBar({required this.label, required this.status, super.key});

  /// Primary status text (e.g. "Connected", "Connecting...").
  final String label;

  /// Current connection lifecycle status.
  final BarStatus status;

  Color get _backgroundColor => switch (status) {
    BarStatus.connected => Palette.success.shade700,
    BarStatus.disconnected => Palette.error.shade700,
    BarStatus.gettingIp => Palette.warning.shade400,
    BarStatus.disconnecting => Palette.warning.shade400,
    BarStatus.connecting => Palette.warning.shade400,
  };

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).spacing;

    return Container(
      color: _backgroundColor,
      padding: EdgeInsets.symmetric(vertical: spacing.s, horizontal: spacing.xl3),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [_buildHeader(context)]),
    );
  }

  Widget _buildHeader(BuildContext context) => switch (status) {
    BarStatus.disconnected => _Header(
      label: label,
      icon: const Icon(UntitledUI.lock_unlocked_03, size: 16, color: Palette.white),
      textColor: Palette.white,
    ),
    BarStatus.gettingIp => _Header(
      label: label,
      icon: LoadingIndicator(color: Palette.grayLight.shade800, size: 16),
      textColor: Palette.grayLight.shade800,
    ),
    BarStatus.connected => _Header(
      label: label,
      icon: const Icon(UntitledUI.lock_03, size: 16, color: Palette.white),
      textColor: Palette.white,
    ),
    BarStatus.disconnecting => _Header(
      label: label,
      icon: LoadingIndicator(color: Palette.grayLight.shade800, size: 16),
      textColor: Palette.grayLight.shade800,
    ),
    BarStatus.connecting => _Header(
      label: label,
      icon: LoadingIndicator(color: Palette.grayLight.shade800, size: 16),
      textColor: Palette.grayLight.shade800,
    ),
  };
}

class _Header extends StatelessWidget {
  const _Header({required this.label, required this.icon, required this.textColor});

  final String label;
  final Widget icon;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).spacing;
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: spacing.s,
      children: [
        icon,
        Text(label, style: Theme.of(context).textStyles.textSm.semibold.copyWith(color: textColor)),
      ],
    );
  }
}
