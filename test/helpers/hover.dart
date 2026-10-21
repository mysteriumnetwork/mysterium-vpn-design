import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';

/// Parks a mouse pointer over [finder] and settles past any transition.
///
/// Returns the gesture so callers can move the pointer away again to assert
/// the resting state.
Future<TestGesture> hover(WidgetTester tester, Finder finder) async {
  final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
  await gesture.addPointer(location: Offset.zero);
  addTearDown(gesture.removePointer);
  await gesture.moveTo(tester.getCenter(finder));
  await tester.pumpAndSettle();
  return gesture;
}
