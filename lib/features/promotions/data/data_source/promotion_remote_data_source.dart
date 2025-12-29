import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../model/promotion_model.dart';
import 'i_promotion_remote_data_source.dart';

class PromotionRemoteDataSourceImpl implements IPromotionRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  PromotionRemoteDataSourceImpl(this.firestore, this.storage);

  @override
  Future<void> uploadPromotion(PromotionModel promotion) async {
    final docId = promotion.id.isNotEmpty
        ? promotion.id
        : const Uuid().v4();
    await firestore.collection('promotions').doc(docId).set(
          promotion.toJson()..['id'] = docId,
        );
  }

  @override
  Future<String> uploadImage(File imageFile) async {
    final fileId = const Uuid().v4();
    final ref = storage.ref().child('promotions/$fileId.png');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  @override
  Future<List<PromotionModel>> fetchPromotions() async {
    final snapshot = await firestore
        .collection('promotions')
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => PromotionModel.fromJson(doc.data(), documentId: doc.id))
        .toList();
  }

  @override
  Future<void> deletePromotion(String promotionId) {
    return firestore.collection('promotions').doc(promotionId).delete();
  }
}
