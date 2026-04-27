import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/utils/screen_type.dart';

/// Applies the standard modal inset for the current screen type.
///
/// On mobile, adds the safe-area padding (plus optional [add]); on tablet
/// and desktop, applies only [add] — modals on larger screens are centred
/// cards and don't need device safe-area insets.
class ModalPadding extends StatelessWidget {
  const ModalPadding({required this.child, this.add = EdgeInsets.zero, super.key});

  /// Computes the effective inset without applying it — useful for callers
  /// that need the numbers without wrapping a widget.
  static EdgeInsets insets(BuildContext context, {EdgeInsets add = EdgeInsets.zero}) {
    final screenType = ScreenType.of(context);
    if (screenType > ScreenType.mobile) {
      return EdgeInsets.zero + add;
    }
    final safeArea = MediaQuery.of(context).padding;
    return safeArea + add;
  }

  /// Extra padding added on top of the screen-type-aware base.
  final EdgeInsets add;

  /// Padded child.
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: insets(context, add: add),
    child: child,
  );
}
