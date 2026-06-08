import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

// ─── Connection rating ────────────────────────────────────────────────────────

/// Rating state for the connection quality thumbs.
enum ConnectionRating {
  /// No rating given yet.
  none,

  /// User rated the connection positively.
  thumbsUp,

  /// User rated the connection negatively.
  thumbsDown,
}

// ─── Status types ─────────────────────────────────────────────────────────────

/// Status variants for [MainIpCard].
sealed class MainIpCardStatus {
  const MainIpCardStatus();
}

/// Card is in the disconnected state – no server selected yet.
final class MainIpCardNotConnected extends MainIpCardStatus {
  const MainIpCardNotConnected();
}

/// A country is selected but no connection has been initiated yet.
final class MainIpCardLocationSelected extends MainIpCardStatus {
  const MainIpCardLocationSelected({
    required this.country,
    required this.countryIcon,
    required this.serviceQuality,
  });

  final String country;
  final Widget countryIcon;
  final String serviceQuality;
}

/// A connection attempt is in progress.
final class MainIpCardConnecting extends MainIpCardStatus {
  const MainIpCardConnecting({
    required this.country,
    required this.countryIcon,
    required this.serviceQuality,
  });

  final String country;
  final Widget countryIcon;
  final String serviceQuality;
}

/// A connection is established.
final class MainIpCardConnected extends MainIpCardStatus {
  const MainIpCardConnected({
    required this.country,
    required this.countryIcon,
    required this.city,
    required this.ipAddress,
    required this.serviceQuality,
    required this.ipPoolCount,
  });

  final String country;
  final Widget countryIcon;
  final String city;
  final String ipAddress;
  final String serviceQuality;
  final int ipPoolCount;
}

/// A new IP country is being previewed above the current connected card.
final class MainIpCardNewIpPreview extends MainIpCardStatus {
  const MainIpCardNewIpPreview({
    required this.country,
    required this.countryIcon,
    required this.city,
    required this.ipAddress,
    required this.serviceQuality,
    required this.ipPoolCount,
    required this.previewCountry,
    required this.previewCountryIcon,
    required this.switchLabel,
  });

  // Current connection
  final String country;
  final Widget countryIcon;
  final String city;
  final String ipAddress;
  final String serviceQuality;
  final int ipPoolCount;

  // Proposed switch
  final String previewCountry;
  final Widget previewCountryIcon;

  /// Button label shown in the main card, e.g. "Switch to Poland".
  final String switchLabel;
}

// ─── Main widget ──────────────────────────────────────────────────────────────

/// The main IP card shown on the home screen. Adapts its content to the
/// current connection [status].
class MainIpCard extends StatelessWidget {
  const MainIpCard({
    required this.status,
    required this.connectLabel,
    required this.disconnectLabel,
    required this.connectingLabel,
    required this.noConnectionTitle,
    required this.noConnectionDescription,
    required this.connectionRatingLabel,
    required this.refreshIpTooltip,
    this.connectionRating = ConnectionRating.none,
    this.showConnectionRating = true,
    this.onConnect,
    this.onDisconnect,
    this.onRefreshIp,
    this.onThumbsUp,
    this.onThumbsDown,
    this.onDismissPreview,
    this.onSwitchCountry,
    this.serviceQualityKey,
    super.key,
  });

  final MainIpCardStatus status;

  /// Optional key placed on the service-quality label (e.g. "Residential") in
  /// the connected / new-IP-preview states, so callers can anchor an overlay
  /// to it. No effect in other states.
  final Key? serviceQualityKey;

  final String connectLabel;
  final String disconnectLabel;
  final String connectingLabel;
  final String noConnectionTitle;
  final String noConnectionDescription;
  final String connectionRatingLabel;
  final String refreshIpTooltip;
  final ConnectionRating connectionRating;

  /// When `false`, the thumbs-up / thumbs-down rating row is omitted from the
  /// connected and new-IP-preview states. Defaults to `true`.
  final bool showConnectionRating;

  final VoidCallback? onConnect;
  final VoidCallback? onDisconnect;
  final VoidCallback? onRefreshIp;
  final VoidCallback? onThumbsUp;
  final VoidCallback? onThumbsDown;
  final VoidCallback? onDismissPreview;
  final VoidCallback? onSwitchCountry;

