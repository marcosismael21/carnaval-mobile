import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:room_finder_flutter/models/PropertyModel.dart';
import 'package:room_finder_flutter/screens/RFPropertyDescriptionScreen.dart';
import 'package:room_finder_flutter/utils/RFColors.dart';
import 'package:room_finder_flutter/utils/RFWidget.dart';

class RFPropertyGridComponent extends StatelessWidget {
  final Property propertyData;

  RFPropertyGridComponent({required this.propertyData});

  @override
  Widget build(BuildContext context) {
    // Color de indicador basado en status
    Color statusColor = rf_primaryColor;
    if (propertyData.isNew == 1) {
      statusColor = Colors.green;
    } else if (propertyData.isFeatured == 1) {
      statusColor = Colors.blue;
    }

    return Container(
      width: context.width() * 0.5 - 24, // Ajustar el ancho para mostrar 2 columnas
      decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen de la propiedad
          Stack(
            children: [
              rfCommonCachedNetworkImage(
                propertyData.image,
                height: 120,
                width: context.width() * 0.5 - 24,
                fit: BoxFit.cover,
              ).cornerRadiusWithClipRRectOnly(topLeft: 8, topRight: 8),
              
              // Indicador de estado (nuevo, destacado, etc)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: boxDecorationWithRoundedCorners(
                    boxShape: BoxShape.circle,
                    backgroundColor: statusColor,
                  ),
                  padding: EdgeInsets.all(6),
                ),
              ),
            ],
          ),
          
          // Información de la propiedad
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  propertyData.title,
                  style: boldTextStyle(size: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                8.height,
                Row(
                  children: [
                    Icon(Icons.location_on, color: rf_primaryColor, size: 14),
                    4.width,
                    Expanded(
                      child: Text(
                        propertyData.address,
                        style: secondaryTextStyle(size: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                6.height,
                Text(
                  propertyData.propertyType.capitalize(),
                  style: secondaryTextStyle(size: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    ).onTap(() {
      RFPropertyDescriptionScreen(propertyId: propertyData.id).launch(context);
    },
    splashColor: Colors.transparent,
    hoverColor: Colors.transparent,
    highlightColor: Colors.transparent);
  }
}

// Extension para capitalizar strings si no está definida globalmente
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}