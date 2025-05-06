import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:room_finder_flutter/components/RFCommonAppComponent.dart';
import 'package:room_finder_flutter/components/RFPropertyListComponent.dart';
import 'package:room_finder_flutter/components/RFLocationComponent.dart';
import 'package:room_finder_flutter/components/RFRecentUpdateComponent.dart';
import 'package:room_finder_flutter/main.dart';
import 'package:room_finder_flutter/models/PropertyModel.dart';
import 'package:room_finder_flutter/models/RoomFinderModel.dart';
import 'package:room_finder_flutter/screens/RFLocationViewAllScreen.dart';
import 'package:room_finder_flutter/screens/RFRecentupdateViewAllScreen.dart';
import 'package:room_finder_flutter/screens/RFSearchDetailScreen.dart';
import 'package:room_finder_flutter/screens/RFViewAllPropertiesScreen.dart';
import 'package:room_finder_flutter/services/property_service.dart';
import 'package:room_finder_flutter/utils/RFColors.dart';
import 'package:room_finder_flutter/utils/RFDataGenerator.dart';
import 'package:room_finder_flutter/utils/RFString.dart';
import 'package:room_finder_flutter/utils/RFWidget.dart';

class RFHomeFragment extends StatefulWidget {
  @override
  _RFHomeFragmentState createState() => _RFHomeFragmentState();
}

class _RFHomeFragmentState extends State<RFHomeFragment> {
  List<RoomFinderModel> categoryData = categoryList();
  List<RoomFinderModel> locationListData = locationList();

  // Para los datos de nuestra API
  List<Property> propertyListData = [];
  bool isLoading = true;
  String error = '';

  PropertyService _propertyService = PropertyService();
  int selectCategoryIndex = 0;
  bool locationWidth = true;

  @override
  void initState() {
    super.initState();
    init();
    fetchProperties();
  }

  void init() async {
    setStatusBarColor(rf_primaryColor,
        statusBarIconBrightness: Brightness.light);
  }

  Future<void> fetchProperties() async {
    try {
      setState(() {
        isLoading = true;
        error = '';
      });

      final properties = await _propertyService.getAllProperties();
      setState(() {
        propertyListData = properties;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Error al cargar propiedades: $e';
        isLoading = false;
      });
      print(error);
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
        mainWidgetHeight: 200,
        subWidgetHeight: 130,
        cardWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Encuentra una propiedad en cualquier lugar',
                style: boldTextStyle(size: 18)),
            16.height,
            AppTextField(
              textFieldType: TextFieldType.EMAIL,
              decoration: rfInputDecoration(
                hintText: "Buscar dirección o cerca de ti",
                showPreFixIcon: true,
                showLableText: false,
                prefixIcon:
                    Icon(Icons.location_on, color: rf_primaryColor, size: 18),
              ),
            ),
            16.height,
            AppButton(
              color: rf_primaryColor,
              elevation: 0.0,
              child: Text('Buscar Ahora', style: boldTextStyle(color: white)),
              width: context.width(),
              onTap: () {
                RFSearchDetailScreen().launch(context);
              },
            ),
            TextButton(
              onPressed: () {
                //
              },
              child: Align(
                alignment: Alignment.topRight,
                child: Text('Búsqueda Avanzada',
                    style: primaryTextStyle(), textAlign: TextAlign.end),
              ),
            )
          ],
        ),
        subWidget: Column(
          children: [
            HorizontalList(
              padding: EdgeInsets.only(right: 16, left: 16),
              wrapAlignment: WrapAlignment.spaceEvenly,
              itemCount: categoryData.length,
              itemBuilder: (BuildContext context, int index) {
                RoomFinderModel data = categoryData[index];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectCategoryIndex = index;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 8),
                    decoration: boxDecorationWithRoundedCorners(
                      backgroundColor: appStore.isDarkModeOn
                          ? scaffoldDarkColor
                          : selectCategoryIndex == index
                              ? rf_selectedCategoryBgColor
                              : rf_categoryBgColor,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Text(
                      data.roomCategoryName.validate(),
                      style: boldTextStyle(
                          color: selectCategoryIndex == index
                              ? rf_primaryColor
                              : gray),
                    ),
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Propiedades Recientemente Añadidas',
                    style: boldTextStyle()),
                TextButton(
                  onPressed: () {
                    RFViewAllPropertiesScreen(properties: propertyListData)
                        .launch(context);
                  },
                  child: Text('Ver Todo',
                      style: secondaryTextStyle(
                          decoration: TextDecoration.underline,
                          textBaseline: TextBaseline.alphabetic)),
                )
              ],
            ).paddingOnly(left: 16, right: 16, top: 16, bottom: 8),

            // Mostrar indicador de carga o lista de propiedades
            if (isLoading)
              Center(child: CircularProgressIndicator(color: rf_primaryColor))
            else if (error.isNotEmpty)
              Center(child: Text(error, style: TextStyle(color: Colors.red)))
            else
              ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: propertyListData.take(3).length,
                itemBuilder: (BuildContext context, int index) {
                  Property data = propertyListData[index];
                  return RFPropertyListComponent(propertyData: data);
                },
              ),
/*
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ubicaciones', style: boldTextStyle()),
                TextButton(
                  onPressed: () {
                    RFLocationViewAllScreen(locationWidth: true)
                        .launch(context);
                  },
                  child: Text('Ver Todo',
                      style: secondaryTextStyle(
                          decoration: TextDecoration.underline)),
                )
              ],
            ).paddingOnly(left: 16, right: 16, bottom: 8),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: List.generate(locationListData.length, (index) {
                return RFLocationComponent(
                    locationData: locationListData[index]);
              }),
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Propiedades Destacadas', style: boldTextStyle()),
                TextButton(
                  onPressed: () {
                    RFViewAllPropertiesScreen(
                      properties: propertyListData
                          .where((property) => property.isFeatured == 1)
                          .toList(),
                      title: "Propiedades Destacadas",
                    ).launch(context);
                  },
                  child: Text('Ver Todo',
                      style: secondaryTextStyle(
                          decoration: TextDecoration.underline)),
                )
              ],
            ).paddingOnly(left: 16, right: 16, top: 16, bottom: 8),

            // Mostrar propiedades destacadas
            if (isLoading)
              Center(child: CircularProgressIndicator(color: rf_primaryColor))
            else if (error.isNotEmpty)
              Center(child: Text(error, style: TextStyle(color: Colors.red)))
            else
              ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: propertyListData
                    .where((property) => property.isFeatured == 1)
                    .take(3)
                    .length,
                itemBuilder: (BuildContext context, int index) {
                  Property data = propertyListData
                      .where((property) => property.isFeatured == 1)
                      .toList()[index];
                  return RFPropertyListComponent(propertyData: data);
                },
              ),
              */
          ],
        ),
      ),
    );
  }
}
