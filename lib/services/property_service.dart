import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/PropertyModel.dart';

class PropertyService {
  final String _baseUrl = 'http://10.0.2.2:3000/api/properties';

   Future<List<Property>> getAllProperties() async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> resp = json.decode(response.body);
        if (resp['success'] && resp['data'] != null) {
          return (resp['data']['properties'] as List)
              .map((json) => Property.fromJson(json))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error al obtener las propiedades: $e');
      throw Exception('Error al obtener las propiedades del servidor.');
    }
  }

     Future<List<Property>> getAllProperties2() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/all'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> resp = json.decode(response.body);
        if (resp['success'] && resp['data'] != null) {
          return (resp['data']['properties'] as List)
              .map((json) => Property.fromJson(json))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error al obtener las propiedades: $e');
      throw Exception('Error al obtener las propiedades del servidor.');
    }
  }

  Future<Property?> getPropertyById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> resp = json.decode(response.body);
        if (resp['success'] && resp['data'] != null) {
          return Property.fromJson(resp['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error al obtener la propiedad con ID $id: $e');
      throw Exception('Error al obtener la propiedad del servidor.');
    }
  }
}