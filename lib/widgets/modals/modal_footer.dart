import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Footer row for a [ModalScaffold] holding one or more stacked actions.
///
/// Adds a top border, respects safe-area padding at the bottom, and on
/// tablet+ constrains the content to a centred 280 px column so buttons
/// don't stretch edge-to-edge.
class ModalFooter extends StatelessWidget {
  const ModalFooter({required this.children, this.spacing, super.key});

  /// Footer actions stacked vertically (typically buttons).
  final List<Widget> children;

  /// Vertical gap between [children]. Defaults to `theme.spacing.ms`.
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    final screenType = ScreenType.of(context);
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.palette.borderPrimary)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.all(theme.spacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: screenType > ScreenType.mobile
                    ? const BoxConstraints(maxWidth: 280)
                    : const BoxConstraints(),
                child: Column(
                  spacing: spacing ?? theme.spacing.ms,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
