import 'dart:io';
import 'dart:math';
import 'dart:ui';

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

  /// When true, wraps [body] in a [ModalPadding] that honours safe-area
  /// insets and the app-bar height. Disable when the body handles insets
  /// itself.
  final bool autoApplyPadding;

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
      child: Builder(
        builder: (context) {
          if (autoApplyPadding) {
            return ModalPadding(
              add: appbar is ModalAppbar
                  ? EdgeInsets.only(top: appbar!.preferredSize.height)
                  : EdgeInsets.zero,
              child: body,
            );
          }
          return body;
        },
      ),
    ),
    backgroundColor: Theme.of(context).palette.bgPopover,
    extendBodyBehindAppBar: true,
    primary: false,
    resizeToAvoidBottomInset: false,
    bottomNavigationBar: footer,
  );
}

/// Decorative blurred horizontal gradient — pink/purple → blue band that
/// fades into the background near the bottom. Renders behind [child] in a
/// [Stack] and reacts to scroll notifications with a subtle parallax. Set
/// [showGradient] to `false` to bypass the effect.
class BackgroundGradient extends StatefulWidget {
  const BackgroundGradient({required this.child, this.showGradient = true, super.key});

  final Widget child;
  final bool showGradient;

  @override
  State<BackgroundGradient> createState() => _BackgroundGradientState();
}

class _BackgroundGradientState extends State<BackgroundGradient> {
  final ValueNotifier<double> _scrollOffset = ValueNotifier(0);

  @override
  void dispose() {
    _scrollOffset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showGradient) {
      return widget.child;
    }

    final theme = Theme.of(context);
    final isMobile = Platform.isIOS || Platform.isAndroid;
    final gradientColor1 = switch (theme.brightness) {
      Brightness.light =>
        isMobile ? const Color(0xFFEFB1FF) : const Color.fromARGB(255, 224, 130, 245),
      Brightness.dark => isMobile ? const Color(0xFFAE51CE) : const Color(0xFFAE51CE),
    };
    final gradientColor2 = switch (theme.brightness) {
      Brightness.light =>
        isMobile ? const Color(0xFF516CEF) : const Color.fromARGB(255, 58, 86, 225),
      Brightness.dark => const Color(0xFF516CEF),
    };

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        _scrollOffset.value = notification.metrics.pixels;
        return false;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(
            min(constraints.maxWidth, isMobile ? constraints.maxWidth * .8 : 380),
            isMobile ? 190 : 120,
          );

          // The blurred gradient subtree is expensive (60-sigma ImageFilter).
          // Build it once per layout and wrap in a RepaintBoundary so the
          // ValueListenableBuilder above only repositions it on scroll
          // without forcing a re-blur.
          final blurredGradient = RepaintBoundary(
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: Stack(
                  children: [
                    // Horizontal gradient (left to right)
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          stops: const [0.0, 0.4, 1.0],
                          colors: [gradientColor1, gradientColor1, gradientColor2],
                        ),
                      ),
                      child: const SizedBox.expand(),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.0, 1.0],
                          colors: [
                            Colors.transparent,
                            theme.palette.bgPopover.withValues(alpha: .5),
                          ],
                        ),
                      ),
                      child: const SizedBox.expand(),
                    ),
                  ],
                ),
              ),
            ),
          );

          return Stack(
            fit: StackFit.expand,
            children: [
              ValueListenableBuilder<double>(
                valueListenable: _scrollOffset,
                builder: (context, offset, child) => Positioned(
                  left: 0,
                  right: 0,
                  top: offset * 0.5,
                  height: size.height,
                  child: Center(child: child),
                ),
                child: blurredGradient,
              ),
              widget.child,
            ],
          );
        },
      ),
    );
  }
}
