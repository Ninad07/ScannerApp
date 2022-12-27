import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:scanner_app/screens/home/components/button.dart';
import 'package:scanner_app/screens/home/subscreens/color.dart';
import 'package:scanner_app/screens/home/subscreens/translate.dart';
import 'package:scanner_app/screens/home/viewmodels/home_screen_view_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;

import '../components/show_dialog.dart';
import 'edit_text_screen.dart';

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
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
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
                    viewModel.toggle(true);
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
                      viewModel.toggle(false);
                      // ignore: use_build_context_synchronously
                      showDialogBox(
                          context,
                          "Result",
                          "Your pdf has been saved as ${viewModel.currentPDFName}.pdf",
                          "Close and Go Back");
                    } catch (e) {
                      viewModel.toggle(false);
                      showDialogBox(
                          context,
                          "Result",
                          "Something went wrong. Please try again",
                          "Close and Try Again");
                    }
                  }),
              const SizedBox(height: 10),
              Button(
                  isProcessing: viewModel.isUploading,
                  title: "Auto Crop and Save",
                  function: () async {
                    viewModel.toggleProcessing(true);
                    await viewModel.uploadAllImages();
                    Directory? appDocDir = await getExternalStorageDirectory();
                    String path = appDocDir!.path;
        
                    for (int i = 0; i < viewModel.imageURLs.length; i++) {
                      var url = viewModel.imageURLs[i];
                      var image =
                          "http://NachiketJoshi.pythonanywhere.com/crop?image=$url&name=${viewModel.images[i].name}";
                      var response = await http.get(Uri.parse(image));
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
                      viewModel.toggleProcessing(false);
                      // ignore: use_build_context_synchronously
                      showDialogBox(
                          context,
                          "Result",
                          "Your images have been auto cropped and the pdf has been saved as ${viewModel.currentPDFName}.pdf",
                          "Close and Go Back");
                    } catch (e) {
                      viewModel.toggleProcessing(false);
                      showDialogBox(
                          context,
                          "Result",
                          "Something went wrong. Please try again",
                          "Close and Try Again");
                    }
                  }),
              const SizedBox(height: 10),
              Button(
                  isProcessing: viewModel.isEditing,
                  title: "Extract and Edit Text",
                  function: () async {
                    viewModel.updateText("");
                    final pdf = pw.Document();
                    viewModel.toggleProcessing2(true);
                    await viewModel.uploadAllImages();
        
                    for (int i = 0; i < viewModel.imageURLs.length; i++) {
                      var url = viewModel.imageURLs[i];
        
                      var texturl =
                          "http://NachiketJoshi.pythonanywhere.com/ocr?image=$url";
                      log(texturl);
                      var response = await http.get(Uri.parse(texturl));
                      log(response.body);
        
                      viewModel.appendEditText("${response.body}\n");
                    }
                    viewModel.toggleProcessing2(false);
        
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return EditTextScreen(false);
                    }));
                  }),
              const SizedBox(height: 10),
              Button(
                  isProcessing: viewModel.isUploading,
                  title: "Translate and Save",
                  function: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => TranslateScreen())));
                  }),
              const SizedBox(height: 10),
              Button(
                  isProcessing: viewModel.isUploading,
                  title: "Change Color and Save",
                  function: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => ChangeColorScreen())));
                  }),
              const SizedBox(height: 10),
              Button(
                  title: "< Back to images section",
                  function: () {
                    Navigator.of(context).pop();
                  })
            ],
          ),
        );
      }),
    ));
  }
}
