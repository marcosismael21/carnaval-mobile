import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:room_finder_flutter/models/PropertyModel.dart';
import 'package:room_finder_flutter/screens/RFPropertyDescriptionScreen.dart';
import 'package:room_finder_flutter/utils/RFColors.dart';
import 'package:room_finder_flutter/utils/RFWidget.dart';

class RFPropertyListComponent extends StatelessWidget {
  final Property propertyData;
  final bool? showHeight;

  RFPropertyListComponent({required this.propertyData, this.showHeight});

  @override
  Widget build(BuildContext context) {
    // Formatear precio para mostrar
    String formattedPrice = 'L. ${propertyData.price}';
    
    // Determinar texto de duración basado en tipo de propiedad
    String rentDuration = '';
    switch (propertyData.propertyType) {
      case 'daily-rental':
        rentDuration = '/día';
        break;
      case 'house':
      case 'apartment':
      case 'room':
        rentDuration = propertyData.status == 'for-rent' ? '/mes' : '';
        break;
      default:
        rentDuration = '';
    }
    
    // Color de indicador basado en status
    Color statusColor = rf_primaryColor;
    if (propertyData.isNew == 1) {
      statusColor = Colors.green;
    } else if (propertyData.isFeatured == 1) {
      statusColor = Colors.blue;
    }

    return Container(
      width: context.width(),
      decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          rfCommonCachedNetworkImage(
            propertyData.image,
            height: 100, 
            width: 100, 
            fit: BoxFit.cover
          ).cornerRadiusWithClipRRect(8),
          16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        propertyData.title, 
                        style: boldTextStyle(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      8.height,
                      Row(
                        children: [
                          Text(
                            formattedPrice, 
                            style: boldTextStyle(color: rf_primaryColor)
                          ),
                          Text(
                            rentDuration, 
                            style: secondaryTextStyle()
                          ),
                        ],
                      ).fit(),
                    ],
                  ).expand(),
                  Row(
                    children: [
                      Container(
                        decoration: boxDecorationWithRoundedCorners(
                          boxShape: BoxShape.circle, 
                          backgroundColor: statusColor
                        ),
                        padding: EdgeInsets.all(4),
                      ),
                      6.width,
                      Text(
                        propertyData.propertyType.capitalize(),
                        style: secondaryTextStyle()
                      ),
                    ],
                  ),
                ],
              ).paddingOnly(left: 3),
              showHeight.validate() ? 8.height : 24.height,
              // Información de la propiedad
              Row(
                children: [
                  Icon(Icons.location_on, color: rf_primaryColor, size: 16),
                  6.width,
                  Expanded(
                    child: Text(
                      '${propertyData.city}, ${propertyData.state}',
                      style: secondaryTextStyle(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              8.height,
              // Detalles adicionales
              Row(
                children: [
                  if (propertyData.bedrooms > 0) ...[
                    Icon(Icons.bed, color: Colors.grey, size: 14),
                    4.width,
                    Text('${propertyData.bedrooms}', style: secondaryTextStyle(size: 12)),
                    12.width,
                  ],
                  if (propertyData.bathrooms != "0.0") ...[
                    Icon(Icons.bathtub_outlined, color: Colors.grey, size: 14),
                    4.width,
                    Text('${propertyData.bathrooms}', style: secondaryTextStyle(size: 12)),
                    12.width,
                  ],
                  if (propertyData.squareFeet != "0.00") ...[
                    Icon(Icons.square_foot, color: Colors.grey, size: 14),
                    4.width,
                    Text('${propertyData.squareFeet}m²', style: secondaryTextStyle(size: 12)),
                  ],
                ],
              ),
            ],
          ).expand()
        ],
      ),
    ).onTap(() {
      RFPropertyDescriptionScreen(propertyId: propertyData.id).launch(context);
    }, splashColor: Colors.transparent, hoverColor: Colors.transparent, highlightColor: Colors.transparent);
  }
}

// Extensión para capitalizar strings
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}