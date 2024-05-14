import 'package:dio/dio.dart';
import 'package:osmflutter/constant/url.dart';

class Schedule {
  Dio dio = Dio(BaseOptions(baseUrl: link.url));

  Future<Response> getAllSchedules() async {
    try {
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
