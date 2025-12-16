import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class ModalFooter extends StatelessWidget {
  const ModalFooter({
    required this.children,
    super.key,
  });

  final List<Widget> children;

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
                  spacing: theme.spacing.ms,
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
