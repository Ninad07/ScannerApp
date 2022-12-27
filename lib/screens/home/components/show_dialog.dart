import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner_app/screens/home/home_screen.dart';
import 'package:scanner_app/screens/home/viewmodels/home_screen_view_model.dart';

import 'button.dart';

void showDialogBox(BuildContext context, String title, String description,
    String buttonText) async {
  showDialog(
      context: context,
      builder: (context_) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: [
            Button(
                title: buttonText,
                function: () async {
                  Provider.of<HomeScreenViewModel>(context, listen: false)
                      .cleanReset();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                      (route) => false);
                }),
          ],
        );
      });
}
