import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

// ─── Variant ──────────────────────────────────────────────────────────────────

/// Visual variant for an [OnboardingComparisonCard].
///
/// [dataCentre] uses red accents and "x" icons for negatives — typically used
/// to depict a generic "Most VPNs" experience. [residential] uses green
/// accents and check icons for positives — used to depict the Mysterium VPN
/// experience built on residential IPs.
enum OnboardingComparisonCardVariant { dataCentre, residential }

// ─── OnboardingComparisonCard ─────────────────────────────────────────────────────────

/// A small browser-window styled card used in onboarding screens to compare
/// "most VPNs" (data centre IPs) against Mysterium VPN (residential IPs).
///
/// Two cards are usually composed side-by-side or stacked with overlap to
/// build the comparison illustration. Both look-and-feel variations are
/// produced by the same widget — switch them via [variant].
///
/// Copy and [image] are supplied by the caller — the design system does not
/// ship the illustrations, so consumers pass per-variant theme-aware assets.
class OnboardingComparisonCard extends StatelessWidget {
  const OnboardingComparisonCard({
    required this.variant,
    required this.pillLabel,
    required this.title,
    required this.items,
    required this.image,
    this.width,
    this.pillMaxWidth,
    this.contentTrailingPadding,
    super.key,
  });

  final OnboardingComparisonCardVariant variant;

  /// Pill text rendered on its own line between the title and the items
  /// list. Caps at [pillMaxWidth] (when set) and wraps to a second line if
  /// exceeded.
  final String pillLabel;

  /// Card heading shown below the illustration. e.g. "Most VPNs".
  final String title;

  /// Bullet rows shown in the list. Each entry is rendered with a leading
  /// status indicator that matches [variant].
  final List<String> items;

  /// Illustration rendered inside the circular badge.
  final ImageProvider image;

  /// Optional fixed width. The card sizes to its content when null.
  final double? width;

  /// Optional max width of the pill label. When the natural text width
  /// exceeds this the label wraps to a second line.
  final double? pillMaxWidth;

