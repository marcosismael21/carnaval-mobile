import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  final String baseUrl = 'http://10.0.2.2:3000/api/auth';

  // Guarda la función de callback para cuando ocurra un error de autenticación
  Function? onAuthError;

  // Constructor que puede recibir una función de callback
  TokenService({this.onAuthError});

  // Método para obtener el token actual usando SharedPreferences directamente
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userToken');
  }

  // Método para obtener el refresh token usando SharedPreferences directamente
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  // Método para guardar tokens en el almacenamiento usando SharedPreferences directamente
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
    print('Tokens guardados en SharedPreferences');
  }

  // Método para refrescar el token cuando expire
  Future<bool> refreshTokens() async {
    print('Iniciando proceso de refresh token');

    final refreshToken = await getRefreshToken();

    if (refreshToken == null) {
      print('No hay refresh token disponible');
      if (onAuthError != null) {
        onAuthError!();
      }
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/refresh-token'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'refresh_token': refreshToken,
        }),
      );

      print('Respuesta de refresh token: ${response.statusCode}');
      print('Cuerpo de respuesta: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);

        if (decodedResponse.containsKey('data')) {
          final data = decodedResponse['data'];

          if (data.containsKey('token') && data.containsKey('refreshToken')) {
            await saveTokens(data['token'], data['refreshToken']);
            print('Tokens actualizados exitosamente');
            return true;
          }
        }
      }

      // Si llegamos aquí, ocurrió un error
      print('Error al refrescar el token');
      if (onAuthError != null) {
        onAuthError!();
      }
      return false;
    } catch (e) {
      print('Excepción durante el refresh token: $e');
      if (onAuthError != null) {
        onAuthError!();
      }
      return false;
    }
  }

  // Método para crear un cliente HTTP que maneje automáticamente la renovación de tokens
  Future<http.Response> authenticatedRequest(
    String method,
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
    bool retry = true,
  }) async {
    final String? token = await getAccessToken();

    if (token == null) {
      throw Exception('No hay token de acceso disponible');
    }

    final Map<String, String> authHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    if (headers != null) {
      authHeaders.addAll(headers);
    }

    http.Response response;

    switch (method.toUpperCase()) {
      case 'GET':
        response = await http.get(
          Uri.parse(endpoint),
          headers: authHeaders,
        );
        break;
      case 'POST':
        response = await http.post(
          Uri.parse(endpoint),
          headers: authHeaders,
          body: body,
        );
        break;
      case 'PUT':
        response = await http.put(
          Uri.parse(endpoint),
          headers: authHeaders,
          body: body,
        );
        break;
      case 'DELETE':
        response = await http.delete(
          Uri.parse(endpoint),
          headers: authHeaders,
          body: body,
        );
        break;
      default:
        throw Exception('Método HTTP no soportado: $method');
    }

    // Si recibimos un error 401 Unauthorized, intentamos refrescar el token
    if (response.statusCode == 401 && retry) {
      final bool refreshed = await refreshTokens();

      if (refreshed) {
        // Si logramos refrescar el token, intentamos la solicitud nuevamente
        return authenticatedRequest(
          method,
          endpoint,
          headers: headers,
          body: body,
          retry: false, // Evitar bucle infinito si falla nuevamente
        );
      }
    }

    return response;
  }

  // Método para cerrar sesión
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userToken');
    await prefs.remove('refreshToken');
    await prefs.remove('userId');
    await prefs.remove('userFirstName');
    await prefs.remove('userLastName');
    await prefs.remove('userEmail');
    print('Sesión cerrada, tokens eliminados');
  }
}
