part of '../plan_card.dart';

class _PlanCardFeatures extends StatefulWidget {
  const _PlanCardFeatures({
    required this.features,
    required this.viewMoreLabel,
    required this.viewLessLabel,
    this.isOffer = false,
  });

  final List<String> features;
  final String viewMoreLabel;
  final String viewLessLabel;
  final bool isOffer;

  @override
  State<_PlanCardFeatures> createState() => _PlanCardFeaturesState();
}

class _PlanCardFeaturesState extends State<_PlanCardFeatures> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenType = ScreenType.of(context);
    final isDesktop = screenType.index >= ScreenType.tablet.index;

    // If isOffer is false, show all features regardless of screen size
    // If isOffer is true and desktop, limit to 3 features
    // If isOffer is true and mobile, show all features
    final shouldLimitFeatures = widget.isOffer && isDesktop;
    final maxFeaturesToShow = shouldLimitFeatures ? 3 : widget.features.length;
    final displayedFeatures = widget.features.take(maxFeaturesToShow).toList();
    final hasMoreFeatures = shouldLimitFeatures && widget.features.length > 3;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: theme.spacing.xs,
      children: [
        for (final feature in displayedFeatures) _Row(feature: feature),
        if (hasMoreFeatures && widget.isOffer)
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: theme.spacing.xs,
              children: [
                if (_expanded)
                  for (final feature in widget.features.skip(3).toList()) _Row(feature: feature),
              ],
            ),
          ),
        if (hasMoreFeatures && widget.isOffer)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Row(
                spacing: theme.spacing.xs,
                children: [
                  Text(
                    _expanded ? widget.viewLessLabel : widget.viewMoreLabel,
                    style:
                        theme.textStyles.textSm.regular.copyWith(color: theme.palette.textTertiary),
                  ),
                  Icon(
                    _expanded ? UntitledUI.chevron_up : UntitledUI.chevron_down,
                    size: 16,
                    color: theme.palette.iconTertiary,
                  ),
                ],
              ),
            ),
          ),
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
