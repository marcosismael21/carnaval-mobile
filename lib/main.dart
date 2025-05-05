import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:room_finder_flutter/screens/RFSplashScreen.dart';
import 'package:room_finder_flutter/store/AppStore.dart';
import 'package:room_finder_flutter/utils/AppTheme.dart';
import 'package:room_finder_flutter/utils/RFConstant.dart';

import 'package:room_finder_flutter/services/property_service.dart';

AppStore appStore = AppStore();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialize();

  appStore.toggleDarkMode(value: getBoolAsync(isDarkModeOnPref));

  runApp(const MyApp());

  
  final service = PropertyService();
  try {
    // obtener todas las propiedades y mostrar JSON crudo
    final all = await service.getAllProperties();
    print(jsonEncode({'properties': all.map((p) => p.toJson()).toList()}));

    // obtener una por id y mostrar JSON crudo
    final id = all.isNotEmpty ? all.first.id : 1;
    final single = await service.getPropertyById(id);
    print(single != null ? jsonEncode(single.toJson()) : '{}');
  } catch (e) {
    print('Error en servicios: \$e');
  }

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        scrollBehavior: SBehavior(),
        navigatorKey: navigatorKey,
        title: 'Room Finder',
        debugShowCheckedModeBanner: false,
        theme: AppThemeData.lightTheme,
        darkTheme: AppThemeData.darkTheme,
        themeMode: appStore.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
        home: RFSplashScreen(),
      ),
    );
  }
}
