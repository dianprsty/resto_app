import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restauran_submission_1/data/model/restaurant_detail_response.dart';
import 'package:restauran_submission_1/data/model/restaurant_list_response.dart';
import 'package:restauran_submission_1/data/model/review_response.dart';

class ApiServices {
  static const String _baseUrl = "https://restaurant-api.dicoding.dev";

  Future<RestaurantListResponse> getRestaurantList() async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/list"));

      if (response.statusCode == 200) {
        return RestaurantListResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to load restaurant list, please try again");
      }
    } catch (e) {
      throw Exception(
          "Failed to load restaurant list, please check your connection");
    }
  }

  Future<RestaurantDetailResponse> getRestaurantDetail(String id) async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/detail/$id"));
      if (response.statusCode == 200) {
        return RestaurantDetailResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            "Failed to load restaurant detail data, please try again");
      }
    } catch (e) {
      throw Exception(
          "Failed to load restaurant detail data, please check your connection");
    }
  }

  Future<RestaurantListResponse> searchRestaurant(String query) async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/search?q=$query"));

      if (response.statusCode == 200) {
        return RestaurantListResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            "Failed to get restaurant search result, please try again");
      }
    } catch (e) {
      throw Exception(
          "Failed to get restaurant search result, please check your connection");
    }
  }

  Future<ReviewResponse> addReview(
      String id, String name, String review) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/review"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'id': id,
          'name': name,
          'review': review,
        }),
      );

      if (response.statusCode == 201) {
        return ReviewResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to add review, please try again");
      }
    } catch (e) {
      throw Exception("Failed to add review, please check your connection");
    }
  }
}