  @override
  Widget build(BuildContext context) {
    final card = switch (status) {
      MainIpCardNotConnected() => _CardShell(
        child: _NotConnectedContent(
          title: noConnectionTitle,
          description: noConnectionDescription,
          connectLabel: connectLabel,
          onConnect: onConnect,
        ),
      ),
      MainIpCardLocationSelected(:final country, :final countryIcon, :final serviceQuality) =>
        _CardShell(
          child: _LocationSelectedContent(
            country: country,
            countryIcon: countryIcon,
            serviceQuality: serviceQuality,
            connectLabel: connectLabel,
            onConnect: onConnect,
          ),
        ),
      MainIpCardConnecting(:final country, :final countryIcon, :final serviceQuality) => _CardShell(
        child: _ConnectingContent(
          country: country,
          countryIcon: countryIcon,
          serviceQuality: serviceQuality,
          connectingLabel: connectingLabel,
        ),
      ),
      MainIpCardConnected(
        :final country,
        :final countryIcon,
        :final city,
        :final ipAddress,
        :final serviceQuality,
        :final ipPoolCount,
      ) =>
        _CardShell(
          child: _ConnectedContent(
            country: country,
            countryIcon: countryIcon,
            city: city,
            ipAddress: ipAddress,
            serviceQuality: serviceQuality,
            serviceQualityKey: serviceQualityKey,
            ipPoolCount: ipPoolCount,
            buttonLabel: disconnectLabel,
            connectionRatingLabel: connectionRatingLabel,
            connectionRating: connectionRating,
            showConnectionRating: showConnectionRating,
            onButton: onDisconnect,
            onRefreshIp: onRefreshIp,
            onThumbsUp: onThumbsUp,
            onThumbsDown: onThumbsDown,
            refreshIpTooltip: refreshIpTooltip,
          ),
        ),
      MainIpCardNewIpPreview(
        :final country,
        :final countryIcon,
        :final city,
        :final ipAddress,
        :final serviceQuality,
        :final ipPoolCount,
        :final previewCountry,
        :final previewCountryIcon,
        :final switchLabel,
      ) =>
        SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              // Preview bar rendered first = sits behind the main card.
              // The main card's top-rounded corners cover the bar's bottom edge.
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: _previewBarHeight,
                child: _PreviewBar(
                  country: previewCountry,
                  countryIcon: previewCountryIcon,
                  onDismiss: onDismissPreview,
                ),
              ),
              // Main card rendered second = sits on top, offset down by 64px
              // so the preview bar peeks out above it.
              Padding(
                padding: const EdgeInsets.only(top: _previewBarContentOffset),
                child: _CardShell(
                  child: _ConnectedContent(
                    country: country,
                    countryIcon: countryIcon,
                    city: city,
                    ipAddress: ipAddress,
                    serviceQuality: serviceQuality,
                    serviceQualityKey: serviceQualityKey,
                    ipPoolCount: ipPoolCount,
                    buttonLabel: switchLabel,
                    connectionRatingLabel: connectionRatingLabel,
                    connectionRating: connectionRating,
                    onButton: onSwitchCountry,
                    onRefreshIp: onRefreshIp,
                    onThumbsUp: onThumbsUp,
                    onThumbsDown: onThumbsDown,
                    refreshIpTooltip: refreshIpTooltip,
                  ),
                ),
              ),
            ],
          ),
        ),
    };

    final maxWidth = ScreenType.of(context) >= ScreenType.tablet
        ? _cardMaxWidthDesktop
        : _cardMaxWidthMobile;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: card,
    );
  }
}

// ─── Layout constants ─────────────────────────────────────────────────────────

const _cardMaxWidthMobile = 480.0;
const _cardMaxWidthDesktop = 343.0;
const _previewBarHeight = 80.0;
const _previewBarContentOffset = 64.0;

// State-layer overlay opacities applied to `_IconTap`'s overlay color
// (the icon's own color), tuned to read correctly on the brand-themed card
// surfaces in both light and dark themes.
const _overlayPressedAlpha = 0.16;
const _overlayHoveredAlpha = 0.10;
const _overlayFocusedAlpha = 0.12;

// ─── Card shell ───────────────────────────────────────────────────────────────

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.kM),
        boxShadow: [BoxShadow(color: Color(0x0D0A0D12), blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: Material(
        color: theme.palette.bgMainIpCard,
        borderRadius: const BorderRadius.all(Radius.kM),
        clipBehavior: Clip.antiAlias,
        child: Padding(padding: EdgeInsets.all(theme.spacing.md), child: child),
      ),
    );
  }
}

// ─── Content variants ─────────────────────────────────────────────────────────

class _NotConnectedContent extends StatelessWidget {
  const _NotConnectedContent({
    required this.title,
    required this.description,
    required this.connectLabel,
    this.onConnect,
  });

