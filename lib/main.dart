import 'package:career_lens/core/config/di/dependency_injection.dart';
import 'package:career_lens/core/model/service/career_predictor_service.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await CareerPredictorService.instance.initialize();

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => CareerLensApp(), // Wrap your app
    ),
  );
}
