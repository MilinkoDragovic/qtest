import 'package:flutter/material.dart';
import 'package:q_test/app.dart';
import 'package:q_test/util/app_config.dart';

void main() async {
  AppConfig prodAppConfig = AppConfig(appName: 'Q Test Prod', flavor: 'prod');
  Widget app = await initializeApp(prodAppConfig);
  runApp(app);
}
