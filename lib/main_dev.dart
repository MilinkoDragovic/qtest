import 'package:flutter/material.dart';
import 'package:q_test/app.dart';
import 'package:q_test/util/app_config.dart';

void main() async {
  AppConfig devAppConfig = AppConfig(appName: 'Q Test Dev', flavor: 'dev');
  Widget app = await initializeApp(devAppConfig);
  runApp(app);
}
