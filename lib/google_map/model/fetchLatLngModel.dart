// To parse this JSON data, do
//
//     final fetchLatLngModel = fetchLatLngModelFromJson(jsonString);

import 'dart:convert';

FetchLatLngModel fetchLatLngModelFromJson(String str) => FetchLatLngModel.fromJson(json.decode(str));

String fetchLatLngModelToJson(FetchLatLngModel data) => json.encode(data.toJson());

class FetchLatLngModel {
  FetchLatLngModel({
    required this.results,
    required this.status,
  });

  List<Result> results;
  String status;

  factory FetchLatLngModel.fromJson(Map<String, dynamic> json) => FetchLatLngModel(
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
    "status": status,
  };
}

class Result {
  Result({
    // required this.addressComponents,
    // required this.formattedAddress,
    required this.geometry,
    // required this.placeId,
    // required this.plusCode,
    // required this.types,
  });

  // List<AddressComponent> addressComponents;
  // String formattedAddress;
  Geometry geometry;
  // String placeId;
  // PlusCode plusCode;
  // List<String> types;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    // addressComponents: List<AddressComponent>.from(json["address_components"].map((x) => AddressComponent.fromJson(x))),
    // formattedAddress: json["formatted_address"],
    geometry: Geometry.fromJson(json["geometry"]),
    // placeId: json["place_id"],
    // plusCode: PlusCode.fromJson(json["plus_code"]),
    // types: List<String>.from(json["types"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    // "address_components": List<dynamic>.from(addressComponents.map((x) => x.toJson())),
    // "formatted_address": formattedAddress,
    "geometry": geometry.toJson(),
    // "place_id": placeId,
    // "plus_code": plusCode.toJson(),
    // "types": List<dynamic>.from(types.map((x) => x)),
  };
}

class AddressComponent {
  AddressComponent({
    required this.longName,
    required this.shortName,
    required this.types,
  });

  String longName;
  String shortName;
  List<String> types;

  factory AddressComponent.fromJson(Map<String, dynamic> json) => AddressComponent(
    longName: json["long_name"],
    shortName: json["short_name"],
    types: List<String>.from(json["types"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "long_name": longName,
    "short_name": shortName,
    "types": List<dynamic>.from(types.map((x) => x)),
  };
}

class Geometry {
  Geometry({
    required this.location,
    // required this.locationType,
    // required this.viewport,
  });

  Location location;
  // String locationType;
  // Viewport viewport;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    location: Location.fromJson(json["location"]),
    // locationType: json["location_type"],
    // viewport: Viewport.fromJson(json["viewport"]),
  );

  Map<String, dynamic> toJson() => {
    "location": location.toJson(),
    // "location_type": locationType,
    // "viewport": viewport.toJson(),
  };
}

class Location {
  Location({
    required this.lat,
    required this.lng,
  });

  double lat;
  double lng;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    lat: json["lat"].toDouble(),
    lng: json["lng"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
  };
}

// class Viewport {
//   Viewport({
//     required this.northeast,
//     required this.southwest,
//   });
//
//   Location northeast;
//   Location southwest;
//
//   factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
//     northeast: Location.fromJson(json["northeast"]),
//     southwest: Location.fromJson(json["southwest"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "northeast": northeast.toJson(),
//     "southwest": southwest.toJson(),
//   };
// }
//
// class PlusCode {
//   PlusCode({
//     required this.compoundCode,
//     required this.globalCode,
//   });
//
//   String compoundCode;
//   String globalCode;
//
//   factory PlusCode.fromJson(Map<String, dynamic> json) => PlusCode(
//     compoundCode: json["compound_code"],
//     globalCode: json["global_code"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "compound_code": compoundCode,
//     "global_code": globalCode,
//   };
// }
