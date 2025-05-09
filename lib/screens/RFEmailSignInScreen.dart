import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:room_finder_flutter/components/RFCommonAppComponent.dart';
import 'package:room_finder_flutter/components/RFConformationDialog.dart';
import 'package:room_finder_flutter/screens/RFHomeScreen.dart';
import 'package:room_finder_flutter/screens/RFResetPasswordScreen.dart';
import 'package:room_finder_flutter/screens/RFSignUpScreen.dart';
import 'package:room_finder_flutter/utils/RFColors.dart';
import 'package:room_finder_flutter/utils/RFString.dart';
import 'package:room_finder_flutter/utils/RFWidget.dart';
import 'package:room_finder_flutter/services/auth_service.dart';

// ignore: must_be_immutable
class RFEmailSignInScreen extends StatefulWidget {
  bool showDialog;

  RFEmailSignInScreen({this.showDialog = false});

  @override
  _RFEmailSignInScreenState createState() => _RFEmailSignInScreenState();
}

class _RFEmailSignInScreenState extends State<RFEmailSignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passWordFocusNode = FocusNode();

  Timer? timer;
  bool isLoading = false;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setStatusBarColor(rf_primaryColor,
        statusBarIconBrightness: Brightness.light);

    widget.showDialog
        ? Timer.run(() {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) {
                Future.delayed(Duration(seconds: 1), () {
                  Navigator.of(context).pop(true);
                });
                return Material(
                    type: MaterialType.transparency,
                    child: RFConformationDialog());
              },
            );
          })
        : SizedBox();
  }

  // Method to handle login process
  Future<void> handleLogin() async {
    print('=== INICIO DEL PROCESO DE LOGIN ===');
    print('Email ingresado: ${emailController.text.trim()}');

    if (emailController.text.trim().isEmpty) {
      print('ERROR: Campo de correo vacío');
      toast('Por favor ingrese su correo electrónico');
      return;
    }

    if (passwordController.text.trim().isEmpty) {
      print('ERROR: Campo de contraseña vacío');
      toast('Por favor ingrese su contraseña');
      return;
    }

    print(
        'Validación de campos completada. Iniciando proceso de autenticación...');
    setState(() {
      isLoading = true;
    });

    try {
      print('Enviando petición a: http://10.0.2.2:3000/api/auth/login');
      print(
          'Datos enviados: { email: ${emailController.text.trim()}, password: [OCULTO] }');

      final userData = await _authService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      print('RESPUESTA DEL SERVIDOR: $userData');
      print('Token recibido: ${userData['token'] ?? 'No se recibió token'}');
      print('UserID recibido: ${userData['userId'] ?? 'No se recibió userId'}');

      // Save user data or token to local storage if needed
      await setValue('user_token', userData['token']);
      await setValue('user_id', userData['userId']);
      await setValue('is_logged_in', true);
      print('Datos guardados en almacenamiento local');

      setState(() {
        isLoading = false;
      });

      print('Login exitoso. Navegando a pantalla principal...');
      toast('Inicio de sesión exitoso');
      RFHomeScreen().launch(context, isNewTask: true);
    } catch (e) {
      print('ERROR DE AUTENTICACIÓN: $e');
      print('Detalles del error: ${e.toString()}');
      setState(() {
        isLoading = false;
      });
      toast(e.toString().replaceAll('Exception: ', ''));
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
        mainWidgetHeight: 230,
        subWidgetHeight: 170,
        cardWidget: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Iniciar sesión para continuar',
                style: boldTextStyle(size: 18)),
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
              textFieldType: TextFieldType.PASSWORD,
              decoration: rfInputDecoration(
                lableText: 'Contraseña',
                showLableText: true,
              ),
            ),
            32.height,
            AppButton(
              color: rf_primaryColor,
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Iniciar Sesión', style: boldTextStyle(color: white)),
              width: context.width(),
              elevation: 0,
              onTap: isLoading ? null : handleLogin,
            ),
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                  child: Text("Reestablecer Contraseña?",
                      style: primaryTextStyle()),
                  onPressed: () {
                    RFResetPasswordScreen().launch(context);
                  }),
            ),
          ],
        ),
        subWidget: socialLoginWidget(context,
            title1: "Nuevo miembro? ",
            title2: "Registrate aquí!", callBack: () {
          RFSignUpScreen().launch(context);
        }),
      ),
    );
  }
}
