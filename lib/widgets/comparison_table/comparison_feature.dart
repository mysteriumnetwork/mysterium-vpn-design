part of '../comparison_table.dart';

/// One row of a [ComparisonTable].
///
/// [label] is rendered in the left column; [values] supplies one cell per
/// column key. An optional [description] renders as a tooltip next to the
/// label.
@immutable
class ComparisonFeature<K> {
  const ComparisonFeature({required this.values, required this.label, this.description});

  /// Feature name displayed in the left column.
  final String label;

  /// Extra context surfaced via a tooltip icon next to the label.
  final String? description;

  /// Per-column values. Missing keys render as an empty cell.
  final Map<K, ComparisonValue<dynamic>> values;

  @override
  String toString() =>
      'ComparisonFeature(label: $label, description: $description, values: $values)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is ComparisonFeature<K> &&
        other.label == label &&
        other.description == description &&
        mapEquals(other.values, values);
  }

  @override
  int get hashCode => label.hashCode ^ description.hashCode ^ values.hashCode;
}
