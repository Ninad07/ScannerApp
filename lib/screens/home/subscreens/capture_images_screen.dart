import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:scanner_app/screens/home/subscreens/images_to_pdf.dart';
import 'package:scanner_app/screens/home/viewmodels/home_screen_view_model.dart';

class CaptureImages extends StatefulWidget {
  const CaptureImages({Key? key}) : super(key: key);

  @override
  State<CaptureImages> createState() => _CaptureImagesState();
}

class _CaptureImagesState extends State<CaptureImages> {
  final ImagePicker _imagePicker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Consumer<HomeScreenViewModel>(
            builder: (context, homeScreenViewModel, _) {
          return FloatingActionButton(
            onPressed: () async {
              final image =
                  await _imagePicker.pickImage(source: ImageSource.camera);
              if (image != null) {
                await homeScreenViewModel.addImage(image);
              }
            },
            child: const Icon(
              Icons.camera,
              color: Colors.white,
            ),
          );
        }),
        appBar: AppBar(
          backgroundColor: Colors.grey.shade900,
          title: const Text(
            "Capture Images",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          leading: Consumer<HomeScreenViewModel>(
            
            builder: (context, homeScreenViewModel, _) {
              return IconButton(
                  onPressed: () {
                    homeScreenViewModel.cleanReset();
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back));
            }
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return PDFConversionScreen();
                  }));
                },
                icon: const Icon(
                  Icons.picture_as_pdf,
                  color: Colors.white,
                ))
          ],
        ),
        body: Consumer<HomeScreenViewModel>(
            builder: (context, homeScreenViewModel, _) {
          final images = homeScreenViewModel.images;
          return GridView.builder(
            itemCount: images.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(5),
                child: images.isEmpty
                    ? null
                    : Image.file(
                        File(images[index]),
                        fit: BoxFit.cover,
                      ),
              );
            },
          );
        }),
      ),
    );
  }
}
