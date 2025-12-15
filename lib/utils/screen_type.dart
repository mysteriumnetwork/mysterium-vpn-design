import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

enum ScreenType implements Comparable<ScreenType> {
  watch._(300),
  mobile._(420),
  tablet._(750),
  desktop._(950);

  const ScreenType._(this.breakpoint);

  static ScreenType of(BuildContext context) {
    final scopeNotifier = _ScreenTypeScope.maybeOf(context);
    if (scopeNotifier != null) {
      // create widget dependency so callers rebuild on change
      // `dependOnInheritedWidgetOfExactType` already did that in maybeOf
      return scopeNotifier.value;
    }

    log(
      'ScreenType.of called without ScreenTypeObserver in widget tree. ',
      name: 'ScreenType',
      error:
          'Falling back to one-time size calculation. Consider wrapping your app with ScreenTypeObserver to get responsive updates.',
    );

    // fallback to original behaviour when provider isn't used
    final view = View.of(context);
    final size = view.physicalSize / view.devicePixelRatio;
    return fromSize(size);
  }

  static ScreenType fromSize(Size size) {
    final deviceWidth = size.width;

    return ScreenType.values
        .sortedByCompare((it) => it.breakpoint, (a, b) => b.compareTo(a))
        .firstWhere(
          (type) => deviceWidth >= type.breakpoint,
          orElse: () => ScreenType.mobile,
        );
  }

  final double breakpoint;

  @override
  int compareTo(ScreenType other) => breakpoint.compareTo(other.breakpoint);

  bool operator <(ScreenType other) => compareTo(other) < 0;

  bool operator <=(ScreenType other) => compareTo(other) <= 0;

  bool operator >(ScreenType other) => compareTo(other) > 0;

  bool operator >=(ScreenType other) => compareTo(other) >= 0;
}

class _ScreenTypeScope extends InheritedNotifier<ValueNotifier<ScreenType>> {
  const _ScreenTypeScope({
    required ValueNotifier<ScreenType> super.notifier,
    required super.child,
  });

  static ValueNotifier<ScreenType>? maybeOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_ScreenTypeScope>();
    return scope?.notifier;
  }
}

class ScreenTypeObserver extends StatefulWidget {
  const ScreenTypeObserver({required this.child, super.key});

  final Widget child;

  @override
  State<ScreenTypeObserver> createState() => _ScreenTypeProviderState();
}

class _ScreenTypeProviderState extends State<ScreenTypeObserver> with WidgetsBindingObserver {
  late final ValueNotifier<ScreenType> notifier;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final size = view.physicalSize / view.devicePixelRatio;
    notifier = ValueNotifier(ScreenType.fromSize(size));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    notifier.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final size = view.physicalSize / view.devicePixelRatio;
    notifier.value = ScreenType.fromSize(size);
  }

  @override
  Widget build(BuildContext context) => _ScreenTypeScope(notifier: notifier, child: widget.child);
}
