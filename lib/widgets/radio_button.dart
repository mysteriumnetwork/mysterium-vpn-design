import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Themed radio button that works either inside a [RadioGroup] ancestor or
/// standalone via [selected] / [onPressed].
///
/// In group mode, tapping calls the enclosing [RadioGroup]'s onChanged with
/// [value]. In standalone mode, pass [selected] to drive the visual state
/// and [onPressed] to handle taps. When both are null the widget renders
/// as a read-only indicator.
class RadioButton<T> extends StatelessWidget {
  const RadioButton({
    this.value,
    this.selected,
    this.onPressed,
    this.enabled = true,
    this.radius = 20.0,
    super.key,
  });

  /// Value identifying this option within a [RadioGroup].
  final T? value;

  /// Explicit selection state. When non-null, overrides the group-based
  /// selection so the widget can be used without a [RadioGroup] ancestor.
  final bool? selected;

  /// Tap handler for standalone use. Bypasses the [RadioGroup] when set.
  final VoidCallback? onPressed;

  /// When `false` the widget renders with a disabled palette.
  final bool enabled;

  /// Outer circle diameter in logical pixels. Defaults to 20.
  final double radius;

  /// Finds the nearest [RadioGroup] state of matching type [T], if any.
  ///
  /// Exposed so composite widgets (e.g. [PlanCard]) can read / toggle the
  /// group themselves rather than embedding a tappable [RadioButton].
  static RadioGroupRegistry<T>? findGroupState<T>(BuildContext context) {
    final state = context.findAncestorStateOfType<State<RadioGroup<T>>>();
    if (state is RadioGroupRegistry<T>) {
      return state! as RadioGroupRegistry<T>;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final palette = Palette.of(context);
    final groupState = findGroupState<T>(context);
    final isSelected = selected ?? (groupState != null && groupState.groupValue == value);

    final icon = _Icon(
      radius: radius,
      foregroundColor: _getForegroundColor(palette, isSelected),
      backgroundColor: _getBackgroundColor(palette, isSelected),
      borderColor: _getBorderColor(palette, isSelected),
    );

    // Standalone mode: render just the visual indicator.
    if (groupState == null && onPressed == null) {
      return icon;
    }

    void handlePressed() {
      if (onPressed != null) {
        onPressed!.call();
      } else {
        groupState?.onChanged.call(value);
      }
    }

    return RawMaterialButton(
      onPressed: handlePressed,
      shape: const CircleBorder(),
      materialTapTargetSize: MaterialTapTargetSize.padded,
      constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
      child: icon,
    );
  }

  Color? _getBorderColor(Palette palette, bool selected) {
    if (selected && enabled) {
      return null;
    }
    return palette.borderPrimary;
  }

  Color? _getBackgroundColor(Palette palette, bool selected) {
    if (!enabled) {
      return palette.bgInactive;
    }
    if (selected) {
      return Palette.brand.shade400;
    }
    return null;
  }

  Color? _getForegroundColor(Palette palette, bool selected) {
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
          decoration: BoxDecoration(shape: BoxShape.circle, color: foregroundColor),
          child: SizedBox.square(dimension: radius * .4),
        ),
    ],
  );
}
