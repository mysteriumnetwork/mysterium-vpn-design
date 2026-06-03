import 'package:flutter/material.dart';

/// Wraps a single entry in a list-based navigation widget.
///
/// Used by `NavRail.itemWrapper` and `BottomNavBar.itemWrapper`. The `child`
/// argument is the fully built item (including tap targets and semantics).
/// Return `child` unchanged unless you need an outer layer (e.g. a product
/// tour).
///
/// For bottom navigation bars, `child` is an `Expanded` cell — keep it in
/// the tree so tabs stay equal width in the row.
typedef ListItemWrapper<T> =
    Widget Function({
      required BuildContext context,
      required int index,
      required T item,
      required Widget child,
    });
