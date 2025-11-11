import 'package:flutter/material.dart';

class UseCaseScaffold extends StatelessWidget {
  const UseCaseScaffold({required this.child, this.appBar, super.key});

  final PreferredSizeWidget? appBar;
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: appBar,
    body: Center(child: child),
  );
}
