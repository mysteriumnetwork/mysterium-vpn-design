import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart'
    hide DesignSystem;

class Colors extends StatelessWidget {
  const Colors({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: Header.labeled(label: 'Colors'),
      body: CustomScrollView(
        slivers: [
          SliverList.list(
            children: const [
              Text('Primary'),
              _Row(label: 'Gray(light mode)', color: Palette.grayLight),
              _Row(label: 'Gray(dark mode)', color: Palette.grayDark),
              _Row(label: 'Brand', color: Palette.brand),
              _Row(label: 'Brand purple', color: Palette.brandPurple),
              _Row(label: 'Error', color: Palette.error),
              _Row(label: 'Warning', color: Palette.warning),
              _Row(label: 'Success', color: Palette.success),

              Text('Secondary'),
              _Row(label: 'Gray purple', color: Palette.grayPurple),
              _Row(label: 'Gray cool', color: Palette.grayCool),
            ],
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              top: theme.spacing.xl3,
              bottom: theme.spacing.xl,
            ),
            sliver: const SliverToBoxAdapter(child: Text('Variable colors')),
          ),
          const _VariableColors(),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.color});

  final String label;
  final PaletteColor color;

  @override
  Widget build(BuildContext context) {
    final swatch = {
      '25': color.shade25,
      '50': color.shade50,
      '100': color.shade100,
      '200': color.shade200,
      '300': color.shade300,
      '400': color.shade400,
      '500': color.shade500,
      '600': color.shade600,
      '700': color.shade700,
      '800': color.shade800,
      '900': color.shade900,
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 150),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final color in swatch.entries)
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 160),
                    child: _Entry(color: color.value, label: color.key),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VariableColors extends StatelessWidget {
  const _VariableColors();

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).palette;
    final data = {
      'text-primary': palette.textPrimary,
      'text-secondary': palette.textSecondary,
      'text-white': palette.textWhite,
      'text-disabled': palette.textDisabled,
      'text-placeholder': palette.textPlaceholder,
      'text-brand-primary': palette.textBrandPrimary,
      'text-error-primary': palette.textErrorPrimary,
      'text-warning-primary': palette.textWarningPrimary,
      'text-success-primary': palette.textSuccessPrimary,
    };
    return SliverList.separated(
      itemCount: data.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, index) {
        final entry = data.entries.elementAt(index);
        return _VariableEntry(color: entry.value, label: entry.key);
      },
    );
  }
}

class _VariableEntry extends StatelessWidget {
  const _VariableEntry({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    spacing: 24,
    children: [
      Container(width: 64, height: 64, color: color),
      Expanded(child: Text('$label\n${color.hexValue}')),
    ],
  );
}

class _Entry extends StatelessWidget {
  const _Entry({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: 12,
    children: [
      SizedBox(height: 80, width: 160, child: ColoredBox(color: color)),
      Flexible(child: Text('$label\n${color.hexValue}')),
    ],
  );
}

extension _ColorExtensions on Color {
  String get hexValue =>
      '#${toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
}
