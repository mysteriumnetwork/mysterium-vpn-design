import 'package:flutter/material.dart' hide Colors;
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:widgetbook_workspace/pages/colors.dart';

@UseCase(name: 'Colors', type: Colors, path: '[Foundations]')
Widget buildTypography(BuildContext context) => const Colors();
