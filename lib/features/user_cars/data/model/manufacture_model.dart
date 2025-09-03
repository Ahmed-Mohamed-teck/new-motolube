import '../../domain/entity/manufacture_entity.dart';

class ManufacturesModel{
  final List<ManufactureModel> manufactures;

  ManufacturesModel.fromJson(Map<String, dynamic> json)
      : manufactures = (json['manufacturers'] as List)
            .map((e) => ManufactureModel(
                  id: e['id'].toString(),
                  name: e['name'],
                ))
            .toList();
}




class ManufactureModel extends ManufactureEntity{
  final String id;
  final String name;

  ManufactureModel({required this.id, required this.name}) : super(id: id, name: name);
}