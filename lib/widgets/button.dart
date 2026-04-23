import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

enum ButtonVariant { primary, secondary, tertiary }

enum ButtonSize { small, medium, large }

@immutable
class ButtonLoading {
  const ButtonLoading({this.text});

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

  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final Widget child;
  final Widget? leading;
  final Widget? trailing;
  final ButtonLoading? loading;
  final ButtonDecoration decoration;
}

@immutable
class ButtonDecoration {
  const ButtonDecoration({
    this.decorationColor,
    this.foregroundColor,
    this.borderColor,
    this.textStyle,
    this.minimumSize,
    this.padding,
  });

  final Color? decorationColor;
  final Color? foregroundColor;

  /// Override the border color for [ButtonSecondary]. Has no effect on
  /// [ButtonPrimary] or [ButtonTertiary].
  final Color? borderColor;

  final TextStyle? textStyle;
  final Size? minimumSize;
  final EdgeInsets? padding;

  @override
  String toString() =>
      'ButtonDecoration(decorationColor: $decorationColor, foregroundColor: $foregroundColor, borderColor: $borderColor, textStyle: $textStyle, minimumSize: $minimumSize, padding: $padding)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is ButtonDecoration &&
        other.decorationColor == decorationColor &&
        other.foregroundColor == foregroundColor &&
        other.borderColor == borderColor &&
        other.textStyle == textStyle &&
        other.minimumSize == minimumSize &&
        other.padding == padding;
  }

  @override
  int get hashCode =>
      Object.hash(decorationColor, foregroundColor, borderColor, textStyle, minimumSize, padding);

  ButtonDecoration copyWith({
    Color? decorationColor,
    Color? foregroundColor,
    Color? borderColor,
    TextStyle? textStyle,
    Size? minimumSize,
    EdgeInsets? padding,
  }) => ButtonDecoration(
    decorationColor: decorationColor ?? this.decorationColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    borderColor: borderColor ?? this.borderColor,
    textStyle: textStyle ?? this.textStyle,
    minimumSize: minimumSize ?? this.minimumSize,
    padding: padding ?? this.padding,
  );
}

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
      style: TextButton.styleFrom(
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
