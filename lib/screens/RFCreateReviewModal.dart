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
  State<RFCreateReviewModal> createState() => _RFCreateReviewModalState();
}

class _RFCreateReviewModalState extends State<RFCreateReviewModal> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController commentController = TextEditingController();
  double rating = 0;
  String userName = '';
  String userId = '';
  String userEmail = '';
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    userName = await getStringAsync('user_name');
    userId = await getStringAsync('user_id');
    userEmail = await getStringAsync('user_email');
    setState(() {});
  }

  Future<void> submitReview() async {
    if (!_formKey.currentState!.validate() || rating == 0) {
      toast(
          'Por favor completa todos los campos y selecciona una calificación.');
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    Review review = Review(
      propertyId: widget.propertyId,
      reviewerId: int.tryParse(userId) ?? 0,
      reviewerName: userName.trim(),
      email: userEmail.trim(),
      rating: rating.toInt(),
      comment: commentController.text.trim(),
    );

    bool success = await ReviewService().createReview(review);

    setState(() {
      isSubmitting = false;
    });

    if (success) {
      toast('Reseña enviada exitosamente');
      widget.onReviewSubmitted();
      finish(context);
    } else {
      toast('Error al enviar la reseña');
    }
  }

  InputDecoration _inputDecoration({required String labelText}) {
    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: radiusOnly(topLeft: 20, topRight: 20),
        backgroundColor: context.cardColor,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Deja una reseña', style: boldTextStyle(size: 18)),
            16.height,
            TextFormField(
              controller: commentController,
              maxLines: 3,
              decoration: _inputDecoration(labelText: "Comentario"),
              validator: (value) =>
                  value!.isEmpty ? 'Por favor ingresa un comentario' : null,
            ),
            16.height,
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    Icons.star,
                    color: index < rating ? Colors.amber : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      rating = (index + 1).toDouble();
                    });
                  },
                );
              }),
            ),
            16.height,
            isSubmitting
                ? CircularProgressIndicator(color: rf_primaryColor)
                : AppButton(
                    text: 'Enviar',
                    color: rf_primaryColor,
                    textStyle: boldTextStyle(color: white),
                    onTap: submitReview,
                    width: context.width(),
                  ),
          ],
        ),
      ),
    );
  }
}
