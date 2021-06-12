import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_app/google_map/map_view/my_map_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CsvController extends GetxController {
  List<String> list = <String>[].obs;
  final getStorage = GetStorage();

  loadCsvFromStorage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['csv'],
      type: FileType.custom,
    );
    String? path = result!.files.first.path;
    var data = loadingCsvData(path!)!.then((value) {
      print(value);
      getStorage.write('csvData', value);
      Get.to(() => MyMapView());
    });
  }

  Future<List<List<dynamic>>>? loadingCsvData(String path) async {
    final csvFile = new File(path).openRead();
    return await csvFile
      .transform(utf8.decoder)
      .transform(
      new CsvToListConverter(),
      )
      .toList();
  }
}
