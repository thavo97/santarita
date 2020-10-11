import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Product.dart';

class Services{
  static const ROOT ='http://192.168.43.202/santarita/products_actions.php';
  static const _GET_ALL_PRODUCTS_ACTION = 'GET_ALL_PRODUCTS';
  static const _UPDATE_PRICE_ACTION = 'UPDATE_PRICE';
  static const _GET_PAGE_PRODUCTS_ACTION ='GET_PAGE_PRODUCTS';
  static const _GET_SEARCH_PRODUCTS_ACTION ='GET_SEARCH_PRODUCTS';

  // Method to create get all products
  static Future<List<Product>> getProducts() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_PRODUCTS_ACTION;
      final response = await http.post(ROOT, body: map);
      //print('getProducts Response: ${response.body}');//mostrando productos
      if (200 == response.statusCode) {
        List<Product> list = parseResponse(response.body);
        return list;
      } else {
        return List<Product>();
      }
    } catch (e) {
      print('error conexion no establecida');
      return List<Product>();

    }
  }
  static Future<List<Product>> getPageProducts(String number_page) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_PAGE_PRODUCTS_ACTION;
      map['number_page'] = number_page;
      final response = await http.post(ROOT, body: map);
      //print('getProducts Response: ${response.body}');//mostrando productos
      if (200 == response.statusCode) {
        List<Product> list = parseResponse(response.body);
        return list;
      } else {
        return List<Product>();
      }
    } catch (e) {
      print('error conexion no establecida');
      return List<Product>();

    }
  }
  static Future<List<Product>> getSearchProducts(String character) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_SEARCH_PRODUCTS_ACTION;
      map['character'] = character;
      final response = await http.post(ROOT, body: map);
      //print('getProducts Response: ${response.body}');//mostrando productos
      if (200 == response.statusCode) {
        List<Product> list = parseResponse(response.body);
        return list;
      } else {
        return List<Product>();
      }
    } catch (e) {
      print('error conexion no establecida');
      return List<Product>();

    }
  }

  static List<Product> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Product>((json) => Product.fromJson(json)).toList();
  }

  // Method to update a product in Database...
  static Future<String> updateProduct(
      String code,String cost,String price,String unit) async {
    try {
      var map = Map<String, dynamic>();
      bool status=true;
      map['action'] = _UPDATE_PRICE_ACTION;
      map['code_product'] = code;
      map['cost_product'] = cost;
      map['price_product'] = price;
      map['unit_product'] = unit;

      final response = await http.post(ROOT, body: map);
      print('updateProduct Response:'+response.body);
      if (200 == response.statusCode) {
        return "success";
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }
}
