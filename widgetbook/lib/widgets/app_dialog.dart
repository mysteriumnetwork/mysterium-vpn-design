import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Default', type: AppDialog)
Widget buildAppDialog(BuildContext context) {
  final showPrimary = context.knobs.boolean(label: 'Show primary button', initialValue: true);
  final showSecondary = context.knobs.boolean(label: 'Show secondary button', initialValue: true);
  final showEmblem = context.knobs.boolean(label: 'Show emblem', initialValue: true);
  final title = context.knobs.string(label: 'Title', initialValue: 'Take a quick tour');
  final description = context.knobs.stringOrNull(
    label: 'Description',
    initialValue: 'Learn your way around the updated app and discover where key features now live.',
  );
  final width = context.knobs.doubleOrNull.input(label: 'Width', initialValue: 349);

  return _InlineAppDialogPreview(
    title: title,
    description: description,
    width: width,
    showEmblem: showEmblem,
    showPrimary: showPrimary,
    showSecondary: showSecondary,
  );
}

class _InlineAppDialogPreview extends StatefulWidget {
  const _InlineAppDialogPreview({
    required this.title,
    required this.description,
    required this.width,
    required this.showEmblem,
    required this.showPrimary,
    required this.showSecondary,
  });

  final String title;
  final String? description;
  final double? width;
  final bool showEmblem;
  final bool showPrimary;
  final bool showSecondary;

  @override
  State<_InlineAppDialogPreview> createState() => _InlineAppDialogPreviewState();
}

class _InlineAppDialogPreviewState extends State<_InlineAppDialogPreview> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;

    final dialog = AppDialog(
      title: widget.title,
      description: widget.description,
      width: widget.width,
      emblem: widget.showEmblem
          ? SizedBox(
              width: 32,
              height: 32,
              child: CircleAvatar(
                backgroundColor: palette.bgSecondarySelected,
                child: Padding(
                  padding: EdgeInsets.all(theme.spacing.sm),
                  child: Icon(UntitledUI.flag_05, size: 20, color: palette.iconBrandSecondary),
                ),
              ),
            )
          : null,
      primaryButton: widget.showPrimary
          ? ButtonPrimary(
              onPressed: () => setState(() => _open = false),
              child: Text(
                'Start tour',
                style: theme.textStyles.textSm.semibold.copyWith(color: palette.textWhite),
              ),
            )
          : null,
      secondaryButton: widget.showSecondary
          ? ButtonTertiary(
              decoration: ButtonDecoration(padding: EdgeInsets.all(theme.spacing.none)),
              onPressed: () => setState(() => _open = false),
              child: Text(
                'Skip for now',
                style: theme.textStyles.textSm.semibold.copyWith(color: palette.textSecondary),
              ),
            )
          : null,
    );

    return Stack(
      children: [
        // Trigger button (always visible behind the overlay)
        Center(
          child: ButtonPrimary(
            onPressed: () => setState(() => _open = true),
            child: const Text('Open dialog'),
          ),
        ),

        // Inline modal overlay — stays inside the device frame
        if (_open)
          Positioned.fill(
            child: ColoredBox(
              color: palette.barrierColor,
              child: Center(
                child: ClipRRect(borderRadius: const BorderRadius.all(Radius.kS), child: dialog),
              ),
            ),
          ),
      ],
    );
  }
}
