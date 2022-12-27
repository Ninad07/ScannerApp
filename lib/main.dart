import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner_app/screens/home/viewmodels/home_screen_view_model.dart';
import 'package:scanner_app/screens/splash/splash_screen.dart';
import 'package:dcdg/dcdg.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const ScannerApp());
}

class ScannerApp extends StatelessWidget {
  const ScannerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeScreenViewModel()),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
