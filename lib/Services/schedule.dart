import 'package:dio/dio.dart';
import 'package:osmflutter/constant/url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class scheduleServices {
  Dio dio = Dio(BaseOptions(baseUrl: link.url));
  late Response response;

  Future<Response> getAllSchedules() async {
    try {
      final SharedPreferences _prefs = await SharedPreferences.getInstance();

      String? token = _prefs.getString('token');
      if (token != null) {
        dio.options.headers["Authorization"] = "$token";
      }
      return await dio.get("api/schedules");
    } on DioException catch (e) {
      print(e.response?.data);
      print(e.response?.headers);
      print(e.response?.requestOptions);
      return e.response!;
    }
  }

  Future<Response> deleteScheduleByID(String id) async {
    try {
      final SharedPreferences _prefs = await SharedPreferences.getInstance();

      String? token = _prefs.getString('token');
      if (token != null) {
        dio.options.headers["Authorization"] = "$token";
      }
      return await dio.delete("api/schedules/deleteScheduleByID/$id");
    } on DioException catch (e) {
      print(e.response?.data);
      print(e.response?.headers);
      print(e.response?.requestOptions);
      return e.response!;
    }
  }

  Future<Response> getScheduleReservationsByDate(
      String date, String userID) async {
    try {
      final SharedPreferences _prefs = await SharedPreferences.getInstance();

      String? token = _prefs.getString('token');
      if (token != null) {
        dio.options.headers["Authorization"] = "$token";
      }
      print("[getScheduleReservationsByDate] date: $date, userID: $userID");
      return await dio.get("api/schedules/schedules-with-date/$date/$userID");
    } on DioException catch (e) {
      print(e.response?.data);
      print(e.response?.headers);
      print(e.response?.requestOptions);
      return e.response!;
    }
  }

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
    print(" routeId ${routeId}");

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
      final SharedPreferences _prefs = await SharedPreferences.getInstance();

      String? token = _prefs.getString('token');
      if (token != null) {
        dio.options.headers["Authorization"] = "$token";
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
