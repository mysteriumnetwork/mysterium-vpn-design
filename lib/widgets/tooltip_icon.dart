import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class TooltipIcon extends StatelessWidget {
  const TooltipIcon({
    required String message,
    IconData icon = UntitledUI.help_circle,
    double size = 16.0,
    Key? key,
  }) : this._(
          key: key,
          message: message,
          icon: icon,
          size: size,
        );

  const TooltipIcon._({
    super.key,
    this.message,
    this.richMessage,
    this.icon = UntitledUI.help_circle,
    this.size = 16.0,
  }) : assert(
          message != null || richMessage != null,
          'Either message or richMessage must be provided.',
        );

  const TooltipIcon.richMessage({
    required InlineSpan message,
    IconData icon = UntitledUI.help_circle,
    double size = 16.0,
    Key? key,
  }) : this._(
          key: key,
          richMessage: message,
          icon: icon,
          size: size,
        );

  final String? message;
  final InlineSpan? richMessage;
  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      mouseCursor: SystemMouseCursors.click,
      message: message,
      richMessage:
          richMessage != null ? TextSpan(children: [richMessage!]) : null,
      verticalOffset: (size / 2) + 4,
      child: Icon(
        icon,
        size: size,
        color: theme.palette.iconDisabled,
      ),
    );
  }
}
