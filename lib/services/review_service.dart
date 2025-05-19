import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ReviewModel.dart';

class ReviewService {
  final String _baseUrl = 'http://10.0.2.2:3000/api/reviews';

  Future<List<Review>> getReviewsByPropertyId(int propertyId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$propertyId'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> resp = json.decode(response.body);
        if (resp['success'] && resp['data'] != null) {
          final data = resp['data'];
          return [Review.fromJson(data)];
        }
      }
      return [];
    } catch (e) {
      print('Error al obtener reseñas: $e');
      throw Exception('Error al obtener reseñas del servidor.');
    }
  }

  Future<bool> createReview(Review review) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(review.toJson()),
      );
      return response.statusCode == 201;
    } catch (e) {
      print('Error al crear reseña: $e');
      return false;
    }
  }
}
