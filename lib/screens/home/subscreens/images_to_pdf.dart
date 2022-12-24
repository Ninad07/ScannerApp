import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:scanner_app/screens/home/components/button.dart';
import 'package:scanner_app/screens/home/viewmodels/home_screen_view_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PDFConversionScreen extends StatelessWidget {
  const PDFConversionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pdf = pw.Document();
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey.shade900,
        title: RichText(
          text: TextSpan(
            text: "Scan",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
            children: [
              TextSpan(
                text: "IT",
                style: TextStyle(
                    color: Colors.grey.shade700, fontWeight: FontWeight.bold),
                children: const [
                  TextSpan(
                    text: "  PDF",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w800),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      body: Consumer<HomeScreenViewModel>(builder: (context, viewModel, _) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Provide the Name of the PDF",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  child: TextField(
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      viewModel.updateCurrentPDFName(value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Button(
                isProcessing: viewModel.isProcessing,
                title: "Convert and Save",
                function: () async {
                  viewModel.toggle();
                  for (var image in viewModel.images) {
                    final ximage = pw.MemoryImage(
                      File(image).readAsBytesSync(),
                    );
                    pdf.addPage(pw.Page(build: (pw.Context context) {
                      return pw.Center(
                        child: pw.Image(ximage),
                      );
                    }));
                  }
                  try {
                    Directory? appDocDir = await getExternalStorageDirectory();
                    String path = appDocDir!.path;
                    log(path);
                    final file = File("$path/${viewModel.currentPDFName}.pdf");
                    var status = await Permission.storage.status;
                    if (!status.isGranted) {
                      await Permission.storage.request();
                    }
                    await file.writeAsBytes(await pdf.save());
                    viewModel.toggle();
                    // ignore: use_build_context_synchronously
                    _showDialog(
                        context,
                        "Result",
                        "Your pdf has been saved as ${viewModel.currentPDFName}.pdf",
                        "Close and Go Back");
                  } catch (e) {
                    viewModel.toggle();
                    _showDialog(
                        context,
                        "Result",
                        "Something went wrong. Please try again",
                        "Close and Try Again");
                  }
                }),
            const SizedBox(height: 10),
            Button(
                title: "< Back to images section",
                function: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      }),
    ));
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
                  }),
            ],
          );
        });
  }
}
