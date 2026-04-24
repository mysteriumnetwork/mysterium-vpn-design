import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Visual style of a [Button]: filled, outlined, or text.
enum ButtonVariant {
  /// Filled background. Primary call-to-action.
  primary,

  /// Outlined border, transparent background. Secondary action.
  secondary,

  /// No border or background. Low-emphasis / inline action.
  tertiary,
}

/// Vertical size of a [Button]. Affects min height, padding, and text size.
enum ButtonSize { small, medium, large }

/// Loading state for a [Button].
///
/// When set, the button becomes non-interactive and renders a spinner in
/// place of the leading widget. If [text] is non-null it replaces the
/// button's child while loading.
@immutable
class ButtonLoading {
  const ButtonLoading({this.text});

  /// Label to show while loading. When null, the original child is kept.
  final String? text;

  @override
  String toString() => 'ButtonLoading(label: $text)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is ButtonLoading && other.text == text;
  }

  @override
  int get hashCode => text.hashCode;
}

/// Base class for the themed button variants.
///
/// Do not extend directly — use [ButtonPrimary], [ButtonSecondary], or
/// [ButtonTertiary]. The sealed hierarchy exists so [variant] can be pattern
/// matched at call sites.
sealed class Button extends StatelessWidget {
  const Button({
    required this.onPressed,
    required this.variant,
    required this.child,
    this.leading,
    this.trailing,
    this.loading,
    this.size = ButtonSize.medium,
    this.decoration = const ButtonDecoration(),
    super.key,
  });

  /// Tap handler. Pass `null` to render the button as disabled.
  final VoidCallback? onPressed;

  /// Which concrete variant this is (primary / secondary / tertiary).
  final ButtonVariant variant;

  /// Size preset — affects min height, padding, and text size.
  final ButtonSize size;

  /// Main button content. Typically a [Text].
  final Widget child;

  /// Optional leading widget (e.g. icon). Hidden while [loading] is set.
  final Widget? leading;

  /// Optional trailing widget (e.g. icon).
  final Widget? trailing;

  /// When non-null the button shows a spinner and becomes non-interactive.
  final ButtonLoading? loading;

  /// Overrides for colours, text style, min size, and padding.
  final ButtonDecoration decoration;
}

/// Overrides for a [Button]'s appearance.
///
/// Every field is optional — unspecified fields fall back to the button's
/// variant + size defaults.
@immutable
class ButtonDecoration {
  const ButtonDecoration({
    this.decorationColor,
    this.foregroundColor,
    this.borderColor,
    this.overlayColor,
    this.textStyle,
    this.minimumSize,
    this.padding,
  });

  /// Background colour.
  final Color? decorationColor;

  /// Text / icon colour.
  final Color? foregroundColor;

  /// Override the border color for [ButtonSecondary]. Has no effect on
  /// [ButtonPrimary] or [ButtonTertiary].
  final Color? borderColor;

  /// Hover/press overlay colour.
  final Color? overlayColor;

  /// Overrides the default size-derived text style.
  final TextStyle? textStyle;

  /// Overrides the default size-derived minimum size.
  final Size? minimumSize;

  /// Overrides the default size-derived padding.
  final EdgeInsets? padding;

  @override
  String toString() =>
      'ButtonDecoration(decorationColor: $decorationColor, foregroundColor: $foregroundColor, borderColor: $borderColor, overlayColor: $overlayColor, textStyle: $textStyle, minimumSize: $minimumSize, padding: $padding)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is ButtonDecoration &&
        other.decorationColor == decorationColor &&
        other.foregroundColor == foregroundColor &&
        other.borderColor == borderColor &&
        other.overlayColor == overlayColor &&
        other.textStyle == textStyle &&
        other.minimumSize == minimumSize &&
        other.padding == padding;
  }

  @override
  int get hashCode => Object.hash(
    decorationColor,
    foregroundColor,
    borderColor,
    overlayColor,
    textStyle,
    minimumSize,
    padding,
  );

  ButtonDecoration copyWith({
    Color? decorationColor,
    Color? foregroundColor,
    Color? borderColor,
    Color? overlayColor,
    TextStyle? textStyle,
    Size? minimumSize,
    EdgeInsets? padding,
  }) => ButtonDecoration(
    decorationColor: decorationColor ?? this.decorationColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    borderColor: borderColor ?? this.borderColor,
    overlayColor: overlayColor ?? this.overlayColor,
    textStyle: textStyle ?? this.textStyle,
    minimumSize: minimumSize ?? this.minimumSize,
    padding: padding ?? this.padding,
  );
}

/// Filled call-to-action button — the highest-emphasis variant.
class ButtonPrimary extends Button {
  const ButtonPrimary({
    required super.onPressed,
    required super.child,
    super.size,
    super.leading,
    super.trailing,
    super.loading,
    super.decoration,
    super.key,
  }) : super(variant: ButtonVariant.primary);

