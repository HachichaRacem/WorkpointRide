import 'package:shared_preferences/shared_preferences.dart';

class sharedpreferences {
  static dynamic lat, lng;

  //For Latitude

  static Future<void> setlat(double cu_lat) async {
    final prefs = await SharedPreferences.getInstance();
    if (cu_lat != null) {
      await prefs.setDouble("lat", cu_lat);
    }
  }

  static Future<dynamic?> getlat() async {
    print("Getting lat ${lat}");
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble("lat");
  }

  //For longitude

  static Future<void> setlng(double cu_lng) async {
    final prefs = await SharedPreferences.getInstance();
    print("lat is ${cu_lng}");
    if (cu_lng != null) {
      await prefs.setDouble("lng", cu_lng);
    }
  }

  static Future<dynamic?> getlng() async {
    print("Getting lng ${lng}");
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble("lng");
  }

  //For Polylines

  static dynamic poly_lat1, poly_lng1;

  static Future<void> set_poly_lat1(double cu_lat) async {
    final prefs = await SharedPreferences.getInstance();
    if (cu_lat != null) {
      await prefs.setDouble("poly_lat1", cu_lat);
    }
  }

  static Future<dynamic?> get_poly_lat1() async {
    print("Getting poly_lat1 ${poly_lat1}");
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble("poly_lat1");
  }

  static Future<void> set_poly_lng1(double cu_lat) async {
    final prefs = await SharedPreferences.getInstance();
    if (cu_lat != null) {
      await prefs.setDouble("poly_lng1", cu_lat);
    }
  }

  static Future<dynamic?> get_poly_lng1() async {
    print("Getting poly_lng1 ${poly_lng1}");
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble("poly_lng1");
  }

  //For Polylines lat

  static dynamic poly_lat2, poly_lng2;

  static Future<void> set_poly_lat2(double cu_lat) async {
    final prefs = await SharedPreferences.getInstance();
    if (cu_lat != null) {
      await prefs.setDouble("poly_lat2", cu_lat);
    }
  }

  static Future<dynamic?> get_poly_lat2() async {
    print("Getting poly_lat2 ${poly_lat2}");
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble("poly_lat2");
  }

  static Future<void> set_poly_lng2(double cu_lat) async {
    final prefs = await SharedPreferences.getInstance();
    if (cu_lat != null) {
      await prefs.setDouble("poly_lng2", cu_lat);
    }
  }

  static Future<dynamic?> get_poly_lng2() async {
    print("Getting poly_lng2 ${poly_lng2}");
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble("poly_lng2");
  }

  //For passenger polylines

  //For Polylines lat1 & lng1

  static dynamic pass_poly_lat1, pass_poly_lng1;

  static Future<void> set_pass_poly_lat1(double cu_lat) async {
    final prefs = await SharedPreferences.getInstance();
    if (cu_lat != null) {
      await prefs.setDouble("pass_poly_lat1", cu_lat);
    }
  }

  static Future<dynamic?> get_pass_poly_lat1() async {
    print("Getting pass_poly_lat1 ${pass_poly_lat1}");
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble("pass_poly_lat1");
  }

  static Future<void> set_pass_poly_lng1(double cu_lat) async {
    print("Before setting lng1 ${poly_lng1}");
    final prefs = await SharedPreferences.getInstance();
    if (cu_lat != null) {
      await prefs.setDouble("pass_poly_lng1", cu_lat);
    }
    print("After setting poly_lng1 = ${poly_lng1} ");
  }

  static Future<dynamic?> get_pass_poly_lng1() async {
    print("Getting pass_poly_lng1 ${pass_poly_lng1}");
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble("pass_poly_lng1");
  }

  //For Polylines lat

  static dynamic pass_poly_lat2, pass_poly_lng2;

  static Future<void> set_pass_poly_lat2(double cu_lat) async {
    final prefs = await SharedPreferences.getInstance();
    if (cu_lat != null) {
      await prefs.setDouble("pass_poly_lat2", cu_lat);
    }
  }

  static Future<dynamic?> get_pass_poly_lat2() async {
    print("Getting pass_poly_lat2 ${pass_poly_lat2}");
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble("pass_poly_lat2");
  }

  static Future<void> set_pass_poly_lng2(double cu_lat) async {
    final prefs = await SharedPreferences.getInstance();
    if (cu_lat != null) {
      await prefs.setDouble("pass_poly_lng2", cu_lat);
    }
  }

  static Future<dynamic?> get_pass_poly_lng2() async {
    print("Getting pass_poly_lng2 ${pass_poly_lng2}");
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble("pass_poly_lng2");
  }
}
