import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class PromoBar extends StatelessWidget {
  const PromoBar({
    required this.text,
    this.onTap,
    this.icon,
    this.actionIcon = Icons.chevron_right,
    super.key,
  });

  final Widget? icon;
  final IconData actionIcon;
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RawMaterialButton(
      onPressed: onTap,
      visualDensity: VisualDensity.compact,
      elevation: 0,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      fillColor: Palette.brand.shade300,
      constraints: const BoxConstraints(minHeight: 40, minWidth: double.infinity),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Row(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null)
                  IconTheme(
                    data: IconThemeData(color: Palette.brand.shade700),
                    child: SizedBox.square(dimension: 24, child: icon),
                  ),
                Flexible(
                  flex: 3,
                  child: Text(
                    text,
                    style: theme.textStyles.textSm.semibold.copyWith(
                      color: Palette.grayLight.shade800,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null)
            Positioned(
              right: 0,
              bottom: 0,
              top: 0,
              child: IconButton(
                onPressed: onTap,
                icon: Icon(actionIcon, color: Palette.grayLight.shade800),
              ),
            ),
        ],
      ),
    );
  }
}
