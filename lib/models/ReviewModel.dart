class Review {
  final int? id;
  final int? propertyId;
  final int? reviewerId;
  final String? reviewerName;
  final String? email;
  final int? rating;
  final String? comment;
  final int? likes;
  final int? dislikes;
  final String? createdAt;
  final String? updatedAt;
  final String? propertyTitle;
  final String? reviewerFirstName;
  final String? reviewerLastName;
  final String? profileImage;

  Review({
    this.id,
    this.propertyId,
    this.reviewerId,
    this.reviewerName,
    this.email,
    this.rating,
    this.comment,
    this.likes,
    this.dislikes,
    this.createdAt,
    this.updatedAt,
    this.propertyTitle,
    this.reviewerFirstName,
    this.reviewerLastName,
    this.profileImage,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        propertyId: json["property_id"],
        reviewerId: json["reviewer_id"],
        reviewerName: json["reviewer_name"] ?? '',
        email: json["email"] ?? '',
        rating: json["rating"] ?? 0,
        comment: json["comment"] ?? '',
        likes: json["likes"] ?? 0,
        dislikes: json["dislikes"] ?? 0,
        createdAt: json["created_at"] ?? '',
        updatedAt: json["updated_at"] ?? '',
        propertyTitle: json["property_title"] ?? '',
        reviewerFirstName: json["reviewer_first_name"] ?? '',
        reviewerLastName: json["reviewer_last_name"] ?? '',
        profileImage: json["profile_image"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "user_id": reviewerId,
        "property_id": propertyId,
        "rating": rating,
        "comment": comment
      };
}
