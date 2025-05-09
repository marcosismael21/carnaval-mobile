import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:room_finder_flutter/components/RFCommonAppComponent.dart';
import 'package:room_finder_flutter/screens/RFEmailSignInScreen.dart';
import 'package:room_finder_flutter/utils/RFColors.dart';
import 'package:room_finder_flutter/utils/RFWidget.dart';
import 'package:room_finder_flutter/utils/RFString.dart';
import 'dart:convert'; // Importación para json
import 'package:http/http.dart' as http; // Importación para http

// Importamos el servicio de autenticación
import '../services/auth_service.dart';

class RFSignUpScreen extends StatefulWidget {
  @override
  _RFSignUpScreenState createState() => _RFSignUpScreenState();
}

class _RFSignUpScreenState extends State<RFSignUpScreen> {
  // Cambiamos a controladores separados para nombre y apellido
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // También agregamos FocusNode para el nuevo campo
  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passWordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();

  bool isLoading = false; // Para controlar el estado de carga

  // Definimos el servicio de autenticación aquí mismo
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  // Función para validar los datos del formulario actualizada para campos separados
  bool _validateForm() {
    if (firstNameController.text.trim().isEmpty) {
      toast('Por favor, ingresa tu nombre');
      return false;
    }

    if (lastNameController.text.trim().isEmpty) {
      toast('Por favor, ingresa tu apellido');
      return false;
    }

    if (emailController.text.isEmpty || !emailController.text.contains('@')) {
      toast('Por favor, ingresa un correo electrónico válido');
      return false;
    }

    if (passwordController.text.isEmpty || passwordController.text.length < 6) {
      toast('La contraseña debe tener al menos 6 caracteres');
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      toast('Las contraseñas no coinciden');
      return false;
    }

    return true;
  }

