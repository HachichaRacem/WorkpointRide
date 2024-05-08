import 'package:dio/dio.dart';
import 'package:osmflutter/constant/url.dart';

class authentication {
  late Response response;
  Dio dio = Dio(BaseOptions(baseUrl: link.url));

  Future<Response<dynamic>> refreshToken() async {
    var response = await dio.post("refreshToken",
        options: Options(headers: {"Refresh-Token": "refresh-token"}));
    return response;
  }

  Future<Response<dynamic>> login(String email, String password) async {
    print("${dio.getUri}");
    try {
      var response = await dio.post("api/users/login",
          data: {'email': email, 'password': password},
          options: Options(headers: {"Refresh-Token": "refresh-token"}));

      return response;
    } on DioException catch (e) {
      print("ERROR: $e");
      if (e.response != null) {
        print(e.response?.data);
        print(e.response?.headers);
        print(e.response?.requestOptions);
      } else {
        print("response: ${e.response}");
        print(e.requestOptions);
        print(e.message);
      }
      return e.response!;
    }
  }
}
