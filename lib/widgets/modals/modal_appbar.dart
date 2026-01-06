import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class ModalAppbar extends StatelessWidget implements PreferredSizeWidget {
  const ModalAppbar({
    this.title,
    this.actions,
    super.key,
  });

  final String? title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final parentRoute = ModalRoute.of(context);
    final theme = Theme.of(context);
    final canPop = parentRoute?.impliesAppBarDismissal ?? false;
    return AppBar(
      elevation: 0,
      backgroundColor: Palette.transparent,
      forceMaterialTransparency: true,
      automaticallyImplyLeading: false,
      title: title == null ? null : Text(title!),
      centerTitle: true,
      actionsPadding: EdgeInsets.symmetric(horizontal: theme.spacing.xl2),
      actions: [
        ...?actions,
        if (canPop) const _ModalCloseButton(),
      ],
    );
  }

  @override
  Size get preferredSize {
    final view = ScreenType.flutterView();
    final topPadding = view != null ? MediaQueryData.fromView(view).padding.top : 0;
    return Size.fromHeight(kToolbarHeight + topPadding);
  }
}

class _ModalCloseButton extends StatelessWidget {
  const _ModalCloseButton();

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: Navigator.of(context).pop,
        icon: const Icon(UntitledUI.x_close),
        iconSize: 24,
      );
}
