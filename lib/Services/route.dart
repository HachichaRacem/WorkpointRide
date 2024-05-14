import 'package:dio/dio.dart';
import 'package:osmflutter/constant/url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class routeService {
  Dio dio = Dio(BaseOptions(baseUrl: link.url));

  Future<Response> getAllRoutes() async {
    try {
      final SharedPreferences _prefs = await SharedPreferences.getInstance();

      String? token = _prefs.getString('token');
      if (token != null) {
        dio.options.headers["Authorization"] = "$token";
      }
      return await dio.get("api/routes");
    } on DioException catch (e) {
      print(e.response?.data);
      print(e.response?.headers);
      print(e.response?.requestOptions);
      return e.response!;
    }
  }

  Future<Response<dynamic>> getRouteByUser(user) async {
    try {
      print("ddddd${user}");
      final SharedPreferences _prefs = await SharedPreferences.getInstance();

      String? token = _prefs.getString('token');
      if (token != null) {
        dio.options.headers["Authorization"] = "$token";
      }
      var response = await dio.get(
        "api/routes/getByUser/${user}",
      );

      return response;
    } on DioException catch (e) {
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
