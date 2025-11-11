import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({
    this.centerTitle = false,
    this.title,
    this.actions,
    super.key,
  });

  factory Header.logo({List<Widget>? actions}) => Header(
        title: const Logo(height: 24),
        actions: actions,
      );

  factory Header.labeled({
    required String label,
    bool centerTitle = true,
    List<Widget>? actions,
  }) =>
      Header(
        title: Text(label),
        actions: actions,
        centerTitle: centerTitle,
      );

  final Widget? title;
  final bool centerTitle;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final canGoBack = Navigator.of(context).canPop();
    final title = this.title ?? (canGoBack ? const _BackLabel() : null);
    return AppBar(
      leading: canGoBack ? const _BackButton() : null,
      title: title,
      centerTitle: centerTitle,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const _PreferredSize();
}

class _PreferredSize extends Size {
  const _PreferredSize() : super.fromHeight(kToolbarHeight);
}

class _BackLabel extends StatelessWidget {
  const _BackLabel();

  @override
  Widget build(BuildContext context) => const Text('Back to home');
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) => IconButton(
        icon: const Icon(UntitledUI.arrow_narrow_left),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
}
