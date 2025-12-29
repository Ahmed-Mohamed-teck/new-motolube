import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entity/promotion_entity.dart';

class PromotionModel extends PromotionEntity {
  PromotionModel({
    required super.id,
    required super.name,
    required super.description,
    required super.startDate,
    required super.endDate,
    required super.imageUrl,
  });

  factory PromotionModel.fromJson(
    Map<String, dynamic> json, {
    String? documentId,
  }) {
    final fallbackId = (documentId ?? '').isNotEmpty
        ? documentId!
        : (json['id'] as String? ?? '');
    return PromotionModel(
      id: fallbackId,
      name: json['name'],
      description: json['description'],
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: (json['endDate'] as Timestamp).toDate(),
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'imageUrl': imageUrl,
      'createdAt': DateTime.now(),
    };
  }
}
