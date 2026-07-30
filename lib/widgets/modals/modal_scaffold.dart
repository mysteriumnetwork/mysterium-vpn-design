import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// A full-screen modal [Scaffold] with the design-system background, an
/// optional decorative gradient, and sensible defaults for modal routes.
///
/// Pair with [showModal] to push the modal. Use [ModalAppbar], [ModalHeader],
/// and [ModalFooter] for consistent top/bottom chrome.
class ModalScaffold extends StatelessWidget {
  const ModalScaffold({
    required this.body,
    this.appbar,
    this.autoApplyPadding = true,
    this.backgroundColor,
    this.footer,
    this.onModalClose,
    this.showGradient = true,
    this.showCloseButton = true,
    super.key,
  });

  /// Optional custom app bar. Defaults to a [ModalAppbar] when null.
  final PreferredSizeWidget? appbar;

  /// Main scrollable content.
  final Widget body;

  /// Optional fixed footer (rendered as [Scaffold.bottomNavigationBar]).
  final Widget? footer;

  /// When true, wraps [body] in a [SafeArea]. The body extends behind the
  /// app bar and [Scaffold] injects the app-bar height (including any top
  /// device inset) into the body's `MediaQuery` padding, so this positions
  /// content directly below the app bar. Disable when the body handles
  /// insets itself (e.g. to scroll content behind the app bar).
  final bool autoApplyPadding;

  /// Background colour of the page. Defaults to the theme's popover
  /// background.
  final Color? backgroundColor;

  /// Close handler used by the default app bar's × button. Falls back to
  /// `Navigator.pop` when null.
  final VoidCallback? onModalClose;

  /// Whether to render the decorative blurred background gradient.
  final bool showGradient;

  /// Whether the default app bar shows a × close button.
  final bool showCloseButton;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: appbar ?? ModalAppbar(onModalClose: onModalClose, showCloseButton: showCloseButton),
    body: BackgroundGradient(
      showGradient: showGradient,
      child: autoApplyPadding ? SafeArea(child: body) : body,
    ),
    backgroundColor: backgroundColor ?? Theme.of(context).palette.bgPopover,
    extendBodyBehindAppBar: true,
    primary: false,
    resizeToAvoidBottomInset: false,
    bottomNavigationBar: footer,
  );
}
