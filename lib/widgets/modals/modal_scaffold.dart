import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:mysterium_vpn_design/widgets/modals/modal_header.dart';
import 'package:mysterium_vpn_design/widgets/modals/modal_padding.dart';

class ModalScaffold extends StatelessWidget {
  const ModalScaffold({
    required this.body,
    this.appbar = const ModalHeader(),
    this.autoApplyPadding = true,
    this.footer,
    super.key,
  });

  final PreferredSizeWidget? appbar;
  final Widget body;
  final Widget? footer;
  final bool autoApplyPadding;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appbar,
        body: _Gradient(
          child: Builder(
            builder: (context) {
              if (autoApplyPadding) {
                return ModalPadding(
                  add: appbar is ModalHeader
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

class _Gradient extends StatelessWidget {
  const _Gradient({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradientColor1 = switch (theme.brightness) {
      Brightness.light => const Color(0xFFEFB1FF),
      Brightness.dark => const Color(0xFFAE51CE),
    };
    const gradientColor2 = Color(0xFF516CEF);

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size.square(min(constraints.maxWidth, 340));
        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: -(size.height * .7),
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      stops: const [0.0, 0.22, 0.85, 1.0],
                      colors: [
                        gradientColor1,
                        gradientColor1,
                        gradientColor2,
                        gradientColor2,
                      ],
                    ),
                  ),
                  child: SizedBox.fromSize(size: size),
                ),
              ),
            ),
            child,
          ],
        );
      },
    );
  }
}
