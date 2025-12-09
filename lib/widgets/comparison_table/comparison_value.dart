part of 'comparison_table.dart';

sealed class ComparisonValue<T> {
  const ComparisonValue(this.value);

  final T value;
}

class ComparisonText extends ComparisonValue<String> {
  const ComparisonText(super.text);
}

class ComparisonAvailable extends ComparisonValue<bool> {
  // ignore: avoid_positional_boolean_parameters
  const ComparisonAvailable(super.isAvailable);
}

class ComparisonWidget extends ComparisonValue<Widget> {
  const ComparisonWidget(super.widget);
}
