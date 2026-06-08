import 'package:flutter/material.dart';

/// Wraps one fully built widget.
///
/// Use this when a component exposes a single child that may need an outer
/// layer, such as a product tour target, analytics boundary, or keyed test
/// fixture. The [child] argument is the complete widget built by the component,
/// including its own tap targets and semantics.
///
/// Return [child] unchanged unless you need to add that outer layer.
typedef SingleWidgetWrapper =
    Widget Function({required BuildContext context, required Widget child});

/// Wraps a single entry in a list-based navigation widget.
///
/// Used by `NavRail.itemWrapper` and `BottomNavBar.itemWrapper`. The [child]
/// argument is the fully built item (including tap targets and semantics).
/// Return [child] unchanged unless you need an outer layer, such as a product
/// tour target.
///
/// For bottom navigation bars, [child] is an `Expanded` cell. Keep it in the
/// tree so tabs stay equal width in the row.
typedef ListItemWrapper<T> =
    Widget Function({
      required BuildContext context,
      required int index,
      required T item,
      required Widget child,
    });
