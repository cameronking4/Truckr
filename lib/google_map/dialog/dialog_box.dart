import 'package:flutter/material.dart';
import 'package:flutter_app/google_map/map_controller/my_map_controller.dart';
import 'package:get/get.dart';

import '../../Constants.dart';

class ShowDialog extends StatelessWidget {
  final MyMapController _myMapController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.all(20),
        decoration: roundedBoxDecoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              _myMapController.selectedData.value,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black),
            ),
            SizedBox(
              width: 5,
              height: 40,
            ),
            TextButton(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  'Done',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
              ),
              style: textButtonRoundedStyle,
              onPressed: () {
                _myMapController.showDialog.value = false;
              },
            ),
            SizedBox(
              width: 5,
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
