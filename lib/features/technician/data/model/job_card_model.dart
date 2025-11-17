import '../../domain/entity/job_card_entity.dart';

class JobCardModel extends JobCardEntity {
  JobCardModel({
    required super.srNumber,
    required super.srStatus,
    required super.openDate,
    required super.branch,
    required super.technicianName,
    required super.customerName,
    required super.vin,
    super.raw,
  });

  factory JobCardModel.fromJson(Map<String, dynamic> json) {
    return JobCardModel(
      srNumber: (json['srNumber'] ?? '').toString(),
      srStatus: (json['srStatus'] ?? '').toString(),
      openDate: (json['openDate'] ?? '').toString(),
      branch: (json['branch'] ?? json['branchId'] ?? '').toString(),
      technicianName: (json['userName'] ?? '').toString(),
      customerName: (json['customer'] ?? json['customerName'] ?? '').toString(),
      vin: (json['vin'] ?? '').toString(),
      raw: Map<String, dynamic>.from(json),
    );
  }

  JobCardEntity toEntity() {
    return JobCardEntity(
      srNumber: srNumber,
      srStatus: srStatus,
      openDate: openDate,
      branch: branch,
      technicianName: technicianName,
      customerName: customerName,
      vin: vin,
      raw: raw,
    );
  }
}
