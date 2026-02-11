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
    final bannerHeight = (bestValueBadge != null && data.isOffer) ? 27.0 : 0.0;

    return Stack(
      fit: StackFit.passthrough,
      children: [
        if (bestValueBadge != null && data.isOffer)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _BannerClipper(visibleHeight: bannerHeight),
              child: _PlanBestValueBanner(text: bestValueBadge),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(top: bannerHeight > 0 ? bannerHeight - 1 : 0),
          child: RawMaterialButton(
            onPressed: onTap,
            elevation: 0,
            hoverElevation: 0,
            focusElevation: 0,
            highlightElevation: 0,
            fillColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color:
                    isHighlighted ? theme.palette.borderBrandPrimary : theme.palette.borderPrimary,
                width: isHighlighted ? 3 : 1,
              ),
            ),
            padding: EdgeInsets.all(theme.spacing.md),
            child: child,
          ),
        ),
      ],
    );
  }
}

class _BannerClipper extends CustomClipper<Path> {
  _BannerClipper({required this.visibleHeight});
  final double visibleHeight;
  static const double borderRadius = 12;
  static const double cornerExtension = 13;

  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(borderRadius, 0)
      ..quadraticBezierTo(0, 0, 0, borderRadius)
      ..lineTo(0, visibleHeight + cornerExtension)
      ..quadraticBezierTo(0, visibleHeight, borderRadius, visibleHeight)
      ..lineTo(size.width - borderRadius, visibleHeight)
      ..quadraticBezierTo(size.width, visibleHeight, size.width, visibleHeight + cornerExtension)
      ..lineTo(size.width, borderRadius)
      ..quadraticBezierTo(size.width, 0, size.width - borderRadius, 0)
      ..lineTo(borderRadius, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(_BannerClipper oldClipper) => oldClipper.visibleHeight != visibleHeight;
}
