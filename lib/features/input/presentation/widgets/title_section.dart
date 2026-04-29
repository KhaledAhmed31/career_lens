import 'package:flutter/material.dart';

List<Widget> titleSection(
  BuildContext context,
  String title,
  String description,
) => [
  Text(title, style: Theme.of(context).textTheme.titleMedium),
  const SizedBox(height: 8.0),
  Text(description, style: Theme.of(context).textTheme.bodySmall),
];
