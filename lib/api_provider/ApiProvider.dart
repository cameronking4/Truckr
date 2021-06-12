import 'dart:convert';
import 'package:flutter_app/Constants.dart';
import 'package:get/get.dart';

class ApiProvider extends GetConnect {
  //getting lat and lng url
  var latLngUrl = 'https://maps.googleapis.com/maps/api/geocode/json?';

  // draw path from lat lng url
  // var googlePathUrl = 'https://roads.googleapis.com/v1/snapToRoads?';
  var googlePathUrl = 'https://roads.googleapis.com/v1/nearestRoads?';

  // ditrection of path
  var directionApiUrl = 'https://maps.googleapis.com/maps/api/directions/json?';

  // getting lat and lng from api
  Future<String> fetchLatLngFromApi(String location) async {
    print(location);
    var url = Uri.encodeFull('${latLngUrl}address=$location, CA&key=$googleApiKey');
    print(url);
    final fetchLatLngResponce = await get(url);
    if (fetchLatLngResponce.hasError) {
      Get.snackbar('Error', fetchLatLngResponce.statusText.toString());
      return fetchLatLngResponce.bodyString.toString();
    } else {
      var responce = fetchLatLngResponce.body;
      var result = jsonEncode(responce);
      return result;
    }
  }

  // create path from lat lng Api
  Future<String> fetchGoogleMapPath(String path) async {
    final pathResponce = await get('${googlePathUrl}points=$path&key=$googleApiKey');
    // final pathResponce = await get('${googlePathUrl}path=-35.27801,149.12958|-35.28032,149.12907|-35.28099,149.12929|-35.28144,149.12984|-35.28194,149.13003|-35.28282,149.12956|-35.28302,149.12881|-35.28473,149.12836&interpolate=true&key=$googleApiKey');
    if (pathResponce.hasError) {
      Get.snackbar('Error', pathResponce.statusText.toString());
      return pathResponce.bodyString.toString();
    } else {
      var responce = pathResponce.body;
      var result = jsonEncode(responce);
      return result;
    }
  }

 Future<String> fetchPathByDistance(origin, destination, String wayPoints) async {
    final responce = await get('${directionApiUrl}origin=$origin&destination=$destination&waypoints=optimize:true|$wayPoints&key=$googleApiKey');
    if (responce.hasError) {
      Get.snackbar('Error', responce.statusText.toString());
      return responce.bodyString.toString();
    } else {
      var data = responce.body;
      var result = jsonEncode(data);
      return result;
    }
  }
}
