import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/google_map/dialog/dialog_box.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../map_controller/my_map_controller.dart';

class MyMapView extends StatelessWidget {
  final MyMapController _myMapController = Get.put(MyMapController());

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Obx(() => _myMapController.googleMapShowCheck.value
          ? Container(
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        GoogleMap(
                          polylines: Set<Polyline>.of(
                              _myMapController.polylines.values),
                          markers: Set<Marker>.from(_myMapController.markers),
                          mapType: MapType.normal,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          zoomGesturesEnabled: true,
                          zoomControlsEnabled: false,
                          mapToolbarEnabled: true,
                          buildingsEnabled: true,
                          trafficEnabled: true,
                          tiltGesturesEnabled: true,
                          onMapCreated: (GoogleMapController controller) {
                            _myMapController.mapController = controller;
                            _myMapController.updateLocation();
                          },
                          initialCameraPosition:
                              _myMapController.initialLocation.value,
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(20, 40, 20, 20),
                            child: ClipOval(
                              child: Material(
                                color: Colors.orange[100], // button color
                                child: InkWell(
                                  splashColor: Colors.orange, // inkwell color
                                  child: SizedBox(
                                    width: 56,
                                    height: 56,
                                    child: Icon(Icons.my_location),
                                  ),
                                  onTap: () {
                                    // Zoom in action
                                    _myMapController.updateLocation();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                            child: ClipOval(
                              child: Material(
                                color: Colors.orange[100], // button color
                                child: InkWell(
                                  splashColor: Colors.orange, // inkwell color
                                  child: SizedBox(
                                    width: 56,
                                    height: 56,
                                    child: Icon(Icons.open_in_new_sharp),
                                  ),
                                  onTap: () {
                                    _myMapController.openMap();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),

                        Obx(() => _myMapController.showDialog.value
                            ? ShowDialog()
                            : Container()),
                      ],
                    ),
                  ),
                  listItemView(),
                ],
              ),
            )
          : Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )),
    );
  }

  listItemView() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          color: Colors.white),
      height: Get.height / 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            height: 3,
            width: 40,
            margin: EdgeInsets.only(left: Get.width / 2.2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
                color: Colors.grey[400]),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: PageView.builder(
                scrollDirection: Axis.horizontal,
                onPageChanged: (value){
                  _myMapController.showSelectedLOcation(value);
                  _myMapController.selectedIndexToOpenMap.value = value;
                  // _myMapController.selectedData.value = _myMapController.sortedLatLngList[value].description;
                },
                itemCount: _myMapController.sortedLatLngList.length,
                itemBuilder: (BuildContext ctx, index) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(40, 20, 40, 20),
                    height: 100,
                    width: 100,
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                    decoration: BoxDecoration(
                        color: _myMapController.pagerColorList[index],
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Expanded(
                            child:
                            Text( "Stop #" +  (index + 1).toString() + "/" + (_myMapController.sortedLatLngList.length).toString()+ "  "+
                              (_myMapController.sortedLatLngList[index].description).replaceAll(' ', '  ')+ "  " +( index > 0 ? (_myMapController.sortedLatLngList[index].distance).toStringAsFixed(2) + " miles away from last stop" : ""),
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