  /// Optional extra padding on the trailing side of the body. Use when this
  /// card is the "back" card of an overlapping comparison to reserve space
  /// for the front card on the right — the body content stays inside the
  /// remaining visible area instead of being hidden behind the front card.
  /// When null defaults to the standard body padding.
  final double? contentTrailingPadding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = _CardTokens.resolve(variant: variant, isDark: isDark);

    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.kM),
          boxShadow: [tokens.dropShadow],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TrafficLightBar(tokens: tokens),
            _CardBody(
              tokens: tokens,
              variant: variant,
              pillLabel: pillLabel,
              title: title,
              items: items,
              image: image,
              pillMaxWidth: pillMaxWidth,
              contentTrailingPadding: contentTrailingPadding,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Tokens ───────────────────────────────────────────────────────────────────

class _CardTokens {
  const _CardTokens({
    required this.bodyDecoration,
    required this.barColor,
    required this.barBorderColor,
    required this.statusBg,
    required this.statusGlow,
    required this.statusIcon,
    required this.itemTextColor,
    required this.titleColor,
    required this.itemTextSize,
    required this.listGap,
    required this.pillBg,
    required this.pillBorder,
    required this.pillTextColor,
    required this.dropShadow,
  });

  factory _CardTokens.resolve({
    required OnboardingComparisonCardVariant variant,
    required bool isDark,
  }) {
    final dropShadow = switch (variant) {
      OnboardingComparisonCardVariant.dataCentre => const BoxShadow(
        color: Color(0x1A000000),
        offset: Offset(15, 21),
        blurRadius: 16.6,
      ),
      OnboardingComparisonCardVariant.residential => const BoxShadow(
        color: Color(0x40000000),
        offset: Offset(8, 10),
        blurRadius: 17.1,
      ),
    };

    if (isDark) {
      const cardBorder = Color(0x803B3447);
      final bodyDecoration = switch (variant) {
        OnboardingComparisonCardVariant.dataCentre => BoxDecoration(
          color: const Color(0xFF251E31),
          border: Border.all(color: cardBorder),
          borderRadius: const BorderRadius.only(bottomLeft: Radius.kM, bottomRight: Radius.kM),
        ),
        OnboardingComparisonCardVariant.residential => BoxDecoration(
          gradient: const RadialGradient(
            center: Alignment(-0.25, -0.5),
            radius: 1.1,
            colors: [Color(0xFF393047), Color(0xFF261D35)],
          ),
          border: Border.all(color: cardBorder),
          borderRadius: const BorderRadius.only(bottomLeft: Radius.kM, bottomRight: Radius.kM),
        ),
      };

      return _CardTokens(
        bodyDecoration: bodyDecoration,
        barColor: const Color(0x66404040),
        barBorderColor: cardBorder,
        statusBg: variant == OnboardingComparisonCardVariant.dataCentre
            ? Palette.error.shade700
            : Palette.success.shade700,
        statusGlow: variant == OnboardingComparisonCardVariant.dataCentre
            ? const Color(0x8CDE3B3D)
            : const Color(0x8C25984D),
        statusIcon: variant == OnboardingComparisonCardVariant.dataCentre
            ? UntitledUI.x_close
            : UntitledUI.check,
        titleColor: Palette.white,
        itemTextColor: variant == OnboardingComparisonCardVariant.dataCentre
            ? const Color(0x8FFFFFFF)
            : Palette.white,
        itemTextSize: variant == OnboardingComparisonCardVariant.dataCentre ? 11 : 12,
        listGap: variant == OnboardingComparisonCardVariant.dataCentre ? 12 : 16,
        pillBg: variant == OnboardingComparisonCardVariant.dataCentre
            ? const Color(0x1FC5C3ED)
            : const Color(0x1F25984D),
        pillBorder: variant == OnboardingComparisonCardVariant.dataCentre
            ? const Color(0x14FFFFFF)
            : const Color(0xA6079455),
        pillTextColor: variant == OnboardingComparisonCardVariant.dataCentre
            ? const Color(0x80FFFFFF)
            : const Color(0xFF25984D),
        dropShadow: dropShadow,
      );
    }

    final bodyDecoration = switch (variant) {
      OnboardingComparisonCardVariant.dataCentre => const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [Color(0xFFF9F9F9), Color(0xFFFFFFFF)],
          stops: [0.17, 0.78],
        ),
        borderRadius: BorderRadius.only(bottomLeft: Radius.kM, bottomRight: Radius.kM),
      ),
      OnboardingComparisonCardVariant.residential => const BoxDecoration(
        color: Palette.white,
        borderRadius: BorderRadius.only(bottomLeft: Radius.kM, bottomRight: Radius.kM),
      ),
    };

    return _CardTokens(
      bodyDecoration: bodyDecoration,
      barColor: const Color(0xFFF3F0F7),
      barBorderColor: const Color(0xFFE7E7ED),
      statusBg: variant == OnboardingComparisonCardVariant.dataCentre
          ? const Color(0xFFDE3B3D)
          : const Color(0xFF25984D),
      statusGlow: variant == OnboardingComparisonCardVariant.dataCentre
          ? const Color(0x8CDE3B3D)
          : const Color(0x8C25984D),
      statusIcon: variant == OnboardingComparisonCardVariant.dataCentre
          ? UntitledUI.x_close
          : UntitledUI.check,
      titleColor: const Color(0xFF252B37),
      itemTextColor: variant == OnboardingComparisonCardVariant.dataCentre
          ? const Color(0xFF535862)
          : const Color(0xFF252B37),
      itemTextSize: variant == OnboardingComparisonCardVariant.dataCentre ? 11 : 12,
      listGap: variant == OnboardingComparisonCardVariant.dataCentre ? 12 : 16,
      pillBg: variant == OnboardingComparisonCardVariant.dataCentre
          ? const Color(0x1FC5C3ED)
          : const Color(0x1F25984D),
      pillBorder: variant == OnboardingComparisonCardVariant.dataCentre
          ? const Color(0xFFF1F1F1)
          : const Color(0x5925984D),
      pillTextColor: variant == OnboardingComparisonCardVariant.dataCentre
          ? const Color(0xFF676767)
          : const Color(0xFF25984D),
      dropShadow: dropShadow,
    );
  }

  final BoxDecoration bodyDecoration;
  final Color barColor;
  final Color barBorderColor;
  final Color statusBg;
  final Color statusGlow;
  final IconData statusIcon;
  final Color itemTextColor;
  final Color titleColor;
  final double itemTextSize;
  final double listGap;
  final Color pillBg;
  final Color pillBorder;
  final Color pillTextColor;
  final BoxShadow dropShadow;
}

// ─── Traffic-light bar (top of the window) ────────────────────────────────────

class _TrafficLightBar extends StatelessWidget {
  const _TrafficLightBar({required this.tokens});

  final _CardTokens tokens;

