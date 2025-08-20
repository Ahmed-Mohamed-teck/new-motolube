class PromotionEntity {
  final String id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String imageUrl;

  PromotionEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.imageUrl,
  });
}