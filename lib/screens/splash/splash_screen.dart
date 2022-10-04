import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:scanner_app/screens/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(const Duration(seconds: 3));
      Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(builder: (_) {
          return const HomeScreen();
        }),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _body(),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "loading",
              style: TextStyle(
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 15),
            const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 4,
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _body() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: "Scan",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 60,
            fontWeight: FontWeight.w600,
          ),
          children: [
            TextSpan(
              text: "IT",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 65,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
