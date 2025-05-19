import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'token_service.dart';

class AuthService {
  final String baseUrl = 'http://10.0.2.2:3000/api/auth';
  late TokenService tokenService;

  // Constructor que inicializa el servicio de tokens
  AuthService({Function? onAuthError}) {
    tokenService = TokenService(onAuthError: onAuthError);
  }

  // Método para registrar usuario
  Future<Map<String, dynamic>> register(
      String firstName, String lastName, String email, String password) async {
    print('=== REGISTRO DE USUARIO ===');
    print('Intentando registrar usuario: $email');
    print('Nombre: $firstName');
    print('Apellido: $lastName');
    print('URL: $baseUrl/register');

    // Crear el cuerpo de la solicitud con los campos requeridos por el backend
    final requestBody = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'active': true,
    };

    print('Cuerpo de la solicitud: $requestBody');

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      print('Código de estado HTTP: ${response.statusCode}');
      print('Respuesta del servidor: ${response.body}');

      // Intentar decodificar la respuesta
      Map<String, dynamic> decoded;
      try {
        decoded = json.decode(response.body);
      } catch (e) {
        print('Error al decodificar la respuesta: $e');
        throw Exception('Formato de respuesta inválido');
      }

      if (response.statusCode == 201 &&
          (decoded['success'] == true || decoded.containsKey('data'))) {
        print('Registro exitoso. Datos de usuario: ${decoded['data']}');

        // Return the data object directly
        if (decoded.containsKey('data')) {
          return decoded['data'];
        } else {
          return decoded;
        }
      } else {
        String errorMessage = 'Error en el registro';

        // Intentar extraer mensaje de error de diferentes estructuras posibles
        if (decoded.containsKey('message')) {
          errorMessage = decoded['message'];
        } else if (decoded.containsKey('error')) {
          errorMessage = decoded['error'];
        } else if (decoded.containsKey('msg')) {
          errorMessage = decoded['msg'];
        }

        print('Error en el registro: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Excepción durante el registro: $e');
      if (e is http.ClientException) {
        print('Error de conexión. Verifica que el servidor esté en línea.');
        throw Exception(
            'Error de conexión. Verifica que el servidor esté en línea.');
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    print('=== LOGIN DE USUARIO ===');
    print('Intentando autenticar: $email');
    print('URL: $baseUrl/login');

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      print('Código de estado HTTP: ${response.statusCode}');
      print('Respuesta del servidor: ${response.body}');

      final decoded = json.decode(response.body);

      if (response.statusCode == 200 &&
          (decoded['success'] == true || decoded.containsKey('data'))) {
        print('Login exitoso. Datos recibidos: ${decoded['data']}');

        // Return the data object directly
        if (decoded.containsKey('data')) {
          return decoded['data'];
        } else {
          return decoded;
        }
      } else {
        String errorMessage = 'Error en el login';

        if (decoded.containsKey('message')) {
          errorMessage = decoded['message'];
        } else if (decoded.containsKey('error')) {
          errorMessage = decoded['error'];
        } else if (decoded.containsKey('msg')) {
          errorMessage = decoded['msg'];
        }

        print('Error en el login: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Excepción durante el login: $e');
      if (e is http.ClientException) {
        print(
            'Error de conexión. Verifica que el servidor esté en línea y la dirección IP sea correcta.');
        throw Exception(
            'Error de conexión. Verifica que el servidor esté en línea.');
      } else if (e is FormatException) {
        print(
            'Error en el formato de la respuesta. La respuesta no es JSON válido.');
        throw Exception('Error en la respuesta del servidor');
      }
      rethrow;
    }
  }

  // Método para obtener información del usuario actual
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await tokenService.authenticatedRequest(
        'GET',
        '$baseUrl/me',
      );

      final decoded = json.decode(response.body);

      if (response.statusCode == 200) {
        return decoded.containsKey('data') ? decoded['data'] : decoded;
      } else {
        throw Exception('Error al obtener información del usuario');
      }
    } catch (e) {
      print('Error al obtener usuario actual: $e');
      rethrow;
    }
  }

  // Método para cerrar sesión
  Future<void> logout() async {
    try {
      // Intentar hacer logout en el servidor
      await tokenService.authenticatedRequest(
        'POST',
        '$baseUrl/logout',
      );
    } catch (e) {
      print('Error al hacer logout en el servidor: $e');
    } finally {
      // Siempre limpiar los datos locales
      await tokenService.logout();
    }
  }

  // Verifica si el usuario está autenticado actualmente
  Future<bool> isAuthenticated() async {
    final token = await tokenService.getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
