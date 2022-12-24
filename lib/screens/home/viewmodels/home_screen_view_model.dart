import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreenViewModel extends ChangeNotifier {
  List _images = [];
  String _currentPDFName = "";
  bool _isProcessing = false;

  List get images => _images;
  String get currentPDFName => _currentPDFName;
  bool get isProcessing => _isProcessing;

  Future addImage(XFile ximage) async {
    final image = ximage.path;
    // final bytes = await File(path).readAsBytes();
    // final image = await decodeImageFromList(bytes);
    _images.add(image);
    notifyListeners();
  }

  void updateCurrentPDFName(String name) {
    _currentPDFName = name;
    notifyListeners();
  }

  void toggle() {
    _isProcessing = !_isProcessing;
    notifyListeners();
  }

  void cleanReset() {
    _images.clear();
    _currentPDFName = "";
    _isProcessing = false;
    notifyListeners();
  }
}
