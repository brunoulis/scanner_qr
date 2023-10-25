import 'package:flutter/material.dart';

class ScannedDataModel with ChangeNotifier {

  // Constructor vacio
  ScannedDataModel();
  List<String> scannedResults = [];

  void addScannedData(String data) {
    scannedResults.add(data);
    notifyListeners();
  }
}