import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysterium_vpn_design/styles/typography/type_scale.dart';

class TextStyles extends ThemeExtension<TextStyles> {
  const TextStyles({this.color});

  factory TextStyles.of(BuildContext context) => Theme.of(context).extension<TextStyles>()!;

  final Color? color;

  TypeScale get displayXlg => TypeScale(
        regular: GoogleFonts.inter(
          fontSize: 28,
          height: 38 / 28,
          fontWeight: FontWeight.w400,
          color: color,
        ),
        medium: GoogleFonts.inter(
          fontSize: 28,
          height: 38 / 28,
          fontWeight: FontWeight.w500,
          color: color,
        ),
        semibold: GoogleFonts.inter(
          fontSize: 28,
          height: 38 / 28,
          fontWeight: FontWeight.w600,
          color: color,
        ),
        bold: GoogleFonts.inter(
          fontSize: 28,
          height: 38 / 28,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      );

  TypeScale get textLg => TypeScale(
        regular: GoogleFonts.inter(
          fontSize: 18,
          height: 28 / 18,
          fontWeight: FontWeight.w400,
          color: color,
        ),
        medium: GoogleFonts.inter(
          fontSize: 18,
          height: 28 / 18,
          fontWeight: FontWeight.w500,
          color: color,
        ),
        semibold: GoogleFonts.inter(
          fontSize: 18,
          height: 28 / 18,
          fontWeight: FontWeight.w600,
          color: color,
        ),
        bold: GoogleFonts.inter(
          fontSize: 18,
          height: 28 / 18,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      );

  TypeScale get textMd => TypeScale(
        regular: GoogleFonts.inter(
          fontSize: 16,
          height: 20 / 16,
          fontWeight: FontWeight.w400,
          color: color,
        ),
        medium: GoogleFonts.inter(
          fontSize: 16,
          height: 20 / 16,
          fontWeight: FontWeight.w500,
          color: color,
        ),
        semibold: GoogleFonts.inter(
          fontSize: 16,
          height: 20 / 16,
          fontWeight: FontWeight.w600,
          color: color,
        ),
        bold: GoogleFonts.inter(
          fontSize: 16,
          height: 20 / 16,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      );

  TypeScale get textSm => TypeScale(
        regular: GoogleFonts.inter(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w400,
          color: color,
        ),
        medium: GoogleFonts.inter(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w500,
          color: color,
        ),
        semibold: GoogleFonts.inter(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w600,
          color: color,
        ),
        bold: GoogleFonts.inter(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      );

  TypeScale get textXs => TypeScale(
        regular: GoogleFonts.inter(
          fontSize: 12,
          height: 18 / 12,
          fontWeight: FontWeight.w400,
          color: color,
        ),
        medium: GoogleFonts.inter(
          fontSize: 12,
          height: 18 / 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
        semibold: GoogleFonts.inter(
          fontSize: 12,
          height: 18 / 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
        bold: GoogleFonts.inter(
          fontSize: 12,
          height: 18 / 12,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      );

  @override
  ThemeExtension<TextStyles> copyWith() => this;

  @override
  ThemeExtension<TextStyles> lerp(
    covariant ThemeExtension<TextStyles>? other,
    double t,
  ) {
    if (other is! TextStyles) {
      return this;
    }
    final lerped = Color.lerp(color, other.color, t);
    return TextStyles(color: lerped);
  }

  TextTheme get materialTextTheme => GoogleFonts.interTextTheme(
        TextTheme(
          // Display / large headings
          displayLarge: displayXlg.bold,
          displayMedium: displayXlg.semibold,
          displaySmall: displayXlg.medium,

          // Headline / section headings
          headlineLarge: textLg.bold,
          headlineMedium: textLg.semibold,
          headlineSmall: textLg.medium,

          // Titles / important labels
          titleLarge: textMd.bold,
          titleMedium: textMd.semibold,
          titleSmall: textMd.medium,

          // Body text
          bodyLarge: textMd.regular,
          bodyMedium: textSm.regular,
          bodySmall: textXs.regular,

          // Labels / buttons
          labelLarge: textSm.medium,
          labelMedium: textSm.semibold,
          labelSmall: textXs.medium,
        ),
      );
}
