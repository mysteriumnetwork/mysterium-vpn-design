import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/utils/screen_type.dart';

class ModalPadding extends StatelessWidget {
  const ModalPadding({
    required this.child,
    this.add = EdgeInsets.zero,
    super.key,
  });

  static EdgeInsets insets(
    BuildContext context, {
    EdgeInsets add = EdgeInsets.zero,
  }) {
    final screenType = ScreenType.of(context);
    if (screenType > ScreenType.mobile) {
      return EdgeInsets.zero + add;
    }
    final safeArea = MediaQuery.of(context).padding;
    return safeArea + add;
  }

  final EdgeInsets add;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
        padding: insets(context, add: add),
        child: child,
      );
}
