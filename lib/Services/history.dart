import 'package:dio/dio.dart';
import 'package:osmflutter/constant/url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryService {
  Dio dio = Dio(BaseOptions(baseUrl: link.url));

  Future<Response> getHistoryByUser(String userID) async {
    try {
      final SharedPreferences _prefs = await SharedPreferences.getInstance();

      String? token = _prefs.getString('token');
      if (token != null) {
        dio.options.headers["Authorization"] = "$token";
      }
      return await dio.get("api/history/getByUser/$userID");
    } on DioException catch (e) {
      print(e.response?.data);
      print(e.response?.headers);
      print(e.response?.requestOptions);
      return e.response!;
    }
  }
}