  final String title;
  final String description;
  final String connectLabel;
  final VoidCallback? onConnect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: theme.spacing.md,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: theme.spacing.ms,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: palette.bgTransparent, shape: BoxShape.circle),
              child: Icon(UntitledUI.star_01, size: 24, color: palette.textIpCardTitle),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: theme.spacing.s,
                children: [
                  Text(
                    title,
                    style: theme.textStyles.textLg.semibold.copyWith(
                      color: palette.textIpCardTitle,
                    ),
                  ),
                  Text(
                    description,
                    style: theme.textStyles.textSm.regular.copyWith(
                      color: palette.textIpCardSubtitle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ButtonPrimary(onPressed: onConnect, size: ButtonSize.large, child: Text(connectLabel)),
      ],
    );
  }
}

class _ConnectingContent extends StatelessWidget {
  const _ConnectingContent({
    required this.country,
    required this.countryIcon,
    required this.serviceQuality,
    required this.connectingLabel,
  });

  final String country;
  final Widget countryIcon;
  final String serviceQuality;
  final String connectingLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: theme.spacing.md,
      children: [
        Row(
          spacing: theme.spacing.ms,
          children: [
            SizedBox(width: 32, height: 32, child: countryIcon),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: theme.spacing.xxs,
                children: [
                  Text(
                    country,
                    style: theme.textStyles.textLg.semibold.copyWith(
                      color: palette.textIpCardTitle,
                    ),
                  ),
                  Text(
                    serviceQuality,
                    style: theme.textStyles.textXs.regular.copyWith(
                      color: palette.textIpCardSubtitle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ButtonPrimary(
          onPressed: () {},
          size: ButtonSize.large,
          decoration: ButtonDecoration(decorationColor: Palette.brand.shade600),
          loading: ButtonLoading(text: connectingLabel),
          child: Text(connectingLabel),
        ),
      ],
    );
  }
}

class _LocationSelectedContent extends StatelessWidget {
  const _LocationSelectedContent({
    required this.country,
    required this.countryIcon,
    required this.serviceQuality,
    required this.connectLabel,
    this.onConnect,
  });

  final String country;
  final Widget countryIcon;
  final String serviceQuality;
  final String connectLabel;
  final VoidCallback? onConnect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: theme.spacing.md,
      children: [
        Row(
          spacing: theme.spacing.ms,
          children: [
            SizedBox(width: 32, height: 32, child: countryIcon),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: theme.spacing.xxs,
                children: [
                  Text(
                    country,
                    style: theme.textStyles.textLg.semibold.copyWith(
                      color: palette.textIpCardTitle,
                    ),
                  ),
                  Text(
                    serviceQuality,
                    style: theme.textStyles.textXs.regular.copyWith(
                      color: palette.textIpCardSubtitle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ButtonPrimary(onPressed: onConnect, size: ButtonSize.large, child: Text(connectLabel)),
      ],
    );
  }
}

class _ConnectedContent extends StatelessWidget {
  const _ConnectedContent({
    required this.country,
    required this.countryIcon,
    required this.city,
    required this.ipAddress,
    required this.serviceQuality,
    required this.ipPoolCount,
    required this.buttonLabel,
    required this.connectionRatingLabel,
    required this.refreshIpTooltip,
    this.serviceQualityKey,
    this.connectionRating = ConnectionRating.none,
    this.showConnectionRating = true,
    this.onButton,
    this.onRefreshIp,
    this.onThumbsUp,
    this.onThumbsDown,
  });

  final String country;
  final Widget countryIcon;
  final String city;
  final String ipAddress;
  final String serviceQuality;
  final Key? serviceQualityKey;
  final int ipPoolCount;
  final String buttonLabel;
  final String connectionRatingLabel;
  final ConnectionRating connectionRating;
  final bool showConnectionRating;
  final VoidCallback? onButton;
  final VoidCallback? onRefreshIp;
  final VoidCallback? onThumbsUp;
  final VoidCallback? onThumbsDown;
  final String refreshIpTooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final subtitleStyle = theme.textStyles.textXs.regular.copyWith(
      color: palette.textIpCardSubtitle,
    );
    final isRefreshActive = ipPoolCount > 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: theme.spacing.md,
      children: [
        // Header area
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: theme.spacing.xxs,
          children: [
            // Location + IP info column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: theme.spacing.xxs,
                children: [
                  Row(
                    spacing: theme.spacing.ms,
                    children: [
                      SizedBox(width: 32, height: 32, child: countryIcon),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: theme.spacing.xxs,
                          children: [
                            Text(
                              country,
                              style: theme.textStyles.textLg.semibold.copyWith(
                                color: palette.textIpCardTitle,
                              ),
                            ),
                            Text(city, style: subtitleStyle),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // IP info row – 44px left pad aligns with location text
                  Padding(
                    padding: const EdgeInsets.only(left: 44),
                    child: Row(
                      spacing: theme.spacing.s,
                      children: [
                        Flexible(
                          child: Text(
                            ipAddress,
                            style: subtitleStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(width: 1, height: 16, color: palette.textIpCardSubtitle),
                        Flexible(
                          child: Text(
                            serviceQuality,
                            key: serviceQualityKey,
                            style: subtitleStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Refresh icon + IP pool label column
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _IconTap(
                  icon: UntitledUI.refresh_cw_05,
                  iconColor: isRefreshActive ? palette.iconIpCard : palette.iconBrandPrimaryHover,
                  onPressed: isRefreshActive ? onRefreshIp : null,
                  tooltip: refreshIpTooltip,
                ),
                Text('IP pool: $ipPoolCount', style: subtitleStyle, textAlign: TextAlign.right),
              ],
            ),
          ],
        ),
        // Disconnect / switch button
        // Figma tokens: bg-base/white, border-brand-secondary (#887db0),
        // text-secondary-(700) (#535862)
        ButtonSecondary(
          onPressed: onButton,
          size: ButtonSize.large,
          decoration: ButtonDecoration(
            decorationColor: Palette.white,
            foregroundColor: Palette.grayLight.shade600,
            borderColor: Palette.brandPurple.shade400,
          ),
          child: Text(buttonLabel),
        ),
        if (showConnectionRating)
          Row(
            spacing: theme.spacing.md,
            children: [
              Expanded(
                child: Text(
                  connectionRatingLabel,
                  style: theme.textStyles.textSm.medium.copyWith(color: palette.textIpCardSubtitle),
                ),
              ),
              Row(
                spacing: theme.spacing.s,
                children: [
                  _IconTap(
                    icon: UntitledUI.thumbs_down,
                    iconColor: connectionRating == ConnectionRating.thumbsDown
                        ? Palette.error
                        : palette.textIpCardSubtitle,
                    onPressed: onThumbsDown,
                    padding: EdgeInsets.all(theme.spacing.xs),
                  ),
                  _IconTap(
                    icon: UntitledUI.thumbs_up,
                    iconColor: connectionRating == ConnectionRating.thumbsUp
                        ? Palette.success
                        : palette.textIpCardSubtitle,
                    onPressed: onThumbsUp,
                    padding: EdgeInsets.all(theme.spacing.xs),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}

// ─── Preview bar ──────────────────────────────────────────────────────────────

class _PreviewBar extends StatelessWidget {
  const _PreviewBar({required this.country, required this.countryIcon, this.onDismiss});

  final String country;
  final Widget countryIcon;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.palette.bgMainIpPreview,
      borderRadius: const BorderRadius.only(topLeft: Radius.kM, topRight: Radius.kM),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: theme.spacing.md),
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: _previewBarContentOffset,
            child: Row(
              spacing: theme.spacing.ms,
              children: [
                SizedBox(width: 32, height: 32, child: countryIcon),
                Expanded(
                  child: Text(
                    country,
                    style: theme.textStyles.textLg.semibold.copyWith(
                      color: Palette.grayLight.shade800,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _IconTap(
                  icon: UntitledUI.x_close,
                  iconColor: Palette.grayLight.shade800,
                  onPressed: onDismiss,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Icon tap helper ──────────────────────────────────────────────────────────

class _IconTap extends StatelessWidget {
  const _IconTap({
    required this.icon,
    this.tooltip,
    this.iconColor = Palette.white,
    this.onPressed,
    this.padding,
  });

  final IconData icon;
  final Color iconColor;
  final VoidCallback? onPressed;
  final String? tooltip;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: onPressed,
    icon: Icon(icon, size: 24, color: iconColor),
    tooltip: tooltip,
    padding: padding ?? EdgeInsets.zero,
    style: ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size(32, 32)),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return iconColor.withValues(alpha: _overlayPressedAlpha);
        }
        if (states.contains(WidgetState.hovered)) {
          return iconColor.withValues(alpha: _overlayHoveredAlpha);
        }
        if (states.contains(WidgetState.focused)) {
          return iconColor.withValues(alpha: _overlayFocusedAlpha);
        }
        return null;
      }),
    ),
  );
}
