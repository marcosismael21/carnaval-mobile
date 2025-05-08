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
    // Color de indicador basado en status
    Color statusColor = rf_primaryColor;
    if (propertyData.isNew == 1) {
      statusColor = Colors.green;
    } else if (propertyData.isFeatured == 1) {
      statusColor = Colors.blue;
    }

    return Container(
      width: context.width(),
      decoration:
          boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          rfCommonCachedNetworkImage(propertyData.image,
                  height: 100, width: 100, fit: BoxFit.cover)
              .cornerRadiusWithClipRRect(8),
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
                          Container(
                            decoration: boxDecorationWithRoundedCorners(
                                boxShape: BoxShape.circle,
                                backgroundColor: statusColor),
                            padding: EdgeInsets.all(4),
                          ),
                          6.width,
                          Text(propertyData.propertyType.capitalize(),
                              style: secondaryTextStyle()),
                        ],
                      ).fit(),
                    ],
                  ).expand(),
                ],
              ).paddingOnly(left: 3),
              showHeight.validate() ? 8.height : 10.height,
              // Información de la propiedad
              Row(
                children: [
                  Icon(Icons.location_on, color: rf_primaryColor, size: 16),
                  6.width,
                  Expanded(
                    child: Text(
                      '${propertyData.address}',
                      style: secondaryTextStyle(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              8.height,
            ],
          ).expand()
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

// Extensión para capitalizar strings
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
