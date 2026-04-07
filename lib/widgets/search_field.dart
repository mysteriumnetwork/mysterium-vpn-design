import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// A styled location-search text field.
///
/// Shows a [UntitledUI.search_sm] leading icon and a placeholder.
/// Calls [onChanged] on every keystroke and [onSubmitted] on keyboard submit.
class SearchField extends StatefulWidget {
  const SearchField({
    required this.placeholder,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.autocorrect = false,
    super.key,
  });

  final String placeholder;
  final bool autocorrect;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextEditingController? controller;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final FocusNode _focus;
  bool _focused = false;

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
    final palette = Theme.of(context).palette;
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.bgPrimary,
        borderRadius: const BorderRadius.all(Radius.kS),
        border: Border.all(color: _focused ? palette.borderBrand : palette.borderPrimary),
        boxShadow: [BoxShadow(color: palette.shadowXs, blurRadius: 2, offset: const Offset(0, 1))],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          spacing: 8,
          children: [
            Icon(UntitledUI.search_sm, size: 20, color: palette.iconTertiary),
            Expanded(
              child: TextField(
                focusNode: _focus,
                controller: widget.controller,
                onChanged: widget.onChanged,
                onSubmitted: widget.onSubmitted,
                autocorrect: widget.autocorrect,
                style: theme.textStyles.textMd.regular.copyWith(color: palette.textPrimary),
                decoration: InputDecoration.collapsed(
                  hintText: widget.placeholder,
                  hintStyle: theme.textStyles.textMd.regular.copyWith(
                    color: palette.textPlaceholder,
                  ),
                ),
                cursorColor: palette.borderBrand,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
