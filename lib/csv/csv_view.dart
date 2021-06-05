import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/csv_controller.dart';

class CsvView extends StatelessWidget {
  final CsvController _csvController = Get.put(CsvController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: MaterialButton(
            onPressed: () {
              _csvController.loadCsvFromStorage();
            },
            color: Colors.cyanAccent,
            child: Text("Load CSV file from phone storage"),
          ),
        ),
      ),
    );
  }
}