  @override
  Widget build(BuildContext context) => IgnorePointer(
    ignoring: loading != null,
    child: FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        elevation: 0,
        backgroundColor: decoration.decorationColor,
        foregroundColor: decoration.foregroundColor,
        iconColor: decoration.foregroundColor,
        minimumSize:
            decoration.minimumSize ??
            switch (size) {
              ButtonSize.small => const Size(60, 36),
              ButtonSize.medium => const Size(60, 40),
              ButtonSize.large => const Size(60, 44),
            },
        textStyle:
            decoration.textStyle ??
            switch (size) {
              ButtonSize.small => Theme.of(context).textStyles.textSm.semibold,
              _ => null,
            },
      ),
      child: _Child(
        loading: loading,
        leading: leading,
        trailing: trailing,
        size: size,
        padding: decoration.padding,
        child: child,
      ),
    ),
  );
}

/// Outlined button for secondary actions alongside a [ButtonPrimary].
class ButtonSecondary extends Button {
  const ButtonSecondary({
    required super.onPressed,
    required super.child,
    super.size,
    super.leading,
    super.trailing,
    super.loading,
    super.decoration,
    super.key,
  }) : super(variant: ButtonVariant.secondary);

  @override
  Widget build(BuildContext context) => IgnorePointer(
    ignoring: loading != null,
    child: OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        backgroundColor: decoration.decorationColor,
        foregroundColor: decoration.foregroundColor,
        iconColor: decoration.foregroundColor,
        side: decoration.borderColor != null ? BorderSide(color: decoration.borderColor!) : null,
        minimumSize:
            decoration.minimumSize ??
            switch (size) {
              ButtonSize.small => const Size(60, 36),
              ButtonSize.medium => const Size(60, 40),
              ButtonSize.large => const Size(60, 44),
            },
        textStyle:
            decoration.textStyle ??
            switch (size) {
              ButtonSize.small => Theme.of(context).textStyles.textSm.semibold,
              _ => null,
            },
      ),
      child: _Child(
        loading: loading,
        leading: leading,
        trailing: trailing,
        size: size,
        padding: decoration.padding,
        child: child,
      ),
    ),
  );
}

/// Text-only button for low-emphasis / inline actions.
class ButtonTertiary extends Button {
  const ButtonTertiary({
    required super.onPressed,
    required super.child,
    super.size,
    super.leading,
    super.trailing,
    super.loading,
    super.decoration,
    super.key,
  }) : super(variant: ButtonVariant.tertiary);

  @override
  Widget build(BuildContext context) => IgnorePointer(
    ignoring: loading != null,
    child: TextButton(
      onPressed: onPressed,
      style:
          TextButton.styleFrom(
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: decoration.decorationColor,
            foregroundColor: decoration.foregroundColor,
            iconColor: decoration.foregroundColor,
            minimumSize:
                decoration.minimumSize ??
                switch (size) {
                  ButtonSize.small => const Size(60, 36),
                  ButtonSize.medium => const Size(60, 40),
                  ButtonSize.large => const Size(60, 44),
                },
            textStyle:
                decoration.textStyle ??
                switch (size) {
                  ButtonSize.small => Theme.of(context).textStyles.textSm.semibold,
                  _ => null,
                },
          ).copyWith(
            overlayColor: decoration.overlayColor != null
                ? WidgetStatePropertyAll(decoration.overlayColor)
                : null,
          ),
      child: _Child(
        loading: loading,
        leading: leading,
        trailing: trailing,
        size: size,
        padding: decoration.padding,
        child: child,
      ),
    ),
  );
}

class _Child extends StatelessWidget {
  const _Child({
    required this.child,
    required this.leading,
    required this.trailing,
    required this.loading,
    required this.size,
    this.padding,
  });

  final Widget child;

  final Widget? leading;
  final Widget? trailing;
  final ButtonLoading? loading;
  final ButtonSize size;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).spacing;
    return Padding(
      padding:
          padding ??
          switch (size) {
            ButtonSize.small => EdgeInsets.symmetric(horizontal: spacing.md, vertical: spacing.s),
            ButtonSize.medium => EdgeInsets.symmetric(horizontal: spacing.md, vertical: spacing.lg),
            ButtonSize.large => EdgeInsets.symmetric(horizontal: spacing.md, vertical: spacing.ms),
          },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: switch (size) {
          ButtonSize.small => spacing.xs,
          ButtonSize.medium => spacing.xs,
          ButtonSize.large => spacing.s,
        },
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (leading != null && loading == null) leading!,
          if (loading != null) _LoadingIndicator(color: IconTheme.of(context).color),
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.xxs),
              child: loading?.text != null ? Text(loading!.text!) : child,
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator({required this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? Palette.of(context).textBrandPrimary;
    const radius = 16 / 2;
    return Stack(
      children: [
        CupertinoActivityIndicator(color: color, radius: radius, animating: false),
        CupertinoActivityIndicator(color: color, radius: radius),
      ],
    );
  }
}