  @override
  Widget build(BuildContext context) => Container(
    height: 25,
    decoration: BoxDecoration(
      color: tokens.barColor,
      border: Border(bottom: BorderSide(color: tokens.barBorderColor)),
      borderRadius: const BorderRadius.only(topLeft: Radius.kM, topRight: Radius.kM),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: const Row(
      children: [
        _TrafficDot(color: Color(0xFFFF5F57)),
        SizedBox(width: 6),
        _TrafficDot(color: Color(0xFFFEBC2E)),
        SizedBox(width: 6),
        _TrafficDot(color: Color(0xFF28C840)),
      ],
    ),
  );
}

class _TrafficDot extends StatelessWidget {
  const _TrafficDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: 8,
    height: 8,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

// ─── Card body ────────────────────────────────────────────────────────────────

const double _kCardBodyPadding = 16;

class _CardBody extends StatelessWidget {
  const _CardBody({
    required this.tokens,
    required this.variant,
    required this.pillLabel,
    required this.title,
    required this.items,
    required this.image,
    required this.pillMaxWidth,
    required this.contentTrailingPadding,
  });

  final _CardTokens tokens;
  final OnboardingComparisonCardVariant variant;
  final String pillLabel;
  final String title;
  final List<String> items;
  final ImageProvider image;
  final double? pillMaxWidth;
  final double? contentTrailingPadding;

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textStyles;
    final padding = contentTrailingPadding == null
        ? const EdgeInsetsDirectional.all(_kCardBodyPadding)
        : EdgeInsetsDirectional.fromSTEB(
            _kCardBodyPadding,
            _kCardBodyPadding,
            contentTrailingPadding!,
            _kCardBodyPadding,
          );
    return DecoratedBox(
      decoration: tokens.bodyDecoration,
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ImageBadge(image: image),
            const SizedBox(height: 8),
            Text(
              title,
              style: textStyles.textMd.bold.copyWith(
                height: 16.25 / 16,
                letterSpacing: -0.176,
                color: tokens.titleColor,
              ),
            ),
            const SizedBox(height: 8),
            _Pill(label: pillLabel, tokens: tokens, maxWidth: pillMaxWidth),
            const SizedBox(height: 16),
            _ItemList(items: items, tokens: tokens),
          ],
        ),
      ),
    );
  }
}

// ─── Image badge ──────────────────────────────────────────────────────────────

class _ImageBadge extends StatelessWidget {
  const _ImageBadge({required this.image});

  final ImageProvider image;

  @override
  Widget build(BuildContext context) => Image(image: image, width: 56, height: 56);
}

// ─── Pill (own line between title and items, wraps when wider than maxWidth) ─

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.tokens, this.maxWidth});

  final String label;
  final _CardTokens tokens;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      label,
      style: Theme.of(context).textStyles.textXs.bold.copyWith(
        fontSize: 8,
        height: 15 / 8,
        letterSpacing: 0.5,
        color: tokens.pillTextColor,
      ),
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: tokens.pillBg,
        border: Border.all(color: tokens.pillBorder),
        borderRadius: const BorderRadius.all(Radius.kFull),
      ),
      child: maxWidth == null
          ? text
          : ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth!),
              child: text,
            ),
    );
  }
}

// ─── Item list ────────────────────────────────────────────────────────────────

class _ItemList extends StatelessWidget {
  const _ItemList({required this.items, required this.tokens});

  final List<String> items;
  final _CardTokens tokens;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (var i = 0; i < items.length; i++) ...[
        if (i > 0) SizedBox(height: tokens.listGap),
        _Item(text: items[i], tokens: tokens),
      ],
    ],
  );
}

class _Item extends StatelessWidget {
  const _Item({required this.text, required this.tokens});

  final String text;
  final _CardTokens tokens;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      _StatusIndicator(tokens: tokens),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          text,
          style: Theme.of(context).textStyles.textXs.regular.copyWith(
            fontSize: tokens.itemTextSize,
            height: 18 / tokens.itemTextSize,
            letterSpacing: -0.176,
            color: tokens.itemTextColor,
          ),
        ),
      ),
    ],
  );
}

// ─── Status indicator (round colored badge with x/check) ──────────────────────

class _StatusIndicator extends StatelessWidget {
  const _StatusIndicator({required this.tokens});

  final _CardTokens tokens;

  @override
  Widget build(BuildContext context) => Container(
    width: 20,
    height: 20,
    decoration: BoxDecoration(
      color: tokens.statusBg,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: tokens.statusGlow,
          blurRadius: 6,
          spreadRadius: -1,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Center(child: Icon(tokens.statusIcon, size: 12, color: Palette.white)),
  );
}
