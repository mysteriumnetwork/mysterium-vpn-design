import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Default', type: BottomSheetDialog)
Widget buildBottomSheetDialog(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: "What didn't you like?");
  final showPrimary = context.knobs.boolean(label: 'Show primary button', initialValue: true);
  final showSecondary = context.knobs.boolean(label: 'Show secondary button', initialValue: true);

  // Derive screen type from the device frame so the layout adapts to the
  // selected device (e.g. iPhone 13 → mobile, MacBook → desktop).
  final screenType = ScreenType.fromSize(MediaQuery.sizeOf(context));

  return _BottomSheetDialogPreview(
    title: title,
    screenType: screenType,
    showPrimary: showPrimary,
    showSecondary: showSecondary,
  );
}

class _BottomSheetDialogPreview extends StatefulWidget {
  const _BottomSheetDialogPreview({
    required this.title,
    required this.screenType,
    required this.showPrimary,
    required this.showSecondary,
  });

  final String title;
  final ScreenType screenType;
  final bool showPrimary;
  final bool showSecondary;

  @override
  State<_BottomSheetDialogPreview> createState() => _BottomSheetDialogPreviewState();
}

class _BottomSheetDialogPreviewState extends State<_BottomSheetDialogPreview> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final isDesktop = widget.screenType >= ScreenType.tablet;

    final dialog = BottomSheetDialog(
      title: widget.title,
      onBack: () => setState(() => _open = false),
      onClose: () => setState(() => _open = false),
      body: const _FeedbackContent(),
      primaryButton: widget.showPrimary
          ? ButtonPrimary(
              onPressed: () => setState(() => _open = false),
              child: const Text('Submit'),
            )
          : null,
      secondaryButton: widget.showSecondary
          ? Builder(
              builder: (context) {
                final palette = Theme.of(context).palette;
                return ButtonSecondary(
                  onPressed: () => setState(() => _open = false),
                  decoration: ButtonDecoration(
                    borderColor: palette.borderBrandSecondary,
                    foregroundColor: palette.textSecondary,
                    decorationColor: Palette.white,
                  ),
                  child: const Text('Cancel'),
                );
              },
            )
          : null,
    );

    return Stack(
      children: [
        Center(
          child: ButtonPrimary(
            onPressed: () => setState(() => _open = true),
            child: const Text('Open dialog'),
          ),
        ),
        if (_open)
          Positioned.fill(
            child: ColoredBox(
              color: Theme.of(context).palette.barrierColor,
              child: isDesktop
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
                          child: dialog,
                        ),
                      ),
                    )
                  : Align(alignment: Alignment.bottomCenter, child: dialog),
            ),
          ),
      ],
    );
  }
}

// ─── Feedback content ─────────────────────────────────────────────────────────

const _kItems = [
  'Latency',
  'Disconnects',
  'Error 7040',
  'Downtimes',
  'Unable to access blocked sites',
  'Testing',
  'Usability issues',
  'Too expensive',
  'Missing features',
  'Speed',
  'Other reason',
];

class _FeedbackContent extends StatefulWidget {
  const _FeedbackContent();

  @override
  State<_FeedbackContent> createState() => _FeedbackContentState();
}

class _FeedbackContentState extends State<_FeedbackContent> {
  final Map<String, bool> _checked = {for (final item in _kItems) item: false};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: theme.spacing.xl2,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = (constraints.maxWidth / 220).floor().clamp(1, 2);
            final itemWidth = (constraints.maxWidth - theme.spacing.xl2 * (columns - 1)) / columns;
            return Wrap(
              spacing: theme.spacing.xl2,
              runSpacing: theme.spacing.xl2,
              children: [
                for (final item in _kItems)
                  SizedBox(
                    width: itemWidth,
                    child: _CheckboxItem(
                      label: item,
                      checked: _checked[item]!,
                      onChanged: (v) => setState(() => _checked[item] = v ?? false),
                    ),
                  ),
              ],
            );
          },
        ),
        _DetailsField(),
      ],
    );
  }
}

// ─── Checkbox item ────────────────────────────────────────────────────────────

class _CheckboxItem extends StatelessWidget {
  const _CheckboxItem({required this.label, required this.checked, required this.onChanged});

  final String label;
  final bool checked;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    return GestureDetector(
      onTap: () => onChanged(!checked),
      behavior: HitTestBehavior.opaque,
      child: Row(
        spacing: theme.spacing.lg,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              value: checked,
              onChanged: onChanged,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              side: BorderSide(color: palette.borderPrimary),
            ),
          ),
          Flexible(
            child: Text(
              label,
              style: theme.textStyles.textMd.medium.copyWith(color: palette.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Details text field ───────────────────────────────────────────────────────

class _DetailsField extends StatefulWidget {
  @override
  State<_DetailsField> createState() => _DetailsFieldState();
}

class _DetailsFieldState extends State<_DetailsField> {
  bool _focused = false;
  late final FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _focus = FocusNode()..addListener(_onFocusChange);
  }

  void _onFocusChange() => setState(() => _focused = _focus.hasFocus);

  @override
  void dispose() {
    _focus
      ..removeListener(_onFocusChange)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.bgPrimary,
        borderRadius: const BorderRadius.all(Radius.kS),
        border: Border.all(color: _focused ? palette.borderBrand : palette.borderPrimary),
        boxShadow: [BoxShadow(color: palette.shadowXs, blurRadius: 2, offset: const Offset(0, 1))],
      ),
      child: TextField(
        focusNode: _focus,
        maxLines: null,
        minLines: 5,
        style: theme.textStyles.textMd.regular.copyWith(color: palette.textPrimary),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(14),
          hintText: 'Please enter more details...',
          hintStyle: theme.textStyles.textMd.regular.copyWith(color: palette.textPlaceholder),
          border: InputBorder.none,
        ),
        cursorColor: palette.borderBrand,
      ),
    );
  }
}
