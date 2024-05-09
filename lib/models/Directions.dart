import 'package:osmflutter/models/Routes.dart';

class Directions {
  final List<Routes> routes;

  Directions({required this.routes});

  factory Directions.fromJson(Map<String, dynamic> json) {
    return Directions(
      routes: List<Routes>.from(
          json['routes'].map((route) => Routes.fromJson(route))),
    );
  }
}
