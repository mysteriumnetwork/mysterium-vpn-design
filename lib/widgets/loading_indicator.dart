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
  const LoadingIndicator({this.color, this.size = 24, super.key})
    : _message = null,
      _messageStyle = null;

  /// Creates a loading indicator with a text [message] displayed below.
  ///
  /// [style] defaults to `textSm.semibold` with `textSecondary`
  /// color from the current theme.
  const LoadingIndicator.message(
    String message, {
    this.color,
    this.size = 24,
    TextStyle? style,
    super.key,
  }) : _message = message,
       _messageStyle = style;

  final Color? color;
  final double size;
  final String? _message;
  final TextStyle? _messageStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.palette.iconPrimary;
    final platform = theme.platform;

    final indicator = platform == TargetPlatform.iOS || platform == TargetPlatform.macOS
        ? CupertinoActivityIndicator(color: effectiveColor, radius: size / 2)
        : SizedBox.square(
            dimension: size,
            child: CircularProgressIndicator(color: effectiveColor, strokeWidth: 2),
          );

    if (_message == null) {
      return indicator;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        indicator,
        SizedBox(height: theme.spacing.ms),
        Text(
          _message,
          style:
              _messageStyle ??
              theme.textStyles.textSm.semibold.copyWith(color: theme.palette.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
