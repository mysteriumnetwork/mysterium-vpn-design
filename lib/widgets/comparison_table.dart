import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:mysterium_vpn_design/widgets/tooltip_icon.dart';

part 'comparison_table/comparison_feature.dart';
part 'comparison_table/comparison_value.dart';

class ComparisonTable<K> extends StatelessWidget {
  const ComparisonTable({
    required this.headerColumns,
    required this.features,
    this.headerIndexColumn,
    super.key,
  });

  final Widget? headerIndexColumn;
  final Map<K, String> headerColumns;
  final List<ComparisonFeature<K>> features;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final textStyles = theme.textStyles;
    return Table(
      border: TableBorder(
        verticalInside: BorderSide(color: palette.borderPrimary),
        bottom: BorderSide(color: palette.borderPrimary),
        top: BorderSide(color: palette.borderPrimary),
        left: BorderSide(color: palette.borderPrimary),
        right: BorderSide(color: palette.borderPrimary),
      ),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const {
        0: FlexColumnWidth(1.75),
      },
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
  }
}

class _Header extends TableRow {
  _Header({
    required Widget? headerIndexColumn,
    required Map<dynamic, String> headerColumns,
    EdgeInsets padding = const EdgeInsets.only(
      left: 16,
      right: 16,
      top: 24,
      bottom: 16,
    ),
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
                child: Text(
                  column,
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
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
                  if (feature.description != null) TooltipIcon(message: feature.description!),
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
                .map(
                  (widget) => _Cell(child: widget),
                ),
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
        child: Align(
          alignment: alignment,
          child: child,
        ),
      );
}
