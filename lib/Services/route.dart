import 'package:dio/dio.dart';
import 'package:osmflutter/constant/url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class routeService {
  late Response response;
  Dio dio = Dio(BaseOptions(baseUrl: link.url));
  SharedPreferences? _prefs;

  Future<Response<dynamic>> getRouteByUser(user) async {
    try {
      print("ddddd${user}");

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
