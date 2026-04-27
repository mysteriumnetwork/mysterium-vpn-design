part of '../comparison_table.dart';

/// A single cell value in a [ComparisonTable] row.
///
/// Use one of the concrete subclasses: [ComparisonText],
/// [ComparisonAvailable], or [ComparisonWidget].
sealed class ComparisonValue<T> {
  const ComparisonValue(this.value);

  final T value;
}

/// Plain-text cell (e.g. "Unlimited", "5 GB").
class ComparisonText extends ComparisonValue<String> {
  const ComparisonText(super.text);
}

/// Boolean cell rendered as a check (true) or cross (false) icon.
class ComparisonAvailable extends ComparisonValue<bool> {
  // ignore: avoid_positional_boolean_parameters
  const ComparisonAvailable(super.isAvailable);
}

/// Arbitrary widget cell for custom content (e.g. a badge, an image).
class ComparisonWidget extends ComparisonValue<Widget> {
  const ComparisonWidget(super.widget);
}
