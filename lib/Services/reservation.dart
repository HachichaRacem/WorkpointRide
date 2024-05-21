import 'package:dio/dio.dart';
import 'package:osmflutter/constant/url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Reservation {
  Dio dio = Dio(BaseOptions(baseUrl: link.url));
  late Response response;
  Future<Response?> createReservation(Map data) async {
    try {
      final SharedPreferences _prefs = await SharedPreferences.getInstance();

      String? token = _prefs.getString('token');
      if (token != null) {
        dio.options.headers["Authorization"] = "$token";
      }
      print("dateeeeeeeeeeeeeeeeeeeeeee   ${data["date"]}");

      var reservationData = {
        "schedule": data["schedule"],
        "user": data["user"],
        "pickupTime": data["pickupTime"],
        "pickupLocation": data["pickupLocation"],
      };

      var response = await dio.post("api/reservations/add",
          data: reservationData
          //    options: Options(headers: {"Refresh-Token": "refresh-token"})
          );
      print("dataaa resssss   ${response}");

      return response;
      // final response = await dio.post("api/reservations/add", data: data);
      // print("etesttttttt00000000${response}");
      //
      // return response;
    } on DioException catch (e) {
      print("dataaa resssss   ${e}");

      return e.response;
    }
  }

  Future<Response> getReservations(String userID) async {
    try {
      final SharedPreferences _prefs = await SharedPreferences.getInstance();

      String? token = _prefs.getString('token');
      if (token != null) {
        dio.options.headers["Authorization"] = "$token";
      }
      return await dio.get("api/reservations/$userID");
    } on DioException catch (e) {
      print(e.response?.data);
      print(e.response?.headers);
      print(e.response?.requestOptions);
      return e.response!;
    }
  }

  Future<Response> getReservationsByDate(String userID, String date) async {
    try {
      final SharedPreferences _prefs = await SharedPreferences.getInstance();

      String? token = _prefs.getString('token');
      if (token != null) {
        dio.options.headers["Authorization"] = "$token";
      }
      return await dio
          .get("api/reservations/reservation-by-date/$userID/$date");
    } on DioException catch (e) {
      print(e.response?.data);
      print(e.response?.headers);
      print(e.response?.requestOptions);
      return e.response!;
    }
  }

  Future<Response> deleteReservationByID(String id) async {
    try {
      return await dio.delete("api/reservations/deleteReservationByID/$id");
    } on DioException catch (e) {
      print(e.response?.data);
      print(e.response?.headers);
      print(e.response?.requestOptions);
      return e.response!;
    }
  }
}
