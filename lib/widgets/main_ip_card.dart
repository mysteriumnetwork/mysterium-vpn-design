import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

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
  });

  final String country;
  final Widget countryIcon;
  final String city;
  final String ipAddress;
}

/// A new IP country is being previewed above the current connected card.
final class MainIpCardNewIpPreview extends MainIpCardStatus {
  const MainIpCardNewIpPreview({
    required this.country,
    required this.countryIcon,
    required this.city,
    required this.ipAddress,
    required this.previewCountry,
    required this.previewCountryIcon,
    required this.switchLabel,
  });

  // Current connection
  final String country;
  final Widget countryIcon;
  final String city;
  final String ipAddress;

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
    this.onConnect,
    this.onDisconnect,
    this.onDetails,
    this.onFavorite,
    this.favoriteTooltip,
    this.onDismissPreview,
    this.onSwitchCountry,
    this.connectedInfoKey,
    this.buttonWrapper,
    super.key,
  });

  final MainIpCardStatus status;

  /// Optional key placed on the city/IP subtitle row in the connected /
  /// new-IP-preview states, so callers can anchor an overlay to it. No effect
  /// in other states.
  final Key? connectedInfoKey;

  final String connectLabel;
  final String disconnectLabel;
  final String connectingLabel;
  final String noConnectionTitle;
  final String noConnectionDescription;

  final VoidCallback? onConnect;
  final VoidCallback? onDisconnect;

  /// Tapping the chevron in the connected / new-IP-preview states — opens the
  /// connection details view.
  final VoidCallback? onDetails;

  /// Tapping the heart in the connected / new-IP-preview states. When null,
  /// the heart is not shown.
  final VoidCallback? onFavorite;

  /// Optional tooltip on the heart (e.g. "Favorites coming soon").
  final String? favoriteTooltip;

  final VoidCallback? onDismissPreview;
  final VoidCallback? onSwitchCountry;

  /// Wraps the primary action button rendered by the current card state.
  final SingleWidgetWrapper? buttonWrapper;

  @override
  Widget build(BuildContext context) {
    final card = switch (status) {
      MainIpCardNotConnected() => _CardShell(
        child: _NotConnectedContent(
          title: noConnectionTitle,
          description: noConnectionDescription,
          connectLabel: connectLabel,
          onConnect: onConnect,
          buttonWrapper: buttonWrapper,
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
            buttonWrapper: buttonWrapper,
          ),
        ),
      MainIpCardConnecting(:final country, :final countryIcon, :final serviceQuality) => _CardShell(
        child: _ConnectingContent(
          country: country,
          countryIcon: countryIcon,
          serviceQuality: serviceQuality,
          connectingLabel: connectingLabel,
          buttonWrapper: buttonWrapper,
        ),
      ),
      MainIpCardConnected(:final country, :final countryIcon, :final city, :final ipAddress) =>
        _CardShell(
          child: _ConnectedContent(
            country: country,
            countryIcon: countryIcon,
            city: city,
            ipAddress: ipAddress,
            infoKey: connectedInfoKey,
            buttonLabel: disconnectLabel,
            onButton: onDisconnect,
            onDetails: onDetails,
            onFavorite: onFavorite,
            favoriteTooltip: favoriteTooltip,
            buttonWrapper: buttonWrapper,
          ),
        ),
      MainIpCardNewIpPreview(
        :final country,
        :final countryIcon,
        :final city,
        :final ipAddress,
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
                    infoKey: connectedInfoKey,
                    buttonLabel: switchLabel,
                    onButton: onSwitchCountry,
                    onDetails: onDetails,
                    onFavorite: onFavorite,
                    favoriteTooltip: favoriteTooltip,
                    buttonWrapper: buttonWrapper,
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

Widget _wrapButton(BuildContext context, SingleWidgetWrapper? wrapper, Widget button) =>
    wrapper?.call(context: context, child: button) ?? button;

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
    this.buttonWrapper,
  });

  final String title;
  final String description;
  final String connectLabel;
  final VoidCallback? onConnect;
  final SingleWidgetWrapper? buttonWrapper;

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
        _wrapButton(
          context,
          buttonWrapper,
          ButtonPrimary(onPressed: onConnect, size: ButtonSize.large, child: Text(connectLabel)),
        ),
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
    this.buttonWrapper,
  });

  final String country;
  final Widget countryIcon;
  final String serviceQuality;
  final String connectingLabel;
  final SingleWidgetWrapper? buttonWrapper;

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
        _wrapButton(
          context,
          buttonWrapper,
          ButtonPrimary(
            onPressed: () {},
            size: ButtonSize.large,
            decoration: ButtonDecoration(decorationColor: Palette.brand.shade600),
            loading: ButtonLoading(text: connectingLabel),
            child: Text(connectingLabel),
          ),
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
    this.buttonWrapper,
  });

  final String country;
  final Widget countryIcon;
  final String serviceQuality;
  final String connectLabel;
  final VoidCallback? onConnect;
  final SingleWidgetWrapper? buttonWrapper;

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
        _wrapButton(
          context,
          buttonWrapper,
          ButtonPrimary(onPressed: onConnect, size: ButtonSize.large, child: Text(connectLabel)),
        ),
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
    required this.buttonLabel,
    this.infoKey,
    this.onButton,
    this.onDetails,
    this.onFavorite,
    this.favoriteTooltip,
    this.buttonWrapper,
  });

  final String country;
  final Widget countryIcon;
  final String city;
  final String ipAddress;
  final Key? infoKey;
  final String buttonLabel;
  final VoidCallback? onButton;
  final VoidCallback? onDetails;
  final VoidCallback? onFavorite;
  final String? favoriteTooltip;
  final SingleWidgetWrapper? buttonWrapper;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final subtitleStyle = theme.textStyles.textXs.regular.copyWith(
      color: palette.textIpCardSubtitle,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: theme.spacing.md,
      children: [
        // Header area: location info with heart + details chevron on the right.
        Row(
          spacing: theme.spacing.ms,
          children: [
            SizedBox(width: 40, height: 40, child: countryIcon),
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
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    key: infoKey,
                    spacing: theme.spacing.s,
                    children: [
                      if (city.isNotEmpty) ...[
                        Flexible(
                          child: Text(city, style: subtitleStyle, overflow: TextOverflow.ellipsis),
                        ),
                        Container(width: 1, height: 16, color: palette.textIpCardSubtitle),
                      ],
                      Flexible(
                        child: Text(
                          ipAddress,
                          style: subtitleStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (onFavorite != null)
              _IconTap(
                icon: UntitledUI.heart,
                iconColor: palette.iconIpCard,
                onPressed: onFavorite,
                tooltip: favoriteTooltip,
              ),
            _IconTap(
              icon: UntitledUI.chevron_right,
              iconColor: palette.iconIpCard,
              onPressed: onDetails,
            ),
          ],
        ),
        // Disconnect / switch button — translucent surface over the card color.
        _wrapButton(
          context,
          buttonWrapper,
          ButtonSecondary(
            onPressed: onButton,
            size: ButtonSize.large,
            decoration: ButtonDecoration(
              decorationColor: palette.bgSecondaryCta,
              foregroundColor: palette.textIpCardTitle,
              borderColor: palette.bgSecondaryCta,
            ),
            child: Text(buttonLabel),
          ),
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
  const _IconTap({required this.icon, required this.iconColor, this.onPressed, this.tooltip});

  final IconData icon;
  final Color iconColor;
  final VoidCallback? onPressed;
  final String? tooltip;
  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: onPressed,
    icon: Icon(icon, size: 24, color: iconColor),
    tooltip: tooltip,
    padding: EdgeInsets.zero,
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
