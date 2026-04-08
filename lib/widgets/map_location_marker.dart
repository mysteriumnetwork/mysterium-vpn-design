import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

// ─── Animation asset paths ────────────────────────────────────────────────────

const _kAnimPulseGreen =
    'packages/mysterium_vpn_design/assets/animations/pulse_green.json';
const _kAnimPulsePurple =
    'packages/mysterium_vpn_design/assets/animations/pulse_purple.json';

// ─── Sizes per breakpoint ─────────────────────────────────────────────────────

/// Sizes for the active (Lottie) pin state.
/// Mobile: 32 px  |  Desktop: 40 px
/// Desktop stays at 40 px so the Lottie inner dot (~11.6 px) visibly exceeds
/// the 12 px idle fill (~10 px after border), preserving the grow-on-select feel.
const _kActiveSizeMobile = 33.0;
const _kActiveSizeDesktop = 40.0;

/// Sizes for the inactive (dot) pin state.
/// Mobile: 8 px   |  Desktop: 12 px
const _kInactiveSizeMobile = 8.0;
const _kInactiveSizeDesktop = 12.0;

// ─── MapLocationMarker ────────────────────────────────────────────────────────

/// A map pin widget matching the Figma "MapLocationMarker" component spec.
///
/// Three visual states, each adaptive to mobile/desktop via [ScreenType]:
/// - **Inactive** (`isConnected=false`, `isSelected=false`): small purple dot.
/// - **Selected** (`isSelected=true`): purple pulse Lottie + optional callout.
/// - **Connected** (`isConnected=true`): green pulse Lottie.
///
/// The "Connect to …" callout should be placed as a **separate** map marker
/// using [MapLocationTooltip], so that the pin position is never affected by
/// the label layout.
///
/// [onPressed] fires on single tap; [onDoubleTap] fires on a second tap
/// within 300 ms.
class MapLocationMarker extends StatelessWidget {
  const MapLocationMarker({
    required this.onPressed,
    this.isConnected = false,
    this.isSelected = false,
    this.onDoubleTap,
    super.key,
  });

  final bool isConnected;
  final bool isSelected;

  final VoidCallback onPressed;
  final VoidCallback? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    final isDesktop = ScreenType.of(context) > ScreenType.mobile;

    if (!isConnected && !isSelected) {
      return _InactivePin(
        size: isDesktop ? _kInactiveSizeDesktop : _kInactiveSizeMobile,
        onPressed: onPressed,
        onDoubleTap: onDoubleTap,
      );
    }

    final animPath = isConnected ? _kAnimPulseGreen : _kAnimPulsePurple;
    return _ActivePin(
      size: isDesktop ? _kActiveSizeDesktop : _kActiveSizeMobile,
      animPath: animPath,
      onPressed: onPressed,
      onDoubleTap: onDoubleTap,
    );
  }
}

// ─── Inactive pin ─────────────────────────────────────────────────────────────

/// Small purple dot for unselected, disconnected locations.
/// Mobile: 8 px outer / 4 px inner.
/// Desktop: 12 px outer / 6 px inner.
class _InactivePin extends StatelessWidget {
  const _InactivePin({
    required this.size,
    required this.onPressed,
    this.onDoubleTap,
  });

  final double size;
  final VoidCallback onPressed;
  final VoidCallback? onDoubleTap;

  @override
  Widget build(BuildContext context) => _GestureHandler(
    onPressed: onPressed,
    onDoubleTap: onDoubleTap,
    hitSize: Size.square(size),
    child: SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).palette.bgMapPinIdle,
          border: Border.all(color: Palette.brandPurple.shade300, width: 1.5),
        ),
      ),
    ),
  );
}

// ─── Active pin (connected or selected) ──────────────────────────────────────

/// Lottie pulse animation — green for connected, purple for selected.
class _ActivePin extends StatelessWidget {
  const _ActivePin({
    required this.size,
    required this.animPath,
    required this.onPressed,
    this.onDoubleTap,
  });

  final double size;
  final String animPath;
  final VoidCallback onPressed;
  final VoidCallback? onDoubleTap;

  @override
  Widget build(BuildContext context) => _GestureHandler(
    onPressed: onPressed,
    onDoubleTap: onDoubleTap,
    hitSize: Size.square(size),
    child: Lottie.asset(
      animPath,
      repeat: true,
      fit: BoxFit.contain,
      alignment: Alignment.center,
    ),
  );
}

// ─── "Connect to…" tooltip ────────────────────────────────────────────────────

/// A standalone tooltip card showing "Connect to <label>".
///
/// Place this as a **separate** map marker (e.g. with `Alignment.topCenter`)
/// at the same lat/lng as the pin so it appears above the pin without
/// affecting its position.
class MapLocationTooltip extends StatelessWidget {
  const MapLocationTooltip({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.bgPrimary,
        borderRadius: const BorderRadius.all(Radius.kS),
        border: Border.all(color: palette.borderPrimary),
        boxShadow: [
          BoxShadow(
            color: palette.shadowLg03,
            blurRadius: 16,
            spreadRadius: -4,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: palette.shadowLg02,
            blurRadius: 6,
            spreadRadius: -2,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: palette.shadowLg01,
            blurRadius: 2,
            spreadRadius: -1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          'Connect to $label',
          style: theme.textStyles.textXs.semibold.copyWith(
            color: palette.textPrimary,
          ),
        ),
      ),
    );
  }
}

// ─── Gesture handler ─────────────────────────────────────────────────────────

class _GestureHandler extends StatefulWidget {
  const _GestureHandler({
    required this.onPressed,
    required this.child,
    required this.hitSize,
    this.onDoubleTap,
  });

  final Widget child;
  final VoidCallback onPressed;
  final VoidCallback? onDoubleTap;
  final Size hitSize;

  @override
  State<_GestureHandler> createState() => _GestureHandlerState();
}

class _GestureHandlerState extends State<_GestureHandler> {
  DateTime? _lastTapTime;

  void _handleTap() {
    HapticFeedback.lightImpact();
    final now = DateTime.now();
    if (widget.onDoubleTap != null &&
        _lastTapTime != null &&
        now.difference(_lastTapTime!).inMilliseconds < 300) {
      _lastTapTime = null;
      widget.onDoubleTap!();
    } else {
      _lastTapTime = now;
      widget.onPressed();
    }
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      IgnorePointer(child: Center(child: widget.child)),
      Positioned.fill(
        child: Center(
          child: SizedBox.fromSize(
            size: widget.hitSize,
            child: Material(
              type: MaterialType.transparency,
              shape: const CircleBorder(),
              color: Palette.transparent,
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              child: InkWell(
                onTap: _handleTap,
                customBorder: const CircleBorder(),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
