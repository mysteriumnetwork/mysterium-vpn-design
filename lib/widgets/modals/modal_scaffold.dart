import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

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

  final PreferredSizeWidget? appbar;
  final Widget body;
  final Widget? footer;
  final bool autoApplyPadding;
  final VoidCallback? onModalClose;
  final bool showGradient;
  final bool showCloseButton;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appbar ?? ModalAppbar(onModalClose: onModalClose, showCloseButton: showCloseButton),
        body: _Gradient(
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

class _Gradient extends StatefulWidget {
  const _Gradient({
    required this.child,
    required this.showGradient,
  });

  final Widget child;
  final bool showGradient;

  @override
  State<_Gradient> createState() => _GradientState();
}

class _GradientState extends State<_Gradient> {
  double _scrollOffset = 0;

  @override
  Widget build(BuildContext context) {
    if (!widget.showGradient) {
      return widget.child;
    }

    final theme = Theme.of(context);
    final gradientColor1 = switch (theme.brightness) {
      Brightness.light => const Color.fromARGB(255, 224, 130, 245),
      Brightness.dark => const Color(0xFFAE51CE),
    };
    final gradientColor2 = switch (theme.brightness) {
      Brightness.light => const Color.fromARGB(255, 58, 86, 225),
      Brightness.dark => const Color(0xFF516CEF),
    };

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        setState(() {
          _scrollOffset = notification.metrics.pixels;
        });
        return false;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenType = ScreenType.of(context);
          final size = Size(
            min(constraints.maxWidth, 300),
            screenType > ScreenType.mobile ? 90 : 200,
          );
          final parallaxOffset = -_scrollOffset * 0.5;
          final blurAmount = size.width * 0.2;

          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: parallaxOffset,
                height: size.height,
                child: Center(
                  child: SizedBox(
                    width: size.width,
                    height: size.height,
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: const Alignment(-1, -0.5),
                            end: const Alignment(1, -0.5),
                            colors: [
                              gradientColor1,
                              gradientColor2,
                            ],
                          ),
                        ),
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ),
                ),
              ),
              widget.child,
            ],
          );
        },
      ),
    );
  }
}
