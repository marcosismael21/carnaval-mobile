import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:room_finder_flutter/components/RFPropertyListComponent.dart';
import 'package:room_finder_flutter/models/PropertyModel.dart';
import 'package:room_finder_flutter/services/property_service.dart';
import 'package:room_finder_flutter/utils/RFColors.dart';
import 'package:room_finder_flutter/utils/RFWidget.dart';

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

  Widget _buildAmenityChip(String amenity) {
    return Chip(
      label: Text(
        amenity.replaceAll('-', ' ').capitalize(),
        style: secondaryTextStyle(size: 12, color: white),
      ),
      backgroundColor: rf_primaryColor.withOpacity(0.7),
      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
    );
  }

  Widget _buildPetChip(String pet) {
    return Chip(
      label: Text(
        pet == 'dogs-allowed' ? 'Perros permitidos' : 'Gatos permitidos',
        style: secondaryTextStyle(size: 12, color: white),
      ),
      backgroundColor: Colors.green.withOpacity(0.7),
      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
    );
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
                      text: propertyData!.status == 'for-rent'
                          ? 'Contactar al anfitrión'
                          : 'Contactar al vendedor',
                      textStyle: boldTextStyle(color: white),
                      width: context.width(),
                      onTap: () {
                        // Acción para contactar
                        toast('Función de contacto por implementar');
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
                                            style: boldTextStyle(size: 18),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'L. ${propertyData!.price}',
                                              style: boldTextStyle(
                                                  size: 18,
                                                  color: rf_primaryColor),
                                            ),
                                            Text(
                                              propertyData!.status == 'for-rent'
                                                  ? 'Por mes'
                                                  : 'En venta',
                                              style: secondaryTextStyle(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    // Ubicación
                                    8.height,
                                    Row(
                                      children: [
                                        Icon(Icons.location_on,
                                            color: rf_primaryColor, size: 16),
                                        8.width,
                                        Expanded(
                                          child: Text(
                                            '${propertyData!.address}, ${propertyData!.city}, ${propertyData!.state}',
                                            style: secondaryTextStyle(),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Detalles principales
                                    16.height,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        if (propertyData!.bedrooms > 0)
                                          Column(
                                            children: [
                                              Icon(Icons.bed,
                                                  color: rf_primaryColor),
                                              4.height,
                                              Text(
                                                  '${propertyData!.bedrooms} Hab',
                                                  style:
                                                      boldTextStyle(size: 14)),
                                            ],
                                          ),
                                        if (propertyData!.bathrooms != "0.0")
                                          Column(
                                            children: [
                                              Icon(Icons.bathtub_outlined,
                                                  color: rf_primaryColor),
                                              4.height,
                                              Text(
                                                  '${propertyData!.bathrooms} Baño',
                                                  style:
                                                      boldTextStyle(size: 14)),
                                            ],
                                          ),
                                        if (propertyData!.squareFeet != "0.00")
                                          Column(
                                            children: [
                                              Icon(Icons.square_foot,
                                                  color: rf_primaryColor),
                                              4.height,
                                              Text(
                                                  '${propertyData!.squareFeet}m²',
                                                  style:
                                                      boldTextStyle(size: 14)),
                                            ],
                                          ),
                                        if (propertyData!.parkingSpaces > 0)
                                          Column(
                                            children: [
                                              Icon(Icons.directions_car,
                                                  color: rf_primaryColor),
                                              4.height,
                                              Text(
                                                  '${propertyData!.parkingSpaces} Park',
                                                  style:
                                                      boldTextStyle(size: 14)),
                                            ],
                                          ),
                                      ],
                                    ),

                                    // Descripción
                                    16.height,
                                    Text('Descripción', style: boldTextStyle()),
                                    8.height,
                                    Text(
                                      propertyData!.description,
                                      style: secondaryTextStyle(),
                                      textAlign: TextAlign.justify,
                                    ),

                                    // Comodidades
                                    16.height,
                                    if (propertyData!.amenities.isNotEmpty) ...[
                                      Text('Comodidades',
                                          style: boldTextStyle()),
                                      8.height,
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: propertyData!.amenities
                                            .map((amenity) =>
                                                _buildAmenityChip(amenity))
                                            .toList(),
                                      ),
                                    ],

                                    // Mascotas permitidas
                                    16.height,
                                    if (propertyData!
                                        .petsAllowed.isNotEmpty) ...[
                                      Text('Mascotas', style: boldTextStyle()),
                                      8.height,
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: propertyData!.petsAllowed
                                            .map((pet) => _buildPetChip(pet))
                                            .toList(),
                                      ),
                                    ],

                                    // Información del anfitrión
                                    16.height,
                                    if (propertyData!.hostName != null) ...[
                                      Text('Anfitrión', style: boldTextStyle()),
                                      8.height,
                                      Row(
                                        children: [
                                          propertyData!.hostProfileImage != null
                                              ? rfCommonCachedNetworkImage(
                                                  propertyData!
                                                      .hostProfileImage!,
                                                  height: 50,
                                                  width: 50,
                                                  fit: BoxFit.cover,
                                                ).cornerRadiusWithClipRRect(25)
                                              : CircleAvatar(
                                                  radius: 25,
                                                  backgroundColor:
                                                      rf_primaryColor,
                                                  child: Icon(Icons.person,
                                                      color: white),
                                                ),
                                          16.width,
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(propertyData!.hostName!,
                                                  style: boldTextStyle()),
                                              if (propertyData!
                                                      .hostAverageRating !=
                                                  null)
                                                Row(
                                                  children: [
                                                    Icon(Icons.star,
                                                        color: Colors.amber,
                                                        size: 16),
                                                    4.width,
                                                    Text(
                                                        '${propertyData!.hostAverageRating}'),
                                                    if (propertyData!
                                                            .hostReviewCount !=
                                                        null) ...[
                                                      4.width,
                                                      Text(
                                                          '(${propertyData!.hostReviewCount} reseñas)',
                                                          style:
                                                              secondaryTextStyle(
                                                                  size: 12)),
                                                    ],
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],

                                    // Mapa de ubicación
                                    16.height,
                                    Text('Ubicación', style: boldTextStyle()),
                                    8.height,
                                    Container(
                                      height: 200,
                                      decoration:
                                          boxDecorationWithRoundedCorners(
                                        borderRadius: radius(8),
                                        backgroundColor:
                                            context.scaffoldBackgroundColor,
                                      ),
                                      child: Center(
                                        child: Text('Mapa por implementar',
                                            style: secondaryTextStyle()),
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
