import 'package:flutter/material.dart';
import 'package:room_finder_flutter/models/PropertyModel.dart';
import 'package:room_finder_flutter/models/RoomFinderModel.dart';
import 'package:room_finder_flutter/screens/RFAboutUsScreen.dart';
import 'package:room_finder_flutter/screens/RFHelpScreen.dart';
import 'package:room_finder_flutter/screens/RFNotificationScreen.dart';
import 'package:room_finder_flutter/screens/RFRecentlyViewedScreen.dart';
import 'package:room_finder_flutter/utils/RFImages.dart';

class CategoryModel {
  final String name;
  final IconData icon;
  final String category;

  CategoryModel(
      {required this.name, required this.icon, required this.category});
}

List<CategoryModel> categoryList() {
  return [
    CategoryModel(
      name: "Alojamientos",
      icon: Icons.hotel,
      category: "Alojamiento",
    ),
    CategoryModel(
      name: "Entretenimiento",
      icon: Icons.sports_soccer,
      category: "Entretenimiento",
    ),
    CategoryModel(
      name: "Restaurantes y Bares",
      icon: Icons.restaurant_menu,
      category: "Restaurante y bar",
    ),
  ];
}

List<RoomFinderModel> settingList() {
  List<RoomFinderModel> settingListData = [];
  settingListData.add(RoomFinderModel(
      img: rf_recent_view,
      roomCategoryName: "Vistos recientemente",
      newScreenWidget: RFRecentlyViewedScreen()));
  settingListData.add(RoomFinderModel(
      img: rf_about_us,
      roomCategoryName: "Sobre nosotros",
      newScreenWidget: RFAboutUsScreen()));
  settingListData.add(RoomFinderModel(
      img: rf_sign_out,
      roomCategoryName: "Cerrar sesión",
      newScreenWidget: SizedBox()));

  return settingListData;
}

List<RoomFinderModel> locationList() {
  List<RoomFinderModel> locationListData = [];
  locationListData.add(RoomFinderModel(
      img: rf_location1, price: "10 Found", location: "Lalitpur"));
  locationListData.add(
      RoomFinderModel(img: rf_location2, price: "4 Found", location: "Imadol"));
  locationListData.add(RoomFinderModel(
      img: rf_location3, price: "12 Found", location: "Kupondole"));
  locationListData.add(RoomFinderModel(
      img: rf_location4, price: "16 Found", location: " Lalitpur"));
  locationListData.add(RoomFinderModel(
      img: rf_location5, price: "20 Found", location: "Mahalaxmi"));
  locationListData.add(RoomFinderModel(
      img: rf_location6, price: "25 Found", location: "Koteshwor"));

  return locationListData;
}
