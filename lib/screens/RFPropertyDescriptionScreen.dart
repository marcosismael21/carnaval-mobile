import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:room_finder_flutter/components/RFPropertyListComponent.dart';
import 'package:room_finder_flutter/models/PropertyModel.dart';
import 'package:room_finder_flutter/screens/RFWebViewScreen%20.dart';
import 'package:room_finder_flutter/services/property_service.dart';
import 'package:room_finder_flutter/utils/RFColors.dart';
import 'package:room_finder_flutter/utils/RFWidget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RFPropertyDescriptionScreen extends StatefulWidget {
  final int propertyId;

  const RFPropertyDescriptionScreen({Key? key, required this.propertyId})
      : super(key: key);

  @override
  _RFPropertyDescriptionScreenState createState() =>
      _RFPropertyDescriptionScreenState();
}

class _RFPropertyDescriptionScreenState
    extends State<RFPropertyDescriptionScreen> {
  Property? propertyData;
  bool isLoading = true;
  String error = '';

  PropertyService _propertyService = PropertyService();

  @override
  void initState() {
    super.initState();
    fetchPropertyDetails();
  }

  Future<void> fetchPropertyDetails() async {
    try {
      setState(() {
        isLoading = true;
        error = '';
      });

      final property =
          await _propertyService.getPropertyById(widget.propertyId);
      setState(() {
        propertyData = property;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Error al cargar los detalles de la propiedad: $e';
        isLoading = false;
      });
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => finish(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: propertyData != null
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: boxDecorationWithRoundedCorners(
                backgroundColor: context.cardColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: gray.withOpacity(0.3),
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      color: rf_primaryColor,
                      text: '¡Llévame allá!',
                      textStyle: boldTextStyle(color: white),
                      width: context.width(),
                      onTap: () async {
                        /*String lat = propertyData!.lat;
                        String lng = propertyData!.lng;

                        String googleDirectionsUrl =
                            'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving';

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                WebViewScreen(url: googleDirectionsUrl),
                          ),
                        );*/
                        String lat = propertyData!.lat;
                        String lng = propertyData!.lng;

                        String openStreetMapUrl =
                            'https://www.openstreetmap.org/?mlat=$lat&mlon=$lng#map=16/$lat/$lng';

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                WebViewScreen(url: openStreetMapUrl),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          : null,
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: rf_primaryColor))
          : error.isNotEmpty
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(error, style: TextStyle(color: Colors.red)),
                    16.height,
                    ElevatedButton(
                      onPressed: fetchPropertyDetails,
                      child: Text('Reintentar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: rf_primaryColor,
                      ),
                    ),
                  ],
                ))
              : propertyData == null
                  ? Center(
                      child: Text('No se encontró la propiedad',
                          style: boldTextStyle()))
                  : Stack(
                      children: [
                        // Imagen de portada
                        Container(
                          height: context.height() * 0.4,
                          child: rfCommonCachedNetworkImage(
                            propertyData!.image,
                            fit: BoxFit.cover,
                            width: context.width(),
                          ),
                        ),

                        // Contenido scrolleable
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              // Espaciado para imagen
                              SizedBox(height: context.height() * 0.35),

                              // Detalles de la propiedad
                              Container(
                                decoration: boxDecorationWithRoundedCorners(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  backgroundColor: context.cardColor,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Título y precio
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            propertyData!.title,
                                            style: boldTextStyle(size: 20),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Ubicación
                                    20.height,
                                    Row(
                                      children: [
                                        Icon(Icons.location_on,
                                            color: rf_primaryColor, size: 30),
                                        8.width,
                                        Expanded(
                                          child: Text(
                                            '${propertyData!.address}',
                                            style:
                                                secondaryTextStyle().copyWith(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Descripción
                                    16.height,
                                    Text('Descripción', style: boldTextStyle()),
                                    8.height,
                                    Text(
                                      propertyData!.description,
                                      style: secondaryTextStyle().copyWith(
                                        fontSize: 15,
                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                    // Galería de fotos
                                    /*16.height,
                                    if (propertyData!.additionalImages !=
                                            null &&
                                        propertyData!
                                            .additionalImages!.isNotEmpty) ...[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Fotos', style: boldTextStyle()),
                                          if (propertyData!
                                                  .additionalImages!.length >
                                              4)
                                            TextButton(
                                              onPressed: () {
                                                // Implementar visualización de todas las fotos
                                                toast('Ver todas las fotos');
                                              },
                                              child: Text(
                                                'Ver todas',
                                                style: secondaryTextStyle(
                                                    color: rf_primaryColor),
                                              ),
                                            ),
                                        ],
                                      ),
                                      8.height,
                                      Container(
                                        height: 120,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: propertyData!
                                                      .additionalImages!
                                                      .length >
                                                  4
                                              ? 4
                                              : propertyData!
                                                  .additionalImages!.length,
                                          itemBuilder: (context, index) {
                                            if (index == 3 &&
                                                propertyData!.additionalImages!
                                                        .length >
                                                    4) {
                                              // Para la cuarta imagen, si hay más de 4
                                              return Stack(
                                                children: [
                                                  Container(
                                                    width: 160,
                                                    margin: EdgeInsets.only(
                                                        right: 8),
                                                    decoration:
                                                        boxDecorationWithRoundedCorners(
                                                      borderRadius: radius(8),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child:
                                                          rfCommonCachedNetworkImage(
                                                        propertyData!
                                                                .additionalImages![
                                                            index],
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned.fill(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: black
                                                            .withOpacity(0.5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '+${propertyData!.additionalImages!.length - 3}',
                                                          style: boldTextStyle(
                                                              color: white,
                                                              size: 20),
                                                        ),
                                                      ),
                                                    ),
                                                  ).onTap(() {
                                                    toast(
                                                        'Ver todas las fotos');
                                                  }),
                                                ],
                                              );
                                            } else {
                                              // Para las primeras 3 imágenes o si hay menos de 4
                                              return Container(
                                                width: 160,
                                                margin:
                                                    EdgeInsets.only(right: 8),
                                                decoration:
                                                    boxDecorationWithRoundedCorners(
                                                  borderRadius: radius(8),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child:
                                                      rfCommonCachedNetworkImage(
                                                    propertyData!
                                                            .additionalImages![
                                                        index],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ).onTap(() {
                                                // Acción al hacer tap en una imagen
                                                toast(
                                                    'Ver imagen ${index + 1}');
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ],
*/
                                    16.height,
                                    Text('Fotos', style: boldTextStyle()),
                                    8.height,
                                    if (propertyData!.additionalImages !=
                                            null &&
                                        propertyData!
                                            .additionalImages!.isNotEmpty)
                                      Container(
                                        height: 120,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: propertyData!
                                                      .additionalImages!
                                                      .length >
                                                  4
                                              ? 4
                                              : propertyData!
                                                  .additionalImages!.length,
                                          itemBuilder: (context, index) {
                                            if (index == 3 &&
                                                propertyData!.additionalImages!
                                                        .length >
                                                    4) {
                                              return Stack(
                                                children: [
                                                  Container(
                                                    width: 160,
                                                    margin: EdgeInsets.only(
                                                        right: 8),
                                                    decoration:
                                                        boxDecorationWithRoundedCorners(
                                                      borderRadius: radius(8),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child:
                                                          rfCommonCachedNetworkImage(
                                                        propertyData!
                                                                .additionalImages![
                                                            index],
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned.fill(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: black
                                                            .withOpacity(0.5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '+${propertyData!.additionalImages!.length - 3}',
                                                          style: boldTextStyle(
                                                              color: white,
                                                              size: 20),
                                                        ),
                                                      ),
                                                    ),
                                                  ).onTap(() {
                                                    toast(
                                                        'Ver todas las fotos');
                                                  }),
                                                ],
                                              );
                                            } else {
                                              return Container(
                                                width: 160,
                                                margin:
                                                    EdgeInsets.only(right: 8),
                                                decoration:
                                                    boxDecorationWithRoundedCorners(
                                                  borderRadius: radius(8),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child:
                                                      rfCommonCachedNetworkImage(
                                                    propertyData!
                                                            .additionalImages![
                                                        index],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ).onTap(() {
                                                toast(
                                                    'Ver imagen ${index + 1}');
                                              });
                                            }
                                          },
                                        ),
                                      )
                                    else
                                      Container(
                                        height: 120,
                                        decoration:
                                            boxDecorationWithRoundedCorners(
                                          backgroundColor: Colors.grey.shade100,
                                          borderRadius: radius(8),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Sin fotos extras por el momento',
                                            style: secondaryTextStyle(),
                                          ),
                                        ),
                                      ),
                                    // Espacio al final para evitar que el botón de acción cubra contenido
                                    32.height,
                                  ],
                                ).paddingAll(16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
    );
  }
}
