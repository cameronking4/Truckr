// To parse this JSON data, do
//
//     final drawPathLatLngModel = drawPathLatLngModelFromJson(jsonString);

import 'dart:convert';

DrawPathLatLngModel drawPathLatLngModelFromJson(String str) => DrawPathLatLngModel.fromJson(json.decode(str));

String drawPathLatLngModelToJson(DrawPathLatLngModel data) => json.encode(data.toJson());

class DrawPathLatLngModel {
  DrawPathLatLngModel({
    required this.snappedPoints,
  });

  List<SnappedPoint> snappedPoints;

  factory DrawPathLatLngModel.fromJson(Map<String, dynamic> json) => DrawPathLatLngModel(
    snappedPoints: List<SnappedPoint>.from(json["snappedPoints"].map((x) => SnappedPoint.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "snappedPoints": List<dynamic>.from(snappedPoints.map((x) => x.toJson())),
  };
}

class SnappedPoint {
  SnappedPoint({
    required this.location,
    // required this.originalIndex,
    // required this.placeId,
  });

  Location location;
  // int originalIndex;
  // String placeId;

  factory SnappedPoint.fromJson(Map<String, dynamic> json) => SnappedPoint(
    location: Location.fromJson(json["location"]),
    // originalIndex: json["originalIndex"] == null ? null : json["originalIndex"],
    // placeId: json["placeId"],
  );

  Map<String, dynamic> toJson() => {
    "location": location.toJson(),
    // "originalIndex": originalIndex == null ? null : originalIndex,
    // "placeId": placeId,
  };
}

class Location {
  Location({
    required this.latitude,
    required this.longitude,
  });

  double latitude;
  double longitude;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
  };
}
