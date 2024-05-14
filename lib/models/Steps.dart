import 'package:osmflutter/models/Location.dart';

class Steps {
  final String polyline;
  final Location startLocation;

  Steps({required this.polyline, required this.startLocation});

  factory Steps.fromJson(Map<String, dynamic> json) {
    return Steps(
      polyline: json['polyline']['points'],
      startLocation: Location.fromJson(json['start_location']),
    );
  }
}
