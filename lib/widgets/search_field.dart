import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// A styled location-search text field.
///
/// Shows a [UntitledUI.search_sm] leading icon and a placeholder.
/// Calls [onChanged] on every keystroke and [onSubmitted] on keyboard submit.
///
/// Set [enabled] to `false` to render the disabled state — the field swaps to
/// `palette.bgInactive`, mutes the icon and text colours, and rejects input.
class SearchField extends StatefulWidget {
  const SearchField({
    required this.placeholder,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.autocorrect = false,
    this.enabled = true,
    super.key,
  });

  final String placeholder;
  final bool autocorrect;

  /// When false, the field uses an inactive background, muted text colours,
  /// and rejects all input.
  final bool enabled;
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

    final mutedColor = palette.textDisabled;
    final iconColor = widget.enabled ? palette.textTertiary : mutedColor;
    final hintColor = widget.enabled ? palette.textTertiary : mutedColor;
    final textColor = widget.enabled ? palette.textPrimary : mutedColor;

    return SizedBox(
      height: theme.spacing.xl4,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: widget.enabled ? palette.bgPrimary : palette.bgInactive,
          borderRadius: const BorderRadius.all(Radius.kS),
          border: Border.all(color: _focused ? palette.borderBrand : palette.borderPrimary),
          boxShadow: [
            BoxShadow(color: palette.shadowXs, blurRadius: 2, offset: const Offset(0, 1)),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: theme.spacing.ms, vertical: theme.spacing.s),
          child: Row(
            spacing: theme.spacing.s,
            children: [
              Icon(UntitledUI.search_sm, size: 20, color: iconColor),
              Expanded(
                child: TextField(
                  focusNode: _focus,
                  controller: widget.controller,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  autocorrect: widget.autocorrect,
                  enabled: widget.enabled,
                  style: theme.textStyles.textMd.regular.copyWith(color: textColor),
                  decoration: InputDecoration.collapsed(
                    hintText: widget.placeholder,
                    hintStyle: theme.textStyles.textMd.regular.copyWith(color: hintColor),
                  ),
                  cursorColor: palette.borderBrand,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
