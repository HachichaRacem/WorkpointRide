import 'package:dio/dio.dart';
import 'package:osmflutter/constant/url.dart';

class Reservation {
  final Dio dio = Dio(BaseOptions(baseUrl: link.url));
  Future<Response> createReservation(Map data) async {
    try {
      final response = await dio.post("api/reservations", data: data);
      return response;
    } on DioException catch (e) {
      print(e.response?.data);
      print(e.response?.headers);
      print(e.response?.requestOptions);
      return e.response!;
    }
  }
}
