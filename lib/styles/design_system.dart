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
      _ => throw UnimplementedError('Unknown palette type: ${palette.runtimeType}'),
    };
    final textStyles = TextStyles(color: palette.textPrimary);
    const radius = Radius();
    const spacing = Spacing();
    return ThemeData(
      brightness: brightness,
      colorScheme: palette.materialColors,
      textTheme: textStyles.materialTextTheme,
      scaffoldBackgroundColor: palette.bgSecondary,
      appBarTheme: AppBarThemeData(
        backgroundColor: palette.bgPrimary,
        surfaceTintColor: palette.bgPrimary,
        foregroundColor: palette.iconPrimary,
        titleTextStyle: textStyles.textLg.medium.copyWith(color: palette.textPrimary),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(radius.s)),
          iconSize: 16,
          textStyle: textStyles.textMd.semibold,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Palette.white,
          foregroundColor: palette.textSecondary,
          iconColor: palette.textSecondary,
          side: BorderSide(color: palette.borderBrand),
          disabledForegroundColor: Palette.grayLight.shade400,
          disabledIconColor: Palette.grayLight.shade400,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(radius.s)),
          iconSize: 16,
          textStyle: textStyles.textMd.semibold,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.textBrandPrimary,
          disabledForegroundColor: Palette.grayLight.shade400,
          textStyle: textStyles.textMd.semibold,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(radius.s)),
          iconSize: 16,
          iconColor: palette.textBrandPrimary,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return Palette.grayLight.shade50;
          }
          return Palette.white;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return palette.bgInactive;
          }
          if (states.contains(WidgetState.selected)) {
            if (states.contains(WidgetState.hovered) || states.contains(WidgetState.pressed)) {
              return Palette.brand.shade500;
            }
            return Palette.brand.shade400;
          }
          return Palette.grayLight.shade300;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.kXs)),
        side: BorderSide(color: palette.borderPrimary),
        checkColor: WidgetStateProperty.all(palette.textWhite),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Palette.brand.shade400;
          }
          if (states.contains(WidgetState.disabled)) {
            return palette.iconDisabled;
          }
          return palette.bgPrimary;
        }),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: textStyles.textMd.regular.copyWith(color: palette.textPrimary),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: palette.bgPrimary,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          constraints: const BoxConstraints(minHeight: 40),
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.kS),
            borderSide: BorderSide(color: palette.borderPrimary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.kS),
            borderSide: BorderSide(color: palette.borderPrimary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.kS),
            borderSide: BorderSide(color: palette.borderBrand),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.kS),
            borderSide: BorderSide(color: palette.borderError),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.kS),
            borderSide: BorderSide(color: palette.borderError),
          ),
          hintStyle: textStyles.textMd.regular.copyWith(color: palette.textTertiary),
        ),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(palette.bgPrimary),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
          elevation: const WidgetStatePropertyAll(2),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.kS),
              side: BorderSide(color: palette.borderPrimary),
            ),
          ),
          padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 4)),
        ),
      ),
      menuButtonTheme: MenuButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return palette.textBrandPrimary;
            }
            return palette.textPrimary;
          }),
          overlayColor: WidgetStatePropertyAll(palette.bgPrimaryHover),
          backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
          textStyle: WidgetStatePropertyAll(textStyles.textMd.regular),
          padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
          minimumSize: const WidgetStatePropertyAll(Size(0, 36)),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorAnimation: TabIndicatorAnimation.elastic,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: palette.borderTabs, width: 2),
        ),
        dividerHeight: spacing.xxs,
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
      tooltipTheme: TooltipThemeData(
        preferBelow: false,
        verticalOffset: 12,
        triggerMode: TooltipTriggerMode.tap,
        enableFeedback: true,
        padding: EdgeInsets.symmetric(horizontal: spacing.md, vertical: spacing.s),
        constraints: const BoxConstraints(maxWidth: 400),
        textStyle: textStyles.textXs.medium.copyWith(color: palette.textTooltip),
        textAlign: TextAlign.center,
        showDuration: const Duration(seconds: 3),
        decoration: BoxDecoration(
          color: palette.tooltipBackground,
          borderRadius: BorderRadius.all(radius.s),
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              spreadRadius: -1,
              color: palette.gray.shade950.withValues(alpha: .04),
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              blurRadius: 6,
              spreadRadius: -2,
              color: palette.gray.shade950.withValues(alpha: .04),
              offset: const Offset(0, 4),
            ),
          ],
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[palette, textStyles, spacing, radius],
    );
  }
}

extension ThemeExtensions on ThemeData {
  Palette get palette => extension<Palette>()!;

  TextStyles get textStyles => extension<TextStyles>()!;

  Spacing get spacing => extension<Spacing>()!;

  Radius get radius => extension<Radius>()!;

  // A temporary util to check if the theme is from new design system or it is legacy.
  bool get isDesignSystem => extension<Spacing>() != null;
}
