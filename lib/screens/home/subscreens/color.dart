import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:scanner_app/screens/home/viewmodels/home_screen_view_model.dart';

import '../components/button.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;

import 'edit_text_screen.dart';

class ChangeColorScreen extends StatelessWidget {
  const ChangeColorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Select Color",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Consumer<HomeScreenViewModel>(builder: (context, viewModel, _) {
            return Container(
              margin: const EdgeInsets.all(10),
              height: 50,
              // color: Colors.grey,
              child: DropdownButton<String>(
                  isExpanded: true,
                  dropdownColor: Colors.grey.shade800,
                  value: viewModel.color,
                  items: const [
                    DropdownMenuItem(
                      child: Text("hsv"),
                      value: "hsv",
                    ),
                    DropdownMenuItem(
                      child: Text("gray"),
                      value: "gray",
                    ),
                    DropdownMenuItem(
                      child: Text("lab"),
                      value: "lab",
                    ),
                  ],
                  onChanged: (value) {
                    viewModel.updateColor(value!);
                  }),
            );
          }),
          const SizedBox(height: 10),
          Consumer<HomeScreenViewModel>(builder: (context, viewModel, _) {
            return Button(
                isProcessing: viewModel.isUploading,
                title: "Proceed >",
                function: () async {
                  final pdf = pw.Document();
                  viewModel.toggleProcessing();
                  await viewModel.uploadAllImages();
                  Directory? appDocDir = await getExternalStorageDirectory();
                  String path = appDocDir!.path;

                  for (int i = 0; i < viewModel.imageURLs.length; i++) {
                    var url = viewModel.imageURLs[i];
                    log(url);
                    var color = viewModel.color;
                    
                    var colorurl =
                        "http://NachiketJoshi.pythonanywhere.com/color?image=$url&color=$color&name=${viewModel.currentPDFName}.jpg";
                        log(colorurl);
                    var response = await http.get(Uri.parse(colorurl));
                    log(response.body);
  var res = const Base64Decoder().convert(response.body);
                    final ximage = pw.MemoryImage(
                      res,
                    );
                    pdf.addPage(pw.Page(build: (pw.Context context) {
                      return pw.Center(
                        child: pw.Image(ximage),
                      );
                    }));
                  }
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
                        "Your images have been colored and the pdf has been saved as ${viewModel.currentPDFName}.pdf",
                        "Close and Go Back");
                  } catch (e) {
                    viewModel.toggleProcessing();
                    _showDialog(
                        context,
                        "Result",
                        "Something went wrong. Please try again",
                        "Close and Try Again");
                  }
                  
                });
          }),
        ],
      ),
    );
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
