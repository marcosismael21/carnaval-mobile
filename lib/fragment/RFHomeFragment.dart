import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:room_finder_flutter/components/RFCommonAppComponent.dart';
import 'package:room_finder_flutter/components/RFPropertyListComponent.dart';
import 'package:room_finder_flutter/components/RFPropertyGridComponent.dart';
import 'package:room_finder_flutter/main.dart';
import 'package:room_finder_flutter/models/PropertyModel.dart';
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
  List<CategoryModel> categoryData = categoryList();

  // Para los datos de nuestra API
  List<Property> propertyListData = [];
  List<Property> filteredProperties = [];
  bool isLoading = true;
  String error = '';

  PropertyService _propertyService = PropertyService();
  int selectCategoryIndex = 0;
  bool locationWidth = true;
  bool isListView = true;

  @override
  void initState() {
    super.initState();
    init();
    fetchProperties();

    for (int i = 0; i < categoryData.length; i++) {
      if (categoryData[i].category == "Alojamiento") {
        selectCategoryIndex = i;
        break;
      }
    }
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
        String defaultCategory = "";
        if (selectCategoryIndex < categoryData.length) {
          defaultCategory = categoryData[selectCategoryIndex].category;
        }

        if (defaultCategory.isNotEmpty) {
          filteredProperties = properties
              .where((property) => property.category == defaultCategory)
              .toList();
        } else {
          filteredProperties = properties;
        }
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

  void filterPropertiesByCategory(String category) {
    if (category.isEmpty) {
      setState(() {
        filteredProperties = propertyListData; // Mostrar todas si no hay filtro
      });
    } else {
      setState(() {
        filteredProperties = propertyListData
            .where((property) => property.category == category)
            .toList();
      });
    }
  }

  void toggleViewMode() {
    setState(() {
      isListView = !isListView;
    });
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
            Text('¡Encuentra tu nuevo lugar favorito de la ciudad!',
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
          ],
        ),
        subWidget: Column(
          children: [
            HorizontalList(
              padding: EdgeInsets.only(right: 16, left: 16),
              wrapAlignment: WrapAlignment.spaceEvenly,
              itemCount: categoryData.length,
              itemBuilder: (BuildContext context, int index) {
                CategoryModel data = categoryData[index];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectCategoryIndex = index;
                      filterPropertiesByCategory(data.category);
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
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(
                        data.icon,
                        size: 18,
                        color: selectCategoryIndex == index
                            ? rf_primaryColor
                            : gray,
                      ),
                      SizedBox(width: 6),
                      Text(
                        data.name.validate(),
                        style: boldTextStyle(
                            color: selectCategoryIndex == index
                                ? rf_primaryColor
                                : gray),
                      ),
                    ]),
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    isListView ? Icons.grid_view : Icons.view_list,
                    color: rf_primaryColor,
                  ),
                  onPressed: toggleViewMode,
                  tooltip: isListView ? 'Ver como mosaico' : 'Ver como lista',
                ),
                Text('Más lugares por conocer', style: boldTextStyle()),
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
            else if (isListView)
              // Vista en lista
              ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: filteredProperties.take(8).length,
                itemBuilder: (BuildContext context, int index) {
                  Property data = filteredProperties[index];
                  return RFPropertyListComponent(propertyData: data);
                },
              )
            else
              // Vista en mosaico
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 0,
                  alignment: WrapAlignment.spaceBetween,
                  children: filteredProperties.take(8).map((data) {
                    return RFPropertyGridComponent(propertyData: data);
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
