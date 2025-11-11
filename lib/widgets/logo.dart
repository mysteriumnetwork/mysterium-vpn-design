import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mysterium_vpn_design/utils/assets.dart';
import 'package:mysterium_vpn_design/utils/constants.dart';

class Logo extends StatelessWidget {
  const Logo({
    this.width,
    this.height,
    this.color,
    super.key,
  });

  final double? width;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final asset = switch (theme.brightness) {
      Brightness.dark => Assets.logoDark,
      Brightness.light => Assets.logoLight,
    };

    return SvgPicture.asset(
      asset,
      package: kPackageName,
      width: width,
      height: height,
      colorFilter:
          color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    );
  }
}
