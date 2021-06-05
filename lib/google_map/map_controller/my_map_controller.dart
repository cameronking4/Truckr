import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/api_provider/ApiProvider.dart';
import 'package:flutter_app/google_map/model/DirectionPathModel.dart';
import 'package:flutter_app/google_map/model/LatLngDistance.dart';
import 'package:flutter_app/google_map/model/drawPathLatLngModel.dart';
import 'package:flutter_app/google_map/model/fetchLatLngModel.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MyMapController extends GetxController {
  // api provider for api implemenatation

  final ApiProvider apiProvider = ApiProvider();
  var selectedIndexToOpenMap = 0.obs;

  // Initial location of the Map view
  var initialLocation = CameraPosition(target: LatLng(0.0, 0.0)).obs;

  // For controlling the view of the Map
  late GoogleMapController mapController;

  // for marker ----------  ---
  Set<Marker> markers = Set<Marker>().obs;

  // for path drawing -----------------
  late PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};

  //location list
  List<String> locationList = <String>[].obs;

  // fetch from api
  List<String> latLngList = <String>[].obs;
  var index = 0.obs;
  var path = ''.obs;
  var check = true.obs;
  var showDialog = false.obs;
  var googleMapShowCheck = false.obs;

  final getStorage = GetStorage();
  List<String> dataList = <String>[].obs;
  List<LatLngDistance> sortedLatLngList = <LatLngDistance>[].obs;
  List<double> markerColorList = <double>[].obs;
  List<Color> pagerColorList = <Color>[].obs;

  var colorIndex = 0.obs;
  RxDouble updateLat = 0.0.obs;
  RxDouble updateLng = 0.0.obs;
  var selectedData = ''.obs;
  var selectedAddress = ''.obs;
  var barcodeItem = ''.obs;
  var lastScanItem = ''.obs;
  var seqNoItem = ''.obs;
  var nameItem = ''.obs;
  var addressItem = ''.obs;
  var wayPoints = ''.obs;

  late Timer _timer;
  late Position currentLocation;

  @override
  onInit() async {
    super.onInit();
    creatRandomMarker();
    currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var value = getStorage.read('csvData');
    var items = value[0].toString().split('\n');
    for (var i = 0; i < items.length; i++) {
      var item = items[i];
      if (item.contains('\"')) {
        var data = item.split('\"');
        locationList.add(data[1]);
        dataList.add(data[0]);
      }
    }
    fetchLatLngFromApi();
  }

  void fetchLatLngFromApi() {
    apiProvider.fetchLatLngFromApi(locationList[index.value]).then((value) {
      var data = fetchLatLngModelFromJson(value);
      latLngList.add(
          '${data.results[0].geometry.location.lat.toStringAsFixed(5)},${data
              .results[0].geometry.location.lng.toStringAsFixed(5)}');
      index++;
      if (index.value < locationList.length) {
        fetchLatLngFromApi();
      } else {
        sortingLatLngList();
        implementDirectionApi();
      }
    });
  }

  Future<void> openMap() async {
    var latitude =
    double.parse(sortedLatLngList[selectedIndexToOpenMap.value].lat);
    var longitude =
    double.parse(sortedLatLngList[selectedIndexToOpenMap.value].lng);

    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  void showMarker(List<LatLngDistance> latLngList) {
    updateLat.value = double.parse(latLngList[0].lat);
    updateLng.value = double.parse(latLngList[0].lng);
    for (var i = 0; i < latLngList.length; i++) {
      // var location = latLngList[i].split(',');
      var lat = double.parse(latLngList[i].lat);
      var lng = double.parse(latLngList[i].lng);
      Marker marker = Marker(
        markerId: MarkerId('$i'),
        position: LatLng(
          lat,
          lng,
        ),
        onTap: () {
          // selectedAddress.value = locationList[i];
          // selectedData.value = dataList[i];
          showDialog.value = true;
          selectedData.value = latLngList[i].description;
          // getDataForDialog(i, sortedLatLngList[i]);
        },
        icon: BitmapDescriptor.defaultMarkerWithHue(markerColorList[i]),
      );
      markers.add(marker);
    }
  }

  setDifferentMarker(int i, int length) {
    if (i == 0) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta);
    } else if (i == length - 1) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    } else {
      return BitmapDescriptor.defaultMarker;
    }
  }

  void updateLocation() {
    _timer = Timer(
      Duration(milliseconds: 1000),
          () {
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(updateLat.value, updateLng.value),
              zoom: 12.0,
            ),
          ),
        );
      },
    );
  }

  createPolylines() async {
    googleMapShowCheck.value = true;
    // for (var i = 0; i < snappedPoints.length; i++) {
    //   polylineCoordinates.add(LatLng(snappedPoints[i].location.latitude,
    //       snappedPoints[i].location.longitude));
    // }

    PolylineId id = PolylineId('poly');
    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );

    // Adding the polyline to the map
    polylines[id] = polyline;
  }

  void getDataForDialog(int i, String selectedAddress) {
    // var data='';
    // var item = selectedData;
    // barcodeItem.value = item.split(' ')[0];
    // var item2 = item.replaceAll(barcodeItem.value, '').trim();
    // lastScanItem.value = item2.split(' ')[0];
    // var item3 = item2.replaceAll(lastScanItem.value, '').trim();
    // seqNoItem.value = item3.split(' ')[0];
    // var item4 = item3.replaceAll(seqNoItem.value, '').trim();
    // data = item4.split(' ')[0];
    // var item5 = item4.replaceAll(data, '').trim();
    // nameItem.value = data.;
    // addressItem.value = selectedAddress;
  }

  Future<void> sortingLatLngList() async {
    var currentLoc = latLngList[0];

    for (var i = 0; i < latLngList.length; i++) {
      var distanceFromCurrent = calculateDistance(
          double.parse(currentLoc.split(',')[0]),
          double.parse(currentLoc.split(',')[1]),
          double.parse(latLngList[i].split(',')[0]),
          double.parse(latLngList[i].split(',')[1]));
      sortedLatLngList.add(LatLngDistance(latLngList[i].split(',')[0],
          latLngList[i].split(',')[1], distanceFromCurrent,
          dataList[i] + ' ' + locationList[i]));
    }
    sortingListForPath(sortedLatLngList);
  }

  void implementDirectionApi() {
    var index = 0;
    var wayPoints = ''.obs;
    for (var i = 1; i <= sortedLatLngList.length; i++) {
      if (i % 24 == 0 && i != 0) {
        // hit the direction apis
        var origin =
            '${sortedLatLngList[(i - 24)].lat},${sortedLatLngList[i - 24].lng}';
        var destination =
            '${sortedLatLngList[i].lat},${sortedLatLngList[i].lng}';
        apiProvider
            .fetchPathByDistance(origin, destination, wayPoints.value)
            .then((value) {
          var repon = directionPathModelFromJson(value);
          repon.routes[0].legs[0].steps.forEach((element) {
            polylineCoordinates.add(
                LatLng(element.startLocation.lat, element.startLocation.lng));
            polylineCoordinates
                .add(LatLng(element.endLocation.lat, element.endLocation.lng));
          });
        });
        index++;
        wayPoints.value = '';
      } else if (sortedLatLngList.length == i) {
        var origin =
            '${sortedLatLngList[index * 24].lat},${sortedLatLngList[index * 24]
            .lng}';
        var destination =
            '${sortedLatLngList[sortedLatLngList.length - 1]
            .lat},${sortedLatLngList[sortedLatLngList.length - 1].lng}';
        apiProvider
            .fetchPathByDistance(origin, destination, wayPoints.value)
            .then((value) {
          var repon = directionPathModelFromJson(value);
          repon.routes[0].legs[0].steps.forEach((element) {
            polylineCoordinates.add(
                LatLng(element.startLocation.lat, element.startLocation.lng));
            polylineCoordinates
                .add(LatLng(element.endLocation.lat, element.endLocation.lng));
          });
          showMarker(sortedLatLngList);
          _timer = Timer(Duration(milliseconds: 2000), () {
            createPolylines();
          });
        });
      } else {
        if (wayPoints.value == '') {
          wayPoints.value =
          'via:${sortedLatLngList[i].lat}%2C${sortedLatLngList[i].lng}';
        } else {
          wayPoints.value =
          '${wayPoints.value}%7Cvia:${sortedLatLngList[i]
              .lat}%2C${sortedLatLngList[i].lng}';
        }
      }
    }
  }

  void showSelectedLOcation(index) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(double.parse(sortedLatLngList[index].lat),
              double.parse(sortedLatLngList[index].lng)),
          zoom: 20.0,
        ),
      ),
    );
  }

  void creatRandomMarker() {
    for (var i = 0; i < 100; i++) {
      switch (colorIndex.value) {
        case 0 :
          {
            markerColorList.add(BitmapDescriptor.hueRed);
            pagerColorList.add(Colors.red[900]!);
            colorIndex.value++;
          }
          break;
        case 1 :
          {
            markerColorList.add(BitmapDescriptor.hueOrange);
            pagerColorList.add(Colors.orange);
            colorIndex.value++;
          }
          break;
        case 2 :
          {
            markerColorList.add(BitmapDescriptor.hueYellow);
            pagerColorList.add(Colors.yellowAccent);
            colorIndex.value++;
          }
          break;
        case 3 :
          {
            markerColorList.add(BitmapDescriptor.hueGreen);
            pagerColorList.add(Colors.green);
            colorIndex.value++;
          }
          break;
        case 4 :
          {
            markerColorList.add(BitmapDescriptor.hueCyan);
            pagerColorList.add(Colors.lightBlue[200]!);
            colorIndex.value++;
          }
          break;
        case 5 :
          {
            markerColorList.add(BitmapDescriptor.hueAzure);
            pagerColorList.add(Colors.indigo[900]!);
            colorIndex.value++;
          }
          break;
        case 6 :
          {
            markerColorList.add(BitmapDescriptor.hueBlue);
            pagerColorList.add(Colors.indigo[900]!);
            colorIndex.value++;
          }
          break;
        case 7 :
          {
            markerColorList.add(BitmapDescriptor.hueViolet);
            pagerColorList.add(Colors.deepPurple);
            colorIndex.value++;
          }
          break;
        case 8 :
          {
            markerColorList.add(BitmapDescriptor.hueMagenta);
            pagerColorList.add(Colors.purpleAccent);
            colorIndex.value++;
          }
          break;
        case 9 :
          {
            markerColorList.add(BitmapDescriptor.hueRose);
            pagerColorList.add(Colors.pink);
            colorIndex.value = 0;
          }
      }
    }
  }

  void sortingListForPath(List<LatLngDistance> sortedLatLngList) {
    Comparator<LatLngDistance> priceComparator =
        (a, b) => a.distance.compareTo(b.distance);
    sortedLatLngList.sort(priceComparator);
    sortedLatLngList.forEach((element) {
      print(element);
    });
  }

  void swap(List list, int i) {
    int temp = list[i];
    list[i] = list[i + 1];
    list[i + 1] = temp;
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}