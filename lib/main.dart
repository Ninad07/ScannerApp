import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner_app/screens/splash/splash_screen.dart';

void main() {
  runApp(const ScannerApp());
}

class ScannerApp extends StatelessWidget {
  const ScannerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Colors.black,
        primaryColorDark: Colors.black,
        primaryColorLight: Colors.black,
        colorScheme: ColorScheme.dark(
          primary: Colors.black,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
