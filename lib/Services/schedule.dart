import 'package:dio/dio.dart';
import 'package:osmflutter/constant/url.dart';

class scheduleServices {
  late Response response;
  Dio dio = Dio(BaseOptions(baseUrl: link.url));

  Future<Response<dynamic>> addSchedule({
    required String user,
    required DateTime startTime,
    required List<DateTime> scheduledDate,
    required int availablePlaces,
    String? routeId,
    double? startPointLat,
    double? startPointLang,
    double? endPointLat,
    double? endPointLang,
    int? duration,
    double? distance,
    String? type,
    List<List<dynamic>>? polyline,
  }) async {
    print(" startTime${startTime}");
    print(" scheduledDate${scheduledDate}");
    print(" availablePlaces${availablePlaces}");
    print(" user${user}");

    try {
      var formattedScheduledDate =
          scheduledDate.map((date) => date.toString()).toList();

      var requestData = {
        'user': user,
        'startTime': startTime.toString(),
        "scheduledDate": formattedScheduledDate,
        "availablePlaces": availablePlaces,
      };

      if (routeId != null) {
        requestData["routeId"] = routeId;
      } else if (startPointLat != null &&
          startPointLang != null &&
          endPointLat != null &&
          endPointLang != null &&
          duration != null &&
          distance != null &&
          type != null &&
          polyline != null) {
        requestData["startPoint"] = {
          "type": "Point",
          "coordinates": [startPointLat, startPointLang]
        };
        requestData["endPoint"] = {
          "type": "Point",
          "coordinates": [endPointLat, endPointLang]
        };
        requestData["duration"] = duration;
        requestData["distance"] = distance;
        requestData["routeType"] = type;
        requestData["polyline"] = polyline;
      }

      var response = await dio.post(
        "api/schedules/add",
        data: requestData,
        //    options: Options(headers: {"Refresh-Token": "refresh-token"})
      );

      return response;
    } on DioException catch (e) {
      print(e);

      if (e.response != null) {
        print(e.response?.data);
        print(e.response?.headers);
        print(e.response?.requestOptions);
      } else {
        print(e.requestOptions);
        print(e.message);
      }
      return e.response!;
    }
  }
}
