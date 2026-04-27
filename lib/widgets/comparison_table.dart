import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

part 'comparison_table/comparison_feature.dart';
part 'comparison_table/comparison_value.dart';

/// A feature comparison grid where rows are features and columns are
/// compared entities (e.g. plans, tiers) keyed by [K].
///
/// Each [ComparisonFeature] specifies per-column [ComparisonValue]s — text,
/// a check / cross icon, or an arbitrary widget. Zebra striping is applied
/// automatically; on tablet+ a horizontal margin is added.
class ComparisonTable<K> extends StatelessWidget {
  const ComparisonTable({
    required this.headerColumns,
    required this.features,
    this.headerIndexColumn,
    super.key,
  });

  /// Optional widget for the empty top-left cell above the feature labels.
  final Widget? headerIndexColumn;

  /// Ordered mapping of column key → header label. Column order follows
  /// iteration order of this map.
  final Map<K, String> headerColumns;

  /// One row per feature, keyed by the same [K] as [headerColumns].
  final List<ComparisonFeature<K>> features;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final textStyles = theme.textStyles;
    final screenType = ScreenType.of(context);
    final isDesktop = screenType.index >= ScreenType.tablet.index;

    final table = Table(
      border: TableBorder(
        verticalInside: BorderSide(color: palette.borderPrimary),
        bottom: BorderSide(color: palette.borderPrimary),
        top: BorderSide(color: palette.borderPrimary),
        left: BorderSide(color: palette.borderPrimary),
        right: BorderSide(color: palette.borderPrimary),
      ),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const {0: FlexColumnWidth(1.75)},
      children: [
        _Header(
          headerIndexColumn: headerIndexColumn,
          headerColumns: headerColumns,
          textStyle: textStyles.textSm.bold,
        ),
        ...features.mapIndexed(
          (index, feature) => _FeatureRow<K>(
            feature: feature,
            keys: headerColumns.keys.toList(),
            color: index.isEven ? palette.bgSecondary : null,
            iconTrueColor: palette.iconSuccessPrimary,
            iconFalseColor: palette.iconPrimary,
            textStyle: textStyles.textSm.regular,
          ),
        ),
      ],
    );

    if (isDesktop) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: theme.spacing.xl2),
        child: table,
      );
    }

    return table;
  }
}

class _Header extends TableRow {
  _Header({
    required Widget? headerIndexColumn,
    required Map<dynamic, String> headerColumns,
    EdgeInsets padding = const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 16),
    TextStyle? textStyle,
  }) : super(
         children: [
           _Cell(
             padding: padding,
             alignment: Alignment.centerLeft,
             child: headerIndexColumn ?? const SizedBox.shrink(),
           ),
           for (final column in headerColumns.values)
             _Cell(
               padding: padding,
               child: Text(column, style: textStyle, textAlign: TextAlign.center),
             ),
         ],
       );
}

class _FeatureRow<K> extends TableRow {
  _FeatureRow({
    required ComparisonFeature<K> feature,
    required List<K> keys,
    Color? color,
    Color? iconTrueColor,
    Color? iconFalseColor,
    TextStyle? textStyle,
  }) : super(
         decoration: BoxDecoration(color: color),
         children: [
           _Cell(
             alignment: Alignment.centerLeft,
             child: Row(
               spacing: 6,
               children: [
                 Expanded(child: Text(feature.label, style: textStyle)),
                 if (feature.description != null)
                   TooltipIcon(message: feature.description!, color: textStyle?.color),
               ],
             ),
           ),
           ...keys
               .map(
                 (key) => switch (feature.values[key]) {
                   final ComparisonText text => Text(
                     text.value,
                     style: textStyle,
                     textAlign: TextAlign.center,
                   ),
                   final ComparisonAvailable available => Icon(
                     available.value ? UntitledUI.check_circle : UntitledUI.x_close,
                     size: 16,
                     color: available.value ? iconTrueColor : iconFalseColor,
                   ),
                   final ComparisonWidget widget => widget.value,
                   null => const SizedBox.shrink(),
                 },
               )
               .map((widget) => _Cell(child: widget)),
         ],
       );
}

class _Cell extends StatelessWidget {
  const _Cell({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.alignment = Alignment.center,
  });

  final EdgeInsets padding;
  final Widget child;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) => Padding(
    padding: padding,
    child: Align(alignment: alignment, child: child),
  );
}
