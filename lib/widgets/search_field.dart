import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Duration of the search field's hover and focus transitions.
const Duration _kTransition = Duration(milliseconds: 150);

/// A styled location-search text field.
///
/// Shows a [UntitledUI.search_sm] leading icon and a placeholder.
/// Calls [onChanged] on every keystroke and [onSubmitted] on keyboard submit.
///
/// Hovering tints the field to [Palette.bgPrimaryHover]; focusing swaps the
/// border to [Palette.borderBrand] and tints the leading icon to match. Both
/// transitions are eased over 150ms.
///
/// Set [enabled] to `false` to render the disabled state — the field swaps to
/// `palette.bgInactive`, mutes the icon and text colours, and rejects input.
///
/// Pass [onTap] for button mode: the field keeps its exact appearance and
/// hover behaviour but renders the placeholder as plain text instead of a live
/// input, and taps anywhere on it call [onTap]. Used where a search bar is
/// really a shortcut to a search elsewhere.
class SearchField extends StatefulWidget {
  const SearchField({
    required this.placeholder,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.focusNode,
    this.autocorrect = false,
    this.enabled = true,
    this.onTap,
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

  /// When non-null the field becomes a button: text input is ignored and a tap
  /// anywhere on it calls this instead.
  final VoidCallback? onTap;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  FocusNode? _internalFocus;
  TextEditingController? _internalController;
  bool _focused = false;
  bool _hasText = false;
  bool _hovered = false;

  bool get _isButton => widget.onTap != null;

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
      _focused = _focus.hasFocus;
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

  /// Field background: disabled wins, then focus (kept flat so the ring reads),
  /// then hover.
  Color _background(Palette palette) {
    if (!widget.enabled) {
      return palette.bgInactive;
    }
    if (!_focused && _hovered) {
      return palette.bgPrimaryHover;
    }
    return palette.bgPrimary;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;

    final mutedColor = palette.textDisabled;
    final restingIconColor = widget.enabled ? palette.textTertiary : mutedColor;
    final iconColor = _focused ? palette.borderBrand : restingIconColor;
    final hintColor = widget.enabled ? palette.textTertiary : mutedColor;
    final textColor = widget.enabled ? palette.textPrimary : mutedColor;

    final hintStyle = theme.textStyles.textMd.regular.copyWith(color: hintColor);

    // Button mode can't be typed into, so it renders the placeholder directly
    // rather than a live TextField.
    final field = _isButton
        ? Text(widget.placeholder, style: hintStyle, maxLines: 1, overflow: TextOverflow.ellipsis)
        : TextField(
            focusNode: _focus,
            controller: _controller,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            autocorrect: widget.autocorrect,
            enabled: widget.enabled,
            style: theme.textStyles.textMd.regular.copyWith(color: textColor),
            decoration: InputDecoration.collapsed(
              hintText: widget.placeholder,
              hintStyle: hintStyle,
            ),
            cursorColor: palette.borderBrand,
          );

    final body = SizedBox(
      height: theme.spacing.xl4,
      child: AnimatedContainer(
        duration: _kTransition,
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: _background(palette),
          borderRadius: const BorderRadius.all(Radius.kS),
          border: Border.all(color: _focused ? palette.borderBrand : palette.borderPrimary),
          boxShadow: [
            BoxShadow(color: palette.shadowXs, blurRadius: 2, offset: const Offset(0, 1)),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: theme.spacing.ms, vertical: theme.spacing.s),
        child: Row(
          spacing: theme.spacing.s,
          children: [
            TweenAnimationBuilder<Color?>(
              tween: ColorTween(end: iconColor),
              duration: _kTransition,
              curve: Curves.easeOut,
              builder: (context, color, _) => Icon(UntitledUI.search_sm, size: 20, color: color),
            ),
            Expanded(child: field),
            if (widget.enabled && _hasText && !_isButton)
              _ClearButton(onPressed: _handleClear, color: restingIconColor),
          ],
        ),
      ),
    );

    return MouseRegion(
      cursor: _isButton && widget.enabled ? SystemMouseCursors.click : MouseCursor.defer,
      // Tracked unconditionally: gating on `enabled` strands `_hovered` when
      // the field is disabled mid-hover. `_background` gates the paint.
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: _isButton
          ? GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.enabled ? widget.onTap : null,
              child: body,
            )
          : body,
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
