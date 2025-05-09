import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:room_finder_flutter/components/RFPropertyListComponent.dart';
import 'package:room_finder_flutter/main.dart';
import 'package:room_finder_flutter/models/PropertyModel.dart';
import 'package:room_finder_flutter/services/property_service.dart';
import 'package:room_finder_flutter/utils/RFColors.dart';
import 'package:room_finder_flutter/utils/RFWidget.dart';

class RFSearchDetailScreen extends StatefulWidget {
  final String? initialQuery;
  RFSearchDetailScreen({this.initialQuery});

  @override
  _RFSearchDetailScreenState createState() => _RFSearchDetailScreenState();
}

class _RFSearchDetailScreenState extends State<RFSearchDetailScreen> {
  final TextEditingController searchController = TextEditingController();

  PropertyService _propertyService = PropertyService();
  List<Property> allProperties = [];
  List<Property> filteredProperties = [];

  bool isLoading = true;
  String error = '';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchAllProperties();

    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      searchController.text = widget.initialQuery!;
      searchQuery = widget.initialQuery!;
    }
  }

  Future<void> fetchAllProperties() async {
    try {
      setState(() {
        isLoading = true;
        error = '';
      });

      final properties = await _propertyService.getAllProperties2();

      setState(() {
        allProperties = properties;

        // Si hay una consulta inicial, aplicar el filtro
        if (searchQuery.isNotEmpty) {
          searchProperties(searchQuery);
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

  void searchProperties(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredProperties = allProperties;
      });
      return;
    }

    final normalizedQuery = query.toLowerCase();
    setState(() {
      filteredProperties = allProperties.where((property) {
        return property.title.toLowerCase().contains(normalizedQuery) ||
            property.propertyType.toLowerCase().contains(normalizedQuery) ||
            property.category.toLowerCase().contains(normalizedQuery) ||
            property.address.toLowerCase().contains(normalizedQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBarWidget(
        context,
        showLeadingIcon: true,
        appBarHeight: 50,
        title: "Búsqueda de tu lugar favorito",
        roundCornerShape: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding:
                  EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 32),
              decoration: boxDecorationWithRoundedCorners(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12)),
                backgroundColor: rf_primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Buscar por zona, nombre o categoría",
                      style: boldTextStyle(color: white)),
                  16.height,
                  AppTextField(
                    controller: searchController,
                    textFieldType: TextFieldType.OTHER,
                    decoration: rfInputDecoration(
                      showLableText: false,
                      showPreFixIcon: true,
                      prefixIcon:
                          Icon(Icons.search, color: rf_primaryColor, size: 18)
                              .paddingOnly(left: 16),
                      hintText: "Busca por zona, nombre o categoría",
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                      searchProperties(value);
                    },
                    onFieldSubmitted: (value) {
                      searchProperties(value);
                    },
                  )
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Resultados de búsqueda', style: boldTextStyle()),
                Text('${filteredProperties.length} Resultados',
                    style: secondaryTextStyle()),
              ],
            ).paddingSymmetric(horizontal: 16, vertical: 16),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(color: rf_primaryColor),
              ).paddingAll(50)
            else if (error.isNotEmpty)
              Center(
                child: Text(error, style: TextStyle(color: Colors.red)),
              ).paddingAll(50)
            else if (filteredProperties.isEmpty && searchQuery.isNotEmpty)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off,
                        size: 50, color: rf_primaryColor.withOpacity(0.5)),
                    16.height,
                    Text('No se encontraron resultados para "$searchQuery"',
                        style: boldTextStyle(
                            color: rf_primaryColor.withOpacity(0.7))),
                    8.height,
                    Text('Intenta con otra búsqueda',
                        style: secondaryTextStyle()),
                  ],
                ),
              ).paddingAll(50)
            else
              ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: filteredProperties.length,
                itemBuilder: (BuildContext context, int index) =>
                    RFPropertyListComponent(
                        propertyData: filteredProperties[index]),
              ),
          ],
        ),
      ),
    );
  }
}
