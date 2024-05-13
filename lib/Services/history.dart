import 'package:dio/dio.dart';
import 'package:osmflutter/constant/url.dart';

class HistoryService {
  Dio dio = Dio(BaseOptions(baseUrl: link.url));

  Future<Response> getHistoryByUser(String userID) async {
    try {
      return await dio.get("api/history/$userID");
    } on DioException catch (e) {
      print(e.response?.data);
      print(e.response?.headers);
      print(e.response?.requestOptions);
      return e.response!;
    }
  }
}
