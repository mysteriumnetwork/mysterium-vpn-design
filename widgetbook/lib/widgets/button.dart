import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:widgetbook_workspace/use_case_scaffold.dart';

@UseCase(name: 'Primary', type: Button)
Widget buildPrimaryButton(BuildContext context) => _buildButton(
  context,
  (args) => ButtonPrimary(
    onPressed: args.isDisabled ? null : () {},
    size: args.size,
    loading: args.isLoading ? ButtonLoading(text: args.loadingText) : null,
    leading: args.showLeading ? const Icon(UntitledUI.plus_circle) : null,
    trailing: args.showTrailing ? const Icon(UntitledUI.arrow_right) : null,
    child: Text(args.buttonText),
  ),
);

@UseCase(name: 'Secondary', type: Button)
Widget buildSecondaryButton(BuildContext context) => _buildButton(
  context,
  (args) => ButtonSecondary(
    onPressed: args.isDisabled ? null : () {},
    size: args.size,
    loading: args.isLoading ? ButtonLoading(text: args.loadingText) : null,
    leading: args.showLeading ? const Icon(UntitledUI.plus_circle) : null,
    trailing: args.showTrailing ? const Icon(UntitledUI.arrow_right) : null,
    child: Text(args.buttonText),
  ),
);

Widget _buildButton(
  BuildContext context,
  Button Function(_ButtonArgs) buttonBuilder,
) {
  final isDisabled = context.knobs.boolean(label: 'Disabled');
  final isLoading = context.knobs.boolean(label: 'Loading');
  final loadingText = context.knobs.stringOrNull(label: 'Loading text');

  final showLeading = context.knobs.boolean(label: 'Show leading');
  final showTrailing = context.knobs.boolean(label: 'Show trailing');
  final buttonText = context.knobs.string(
    label: 'Text',
    initialValue: 'Click me',
  );
  final size = context.knobs.object.dropdown(
    label: 'Size',
    initialOption: ButtonSize.medium,
    options: ButtonSize.values,
    labelBuilder: (size) => size.name,
  );

  return UseCaseScaffold(
    child: buttonBuilder((
      isDisabled: isDisabled,
      isLoading: isLoading,
      loadingText: loadingText,
      showLeading: showLeading,
      showTrailing: showTrailing,
      buttonText: buttonText,
      size: size,
    )),
  );
}

typedef _ButtonArgs = ({
  bool isDisabled,
  bool isLoading,
  String? loadingText,
  bool showLeading,
  bool showTrailing,
  String buttonText,
  ButtonSize size,
});
