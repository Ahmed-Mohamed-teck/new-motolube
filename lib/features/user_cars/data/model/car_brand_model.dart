import 'package:newmotorlube/features/user_cars/domain/entity/car_brand_entity.dart';


class CarBrandsModel{
  final List<CarBrandModel> carBrands;

  CarBrandsModel.fromJson(Map<String, dynamic> json)
      : carBrands = (json['brands'] as List)
      .map((e) => CarBrandModel(
    id: e['id'].toString(),
    name: e['name'],
  ))
      .toList();
}




class CarBrandModel extends CarBrandEntity{
  final String id;
  final String name;

  CarBrandModel({required this.id, required this.name}) : super(id: id, name: name);
}