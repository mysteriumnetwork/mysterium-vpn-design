import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Dropdown', type: SettingsCard)
Widget buildSettingsCardDropdown(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'VPN protocol');
  final subtitle = context.knobs.stringOrNull(
    label: 'Subtitle',
    initialValue: 'Refresh to get a new IP address',
  );
  final position = context.knobs.object.dropdown(
    label: 'Position',
    options: SettingsCardPosition.values,
    initialOption: SettingsCardPosition.single,
    labelBuilder: (p) => p.name,
  );
  final value = context.knobs.string(label: 'Selected value', initialValue: 'Fast (WireGuard)');

  return _scaffold(
    context,
    child: SettingsCard(
      icon: _CheckCircleIcon(),
      title: title,
      subtitle: subtitle,
      position: position,
      trailing: _DropdownTrailing(label: value),
    ),
  );
}

@UseCase(name: 'Button', type: SettingsCard)
Widget buildSettingsCardButton(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Reset app');
  final subtitle = context.knobs.stringOrNull(
    label: 'Subtitle',
    initialValue: "Reset when something isn't working",
  );
  final position = context.knobs.object.dropdown(
    label: 'Position',
    options: SettingsCardPosition.values,
    initialOption: SettingsCardPosition.single,
    labelBuilder: (p) => p.name,
  );
  final buttonLabel = context.knobs.string(label: 'Button label', initialValue: 'Reset');

  return _scaffold(
    context,
    child: SettingsCard(
      icon: _CheckCircleIcon(),
      title: title,
      subtitle: subtitle,
      position: position,
      trailing: _TextButtonTrailing(label: buttonLabel),
    ),
  );
}

@UseCase(name: 'Toggle', type: SettingsCard)
Widget buildSettingsCardToggle(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Kill switch');
  final subtitle = context.knobs.stringOrNull(
    label: 'Subtitle',
    initialValue: 'Block internet when VPN drops',
  );
  final position = context.knobs.object.dropdown(
    label: 'Position',
    options: SettingsCardPosition.values,
    initialOption: SettingsCardPosition.single,
    labelBuilder: (p) => p.name,
  );
  final toggled = context.knobs.boolean(label: 'Toggled', initialValue: true);

  return _scaffold(
    context,
    child: SettingsCard(
      icon: _CheckCircleIcon(),
      title: title,
      subtitle: subtitle,
      position: position,
      trailing: Switch(value: toggled, onChanged: null),
    ),
  );
}

@UseCase(name: 'Arrow', type: SettingsCard)
Widget buildSettingsCardArrow(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'VPN protocol');
  final subtitle = context.knobs.stringOrNull(label: 'Subtitle', initialValue: 'Fast (WireGuard)');
  final position = context.knobs.object.dropdown(
    label: 'Position',
    options: SettingsCardPosition.values,
    initialOption: SettingsCardPosition.single,
    labelBuilder: (p) => p.name,
  );

  return _scaffold(
    context,
    child: SettingsCard(
      icon: _CheckCircleIcon(),
      title: title,
      subtitle: subtitle,
      position: position,
      trailing: const _ArrowTrailing(),
    ),
  );
}

@UseCase(name: 'Group', type: SettingsCard)
Widget buildSettingsCardGroup(BuildContext context) => _scaffold(
  context,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SettingsCard(
        icon: _CheckCircleIcon(),
        title: 'Kill switch',
        subtitle: 'Block internet when VPN drops',
        position: SettingsCardPosition.top,
        trailing: const Switch(value: true, onChanged: null),
      ),
      SettingsCard(
        icon: _CheckCircleIcon(),
        title: 'VPN protocol',
        subtitle: 'Fast (WireGuard)',
        position: SettingsCardPosition.middle,
        trailing: const _ArrowTrailing(),
      ),
      SettingsCard(
        icon: _CheckCircleIcon(),
        title: 'Reset app',
        subtitle: "Reset when something isn't working",
        position: SettingsCardPosition.bottom,
        trailing: const _TextButtonTrailing(label: 'Reset'),
      ),
    ],
  ),
);

// ─── Scaffold ─────────────────────────────────────────────────────────────────

Widget _scaffold(BuildContext context, {required Widget child}) {
  final isMobile = context.knobs.boolean(label: 'Mobile style');
  final width = isMobile ? 343.0 : 630.0;
  final content = Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(width: width, child: child),
    ),
  );
  return isMobile ? ScreenTypeOverride(screenType: ScreenType.mobile, child: content) : content;
}

// ─── Trailing helpers ─────────────────────────────────────────────────────────

class _TextButtonTrailing extends StatelessWidget {
  const _TextButtonTrailing({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      label,
      style: theme.textStyles.textSm.semibold.copyWith(color: theme.palette.textBrandPrimary),
    );
  }
}

class _DropdownTrailing extends StatelessWidget {
  const _DropdownTrailing({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    return Container(
      width: 257,
      height: 40,
      decoration: BoxDecoration(
        color: palette.bgPrimary,
        border: Border.all(color: palette.borderPrimary),
        borderRadius: const BorderRadius.all(Radius.kS),
        boxShadow: [BoxShadow(color: palette.shadowXs, blurRadius: 2, offset: const Offset(0, 1))],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textStyles.textMd.regular.copyWith(color: palette.textTertiary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Icon(UntitledUI.chevron_down, size: 20, color: palette.iconPrimary),
        ],
      ),
    );
  }
}

class _ArrowTrailing extends StatelessWidget {
  const _ArrowTrailing();

  @override
  Widget build(BuildContext context) =>
      Icon(UntitledUI.chevron_right, size: 24, color: Theme.of(context).palette.iconTertiary);
}

// ─── Icon placeholder ─────────────────────────────────────────────────────────

class _CheckCircleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Icon(UntitledUI.check_circle, size: 20, color: Theme.of(context).palette.iconBrandSecondary);
}
