import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

FutureOr<T?> showModal<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  ScreenType? screenType,
  bool allowDismiss = true,
}) async =>
    await showDialog<T>(
      context: context,
      barrierDismissible: allowDismiss,
      builder: (ctx) => _AdaptiveModal(
        screenType: screenType,
        child: builder(ctx),
      ),
    );

class _AdaptiveModal extends StatelessWidget {
  const _AdaptiveModal({
    required this.child,
    required this.screenType,
  });

  final Widget child;
  final ScreenType? screenType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenType = this.screenType ?? ScreenType.of(context);
    if (screenType <= ScreenType.mobile) {
      return child;
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 640, maxWidth: 640),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(theme.radius.xl),
              boxShadow: [
                BoxShadow(
                  color: theme.palette.shadowXl03,
                  offset: const Offset(0, 3),
                  blurRadius: 3,
                  spreadRadius: -1.5,
                ),
                BoxShadow(
                  color: theme.palette.shadowXl02,
                  offset: const Offset(0, 8),
                  blurRadius: 8,
                  spreadRadius: -4,
                ),
                BoxShadow(
                  color: theme.palette.shadowXl01,
                  offset: const Offset(0, 20),
                  blurRadius: 24,
                  spreadRadius: -4,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(theme.radius.xl),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
