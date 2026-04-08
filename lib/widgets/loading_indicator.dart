import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// A platform-adaptive loading indicator.
///
/// On iOS and macOS renders a [CupertinoActivityIndicator].
/// On other platforms renders a [CircularProgressIndicator].
///
/// [color] defaults to [Palette.iconPrimary] from the current theme.
/// [size] controls the diameter (default 24).
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({this.color, this.size = 24, super.key});

  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).palette.iconPrimary;
    final platform = Theme.of(context).platform;

    if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
      return CupertinoActivityIndicator(color: effectiveColor, radius: size / 2);
    }

    return SizedBox.square(
      dimension: size,
      child: CircularProgressIndicator(color: effectiveColor, strokeWidth: 2),
    );
  }
}
