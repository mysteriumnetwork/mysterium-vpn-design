import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class ModalAppbar extends StatelessWidget implements PreferredSizeWidget {
  const ModalAppbar({
    this.title,
    this.actions,
    this.onModalClose,
    this.showCloseButton = true,
    super.key,
  });

  final String? title;
  final List<Widget>? actions;
  final VoidCallback? onModalClose;
  final bool showCloseButton;

  @override
  Widget build(BuildContext context) {
    final parentRoute = ModalRoute.of(context);
    final theme = Theme.of(context);
    final canPop = (parentRoute?.impliesAppBarDismissal ?? false) && showCloseButton;
    return AppBar(
      elevation: 0,
      backgroundColor: Palette.transparent,
      forceMaterialTransparency: true,
      automaticallyImplyLeading: false,
      title: title == null ? null : Text(title!),
      centerTitle: true,
      actionsPadding: EdgeInsets.only(right: theme.spacing.md, top: theme.spacing.md),
      actions: [
        ...?actions,
        if (canPop) _ModalCloseButton(onPressed: onModalClose),
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
  const _ModalCloseButton({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: onPressed ?? Navigator.of(context).pop,
    icon: const Icon(UntitledUI.x_close),
    iconSize: 24,
  );
}
