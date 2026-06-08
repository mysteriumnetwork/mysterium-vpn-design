import 'dart:async';

import 'package:flutter/material.dart' hide Radius;
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// A compact informational popover: a leading circular [icon] badge, a bold
/// [title], a multi-paragraph [body], and an optional trailing text button
/// ([actionLabel] / [onAction]) — e.g. a short "why does X happen?" explainer
/// or a contextual tip.
///
/// Themed from the ambient design-system palette; the surface uses
/// [Palette.bgModals] (`#22262f` in dark, near-white in light).
///
/// Content-only — it has no anchoring of its own. Use [showInfoPopover] to
/// float it over an anchor with outside-tap dismissal, or embed it directly.
class InfoPopover extends StatelessWidget {
  const InfoPopover({
    required this.title,
    required this.body,
    this.actionLabel,
    this.onAction,
    this.icon = UntitledUI.home_03,
    super.key,
  });

  final String title;

  /// Body text. Use `\n\n` to separate paragraphs.
  final String body;

  /// Optional trailing text-button label (e.g. "Got it"). The button is
  /// rendered only when both [actionLabel] and [onAction] are provided;
  /// otherwise the popover relies on outside-tap dismissal.
  final String? actionLabel;

  /// Invoked when the action button is tapped.
  final VoidCallback? onAction;

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final spacing = theme.spacing;

    // Material provides the text/ink context the popover needs when shown in an
    // Overlay (otherwise Text renders with the debug yellow underline).
    return Material(
      type: MaterialType.transparency,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 343),
        padding: EdgeInsets.all(spacing.ms),
        decoration: BoxDecoration(
          color: palette.bgModals,
          borderRadius: const BorderRadius.all(Radius.kXs),
          boxShadow: [
            BoxShadow(
              color: palette.shadowLg01,
              offset: const Offset(0, 12),
              blurRadius: 16,
              spreadRadius: -4,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedIcon(
              icon: icon,
              decoration: IconDecoration(
                backgroundColor: palette.bgSecondarySelected,
                iconSize: 20,
                padding: const EdgeInsets.all(6),
                borderRadius: const BorderRadius.all(Radius.kFull),
              ),
            ),
            SizedBox(height: spacing.s),
            Text(
              title,
              style: theme.textStyles.textXs.semibold.copyWith(color: palette.textPrimary),
            ),
            SizedBox(height: spacing.xxs),
            Text(body, style: theme.textStyles.textXs.medium.copyWith(color: palette.textTertiary)),
            if (actionLabel case final label? when onAction != null)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onAction,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: spacing.s, vertical: spacing.xs),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    label,
                    style: theme.textStyles.textXs.semibold.copyWith(
                      color: palette.textBrandPrimary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Floats an [InfoPopover] over the widget identified by [anchorKey], with a
/// full-screen transparent barrier that dismisses on outside tap. The popover
/// is placed below the anchor when there is room, otherwise above, and is
/// clamped horizontally to stay on-screen with a small tail pointing at the
/// anchor. Tapping the [actionLabel] button (when provided) also dismisses.
///
/// Returns a future that completes when the popover is dismissed (by either
/// path). [onDismiss] is invoked once on dismissal, before the future
/// completes. If the anchor has no mounted render box, returns immediately
/// without showing anything.
Future<void> showInfoPopover({
  required BuildContext context,
  required GlobalKey anchorKey,
  required String title,
  required String body,
  String? actionLabel,
  IconData icon = UntitledUI.home_03,
  VoidCallback? onDismiss,
}) {
  final anchorContext = anchorKey.currentContext;
  final overlay = Overlay.maybeOf(context, rootOverlay: true);
  if (anchorContext == null || overlay == null) {
    return Future<void>.value();
  }
  final anchorBox = anchorContext.findRenderObject() as RenderBox?;
  final overlayBox = overlay.context.findRenderObject() as RenderBox?;
  if (anchorBox == null || !anchorBox.hasSize || overlayBox == null) {
    return Future<void>.value();
  }

  final anchorTopLeft = anchorBox.localToGlobal(Offset.zero, ancestor: overlayBox);
  final anchorRect = anchorTopLeft & anchorBox.size;

  final completer = Completer<void>();
  late OverlayEntry entry;
  var dismissed = false;
  void dismiss() {
    if (dismissed) {
      return;
    }
    dismissed = true;
    entry
      ..remove()
      ..dispose();
    onDismiss?.call();
    completer.complete();
  }

  entry = OverlayEntry(
    builder: (context) => _InfoPopoverOverlay(
      anchorRect: anchorRect,
      onBarrierTap: dismiss,
      child: InfoPopover(
        title: title,
        body: body,
        actionLabel: actionLabel,
        onAction: actionLabel != null ? dismiss : null,
        icon: icon,
      ),
    ),
  );
  overlay.insert(entry);
  return completer.future;
}

/// Lays out the popover relative to [anchorRect] with a dismiss barrier and a
/// tail pointing at the anchor.
class _InfoPopoverOverlay extends StatelessWidget {
  const _InfoPopoverOverlay({
    required this.anchorRect,
    required this.onBarrierTap,
    required this.child,
  });

  final Rect anchorRect;
  final VoidCallback onBarrierTap;
  final Widget child;

  static const double _gap = 8;
  static const double _margin = 12;
  static const double _maxWidth = 343;
  static const double _tailSize = 8;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screen = media.size;
    final width = _maxWidth.clamp(0.0, screen.width - 2 * _margin);

    // Prefer below the anchor; flip above when the lower half has less room.
    final spaceBelow = screen.height - anchorRect.bottom;
    final spaceAbove = anchorRect.top;
    final showBelow = spaceBelow >= spaceAbove;

    // Horizontal: center on the anchor, clamped to screen margins.
    var left = anchorRect.center.dx - width / 2;
    left = left.clamp(_margin, screen.width - _margin - width);

    final tailCenterX = anchorRect.center.dx.clamp(
      left + _tailSize * 2,
      left + width - _tailSize * 2,
    );

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onBarrierTap,
            child: const SizedBox.shrink(),
          ),
        ),
        Positioned(
          left: left,
          width: width,
          top: showBelow ? anchorRect.bottom + _gap : null,
          bottom: showBelow ? null : screen.height - anchorRect.top + _gap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showBelow) _Tail(pointUp: true, offsetX: tailCenterX - left),
              child,
              if (!showBelow) _Tail(pointUp: false, offsetX: tailCenterX - left),
            ],
          ),
        ),
      ],
    );
  }
}

class _Tail extends StatelessWidget {
  const _Tail({required this.pointUp, required this.offsetX});

  final bool pointUp;
  final double offsetX;

  @override
  Widget build(BuildContext context) {
    const size = _InfoPopoverOverlay._tailSize;
    return Padding(
      padding: EdgeInsets.only(left: (offsetX - size).clamp(0.0, double.infinity)),
      child: CustomPaint(
        size: const Size(size * 2, size),
        painter: _TailPainter(pointUp: pointUp, color: Theme.of(context).palette.bgModals),
      ),
    );
  }
}

class _TailPainter extends CustomPainter {
  _TailPainter({required this.pointUp, required this.color});

  final bool pointUp;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    if (pointUp) {
      path
        ..moveTo(size.width / 2, 0)
        ..lineTo(0, size.height)
        ..lineTo(size.width, size.height)
        ..close();
    } else {
      path
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width / 2, size.height)
        ..close();
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TailPainter oldDelegate) =>
      oldDelegate.pointUp != pointUp || oldDelegate.color != color;
}
