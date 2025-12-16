import 'package:flutter/widgets.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

abstract class WidgetbookUtils {
  const WidgetbookUtils._();

  static const Map<String, IconData> namedIcons = {
    'activity': UntitledUI.activity,
    'alert_circle': UntitledUI.alert_circle,
    'arrow_down': UntitledUI.arrow_down,
    'arrow_left': UntitledUI.arrow_left,
    'arrow_right': UntitledUI.arrow_right,
    'arrow_up': UntitledUI.arrow_up,
    'check_circle': UntitledUI.check_circle,
    'x_close': UntitledUI.x_close,
    'download_01': UntitledUI.download_01,
    'heart': UntitledUI.heart,
    'lock_02': UntitledUI.lock_02,
    'file_search_02': UntitledUI.file_search_02,
    'settings_02': UntitledUI.settings_02,
    'share_02': UntitledUI.share_02,
    'star_02': UntitledUI.star_02,
    'upload_02': UntitledUI.upload_02,
  };

  static List<IconData> get icons => namedIcons.values.toList();

  static String iconName(IconData icon) => namedIcons.entries
      .firstWhere(
        (entry) => entry.value == icon,
        orElse: () => const MapEntry('unknown', UntitledUI.activity),
      )
      .key;
}
