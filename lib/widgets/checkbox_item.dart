import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// A row combining a [Checkbox] with a tappable label.
///
/// The whole row acts as the hit target — tapping anywhere calls
/// [onChanged]. Intended for forms and option lists where the label is
/// rich (e.g. contains [LinkSpan]s).
class CheckboxItem extends StatelessWidget {
  const CheckboxItem({
    required this.value,
    required this.onChanged,
    required this.label,
    super.key,
  });

  /// Whether the checkbox is currently checked.
  final bool value;

  /// Invoked when the row is tapped. Pass `null` to render as read-only.
  final VoidCallback? onChanged;

  /// Label shown next to the checkbox. Typically a [Text] or [RichText].
  final Widget label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onChanged,
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: theme.spacing.lg,
        children: [
          Padding(
            padding: EdgeInsets.only(top: theme.spacing.xxs),
            child: SizedBox(
              width: 20,
              height: 20,
              child: IgnorePointer(
                child: Checkbox(
                  value: value,
                  onChanged: onChanged == null ? null : (_) {},
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
          ),
          Expanded(child: label),
        ],
      ),
    );
  }
}
