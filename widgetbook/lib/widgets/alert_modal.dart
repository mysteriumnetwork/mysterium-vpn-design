import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'AlertModal', type: AlertModal)
Widget buildAlertModal(BuildContext context) {
  final type = context.knobs.object.dropdown<AlertModalType>(
    label: 'Type',
    options: AlertModalType.values,
    initialOption: AlertModalType.brand,
    labelBuilder: (t) => t.name,
  );
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Notifications can be enabled later in your system settings.',
  );
  final supportingText = context.knobs.stringOrNull(
    label: 'Supporting text',
    initialValue: 'Get notified when your subscription ends or when key actions are needed.',
  );
  final showIcon = context.knobs.boolean(label: 'Show icon', initialValue: true);
  final showClose = context.knobs.boolean(label: 'Show close button', initialValue: true);
  final showInput = context.knobs.boolean(label: 'Show input');
  final showPrimary = context.knobs.boolean(label: 'Show primary button', initialValue: true);
  final showSecondary = context.knobs.boolean(label: 'Show secondary button', initialValue: true);

  // Derive screen type from the device frame so the modal adapts to the
  // selected device (e.g. iPhone 13 → mobile, MacBook → desktop).
  final screenType = ScreenType.fromSize(MediaQuery.sizeOf(context));
  final isDesktop = screenType >= ScreenType.tablet;

  final modal = AlertModal(
    screenType: screenType,
    type: type,
    title: title,
    supportingText: supportingText,
    showIcon: showIcon,
    onClose: showClose ? () {} : null,
    input: showInput ? const _SampleInput() : null,
    primaryButton: showPrimary
        ? ButtonPrimary(onPressed: () {}, size: ButtonSize.small, child: const Text('Enable'))
        : null,
    secondaryButton: showSecondary
        ? ButtonSecondary(onPressed: () {}, size: ButtonSize.small, child: const Text('Dismiss'))
        : null,
  );

  return Padding(
    padding: const EdgeInsets.all(16),
    child: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isDesktop ? 630 : 343),
        child: modal,
      ),
    ),
  );
}

class _SampleInput extends StatelessWidget {
  const _SampleInput();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    return TextField(
      decoration: InputDecoration(
        hintText: 'Enter a value',
        hintStyle: theme.textStyles.textSm.regular.copyWith(color: palette.textPlaceholder),
        contentPadding: EdgeInsets.symmetric(
          horizontal: theme.spacing.ms,
          vertical: theme.spacing.s,
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.kS),
          borderSide: BorderSide(color: palette.borderPrimary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.kS),
          borderSide: BorderSide(color: palette.borderPrimary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.kS),
          borderSide: BorderSide(color: palette.borderBrand),
        ),
      ),
    );
  }
}
