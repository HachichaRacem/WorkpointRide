import 'package:osmflutter/models/Steps.dart';

class Routes {
  final List<Steps> steps;

  Routes({required this.steps});

  factory Routes.fromJson(Map<String, dynamic> json) {
    return Routes(
      steps: List<Steps>.from(
          json['legs'][0]['steps'].map((step) => Steps.fromJson(step))),
    );
  }
}
