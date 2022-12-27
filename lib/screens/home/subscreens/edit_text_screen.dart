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
import '../components/show_dialog.dart';

class EditTextScreen extends StatelessWidget {
  final bool translate;

  const EditTextScreen(this.translate, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenViewModel>(builder: (context, viewModel, _) {
      return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  Directory? appDocDir = await getExternalStorageDirectory();
                  String path = appDocDir!.path;
                  final pdf = pw.Document();
                  pdf.addPage(pw.Page(build: (pw.Context context) {
                    return pw.Center(
                      child: pw.Text(translate
                          ? viewModel.translatedText
                          : viewModel.ocrText),
                    );
                  }));

                  try {
                    final file = File("$path/${viewModel.currentPDFName}.pdf");
                    var status = await Permission.storage.status;
                    if (!status.isGranted) {
                      await Permission.storage.request();
                    }
                    await file.writeAsBytes(await pdf.save());

                    // ignore: use_build_context_synchronously
                    showDialogBox(
                        context,
                        "Result",
                        "Your translated doc has been saved as ${viewModel.currentPDFName}.pdf",
                        "Close and Go Back");
                  } catch (e) {
                    showDialogBox(
                        context,
                        "Result",
                        "Something went wrong. Please try again",
                        "Close and Try Again");
                  }
                },
                icon: Icon(Icons.save)),
          ],
        ),
        body: SingleChildScrollView(
          child: TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 99999,
            initialValue:
                translate ? viewModel.translatedText : viewModel.ocrText,
            onChanged: (value) {
              translate
                  ? viewModel.updateText(value)
                  : viewModel.updateEditText(value);
            },
          ),
        ),
      ));
    });
  }
}
