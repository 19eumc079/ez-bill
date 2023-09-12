import 'package:flutter/material.dart';

class InvoiceProvider extends ChangeNotifier {
  List<Map<String, dynamic>> invoiceItems = [];
  void addItem(Map<String, dynamic> item) {
    invoiceItems.add(item);
    notifyListeners();
  }
}
