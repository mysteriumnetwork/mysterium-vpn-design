part of '../plan_card.dart';

class _PlanContainer extends StatelessWidget {
  const _PlanContainer({
    required this.isHighlighted,
    required this.data,
    required this.onTap,
    required this.child,
  });

  final bool isHighlighted;
  final PlanData data;
  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bestValueBadge = data.bestValueBadge;
    final promoBadge = data.promoBadge;

    return Stack(
      fit: StackFit.passthrough,
      children: [
        if (bestValueBadge != null)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _PlanBestValueBanner(text: bestValueBadge),
          ),
        Padding(
          padding: EdgeInsets.only(top: bestValueBadge != null ? 27 : 0),
          child: RawMaterialButton(
            onPressed: onTap,
            elevation: 0,
            hoverElevation: 0,
            focusElevation: 0,
            highlightElevation: 0,
            fillColor: theme.palette.bgPopover,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color:
                    isHighlighted ? theme.palette.borderBrandPrimary : theme.palette.borderPrimary,
                width: isHighlighted ? 3 : 1,
              ),
            ),
            padding: EdgeInsets.all(theme.spacing.md),
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                child,
                if (promoBadge != null)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Badge(
                      text: promoBadge,
                      size: BadgeSize.small,
                      type: BadgeType.greenSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
