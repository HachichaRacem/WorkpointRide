import 'package:dio/dio.dart';
import 'package:osmflutter/constant/url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Schedule {
  Dio dio = Dio(BaseOptions(baseUrl: link.url));

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

  Future<Response> getScheduleReservationsByDate(
      String date, String userID) async {
    try {
      print("[getScheduleReservationsByDate] date: $date, userID: $userID");
      return await dio.get("api/schedules/schedules-with-date/$date/$userID");
    } on DioException catch (e) {
      print(e.response?.data);
      print(e.response?.headers);
      print(e.response?.requestOptions);
      return e.response!;
    }
  }
}
