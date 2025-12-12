import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:widgetbook_workspace/main.directories.g.dart';

void main() {
  runApp(const WidgetbookApp());
}

@App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lightTheme = WidgetbookTheme(
      name: 'Light',
      data: DesignSystem.lightTheme,
    );
    final darkTheme = WidgetbookTheme(
      name: 'Dark',
      data: DesignSystem.darkTheme,
    );
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    return Widgetbook.material(
      directories: directories,
      lightTheme: lightTheme.data,
      darkTheme: darkTheme.data,
      addons: [
        MaterialThemeAddon(
          initialTheme: switch (brightness) {
            Brightness.dark => darkTheme,
            Brightness.light => lightTheme,
          },
          themes: [darkTheme, lightTheme],
        ),
        InspectorAddon(),
        BuilderAddon(
          name: 'Background',
          builder: (context, child) {
            final theme = Theme.of(context);
            return ColoredBox(color: theme.palette.bgTertiary, child: child);
          },
        ),
        AlignmentAddon(),
      ],
    );
  }
}
