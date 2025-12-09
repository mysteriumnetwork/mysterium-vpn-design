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
  Widget build(BuildContext context) => IgnorePointer(
        ignoring: loading != null,
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            minimumSize: switch (size) {
              ButtonSize.small => const Size(60, 36),
              ButtonSize.medium => const Size(60, 40),
              ButtonSize.large => const Size(60, 44),
            },
            textStyle: switch (size) {
              ButtonSize.small => Theme.of(context).textStyles.textSm.semibold,
              _ => null,
            },
          ),
          child: _Child(
            loading: loading,
            leading: leading,
            trailing: trailing,
            size: size,
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
            minimumSize: switch (size) {
              ButtonSize.small => const Size(60, 36),
              ButtonSize.medium => const Size(60, 40),
              ButtonSize.large => const Size(60, 44),
            },
            textStyle: switch (size) {
              ButtonSize.small => Theme.of(context).textStyles.textSm.semibold,
              _ => null,
            },
          ),
          child: _Child(
            loading: loading,
            leading: leading,
            trailing: trailing,
            size: size,
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
  });

  final Widget child;

  final Widget? leading;
  final Widget? trailing;
  final ButtonLoading? loading;
  final ButtonSize size;

  @override
  Widget build(BuildContext context) => Padding(
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: switch (size) {
            ButtonSize.small => 4,
            ButtonSize.medium => 4,
            ButtonSize.large => 8,
          },
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (leading != null && loading == null) leading!,
            if (loading != null)
              _LoadingIndicator(
                color: IconTheme.of(context).color,
              ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: loading?.text != null ? Text(loading!.text!) : child,
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      );
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
