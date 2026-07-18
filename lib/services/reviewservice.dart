import 'package:bead_beauty/models/reviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReviewProvider with ChangeNotifier {
  List<Review> _reviews = [];
  List<Review> get reviews => _reviews;

  Future<void> fetchReviews() async {
    final res = await http.get(
      Uri.parse('https://bread-backend-vc53.onrender.com/api/reviews'),
    );
    if (res.statusCode == 200) {
      _reviews = (json.decode(utf8.decode(res.bodyBytes)) as List)
          .map((i) => Review.fromJson(i))
          .toList();
      notifyListeners();
    }
  }

  Future<void> deleteReview(int id) async {
    await http.delete(
      Uri.parse('https://bread-backend-vc53.onrender.com/api/reviews/$id'),
    );
    fetchReviews();
  }

  Future<void> addReview(Review review) async {
    final response = await http.post(
      Uri.parse('https://bread-backend-vc53.onrender.com/api/reviews'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "authorName": review.authorName,
        "content": review.content,
        "stars": review.stars,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      fetchReviews();
    }
  }
}
