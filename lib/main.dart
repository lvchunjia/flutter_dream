import 'package:flutter/material.dart';
import 'package:flutter_dream/storage/db_storage/db_storage.dart';

import 'navigation/app_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbStorage.instance.open();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AppNavigation(),
    );
  }
}
