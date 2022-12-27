import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:github/github.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class HomeScreenViewModel extends ChangeNotifier {
  List _images = [];
  List _imageURLs = [];
  String _currentPDFName = "";
  bool _isProcessing = false;
  bool _isUploading = false;
  String _language = "Hindi";
  String translatedText = "";
  String ocrText = "";
  String color = "hsv";
  bool isEditing = false;
  Map langmap = {
    "Hindi": "hi",
    "Tamil": "ta",
    "Telugu": "te",
    "Gujarati": "gu",
    "Bengali": "bn",
    "Kannada": "kn",
  };

  List get images => _images;
  List get imageURLs => _imageURLs;
  String get currentPDFName => _currentPDFName;
  bool get isProcessing => _isProcessing;
  bool get isUploading => _isUploading;
  String get language => _language;

  Future addImage(XFile ximage) async {
    // final bytes = await File(path).readAsBytes();
    // final image = await decodeImageFromList(bytes);
    // _images.add(await uploadImageToFirebase(ximage));
    _images.add(ximage);
    notifyListeners();
  }

  Future uploadAllImages() async {
    for (var image in _images) {
      _imageURLs.add(await uploadImageToFirebase(image));
    }
    notifyListeners();
  }

  Future uploadImageToFirebase(XFile image) async {
    String fileName = image.name;
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('images/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(File(image.path));
    TaskSnapshot taskSnapshot = await Future.value(uploadTask);
    var url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  void updateCurrentPDFName(String name) {
    _currentPDFName = name;
    notifyListeners();
  }

  void toggle(bool val) {
    _isProcessing = val;
    notifyListeners();
  }

  void toggleProcessing(bool val) {
    _isUploading = val;
    notifyListeners();
  }

  void toggleProcessing2(bool val) {
    isEditing = val;
    notifyListeners();
  }

  void cleanReset() {
    _images.clear();
    _imageURLs.clear();
    _currentPDFName = "";
    _isProcessing = false;
    _isUploading = false;
    isEditing = false;
    translatedText = ocrText = "";
    color = "hsv";
    _language = "Hindi";
    notifyListeners();
  }

  void updateLanguage(String language) {
    _language = language;
    notifyListeners();
  }

  void appendText(String text) {
    translatedText += text;
    notifyListeners();
  }

  void appendEditText(String text) {
    ocrText += text;
    notifyListeners();
  }

  void updateText(String text) {
    translatedText = text;
    notifyListeners();
  }

  void updateEditText(String text) {
    ocrText = text;
    notifyListeners();
  }

  void updateColor(String color) {
    this.color = color;
    notifyListeners();
  }
}
