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
    await firestore.collection('promotions').add(promotion.toJson());
  }

  @override
  Future<String> uploadImage(File imageFile) async {
    final fileId = const Uuid().v4();
    final ref = storage.ref().child('promotions/$fileId.png');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }
}
