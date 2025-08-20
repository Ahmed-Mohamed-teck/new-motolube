class CarEntity {
  final String id;
  final String name;
  final String model;
  final String year;
  final String vin;

  CarEntity({
    required this.id,
    required this.name,
    required this.model,
    required this.year,
    required this.vin,
  });

  @override
  String toString() {
    return 'CarEntity(id: $id, name: $name, model: $model, year: $year, vin: $vin)';
  }
}