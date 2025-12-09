import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class RadioButton<T> extends StatelessWidget {
  const RadioButton({
    required this.value,
    this.onPressed,
    this.enabled = true,
    this.radius = 20.0,
    super.key,
  });

  final T? value;
  final VoidCallback? onPressed;
  final bool enabled;
  final double radius;

  static RadioGroupRegistry<T>? _findGroupState<T>(BuildContext context) {
    final state = context.findAncestorStateOfType<State<RadioGroup<T>>>();
    if (state is RadioGroupRegistry<T>) {
      return state! as RadioGroupRegistry<T>;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final palette = Palette.of(context);
    final groupState = _findGroupState<T>(context);
    final selected = groupState != null && groupState.groupValue == value;

    void onPressed() {
      if (this.onPressed != null) {
        this.onPressed!.call();
      } else {
        groupState?.onChanged.call(value);
      }
    }

    return RawMaterialButton(
      onPressed: onPressed,
      shape: const CircleBorder(),
      materialTapTargetSize: MaterialTapTargetSize.padded,
      constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
      child: _Icon(
        radius: radius,
        foregroundColor: _getForegroundColor(palette, selected),
        backgroundColor: _getBackgroundColor(palette, selected),
        borderColor: _getBorderColor(palette, selected),
      ),
    );
  }

  Color? _getBorderColor(
    Palette palette,
    bool selected,
  ) {
    if (selected && enabled) {
      return null;
    }
    return palette.borderPrimary;
  }

  Color? _getBackgroundColor(
    Palette palette,
    bool selected,
  ) {
    if (!enabled) {
      return palette.bgInactive;
    }
    if (selected) {
      return Palette.brand;
    }
    return null;
  }

  Color? _getForegroundColor(
    Palette palette,
    bool selected,
  ) {
    if (!selected) {
      return null;
    }
    if (!enabled) {
      return palette.iconDisabled;
    }
    return palette.iconWhite;
  }
}

class _Icon extends StatelessWidget {
  const _Icon({
    required this.radius,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.borderColor,
  });

  final double radius;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.center,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
              border: borderColor != null
                  ? BoxBorder.fromBorderSide(BorderSide(color: borderColor!))
                  : null,
            ),
            child: SizedBox.square(dimension: radius),
          ),
          if (foregroundColor != null)
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: foregroundColor,
              ),
              child: SizedBox.square(dimension: radius * .4),
            ),
        ],
      );
}
