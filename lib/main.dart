import 'package:career_lens/core/config/di/dependency_injection.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const CareerLensApp());
}
