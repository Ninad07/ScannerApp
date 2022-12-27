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

class TranslateScreen extends StatelessWidget {
  const TranslateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Translate", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Select Language",
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
                  value: viewModel.language,
                  items: const [
                    DropdownMenuItem(
                      child: Text("Hindi"),
                      value: "Hindi",
                    ),
                    DropdownMenuItem(
                      child: Text("Tamil"),
                      value: "Tamil",
                    ),
                    DropdownMenuItem(
                      child: Text("Telugu"),
                      value: "Telugu",
                    ),
                    DropdownMenuItem(
                      child: Text("Gujarati"),
                      value: "Gujarati",
                    ),
                    DropdownMenuItem(
                      child: Text("Bengali"),
                      value: "Bengali",
                    ),
                    DropdownMenuItem(
                      child: Text("Kannada"),
                      value: "Kannada",
                    ),
                  ],
                  onChanged: (value) {
                    viewModel.updateLanguage(value!);
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
                  viewModel.toggleProcessing(true);
                  await viewModel.uploadAllImages();
                  Directory? appDocDir = await getExternalStorageDirectory();
                  String path = appDocDir!.path;

                  for (int i = 0; i < viewModel.imageURLs.length; i++) {
                    var url = viewModel.imageURLs[i];
                    log(url);
                    var lang = viewModel.langmap[viewModel.language];
                    log(lang);

                    var texturl =
                        "http://NachiketJoshi.pythonanywhere.com/translate?image=$url&language=$lang";
                    log(texturl);
                    var response = await http.get(Uri.parse(texturl));
                    log(response.body);
                   
                    viewModel.appendText("${response.body}\n");
                  }
                  viewModel.toggleProcessing(false);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return EditTextScreen(viewModel.translatedText);
                  }));
                  
                });
          }),
        ],
      ),
    );
  }

  
}
