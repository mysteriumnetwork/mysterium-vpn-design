import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Haptic feedback vocabulary for design-system controls.
///
/// Fires only on Android and iOS. Both platforms already gate these calls on
/// the user's system haptics setting, so there is nothing extra to honour here.
enum HapticLevel {
  /// No feedback.
  none,

  /// Discrete state change — tabs, navigation, list and option selection.
  selection,

  /// Ordinary button or icon-button press.
  press,

  /// High-consequence action — connect and disconnect.
  impact;

  /// Fires this feedback. No-op off Android/iOS.
  ///
  /// Use this for an inline tap body; use [wrap] for a pass-through callback.
  void fire() {
    if (!_supported) {
      return;
    }
    switch (this) {
      case HapticLevel.none:
        return;
      case HapticLevel.selection:
        HapticFeedback.selectionClick();
      case HapticLevel.press:
        HapticFeedback.lightImpact();
      case HapticLevel.impact:
        HapticFeedback.mediumImpact();
    }
  }

  /// Wraps [callback] so it fires this feedback first.
  ///
  /// Returns `null` for a `null` [callback] — controls derive their disabled
  /// rendering from a null handler, so the nullability has to survive.
  /// Off Android/iOS it returns [callback] untouched, which the AOT compiler
  /// folds into a pass-through.
  VoidCallback? wrap(VoidCallback? callback) {
    if (callback == null || this == HapticLevel.none || !_supported) {
      return callback;
    }
    return () {
      fire();
      callback();
    };
  }

  static bool get _supported => switch (defaultTargetPlatform) {
    TargetPlatform.android || TargetPlatform.iOS => true,
    _ => false,
  };
}