  // Función para realizar el registro actualizada para campos separados
  Future<void> _register() async {
    print('Iniciando proceso de registro');

    if (!_validateForm()) {
      print('Validación fallida');
      return;
    }

    print('Formulario validado correctamente');

    setState(() {
      isLoading = true;
    });

    print('Estado de carga activado');

    try {
      print('Llamando al servicio de registro con:');
      print('Nombre (first_name): ${firstNameController.text.trim()}');
      print('Apellido (last_name): ${lastNameController.text.trim()}');
      print('Email: ${emailController.text.trim()}');
      print('Password: ${passwordController.text.length} caracteres');

      // Intentemos directamente con una petición HTTP para ver qué está pasando
      final response = await http.post(
        Uri.parse('${_authService.baseUrl}/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'first_name': firstNameController.text.trim(),
          'last_name': lastNameController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
          'active': true, // Si el servidor requiere un estado activo
        }),
      );

      print('Código de estado HTTP: ${response.statusCode}');
      print('Respuesta del servidor: ${response.body}');

      // Intentamos decodificar la respuesta
      Map<String, dynamic> decodedResponse;
      try {
        decodedResponse = json.decode(response.body);
        print('Respuesta decodificada: $decodedResponse');
      } catch (e) {
        print('Error al decodificar la respuesta: $e');
        throw Exception('Formato de respuesta inválido');
      }

      if (response.statusCode != 201) {
        // Si hay un mensaje de error específico en la respuesta, lo usamos
        if (decodedResponse.containsKey('message')) {
          throw Exception(decodedResponse['message']);
        } else if (decodedResponse.containsKey('error')) {
          throw Exception(decodedResponse['error']);
        } else {
          throw Exception(
              'Error en el registro: Código ${response.statusCode}');
        }
      }

      if (decodedResponse.containsKey('data')) {
        final userData = decodedResponse['data'];

        // Guardamos los datos del usuario en SharedPreferences
        if (userData.containsKey('id'))
          await setValue('userId', userData['id']);
        if (userData.containsKey('token'))
          await setValue('userToken', userData['token']);
        if (userData.containsKey('first_name'))
          await setValue('userFirstName', userData['first_name']);
        if (userData.containsKey('last_name'))
          await setValue('userLastName', userData['last_name']);
        if (userData.containsKey('email'))
          await setValue('userEmail', userData['email']);

        print('Datos guardados en SharedPreferences');

        toast('Registro exitoso');

        // Redirigimos al usuario a la pantalla de inicio de sesión
        print('Redirigiendo a pantalla de inicio de sesión');
        RFEmailSignInScreen(showDialog: true).launch(context);
      } else {
        throw Exception('No se recibieron los datos de usuario esperados');
      }
    } catch (e) {
      print('Error durante el registro: $e');
      toast(e.toString().replaceAll('Exception: ', ''));
      // Mostrar mensaje en pantalla además del toast
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
      print('Estado de carga desactivado');
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RFCommonAppComponent(
        title: RFAppName,
        subTitle: RFAppSubTitle,
        mainWidgetHeight: 250,
        subWidgetHeight: 190,
        cardWidget: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Crear una cuenta', style: boldTextStyle(size: 18)),
            16.height,
            AppTextField(
              controller: firstNameController,
              focus: firstNameFocusNode,
              nextFocus: lastNameFocusNode,
              textFieldType: TextFieldType.NAME,
              decoration: rfInputDecoration(
                lableText: "Nombre",
                showLableText: true,
                suffixIcon: Container(
                  padding: EdgeInsets.all(2),
                  decoration: boxDecorationWithRoundedCorners(
                      boxShape: BoxShape.circle,
                      backgroundColor: rf_rattingBgColor),
                  child: Icon(Icons.done, color: Colors.white, size: 14),
                ),
              ),
            ),
            16.height,
            AppTextField(
              controller: lastNameController,
              focus: lastNameFocusNode,
              nextFocus: emailFocusNode,
              textFieldType: TextFieldType.NAME,
              decoration: rfInputDecoration(
                lableText: "Apellido",
                showLableText: true,
                suffixIcon: Container(
                  padding: EdgeInsets.all(2),
                  decoration: boxDecorationWithRoundedCorners(
                      boxShape: BoxShape.circle,
                      backgroundColor: rf_rattingBgColor),
                  child: Icon(Icons.done, color: Colors.white, size: 14),
                ),
              ),
            ),
            16.height,
            AppTextField(
              controller: emailController,
              focus: emailFocusNode,
              nextFocus: passWordFocusNode,
              textFieldType: TextFieldType.EMAIL,
              decoration: rfInputDecoration(
                lableText: "Correo electrónico",
                showLableText: true,
                suffixIcon: Container(
                  padding: EdgeInsets.all(2),
                  decoration: boxDecorationWithRoundedCorners(
                      boxShape: BoxShape.circle,
                      backgroundColor: rf_rattingBgColor),
                  child: Icon(Icons.done, color: Colors.white, size: 14),
                ),
              ),
            ),
            16.height,
            AppTextField(
              controller: passwordController,
              focus: passWordFocusNode,
              nextFocus: confirmPasswordFocusNode,
              textFieldType: TextFieldType.PASSWORD,
              decoration: rfInputDecoration(
                lableText: 'Contraseña',
                showLableText: true,
              ),
            ),
            16.height,
            AppTextField(
              controller: confirmPasswordController,
              focus: confirmPasswordFocusNode,
              textFieldType: TextFieldType.PASSWORD,
              decoration: rfInputDecoration(
                lableText: 'Confirmar contraseña',
                showLableText: true,
              ),
            ),
            32.height,
            AppButton(
              color: rf_primaryColor,
              child: isLoading
                  ? CircularProgressIndicator(color: white)
                  : Text('Crear cuenta', style: boldTextStyle(color: white)),
              width: context.width(),
              height: 45,
              elevation: 0,
              onTap: () {
                print('Botón de registro presionado');
                if (!isLoading) {
                  _register();
                } else {
                  print('Ya hay un registro en proceso, ignorando tap');
                }
              },
            ),
          ],
        ),
        subWidget: rfCommonRichText(
                title: "Ya tienes una cuenta? ", subTitle: "Inicia sesión aquí")
            .paddingAll(8)
            .onTap(
          () {
            finish(context);
          },
        ),
      ),
    );
  }
}
