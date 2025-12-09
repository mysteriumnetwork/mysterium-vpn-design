import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

@immutable
abstract class Palette extends ThemeExtension<Palette> {
  const Palette();

  factory Palette.of(BuildContext context) =>
      Theme.of(context).extension<Palette>()!;

  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const transparent = Color(0x00000000);

  static const _grayLight = 0xFF717680;
  static const grayLight = PaletteColor(
    _grayLight,
    {
      25: Color(0xFFFDFDFD),
      50: Color(0xFFFAFAFA),
      100: Color(0xFFF5F5F5),
      200: Color(0xFFE9EAEB),
      300: Color(0xFFD5D7DA),
      400: Color(0xFFA4A7AE),
      500: Color(_grayLight),
      600: Color(0xFF535862),
      700: Color(0xFF414651),
      800: Color(0xFF252B37),
      900: Color(0xFF181D27),
      950: Color(0xFF0A0D12),
    },
  );

  static const _grayDark = 0xFF85888E;
  static const grayDark = PaletteColor(
    _grayDark,
    {
      25: Color(0xFFFAFAFA),
      50: Color(0xFFF7F7F7),
      100: Color(0xFFF0F0F1),
      200: Color(0xFFECECED),
      300: Color(0xFFCECFD2),
      400: Color(0xFF94979C),
      500: Color(_grayDark),
      600: Color(0xFF61656C),
      700: Color(0xFF373A41),
      800: Color(0xFF22262F),
      900: Color(0xFF13161B),
      950: Color(0xFF0C0E12),
    },
  );

  static const _brand = 0xFFC644F1;
  static const brand = PaletteColor(
    _brand,
    {
      25: Color(0xFFFEFAFF),
      50: Color(0xFFFCF4FF),
      100: Color(0xFFF9E8FF),
      200: Color(0xFFF2D0FE),
      300: Color(0xFFE8AAFD),
      400: Color(0xFFDA78FA),
      500: Color(_brand),
      600: Color(0xFFA924D5),
      700: Color(0xFF8B1AB1),
      800: Color(0xFF721890),
      900: Color(0xFF5F1877),
      950: Color(0xFF47104C),
    },
  );

  static const _brandPurple = 0xFF6E43B1;
  static const brandPurple = PaletteColor(
    _brandPurple,
    {
      25: Color(0xFFFCFBFE),
      50: Color(0xFFF9F8FC),
      100: Color(0xFFEEE9F7),
      200: Color(0xFFDDD3EE),
      300: Color(0xFFC1AEE0),
      400: Color(0xFF8B67C5),
      500: Color(_brandPurple),
      600: Color(0xFF57358D),
      700: Color(0xFF4B2E7A),
      800: Color(0xFF342055),
      900: Color(0xFF291943),
      950: Color(0xFF1B112C),
    },
  );

  static const _error = 0xFFF04438;
  static const error = PaletteColor(
    _error,
    {
      25: Color(0xFFFFFBFA),
      50: Color(0xFFFEF3F2),
      100: Color(0xFFFEE4E2),
      200: Color(0xFFFECDCA),
      300: Color(0xFFFDA29B),
      400: Color(0xFFF97066),
      500: Color(_error),
      600: Color(0xFFD92D20),
      700: Color(0xFFB42318),
      800: Color(0xFF912018),
      900: Color(0xFF7A271A),
      950: Color(0xFF55160C),
    },
  );

  static const _warning = 0xFFF79009;
  static const warning = PaletteColor(
    _warning,
    {
      25: Color(0xFFFFFCF5),
      50: Color(0xFFFFFAEB),
      100: Color(0xFFFEF0C7),
      200: Color(0xFFFEDF89),
      300: Color(0xFFFEC84B),
      400: Color(0xFFFDB022),
      500: Color(_warning),
      600: Color(0xFFDC6803),
      700: Color(0xFFB54708),
      800: Color(0xFF93370D),
      900: Color(0xFF7A2E0E),
      950: Color(0xFF4E1D09),
    },
  );

  static const _success = 0xFF17B26A;
  static const success = PaletteColor(
    _success,
    {
      25: Color(0xFFF6FEF9),
      50: Color(0xFFECFDF3),
      100: Color(0xFFDCF9E6),
      200: Color(0xFFABFEC6),
      300: Color(0xFF75E0A7),
      400: Color(0xFF47CD89),
      500: Color(_success),
      600: Color(0xFF079455),
      700: Color(0xFF067647),
      800: Color(0xFF085D3A),
      900: Color(0xFF074D31),
      950: Color(0xFF053321),
    },
  );

