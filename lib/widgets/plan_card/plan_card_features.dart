part of '../plan_card.dart';

class _PlanCardFeatures extends StatelessWidget {
  const _PlanCardFeatures({
    required this.features,
  });

  final List<String> features;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: theme.spacing.ms,
      children: [
        for (final feature in features) _Row(feature: feature),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.feature,
  });

  final String feature;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      spacing: theme.spacing.s,
      children: [
        Icon(
          UntitledUI.check_circle,
          size: 16,
          color: theme.palette.iconTertiary,
        ),
        Expanded(
          child: Text(
            feature,
            style: theme.textStyles.textSm.regular.copyWith(color: theme.palette.textTertiary),
          ),
        ),
      ],
    );
  }
}
