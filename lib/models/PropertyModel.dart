class Property {
  final int id;
  final String title;
  final String description;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final int bedrooms;
  final String bathrooms;
  final String propertyType;
  final String status;
  final String image;
  final String category;
  final int isNew;
  final int isFeatured;
  final int isVerified;
  final int parkingSpaces;
  final dynamic hostId;
  final String averageRating;
  final int views;
  final String createdAt;
  final String updatedAt;
  final String lat;
  final String lng;
  final List<String> amenities;
  final List<String> petsAllowed;
  final String? hostFirstName;
  final String? hostLastName;
  final String? hostProfileImage;
  final String? hostBio;
  final String? hostName;
  final List<String>? additionalImages;
  final int? hostAverageRating;
  final int? hostReviewCount;

  Property({
    required this.id,
    required this.title,
    required this.description,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.bedrooms,
    required this.bathrooms,
    required this.propertyType,
    required this.status,
    required this.image,
    required this.category,
    required this.isNew,
    required this.isFeatured,
    required this.isVerified,
    required this.parkingSpaces,
    required this.hostId,
    required this.averageRating,
    required this.views,
    required this.createdAt,
    required this.updatedAt,
    required this.lat,
    required this.lng,
    required this.amenities,
    required this.petsAllowed,
    this.hostFirstName,
    this.hostLastName,
    this.hostProfileImage,
    this.hostBio,
    this.hostName,
    this.additionalImages,
    this.hostAverageRating,
    this.hostReviewCount,
  });

  factory Property.fromJson(Map<String, dynamic> json) => Property(
        id: json["id"],
        title: json["title"] ?? "",
        description: json["description"] ?? "",
        category: json["category"] ?? "",
        address: json["address"] ?? "",
        city: json["city"] ?? "",
        state: json["state"] ?? "",
        zipCode: json["zip_code"] ?? "",
        bedrooms: json["bedrooms"] ?? 0,
        bathrooms: json["bathrooms"] ?? "",
        propertyType: json["property_type"] ?? "",
        status: json["status"] ?? "",
        image: json["image"] ?? "",
        isNew: json["isNew"] ?? 0,
        isFeatured: json["isFeatured"] ?? 0,
        isVerified: json["isVerified"] ?? 0,
        parkingSpaces: json["parkingSpaces"] ?? 0,
        hostId: json["host_id"] ?? 0,
        averageRating: json["average_rating"] ?? "",
        views: json["views"] ?? 0,
        createdAt: json["created_at"] ?? "",
        updatedAt: json["updated_at"] ?? "",
        lat: json["lat"] ?? "",
        lng: json["lng"] ?? "",
        amenities: json["amenities"] != null
            ? List<String>.from(json["amenities"].map((x) => x))
            : [],
        petsAllowed: json["pets_allowed"] != null
            ? List<String>.from(json["pets_allowed"].map((x) => x))
            : [],
        hostFirstName: json["host_first_name"] ?? "",
        hostLastName: json["host_last_name"] ?? "",
        hostProfileImage: json["host_profile_image"] ?? "",
        hostBio: json["host_bio"] ?? "",
        hostName: json["host_name"] ?? "",
        additionalImages: json["additional_images"] != null
            ? List<String>.from(json["additional_images"].map((x) => x))
            : [],
        hostAverageRating: json["host_average_rating"] ?? 0,
        hostReviewCount: json["host_review_count"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "address": address,
        "category": category,
        "city": city,
        "state": state,
        "zip_code": zipCode,
        "bedrooms": bedrooms,
        "bathrooms": bathrooms,
        "property_type": propertyType,
        "status": status,
        "image": image,
        "isNew": isNew,
        "isFeatured": isFeatured,
        "isVerified": isVerified,
        "parkingSpaces": parkingSpaces,
        "host_id": hostId,
        "average_rating": averageRating,
        "views": views,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "lat": lat,
        "lng": lng,
        "amenities": amenities,
        "pets_allowed": petsAllowed,
        "host_first_name": hostFirstName,
        "host_last_name": hostLastName,
        "host_profile_image": hostProfileImage,
        "host_bio": hostBio,
        "host_name": hostName,
        "additional_images": additionalImages,
        "host_average_rating": hostAverageRating,
        "host_review_count": hostReviewCount,
      };
}
