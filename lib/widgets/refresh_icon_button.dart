import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// An icon button whose glyph spins while [spinning] is true.
///
/// Defaults to the refresh glyph used across the app. Use for refresh-style
/// actions where the continuous spin communicates in-progress work in place of
/// a separate loading indicator. While [spinning] the button ignores taps, so a
/// spin reliably blocks repeat presses without the caller having to clear
/// [onPressed].
class RefreshIconButton extends StatefulWidget {
  const RefreshIconButton({
    this.onPressed,
    this.spinning = false,
    this.tooltip,
    this.color,
    this.icon = UntitledUI.refresh_cw_05,
    this.iconSize = 18,
    super.key,
  });

  /// Called when tapped. Pass null to disable; taps are also ignored while
  /// [spinning].
  final VoidCallback? onPressed;

  /// Whether the glyph is currently spinning.
  final bool spinning;

  final String? tooltip;

  /// Glyph colour. Defaults to the theme's secondary icon colour.
  final Color? color;

  final IconData icon;
  final double iconSize;

  @override
  State<RefreshIconButton> createState() => _RefreshIconButtonState();
}

class _RefreshIconButtonState extends State<RefreshIconButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void initState() {
    super.initState();
    _syncSpin();
  }

  @override
  void didUpdateWidget(covariant RefreshIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.spinning != oldWidget.spinning) {
      _syncSpin();
    }
  }

  void _syncSpin() {
    if (widget.spinning) {
      _controller.repeat();
    } else {
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IconButton(
    // Spinning means a refresh is in flight, so ignore taps until it settles.
    onPressed: widget.spinning ? null : widget.onPressed,
    tooltip: widget.tooltip,
    padding: EdgeInsets.zero,
    visualDensity: VisualDensity.compact,
    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
    icon: RotationTransition(
      turns: _controller,
      child: Icon(
        widget.icon,
        size: widget.iconSize,
        color: widget.color ?? Theme.of(context).palette.iconSecondary,
      ),
    ),
  );
}
