import 'package:dio/dio.dart';
import 'package:osmflutter/constant/url.dart';

class Route {
  Dio dio = Dio(BaseOptions(baseUrl: link.url));

  Future<Response> getAllRoutes() async {
    try {
      return await dio.get("api/routes");
    } on DioException catch (e) {
      print(e.response?.data);
      print(e.response?.headers);
      print(e.response?.requestOptions);
      return e.response!;
    }
  }

  Future<Response> getRoutesByUser(String userID) async {
    try {
      final response = await dio.get("api/routes/$userID");
      return response;
    } on DioException catch (e) {
      print(e.response?.data);
      print(e.response?.headers);
      print(e.response?.requestOptions);
      return e.response!;
    }
  }
}
