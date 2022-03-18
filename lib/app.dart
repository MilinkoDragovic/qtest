import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:q_test/pages/home_page.dart';
import 'package:q_test/util/app_config.dart';

Future<Widget> initializeApp(AppConfig appConfig) async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  return MyApp(appConfig);
}

class MyApp extends StatelessWidget {
  const MyApp(AppConfig? appConfig, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      routes: {
        'home': (BuildContext context) => const HomePage(),
      },
    );
  }
}