  static const _grayPurple = 0xFF6A5D98;
  static const grayPurple = PaletteColor(
    _grayPurple,
    {
      25: Color(0xFFFCFCFD),
      50: Color(0xFFF6F6F9),
      100: Color(0xFFF1EFF5),
      200: Color(0xFFDFDCEA),
      300: Color(0xFFBFB9D4),
      400: Color(0xFF887DB0),
      500: Color(_grayPurple),
      600: Color(0xFF544A78),
      700: Color(0xFF494068),
      800: Color(0xFF37304F),
      900: Color(0xFF151122),
      950: Color(0xFF110E1B),
    },
  );

// dart
  static const _grayDarkAlpha = 0xFFFFFFFF;
  static const grayDarkAlpha = PaletteColor(
    _grayDarkAlpha,
    {
      25: Color(0xFAFFFFFF), // 98%
      50: Color(0xF5FFFFFF), // 96%
      100: Color(0xF0FFFFFF), // 94%
      200: Color(0xEBFFFFFF), // 92%
      300: Color(0xCCFFFFFF), // 80%
      400: Color(0x8FFFFFFF), // 56%
      500: Color(0x80FFFFFF), // 50%
      600: Color(0x59FFFFFF), // 35%
      700: Color(0x29FFFFFF), // 16%
      800: Color(0x14FFFFFF), // 8%
      900: Color(0x0AFFFFFF), // 4%
      950: Color(0x00FFFFFF), // 0%
    },
  );

  static const _grayCool = 0xFF5D6B98;
  static const grayCool = PaletteColor(
    _grayCool,
    {
      25: Color(0xFFFCFCFD),
      50: Color(0xFFF9F9FB),
      100: Color(0xFFEFF1F5),
      200: Color(0xFFDCDDEA),
      300: Color(0xFFB9C0D4),
      400: Color(0xFF7D89B0),
      500: Color(_grayCool),
      600: Color(0xFF4A5578),
      700: Color(0xFF404968),
      800: Color(0xFF30374F),
      900: Color(0xFF111322),
      950: Color(0xFF0E101B),
    },
  );

  abstract final Color gray;

  ///
  /// Text Colors
  ///
  abstract final Color textPrimary;
  abstract final Color textPrimarySelected;
  abstract final Color textSecondary;
  abstract final Color textTertiary;
  abstract final Color textWhite;
  abstract final Color textDisabled;
  abstract final Color textPlaceholder;
  abstract final Color textBrandPrimary;
  abstract final Color textErrorPrimary;
  abstract final Color textWarningPrimary;
  abstract final Color textSuccessPrimary;

  ///
  /// Border Colors
  ///
  abstract final Color borderPrimary;
  abstract final Color borderSecondary;
  abstract final Color borderBrand;
  abstract final Color borderError;
  abstract final Color borderTabs;

  ///
  /// Icon Colors
  ///
  abstract final Color iconPrimary;
  abstract final Color iconSuccessPrimary;
  abstract final Color iconSecondary;
  abstract final Color iconTertiary;
  abstract final Color iconWhite;
  abstract final Color iconDisabled;

  ///
  /// Background Colors
  ///
  abstract final Color bgPrimary;
  abstract final Color bgSecondary;
  abstract final Color bgTertiary;
  abstract final Color bgQuaternary;
  abstract final Color bgBrandPrimary;
  abstract final Color bgBrandPrimaryHover;
  abstract final Color bgBrandPrimaryInactive;
  abstract final Color bgBrandSecondary;
  abstract final Color bgBrandSecondaryInactive;
  abstract final Color bgInactive;

  abstract final ColorScheme materialColors;

  @override
  ThemeExtension<Palette> copyWith() => this;

  @override
  ThemeExtension<Palette> lerp(
    covariant ThemeExtension<Palette>? other,
    double t,
  ) =>
      this;
}

class PaletteDark extends Palette {
  const PaletteDark();

  @override
  PaletteColor get gray => Palette.grayDark;

  ///
  /// Text Colors
  ///
  @override
  Color get textPrimary => gray.shade50;

  @override
  Color get textPrimarySelected => Palette.brand.shade300;

  @override
  Color get textSecondary => gray.shade300;

  @override
  Color get textTertiary => Palette.grayDarkAlpha.shade400;

  @override
  Color get textWhite => Palette.white;

  @override
  Color get textDisabled => gray.shade500;

  @override
  Color get textPlaceholder => gray.shade400;

  @override
  Color get textBrandPrimary => Palette.brand.shade300;

  @override
  Color get textErrorPrimary => Palette.error.shade400;

  @override
  Color get textWarningPrimary => Palette.warning.shade400;

  @override
  Color get textSuccessPrimary => Palette.success.shade400;

  ///
  /// Border Colors
  ///
  @override
  Color get borderPrimary => Palette.grayPurple.shade600;

  @override
  Color get borderSecondary => Palette.grayPurple.shade600;

  @override
  Color get borderBrand => Palette.grayPurple.shade400;

