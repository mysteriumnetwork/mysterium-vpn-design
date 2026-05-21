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
    this.focusNode,
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

  /// Optional external focus node. When provided, the caller owns and
  /// disposes it; otherwise the field creates and manages an internal one.
  final FocusNode? focusNode;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  FocusNode? _internalFocus;
  TextEditingController? _internalController;
  bool _focused = false;
  bool _hasText = false;

  FocusNode get _focus => widget.focusNode ?? (_internalFocus ??= FocusNode());
  TextEditingController get _controller =>
      widget.controller ?? (_internalController ??= TextEditingController());

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
    _controller.addListener(_onTextChange);
    _hasText = _controller.text.isNotEmpty;
  }

  void _onFocusChange() => setState(() => _focused = _focus.hasFocus);

  void _onTextChange() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _handleClear() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  @override
  void didUpdateWidget(SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _internalFocus)?.removeListener(_onFocusChange);
      _focus.addListener(_onFocusChange);
    }
    if (oldWidget.controller != widget.controller) {
      (oldWidget.controller ?? _internalController)?.removeListener(_onTextChange);
      _controller.addListener(_onTextChange);
      _hasText = _controller.text.isNotEmpty;
    }
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocusChange);
    _controller.removeListener(_onTextChange);
    _internalFocus?.dispose();
    _internalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;

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
                  controller: _controller,
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
              if (widget.enabled && _hasText)
                _ClearButton(onPressed: _handleClear, color: iconColor),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClearButton extends StatelessWidget {
  const _ClearButton({required this.onPressed, required this.color});

  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: onPressed,
    icon: Icon(UntitledUI.x_close, size: 20, color: color),
    tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
    padding: EdgeInsets.zero,
    constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
    visualDensity: VisualDensity.compact,
    splashRadius: 16,
  );
}
