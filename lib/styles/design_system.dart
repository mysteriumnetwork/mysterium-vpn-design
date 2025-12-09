import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Radius, Typography;
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

sealed class DesignSystem {
  const DesignSystem._();

  static ThemeData get lightTheme => _build(palette: const PaletteLight());

  static ThemeData get darkTheme => _build(palette: const PaletteDark());

  static ThemeData _build({required Palette palette}) {
    final brightness = switch (palette) {
      PaletteLight _ => Brightness.light,
      PaletteDark _ => Brightness.dark,
      _ => throw UnimplementedError(
          'Unknown palette type: ${palette.runtimeType}',
        ),
    };
    final textStyles = TextStyles(color: palette.textPrimary);
    const radius = Radius();
    return ThemeData(
      brightness: brightness,
      colorScheme: palette.materialColors,
      textTheme: textStyles.materialTextTheme,
      scaffoldBackgroundColor: palette.bgSecondary,
      appBarTheme: AppBarThemeData(
        backgroundColor: palette.bgPrimary,
        surfaceTintColor: palette.bgPrimary,
        foregroundColor: palette.iconPrimary,
        titleTextStyle: textStyles.textLg.medium.copyWith(
          color: palette.textPrimary,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: palette.bgBrandPrimary,
          surfaceTintColor: palette.bgBrandPrimaryHover,
          overlayColor: palette.bgBrandPrimaryHover,
          foregroundColor: palette.textWhite,
          iconColor: palette.textWhite,
          disabledBackgroundColor: Palette.grayLight.shade100,
          disabledForegroundColor: Palette.grayLight.shade400,
          disabledIconColor: Palette.grayLight.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(radius.s),
          ),
          iconSize: 16,
          textStyle: textStyles.textMd.semibold,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.textSecondary,
          iconColor: palette.textSecondary,
          side: BorderSide(color: palette.borderBrand),
          disabledForegroundColor: Palette.grayLight.shade400,
          disabledIconColor: Palette.grayLight.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(radius.s),
          ),
          iconSize: 16,
          textStyle: textStyles.textMd.semibold,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorAnimation: TabIndicatorAnimation.elastic,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: palette.borderTabs, width: 2),
        ),
        dividerHeight: 1,
        dividerColor: palette.borderSecondary,
        indicatorColor: palette.borderTabs,
        labelColor: palette.textPrimarySelected,
        labelStyle: textStyles.textMd.semibold,
        labelPadding: EdgeInsets.zero,
        unselectedLabelColor: palette.textTertiary,
      ),
      cupertinoOverrideTheme: NoDefaultCupertinoThemeData(
        primaryColor: Palette.brand,
        brightness: brightness,
        applyThemeToAll: true,
      ),
      extensions: <ThemeExtension<dynamic>>[
        palette,
        textStyles,
        const Spacing(),
        const Radius(),
      ],
    );
  }
}

extension ThemeExtensions on ThemeData {
  Palette get palette => extension<Palette>()!;

  TextStyles get textStyles => extension<TextStyles>()!;

  Spacing get spacing => extension<Spacing>()!;

  Radius get radius => extension<Radius>()!;
}
