import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({
    this.centerTitle = false,
    this.title,
    this.actions,
    this.backgroundColor,
    this.automaticallyImplyLeading,
    this.showBackButton,
    super.key,
  });

  factory Header.logo({
    List<Widget>? actions,
    Color? backgroundColor,
    bool? automaticallyImplyLeading,
    bool? showBackButton,
  }) => Header(
    title: const Logo(height: 24),
    actions: actions,
    backgroundColor: backgroundColor,
    automaticallyImplyLeading: automaticallyImplyLeading,
    showBackButton: showBackButton,
  );

  factory Header.labeled({
    required String label,
    bool centerTitle = true,
    List<Widget>? actions,
    Color? backgroundColor,
    bool? automaticallyImplyLeading,
    bool? showBackButton,
  }) => Header(
    title: Text(label),
    actions: actions,
    centerTitle: centerTitle,
    backgroundColor: backgroundColor,
    automaticallyImplyLeading: automaticallyImplyLeading,
    showBackButton: showBackButton,
  );

  final Widget? title;
  final bool centerTitle;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final bool? automaticallyImplyLeading;
  final bool? showBackButton;

  @override
  Widget build(BuildContext context) {
    final canGoBack = Navigator.of(context).canPop();
    final title = this.title ?? (canGoBack ? const _BackLabel() : null);
    return AppBar(
      leading: (showBackButton ?? canGoBack) ? const _BackButton() : null,
      automaticallyImplyLeading: automaticallyImplyLeading ?? false,
      title: title,
      centerTitle: centerTitle,
      actions: actions,
      backgroundColor: backgroundColor,
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
