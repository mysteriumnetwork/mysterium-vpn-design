import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:widgetbook_workspace/main.directories.g.dart';
import 'package:widgetbook_workspace/widgets/screen_container.dart';

void main() {
  runApp(const WidgetbookApp());
}

@App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lightTheme = WidgetbookTheme(name: 'Light', data: DesignSystem.lightTheme);
    final darkTheme = WidgetbookTheme(name: 'Dark', data: DesignSystem.darkTheme);
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    return ScreenTypeObserver(
      child: Widgetbook.material(
        directories: [
          ...directories,
          WidgetbookComponent(
            name: '$ScreenContainer',
            useCases: [
              WidgetbookUseCase(name: 'Default', builder: (context) => const ScreenContainer()),
            ],
          ),
        ],
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
          TextScaleAddon(),
          ViewportAddon([
            IosViewports.iPhoneSE,
            IosViewports.iPhone12,
            IosViewports.iPhone13,
            IosViewports.iPhone13ProMax,
            MacosViewports.desktop,
            MacosViewports.macbookPro,
            AndroidViewports.largeTablet,
            AndroidViewports.mediumTablet,
            AndroidViewports.smallTablet,
            AndroidViewports.samsungGalaxyS20,
            AndroidViewports.samsungGalaxyA50,
          ]),
          AlignmentAddon(),
          BuilderAddon(
            name: 'ScreenUtil',
            builder: (context, child) => ScreenUtilInit(
              designSize: const Size(375, 812),
              minTextAdapt: true,
              splitScreenMode: true,
              useInheritedMediaQuery: true,
              builder: (context, child) => child!,
              child: child,
            ),
          ),
          BuilderAddon(
            name: 'Bounds',
            builder: (context, child) => DecoratedBox(
              decoration: BoxDecoration(border: Border.all(color: Colors.white)),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
