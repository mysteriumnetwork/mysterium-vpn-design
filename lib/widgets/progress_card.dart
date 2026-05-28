import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({
    required this.actionlabel,
    required this.onActionPressed,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.progressValue,
    this.progressLabel,
    this.title,
    this.description,
    super.key,
  });

  final IconData? icon;
  final double? progressValue;
  final String? progressLabel;
  final Color? iconColor;
  final String? title;
  final String? description;
  final String actionlabel;
  final VoidCallback onActionPressed;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    const spacing = Spacing();
    final theme = Theme.of(context);

    final bgColor =
        backgroundColor ??
        (theme.brightness == Brightness.dark
            ? Palette.grayLight.shade800
            : Palette.grayLight.shade25);

    final iconBgColor = theme.brightness == Brightness.dark
        ? Palette.brand.shade900
        : Palette.brand.shade100;

    final iconFgColor =
        iconColor ?? (theme.brightness == Brightness.dark ? Palette.brand.shade400 : Palette.brand);

    final titleColor = theme.brightness == Brightness.dark
        ? Palette.white
        : Palette.grayLight.shade800;

    final descriptionColor = theme.brightness == Brightness.dark
        ? Palette.white.withAlpha(143)
        : Palette.grayLight;

    final buttonTextColor = theme.brightness == Brightness.dark
        ? Palette.brand.shade300
        : Palette.brand.shade600;

    final progressHeader = Row(
      children: [
        if (icon != null)
          Padding(
            padding: EdgeInsets.only(right: spacing.md),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: iconBgColor,
              child: Icon(icon, color: iconFgColor, size: 20),
            ),
          ),
        if (progressValue != null) Expanded(child: ProgressBar.linear(value: progressValue!)),
        if (progressLabel != null)
          Padding(
            padding: EdgeInsets.only(left: spacing.md),
            child: SizedBox(
              width: spacing.xl3,
              child: FittedBox(fit: BoxFit.scaleDown, child: Text(progressLabel!)),
            ),
          ),
      ],
    );

    return Container(
      decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.kM), color: bgColor),
      padding: EdgeInsets.all(spacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          progressHeader,
          if (progressHeader.children.isNotEmpty) SizedBox(height: spacing.ms),
          if (title != null)
            Padding(
              padding: EdgeInsets.only(top: spacing.ms),
              child: Row(
                children: [
                  Expanded(
                    child: Text(title!, style: TextStyles(color: titleColor).textMd.semibold),
                  ),
                ],
              ),
            ),
          if (description != null)
            Padding(
              padding: EdgeInsets.only(top: spacing.s),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      description!,
                      style: TextStyles(color: descriptionColor).textXs.regular,
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.only(top: spacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ButtonTertiary(
                  onPressed: onActionPressed,
                  child: Text(
                    actionlabel,
                    style: TextStyles(color: buttonTextColor).textSm.semibold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
