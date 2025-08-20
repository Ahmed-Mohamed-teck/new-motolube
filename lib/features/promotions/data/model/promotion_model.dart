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

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: (json['endDate'] as Timestamp).toDate(),
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'imageUrl': imageUrl,
      'createdAt': DateTime.now(),
    };
  }
}
