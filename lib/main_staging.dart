import 'package:flutter/material.dart';
import 'package:q_test/app.dart';
import 'package:q_test/util/app_config.dart';

void main() async {
  AppConfig stagingAppConfig =
      AppConfig(appName: 'Q Test Staging', flavor: 'staging');
  Widget app = await initializeApp(stagingAppConfig);
  runApp(app);
}
