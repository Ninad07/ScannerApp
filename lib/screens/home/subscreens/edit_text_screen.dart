import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:scanner_app/screens/home/viewmodels/home_screen_view_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;

import '../components/button.dart';

class EditTextScreen extends StatelessWidget {
  const EditTextScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenViewModel>(builder: (context, viewModel, _) {
      return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: () async {
              Directory? appDocDir = await getExternalStorageDirectory();
                  String path = appDocDir!.path;
              final pdf = pw.Document();
              pdf.addPage(pw.Page(build: (pw.Context context) {
                      return pw.Center(
                        child: pw.Text(viewModel.translatedText),
                      );
                    }));

              try {
                    final file = File("$path/${viewModel.currentPDFName}.pdf");
                    var status = await Permission.storage.status;
                    if (!status.isGranted) {
                      await Permission.storage.request();
                    }
                    await file.writeAsBytes(await pdf.save());
                    viewModel.toggleProcessing();
                    // ignore: use_build_context_synchronously
                    _showDialog(
                        context,
                        "Result",
                        "Your translated doc has been saved as ${viewModel.currentPDFName}.pdf",
                        "Close and Go Back");
                  } catch (e) {
                    viewModel.toggleProcessing();
                    _showDialog(
                        context,
                        "Result",
                        "Something went wrong. Please try again",
                        "Close and Try Again");
                  }
            }, icon: Icon(Icons.save)),
          ],
        ),
        body: SingleChildScrollView(
          child: TextFormField(
            keyboardType: TextInputType.multiline,
  maxLines: 99999,
            initialValue: viewModel.translatedText,
            onChanged: (value) {
              viewModel.updateText(value);
            },
          ),
        ),
      ));
    });
  }

  void _showDialog(BuildContext context, String title, String description,
      String buttonText) async {
    await showDialog(
        context: context,
        builder: (context_) {
          return AlertDialog(
            title: Text(title),
            content: Text(description),
            actions: [
              Button(
                  title: buttonText,
                  function: () async {
                    Navigator.of(context_).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }
}