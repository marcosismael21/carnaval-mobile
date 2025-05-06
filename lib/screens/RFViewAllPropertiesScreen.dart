import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:room_finder_flutter/components/RFPropertyListComponent.dart';
import 'package:room_finder_flutter/models/PropertyModel.dart';
import 'package:room_finder_flutter/services/property_service.dart';
import 'package:room_finder_flutter/utils/RFColors.dart';
import 'package:room_finder_flutter/utils/RFWidget.dart';

class RFViewAllPropertiesScreen extends StatefulWidget {
  final List<Property>? properties;
  final String? title;

  const RFViewAllPropertiesScreen({
    Key? key,
    this.properties,
    this.title = "Propiedades Recientemente Añadidas",
  }) : super(key: key);

  @override
  _RFViewAllPropertiesScreenState createState() => _RFViewAllPropertiesScreenState();
}

class _RFViewAllPropertiesScreenState extends State<RFViewAllPropertiesScreen> {
  List<Property> propertyList = [];
  bool isLoading = true;
  String error = '';

  PropertyService _propertyService = PropertyService();

  @override
  void initState() {
    super.initState();
    if (widget.properties != null && widget.properties!.isNotEmpty) {
      propertyList = widget.properties!;
      isLoading = false;
    } else {
      fetchAllProperties();
    }
  }

  Future<void> fetchAllProperties() async {
    try {
      setState(() {
        isLoading = true;
        error = '';
      });
      
      final properties = await _propertyService.getAllProperties();
      setState(() {
        propertyList = properties;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBarWidget(
        context, 
        title: widget.title!, 
        appBarHeight: 80, 
        showLeadingIcon: true, 
        roundCornerShape: true
      ),
      body: isLoading 
        ? Center(child: CircularProgressIndicator(color: rf_primaryColor))
        : error.isNotEmpty
          ? Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(error, style: TextStyle(color: Colors.red)),
                16.height,
                ElevatedButton(
                  onPressed: fetchAllProperties,
                  child: Text('Reintentar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: rf_primaryColor,
                  ),
                ),
              ],
            ))
          : propertyList.isEmpty
            ? Center(child: Text('No hay propiedades disponibles', style: boldTextStyle()))
            : RefreshIndicator(
                onRefresh: fetchAllProperties,
                color: rf_primaryColor,
                child: ListView.builder(
                  padding: EdgeInsets.only(right: 16, left: 16, bottom: 16, top: 24),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: propertyList.length,
                  itemBuilder: (BuildContext context, int index) {
                    Property data = propertyList[index];
                    return RFPropertyListComponent(propertyData: data);
                  },
                ),
              ),
    );
  }
}