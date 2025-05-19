import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:room_finder_flutter/components/RFCommonAppComponent.dart';
import 'package:room_finder_flutter/screens/RFHomeScreen.dart';
import 'package:room_finder_flutter/screens/RFResetPasswordScreen.dart';
import 'package:room_finder_flutter/screens/RFSignUpScreen.dart';
import 'package:room_finder_flutter/utils/RFColors.dart';
import 'package:room_finder_flutter/utils/RFString.dart';
import 'package:room_finder_flutter/services/auth_service.dart';
import 'package:room_finder_flutter/utils/RFWidget.dart';

class RFEmailSignInScreen extends StatefulWidget {
  @override
  _RFEmailSignInScreenState createState() => _RFEmailSignInScreenState();
}

class _RFEmailSignInScreenState extends State<RFEmailSignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    setStatusBarColor(rf_primaryColor,
        statusBarIconBrightness: Brightness.light);
  }

  // Updated login handler to match API response structure
  Future<void> handleLogin() async {
    // Validate input fields
    if (emailController.text.trim().isEmpty) {
      toast('Por favor ingrese su correo electrónico');
      return;
    }

    if (passwordController.text.trim().isEmpty) {
      toast('Por favor ingrese su contraseña');
      return;
    }

    // Show loading indicator
    setState(() {
      isLoading = true;
    });

    try {
      final userData = await _authService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      // Log the structure to debug
      print('User data structure received: $userData');

      // Extract data based on the actual API response structure
      final user = userData['user'];
      final accessToken = userData['accessToken'];
      final refreshToken = userData['refreshToken'];

      // Save tokens and user data
      await setValue('user_token', accessToken);
      await setValue('refresh_token', refreshToken);
      await setValue('user_id', user['id'].toString());
      await setValue('is_logged_in', true);

      // Save user's name from the correct path in the response
      final firstName = user['first_name'] ?? '';
      final lastName = user['last_name'] ?? '';
      final fullName = '$firstName $lastName'.trim();
      await setValue('user_name', fullName);

      // Also save individual name components if needed elsewhere
      await setValue('user_first_name', firstName);
      await setValue('user_last_name', lastName);
      await setValue('user_email', user['email']);

      setState(() {
        isLoading = false;
      });

      toast('Inicio de sesión exitoso');
      RFHomeScreen().launch(context, isNewTask: true);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      toast(e.toString().replaceAll('Exception: ', ''));
    }
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
                child:
                    Text("Reestablecer Contraseña?", style: primaryTextStyle()),
                onPressed: () {
                  RFResetPasswordScreen().launch(context);
                },
              ),
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
