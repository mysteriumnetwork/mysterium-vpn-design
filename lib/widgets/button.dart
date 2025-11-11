import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

enum ButtonVariant {
  primary,
  secondary,
  link;
}

enum ButtonSize {
  small,
  medium,
  large;
}

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

abstract class Button extends StatelessWidget {
  const Button({
    required this.onPressed,
    required this.variant,
    required this.child,
    this.leading,
    this.trailing,
    this.loading,
    this.size = ButtonSize.medium,
    super.key,
  });

  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final Widget child;
  final Widget? leading;
  final Widget? trailing;
  final ButtonLoading? loading;
}

class ButtonPrimary extends Button {
  const ButtonPrimary({
    required super.onPressed,
    required super.child,
    super.size,
    super.leading,
    super.trailing,
    super.loading,
    super.key,
  }) : super(variant: ButtonVariant.primary);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IgnorePointer(
      ignoring: loading != null,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          minimumSize: switch (size) {
            ButtonSize.small => const Size(120, 36),
            ButtonSize.medium => const Size(140, 40),
            ButtonSize.large => const Size(150, 44),
          },
          textStyle: switch (size) {
            ButtonSize.small => Theme.of(context).textStyles.textSm.semibold,
            _ => null,
          },
          padding: switch (size) {
            ButtonSize.small => const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ButtonSize.medium => const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
            ButtonSize.large => const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
          },
        ),
        child: _Child(
          loading: loading,
          loadingColor:
              theme.filledButtonTheme.style?.foregroundColor?.resolve({}) ??
                  theme.palette.textWhite,
          leading: leading,
          trailing: trailing,
          size: size,
          child: child,
        ),
      ),
    );
  }
}

class ButtonSecondary extends Button {
  const ButtonSecondary({
    required super.onPressed,
    required super.child,
    super.size,
    super.leading,
    super.trailing,
    super.loading,
    super.key,
  }) : super(variant: ButtonVariant.secondary);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IgnorePointer(
      ignoring: loading != null,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: switch (size) {
            ButtonSize.small => const Size(120, 36),
            ButtonSize.medium => const Size(140, 40),
            ButtonSize.large => const Size(150, 44),
          },
          textStyle: switch (size) {
            ButtonSize.small => Theme.of(context).textStyles.textSm.semibold,
            _ => null,
          },
          padding: switch (size) {
            ButtonSize.small => const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ButtonSize.medium => const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
            ButtonSize.large => const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
          },
        ),
        child: _Child(
          loading: loading,
          loadingColor:
              theme.outlinedButtonTheme.style?.foregroundColor?.resolve({}) ??
                  theme.palette.textSecondary,
          leading: leading,
          trailing: trailing,
          size: size,
          child: child,
        ),
      ),
    );
  }
}

class _Child extends StatelessWidget {
  const _Child({
    required this.child,
    required this.leading,
    required this.trailing,
    required this.loading,
    required this.size,
    required this.loadingColor,
  });

  final Widget child;

  final Widget? leading;
  final Widget? trailing;
  final ButtonLoading? loading;
  final ButtonSize size;
  final Color loadingColor;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        spacing: switch (size) {
          ButtonSize.small => 6,
          ButtonSize.medium => 8,
          ButtonSize.large => 10,
        },
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (leading != null && loading == null) leading!,
          if (loading != null)
            _LoadingIndicator(
              size: switch (size) { ButtonSize.small => 14, _ => 16 },
              color: loadingColor,
            ),
          Flexible(
            child: loading?.text != null ? Text(loading!.text!) : child,
          ),
          if (trailing != null) trailing!,
        ],
      );
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator({required this.size, required this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? Palette.of(context).textBrandPrimary;
    final radius = size / 2;
    return Stack(
      children: [
        CupertinoActivityIndicator(
          color: color,
          radius: radius,
          animating: false,
        ),
        CupertinoActivityIndicator(color: color, radius: radius),
      ],
    );
  }
}
