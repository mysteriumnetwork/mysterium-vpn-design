import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

enum BarStatus { connected, disconnected, gettingIp, disconnecting, connecting }

class ConnectionBar extends StatefulWidget {
  const ConnectionBar({
    required this.label,
    required this.killSwitchLabel,
    required this.killSwitchDescription,
    required this.status,
    super.key,
  });

  final String label;
  final BarStatus status;
  final String killSwitchLabel;
  final String killSwitchDescription;

  @override
  State<ConnectionBar> createState() => _ConnectionBarState();
}

class _ConnectionBarState extends State<ConnectionBar> {
  bool _expanded = false;

  bool get _canExpand => widget.status == BarStatus.connected;

  Color get _backgroundColor => switch (widget.status) {
    BarStatus.connected => Palette.success.shade700,
    BarStatus.disconnected => Palette.error.shade700,
    BarStatus.gettingIp => Palette.warning.shade400,
    BarStatus.disconnecting => Palette.warning.shade400,
    BarStatus.connecting => Palette.warning.shade400,
  };

  @override
  void didUpdateWidget(ConnectionBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_canExpand && _expanded) {
      setState(() => _expanded = false);
    }
  }

  void _toggle() {
    if (!_canExpand) {
      return;
    }
    setState(() => _expanded = !_expanded);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).spacing;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: _expanded ? Radius.kM : Radius.kNone,
          bottomRight: _expanded ? Radius.kM : Radius.kNone,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: _toggle,
            child: Padding(
              padding: EdgeInsets.only(
                top: spacing.s,
                bottom: spacing.s,
                left: spacing.xl3,
                right: spacing.md,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildHeader(context),
                  Visibility(
                    visible: _canExpand,
                    maintainAnimation: true,
                    maintainState: true,
                    maintainSize: true,
                    child: AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(UntitledUI.chevron_down, color: Palette.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: _expanded
                ? _KillSwitchRow(
                    killSwitchLabel: widget.killSwitchLabel,
                    killSwitchDescription: widget.killSwitchDescription,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => switch (widget.status) {
    BarStatus.disconnected => _Header(
      label: widget.label,
      icon: const Icon(UntitledUI.lock_unlocked_03, size: 16, color: Palette.white),
      textColor: Palette.white,
    ),
    BarStatus.gettingIp => _Header(
      label: widget.label,
      icon: LoadingIndicator(color: Palette.grayLight.shade800, size: 16),
      textColor: Palette.grayLight.shade800,
    ),
    BarStatus.connected => _Header(
      label: widget.label,
      icon: const Icon(UntitledUI.lock_03, size: 16, color: Palette.white),
      textColor: Palette.white,
    ),
    BarStatus.disconnecting => _Header(
      label: widget.label,
      icon: LoadingIndicator(color: Palette.grayLight.shade800, size: 16),
      textColor: Palette.grayLight.shade800,
    ),
    BarStatus.connecting => _Header(
      label: widget.label,
      icon: LoadingIndicator(color: Palette.grayLight.shade800, size: 16),
      textColor: Palette.grayLight.shade800,
    ),
  };
}

// ─── Header variants ──────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({required this.label, required this.icon, required this.textColor});

  final String label;
  final Widget icon;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).spacing;
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: spacing.s,
        children: [
          icon,
          Text(
            label,
            style: Theme.of(context).textStyles.textSm.semibold.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) =>
      Container(height: 1, color: Theme.of(context).palette.borderSecondary);
}

class _KillSwitchRow extends StatelessWidget {
  const _KillSwitchRow({required this.killSwitchLabel, required this.killSwitchDescription});

  final String killSwitchLabel;
  final String killSwitchDescription;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).spacing;
    final style = Theme.of(context).textStyles.textXs.regular.copyWith(color: Palette.white);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _Divider(),
        Padding(
          padding: EdgeInsets.only(
            top: spacing.s,
            bottom: spacing.s,
            left: spacing.xl3,
            right: spacing.xl3,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: spacing.md,
            children: [
              Text(killSwitchLabel, style: style),
              Expanded(child: Text(killSwitchDescription, style: style)),
            ],
          ),
        ),
      ],
    );
  }
}
