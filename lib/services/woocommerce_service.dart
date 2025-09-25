import 'dart:convert';
import 'package:dio/dio.dart';

class WooCommerceService {
  final String baseUrl = "http://192.168.1.98/wordpress-6.8.2/wordpress/wp-json/wc/v3";
  final String consumerKey = "ck_d8e8d05c17ef217d3f493dc1047c11f6e7600505";
  final String consumerSecret = "cs_bab4f950b26eb0508928256f86f75400622b2bb0";

  late Dio _dio;

  WooCommerceService() {
    final String basicAuth =
        "Basic ${base64Encode(utf8.encode("$consumerKey:$consumerSecret"))}";

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          "Authorization": basicAuth,
          "Content-Type": "application/json",
        },
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
  }

  // Register new customer
  Future<Map<String, dynamic>> registerUser(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post(
        "/customers", // ✅ since baseUrl already has /wc/v3
        data: jsonEncode(userData),
      );

      return response.data;
    } on DioException catch (e) {
      return {
        "error": true,
        "message": e.response?.data ?? e.message,
      };
    }
  }

  // Login user (JWT)
  Future<Map<String, dynamic>> loginUser(String username, String password) async {
    try {
      final response = await _dio.post(
        "http://192.168.1.98/wordpress-6.8.2/wordpress/wp-json/jwt-auth/v1/token",
        data: jsonEncode({
          "username": username,
          "password": password,
        }),
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );

      print(response.data);

      return response.data;
    } on DioException catch (e) {

      print(e.response?.data ?? e.message);

      return {
        "error": true,
        "message": e.response?.data ?? e.message,
      };
    }
  }

  // Get customer details by email
  Future<Map<String, dynamic>> getCustomerByEmail(String email) async {
    try {
      final response = await _dio.get(
        "/customers",
        queryParameters: {"email": email},
      );

      if (response.statusCode == 200 && response.data.isNotEmpty) {
        return response.data[0]; // WooCommerce returns a list, pick first
      } else {
        throw Exception("Customer not found");
      }
    } on DioException catch (e) {
      throw Exception("Failed to fetch customer: ${e.response?.data ?? e.message}");
    }
  }

  Future <Map<String,dynamic>> getCustomerById(int id) async {

      try{

        final response = await _dio.get("/customers/$id");

        if(response.statusCode == 200){

          return response.data;
        }
        else{

          throw Exception("Failed to load Customer");
        }
      }on DioException catch (e){

        throw Exception("Dio Error: ${e.response?.data ??e.message}");
      }

  }



  /// Fetch brands
  Future<List<dynamic>> getBrands() async {
    try {
      final response = await _dio.get("/products/brands");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to load brands: ${response.data}");
      }
    } on DioError catch (e) {
      throw Exception("Dio error: ${e.response?.data ?? e.message}");
    }
  }


  /// Fetch catgories
  Future<List<dynamic>> getCategories() async {
    try {
      final response = await _dio.get("/products/categories");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to load categories: ${response.data}");
      }
    } on DioError catch (e) {
      throw Exception("Dio error: ${e.response?.data ?? e.message}");
    }
  }
  /// Fetch products
  Future<List<dynamic>> getProducts() async {
    try {
      final response = await _dio.get("/products");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to load products: ${response.data}");
      }
    } on DioError catch (e) {
      throw Exception("Dio error: ${e.response?.data ?? e.message}");
    }
  }

  /// Fetch Single products
  Future<Map<String, dynamic>> getProductById(String id) async {
    try {
      final response = await _dio.get("/products/" + id);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to load products: ${response.data}");
      }
    } on DioError catch (e) {
      throw Exception("Dio error: ${e.response?.data ?? e.message}");
    }
  }

  /// Fetch orders
  Future<List<dynamic>> getOrders() async {
    try {
      final response = await _dio.get("/orders");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to load orders: ${response.data}");
      }
    } on DioError catch (e) {
      throw Exception("Dio error: ${e.response?.data ?? e.message}");
    }
  }
}
