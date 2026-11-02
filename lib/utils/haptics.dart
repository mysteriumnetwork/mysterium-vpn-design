import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Haptic feedback vocabulary for design-system controls.
///
/// Fires only on Android and iOS. Both platforms already gate these calls on
/// the user's system haptics setting. See `docs/haptics.md` for which control
/// uses which level.
enum HapticLevel {
  /// No feedback.
  none,

  /// Discrete state change — list and option selection.
  selection,

  /// Ordinary button or icon-button press.
  press,

  /// High-consequence action — connect and disconnect.
  impact,

  /// A task finished — the tunnel came up, a purchase went through.
  success,

  /// A task finished with a caveat.
  warning,

  /// A task failed.
  error;

  /// Master switch, mirroring the user's in-app haptics setting.
  ///
  /// Read when feedback fires rather than when it is wrapped, so flipping it
  /// takes effect without rebuilding the widgets that wrapped a callback.
  static bool enabled = true;

  /// Fires this feedback. No-op off Android/iOS, or when [enabled] is false.
  ///
  /// Use this for an inline tap body or a state outcome; use [wrap] for a
  /// pass-through callback.
  void fire() {
    if (!enabled || !_platformSupported) {
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
      case HapticLevel.success:
        HapticFeedback.successNotification();
      case HapticLevel.warning:
        HapticFeedback.warningNotification();
      case HapticLevel.error:
        HapticFeedback.errorNotification();
    }
  }

  /// Wraps [callback] so it fires this feedback first.
  ///
  /// Returns `null` for a `null` [callback] — controls derive their disabled
  /// rendering from a null handler, so the nullability has to survive.
  /// Off Android/iOS it returns [callback] untouched, which the AOT compiler
  /// folds into a pass-through.
  VoidCallback? wrap(VoidCallback? callback) {
    if (callback == null || this == HapticLevel.none || !_platformSupported) {
      return callback;
    }
    return () {
      fire();
      callback();
    };
  }

  static bool get _platformSupported => switch (defaultTargetPlatform) {
    TargetPlatform.android || TargetPlatform.iOS => true,
    _ => false,
  };
}
