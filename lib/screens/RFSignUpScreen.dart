import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:room_finder_flutter/components/RFCommonAppComponent.dart';
import 'package:room_finder_flutter/screens/RFEmailSignInScreen.dart';
import 'package:room_finder_flutter/utils/RFColors.dart';
import 'package:room_finder_flutter/utils/RFWidget.dart';

import '../utils/RFString.dart';

class RFSignUpScreen extends StatefulWidget {
  @override
  _RFSignUpScreenState createState() => _RFSignUpScreenState();
}

class _RFSignUpScreenState extends State<RFSignUpScreen> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  FocusNode fullNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passWordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
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
              controller: fullNameController,
              focus: fullNameFocusNode,
              nextFocus: emailFocusNode,
              textFieldType: TextFieldType.NAME,
              decoration: rfInputDecoration(
                lableText: "Nombre completo",
                showLableText: true,
                suffixIcon: Container(
                  padding: EdgeInsets.all(2),
                  decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: rf_rattingBgColor),
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
                  decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: rf_rattingBgColor),
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
              child: Text('Crear cuenta', style: boldTextStyle(color: white)),
              width: context.width(),
              height: 45,
              elevation: 0,
              onTap: () {
                RFEmailSignInScreen(showDialog: true).launch(context);
              },
            ),
          ],
        ),
        subWidget: rfCommonRichText(title: "Ya tienes una cuenta? ", subTitle: "Inicia sesión aquí").paddingAll(8).onTap(
          () {
            finish(context);
          },
        ),
      ),
    );
  }
}
