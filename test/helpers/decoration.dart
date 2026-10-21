import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The [BoxDecoration] of the first [DecoratedBox] under [of].
BoxDecoration decorationOf(WidgetTester tester, Finder of) =>
    tester
            .widget<DecoratedBox>(
              find.descendant(of: of, matching: find.byType(DecoratedBox)).first,
            )
            .decoration
        as BoxDecoration;
