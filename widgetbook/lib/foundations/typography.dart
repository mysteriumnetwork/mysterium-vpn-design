import 'package:flutter/material.dart' hide Typography;
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:widgetbook_workspace/pages/typography.dart';

@UseCase(name: 'Typography', type: Typography, path: '[Foundations]')
Widget buildTypography(BuildContext context) => const Typography();
