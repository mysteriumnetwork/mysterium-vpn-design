import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class CheckboxItem extends StatelessWidget {
  const CheckboxItem({
    required this.value,
    required this.onChanged,
    required this.label,
    super.key,
  });

  final bool value;
  final VoidCallback? onChanged;
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
                  onChanged: (_) {},
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
