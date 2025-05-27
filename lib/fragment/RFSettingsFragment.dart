import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:room_finder_flutter/components/RFCommonAppComponent.dart';
import 'package:room_finder_flutter/main.dart';
import 'package:room_finder_flutter/models/RoomFinderModel.dart';
import 'package:room_finder_flutter/screens/RFEmailSignInScreen.dart';
import 'package:room_finder_flutter/utils/RFColors.dart';
import 'package:room_finder_flutter/utils/RFDataGenerator.dart';
import 'package:room_finder_flutter/utils/RFImages.dart';
import 'package:room_finder_flutter/utils/RFWidget.dart';

class RFSettingsFragment extends StatefulWidget {
  @override
  State<RFSettingsFragment> createState() => _RFSettingsFragmentState();
}

class _RFSettingsFragmentState extends State<RFSettingsFragment> {
  final List<RoomFinderModel> settingData = settingList();
  String? userName;

  @override
  void initState() {
    super.initState();
    init();
    loadUserName();
  }

  void init() async {
    setStatusBarColor(rf_primaryColor,
        statusBarIconBrightness: Brightness.light);
  }

  // Load user name from shared preferences
  void loadUserName() async {
    // Replace getValue with getStringAsync from nb_utils
    userName = await getStringAsync('user_name');
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RFCommonAppComponent(
        title: "Configuración",
        mainWidgetHeight: 200,
        subWidgetHeight: 100,
        accountCircleWidget: Align(
          alignment: Alignment.bottomCenter,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(top: 120),
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  color: white, // Agregamos fondo blanco
                  border: Border.all(color: white, width: 4),
                  // Eliminamos boxShape: BoxShape.circle para que sea rectangular
                ),
                child: rfCommonCachedNetworkImage(
                  rf_logo,
                  fit: BoxFit.cover,
                  width: 220,
                  height: 220,
                  radius: 0,
                ),
              ),
            ],
          ),
        ),
        subWidget: Column(
          children: [
            16.height,
            // Dynamic username display
            Text(
                userName != null && userName!.isNotEmpty
                    ? 'Hola, $userName'
                    : '',
                style: boldTextStyle(size: 18)),
            8.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            16.height,
            Container(
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: boxDecorationWithRoundedCorners(
                backgroundColor: appStore.isDarkModeOn
                    ? scaffoldDarkColor
                    : rf_selectedCategoryBgColor,
              ),
            ),
            SettingItemWidget(
              title: "Modo oscuro",
              leading: Icon(Icons.dark_mode_outlined,
                  size: 18, color: rf_primaryColor),
              titleTextStyle: primaryTextStyle(),
              trailing: Switch(
                value: appStore.isDarkModeOn,
                activeTrackColor: rf_primaryColor,
                onChanged: (bool value) {
                  appStore.toggleDarkMode(value: value);
                  setStatusBarColor(rf_primaryColor,
                      statusBarIconBrightness: Brightness.light);
                  setState(() {});
                },
              ),
              padding: EdgeInsets.only(left: 40, right: 16, top: 8),
              onTap: () {
                //
              },
            ),
            ListView.builder(
              padding: EdgeInsets.only(left: 22),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: settingData.length,
              itemBuilder: (BuildContext context, int index) {
                RoomFinderModel data = settingData[index];
                return Container(
                  margin: EdgeInsets.only(right: 24),
                  child: SettingItemWidget(
                    title: data.roomCategoryName.validate(),
                    leading: data.img
                        .validate()
                        .iconImage(iconColor: rf_primaryColor, size: 18),
                    titleTextStyle: primaryTextStyle(),
                    onTap: () {
                      if (index == 1) {
                        showConfirmDialogCustom(
                          context,
                          cancelable: false,
                          title: "¿Estás seguro que deseas cerrar sesión?",
                          dialogType: DialogType.CONFIRMATION,
                          onCancel: (v) {
                            finish(context);
                          },
                          onAccept: (v) async {
                            try {
                              // Clear user data on logout
                              await removeKey('user_token');
                              await removeKey('user_id');
                              await removeKey('is_logged_in');
                              await removeKey('user_name');

                              // Navegar y limpiar toda la pila
                              RFEmailSignInScreen().launch(context, isNewTask: true);
                            } catch (e) {
                              print('Error durante logout: $e');
                            }
                          },
                        );
                      } else {
                        data.newScreenWidget.validate().launch(context);
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}