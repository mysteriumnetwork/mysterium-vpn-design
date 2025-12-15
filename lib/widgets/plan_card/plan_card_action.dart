part of '../plan_card.dart';

class _PlanCardAction extends StatelessWidget {
  const _PlanCardAction({
    required this.onPressed,
    required this.text,
    required this.icon,
  });

  final VoidCallback onPressed;
  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: MaterialWrapper(
        borderRadius: BorderRadius.all(theme.radius.s),
        child: InkWell(
          onTap: onPressed,
          child: Row(
            spacing: theme.spacing.xs,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  text,
                  style: theme.textStyles.textSm.medium.copyWith(color: theme.palette.textTertiary),
                ),
              ),
              if (icon != null)
                Icon(
                  icon,
                  size: 16,
                  color: theme.palette.iconTertiary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
