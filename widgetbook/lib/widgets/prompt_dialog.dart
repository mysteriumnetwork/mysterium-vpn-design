import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Default', type: PromptDialog)
Widget buildPromptDialog(BuildContext context) {
  final showPrimary = context.knobs.boolean(label: 'Show primary button', initialValue: true);
  final showSecondary = context.knobs.boolean(label: 'Show secondary button', initialValue: true);
  final title = context.knobs.string(label: 'Title', initialValue: 'Stay updated by email');
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue:
        'Would you like to receive email updates, privacy tips, and special offers from Mysterium Network?',
  );
  final imageSize = context.knobs.double.slider(
    label: 'Image size',
    initialValue: 80,
    min: 40,
    max: 160,
  );

  return _InlineDialogPreview(
    title: title,
    subtitle: subtitle,
    imageSize: imageSize,
    showPrimary: showPrimary,
    showSecondary: showSecondary,
  );
}

class _InlineDialogPreview extends StatefulWidget {
  const _InlineDialogPreview({
    required this.title,
    required this.subtitle,
    required this.imageSize,
    required this.showPrimary,
    required this.showSecondary,
  });

  final String title;
  final String subtitle;
  final double imageSize;
  final bool showPrimary;
  final bool showSecondary;

  @override
  State<_InlineDialogPreview> createState() => _InlineDialogPreviewState();
}

class _InlineDialogPreviewState extends State<_InlineDialogPreview> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    // Derive screen type from the device frame MediaQuery so the layout
    // adapts to the selected device (e.g. iPhone 13 → mobile, MacBook → desktop).
    final screenType = ScreenType.fromSize(MediaQuery.sizeOf(context));
    final isDesktop = screenType >= ScreenType.tablet;

    final dialog = PromptDialog(
      screenType: screenType,
      image: Icon(
        UntitledUI.mail_01,
        size: widget.imageSize,
        color: Theme.of(context).palette.iconBrandSecondary,
      ),
      title: widget.title,
      subtitle: widget.subtitle,
      primaryButton: widget.showPrimary
          ? FilledButton(
              onPressed: () => setState(() => _open = false),
              child: const Text('Allow notifications'),
            )
          : null,
      secondaryButton: widget.showSecondary
          ? OutlinedButton(
              onPressed: () => setState(() => _open = false),
              child: const Text('Not now'),
            )
          : null,
    );

    return Stack(
      children: [
        // Trigger button (always visible behind the overlay)
        Center(
          child: FilledButton(
            onPressed: () => setState(() => _open = true),
            child: const Text('Open dialog'),
          ),
        ),

        // Inline modal overlay — stays inside the device frame
        if (_open)
          Positioned.fill(
            child: ColoredBox(
              color: Colors.black54,
              child: isDesktop
                  ? Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 600,
                          maxWidth: 600,
                          minHeight: 400,
                          maxHeight: 400,
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.kXl),
                          child: dialog,
                        ),
                      ),
                    )
                  : dialog,
            ),
          ),
      ],
    );
  }
}
