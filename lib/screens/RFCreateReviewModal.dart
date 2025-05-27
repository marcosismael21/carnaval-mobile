import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:room_finder_flutter/models/ReviewModel.dart';
import 'package:room_finder_flutter/services/review_service.dart';
import 'package:room_finder_flutter/utils/RFColors.dart';
import 'package:room_finder_flutter/screens/RFEmailSignInScreen.dart'; // Asegúrate de importar tu pantalla de login

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
  bool isUserLoggedIn = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    userName = await getStringAsync('user_name');
    userId = await getStringAsync('user_id');
    userEmail = await getStringAsync('user_email');

    // Verificar si el usuario está logueado
    isUserLoggedIn =
        userName.isNotEmpty && userId.isNotEmpty && userEmail.isNotEmpty;

    setState(() {});
  }

  Future<void> submitReview() async {
    // Verificar primero si el usuario está logueado
    if (!isUserLoggedIn) {
      _showLoginDialog();
      return;
    }

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

  void _showLoginDialog() {
    showConfirmDialogCustom(
      context,
      cancelable: true,
      title: "Iniciar sesión requerido",
      subTitle:
          "Para dejar tu reseña debes iniciar sesión. ¿Quieres ir a la pantalla de login?",
      dialogType: DialogType.CONFIRMATION,
      onCancel: (v) {
        finish(context);
      },
      onAccept: (v) {
        finish(context); // Cerrar el modal actual
        RFEmailSignInScreen().launch(context, isNewTask: true);
      },
    );
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

            // Si no está logueado, mostrar mensaje informativo
            if (!isUserLoggedIn) ...[
              Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange, size: 20),
                    8.width,
                    Expanded(
                      child: Text(
                        'Debes iniciar sesión para dejar una reseña',
                        style: primaryTextStyle(size: 14, color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            TextFormField(
              controller: commentController,
              maxLines: 3,
              enabled: isUserLoggedIn, // Deshabilitar si no está logueado
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
                  onPressed: isUserLoggedIn
                      ? () {
                          setState(() {
                            rating = (index + 1).toDouble();
                          });
                        }
                      : null, // Deshabilitar si no está logueado
                );
              }),
            ),
            16.height,
            isSubmitting
                ? CircularProgressIndicator(color: rf_primaryColor)
                : AppButton(
                    text: isUserLoggedIn
                        ? 'Enviar'
                        : 'Iniciar sesión para reseñar',
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
