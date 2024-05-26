import 'package:dio/dio.dart';
import 'package:osmflutter/constant/url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  Dio dio = Dio(BaseOptions(baseUrl: link.url));
  late Response response;

  Future<Response> getProfile(String id) async {
    try {
      final SharedPreferences _prefs = await SharedPreferences.getInstance();
      String? token = _prefs.getString('token');
      if (token != null) {
        dio.options.headers["Authorization"] = token;
      }
      return await dio.get("api/users/$id");
    } on DioException catch (e) {
      print(e.response?.data);
      print(e.response?.headers);
      print(e.response?.requestOptions);
      return e.response!;
    }
  }
}
