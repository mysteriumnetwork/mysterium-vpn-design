part of 'comparison_table.dart';

@immutable
class ComparisonFeature<K> {
  const ComparisonFeature({
    required this.values,
    required this.label,
    this.description,
  });

  final String label;
  final String? description;
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
