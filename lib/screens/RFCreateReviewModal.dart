import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:room_finder_flutter/models/ReviewModel.dart';
import 'package:room_finder_flutter/services/review_service.dart';
import 'package:room_finder_flutter/utils/RFColors.dart';

class RFCreateReviewModal extends StatefulWidget {
  final int propertyId;
  final VoidCallback onReviewSubmitted;

  const RFCreateReviewModal({
    Key? key,
    required this.propertyId,
    required this.onReviewSubmitted,
  }) : super(key: key);

  @override
  _RFCreateReviewModalState createState() => _RFCreateReviewModalState();
}

class _RFCreateReviewModalState extends State<RFCreateReviewModal> {
  final TextEditingController commentController = TextEditingController();
  int rating = 0;
  bool isSubmitting = false;

  String? userName;
  String? userId;

  final ReviewService _reviewService = ReviewService();

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  void loadUserInfo() async {
    userName = await getStringAsync('user_name');
    userId = await getStringAsync('user_id');
    setState(() {});
  }

  Future<void> submitReview() async {
    if (rating == 0 || commentController.text.trim().isEmpty) {
      toast('Por favor completa todos los campos');
      return;
    }

    setState(() => isSubmitting = true);

    Review newReview = Review(
      reviewerName: userName?.trim() ?? '',
      reviewerId: int.tryParse(userId ?? '0') ?? 0,
      comment: commentController.text.trim(),
      rating: rating,
      propertyId: widget.propertyId,
    );

    bool success = await _reviewService.createReview(newReview);

    setState(() => isSubmitting = false);

    if (success) {
      toast('Reseña enviada con éxito');
      widget.onReviewSubmitted();
      finish(context);
    } else {
      toast('Ocurrió un error al enviar la reseña');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: boxDecorationWithRoundedCorners(
          borderRadius: radiusOnly(topLeft: 16, topRight: 16),
          backgroundColor: context.cardColor,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Escribe una reseña', style: boldTextStyle(size: 18)),
              16.height,
              TextField(
                controller: commentController,
                maxLines: 3,
                decoration: inputDecoration(labelText: "Comentario"),
              ),
              16.height,
              Text('Calificación', style: secondaryTextStyle()),
              8.height,
              Row(
                children: List.generate(5, (index) {
                  int star = index + 1;
                  return IconButton(
                    icon: Icon(
                      star <= rating ? Icons.star : Icons.star_border,
                      color: rf_primaryColor,
                    ),
                    onPressed: () => setState(() => rating = star),
                  );
                }),
              ),
              16.height,
              AppButton(
                text: isSubmitting ? 'Enviando...' : 'Enviar',
                color: rf_primaryColor,
                textStyle: boldTextStyle(color: white),
                width: context.width(),
                onTap: isSubmitting ? null : submitReview,
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration({required String labelText}) {
    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
    );
  }
}
