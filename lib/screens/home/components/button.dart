import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:scanner_app/screens/home/viewmodels/home_screen_view_model.dart';

class Button extends StatelessWidget {
  final String title;
  final Function() function;
  final bool isProcessing;
  Button({required this.title, required this.function, this.isProcessing = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          await function();
        },
        style: TextButton.styleFrom(
            backgroundColor: Colors.grey.shade700,
            fixedSize: Size(MediaQuery.of(context).size.width - 100, 45)),
        child: isProcessing
            ? const SizedBox(
              height: 15,
              width: 15,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : Text(
                title,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
      );
  }
}