  @override
  Color get borderError => Palette.error.shade400;

  @override
  Color get borderTabs => Palette.brand.shade300;

  ///
  /// Icon Colors
  ///
  @override
  Color get iconPrimary => Palette.white;

  @override
  Color get iconSuccessPrimary => Palette.success.shade200;

  @override
  Color get iconSecondary => gray.shade300;

  @override
  Color get iconTertiary => gray.shade300;

  @override
  Color get iconWhite => Palette.white;

  @override
  Color get iconDisabled => Palette.grayLight.shade400;

  ///
  /// Background Colors
  ///
  @override
  Color get bgPrimary => Palette.brandPurple.shade800;

  @override
  Color get bgSecondary => Palette.brandPurple.shade900;

  @override
  Color get bgTertiary => Palette.grayPurple.shade800;

  @override
  Color get bgQuaternary => gray.shade700;

  @override
  Color get bgBrandPrimary => Palette.brand.shade400;

  @override
  Color get bgBrandPrimaryHover => Palette.brand.shade700;

  @override
  Color get bgBrandPrimaryInactive => Palette.brand.shade500;

  @override
  Color get bgBrandSecondary => gray.shade800;

  @override
  Color get bgBrandSecondaryInactive => Palette.brand.shade600;

  @override
  Color get bgInactive => Palette.brandPurple.shade900;

  @override
  ColorScheme get materialColors => ColorScheme.dark(
        primary: Palette.brand.shade500,
        onPrimary: textPrimary,
        surface: bgPrimary,
        onSurface: textPrimary,
        surfaceContainer: bgSecondary,
        surfaceContainerHigh: bgTertiary,
        surfaceContainerHighest: bgQuaternary,
        error: Palette.error,
        errorContainer: borderError,
        onError: textPrimary,
        onErrorContainer: textPrimary,
        outline: borderPrimary,
      );
}

class PaletteLight extends Palette {
  const PaletteLight();

  @override
  PaletteColor get gray => Palette.grayLight;

  ///
  /// Text Colors
  ///
  @override
  Color get textPrimary => gray.shade800;

  @override
  Color get textPrimarySelected => Palette.brand.shade700;

  @override
  Color get textSecondary => gray.shade700;

  @override
  Color get textTertiary => gray.shade500;

  @override
  Color get textWhite => Palette.white;

  @override
  Color get textDisabled => gray.shade500;

  @override
  Color get textPlaceholder => gray.shade500;

  @override
  Color get textBrandPrimary => Palette.brand.shade900;

  @override
  Color get textErrorPrimary => Palette.error.shade600;

  @override
  Color get textWarningPrimary => Palette.warning.shade600;

  @override
  Color get textSuccessPrimary => Palette.success.shade600;

  ///
  /// Border Colors
  ///
  @override
  Color get borderPrimary => gray.shade300;

  @override
  Color get borderSecondary => Palette.grayPurple.shade200;

  @override
  Color get borderBrand => Palette.grayPurple.shade400;

  @override
  Color get borderError => Palette.error.shade500;

  @override
  Color get borderTabs => Palette.brand.shade700;

  ///
  /// Icon Colors
  ///
  @override
  Color get iconPrimary => gray.shade800;

  @override
  Color get iconSuccessPrimary => Palette.success.shade700;

  @override
  Color get iconSecondary => gray.shade700;

  @override
  Color get iconTertiary => gray.shade700;

  @override
  Color get iconWhite => Palette.white;

  @override
  Color get iconDisabled => Palette.grayLight.shade400;

  ///
  /// Background Colors
  ///
  @override
  Color get bgPrimary => Palette.white;

  @override
  Color get bgSecondary => gray.shade100;

  @override
  Color get bgTertiary => Palette.grayPurple.shade25;

  @override
  Color get bgQuaternary => gray.shade200;

  @override
  Color get bgBrandPrimary => Palette.brand;

  @override
  Color get bgBrandPrimaryHover => Palette.brand.shade700;

  @override
  Color get bgBrandPrimaryInactive => gray.shade100;

  @override
  Color get bgBrandSecondary => Palette.brand.shade50;

  @override
  Color get bgBrandSecondaryInactive => Palette.brand.shade100;

  @override
  Color get bgInactive => gray.shade100;

  @override
  ColorScheme get materialColors => ColorScheme.light(
        primary: Palette.brand.shade500,
        onPrimary: textPrimary,
        surface: bgPrimary,
        onSurface: textPrimary,
        surfaceContainer: bgSecondary,
        surfaceContainerHigh: bgTertiary,
        surfaceContainerHighest: bgQuaternary,
        error: Palette.error,
        errorContainer: borderError,
        onError: textPrimary,
        onErrorContainer: textPrimary,
        outline: borderPrimary,
      );
}
