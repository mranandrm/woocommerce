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
