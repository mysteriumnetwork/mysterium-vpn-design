part of '../plan_card.dart';

class _PlanBestValueBanner extends StatelessWidget {
  const _PlanBestValueBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.spacing;

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Palette.success,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: spacing.xl2,
          right: spacing.xl2,
          bottom: spacing.xl2,
          top: spacing.xs,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: theme.textStyles.textXs.semibold.copyWith(
            color: Palette.black,
          ),
        ),
      ),
    );
  }
}
