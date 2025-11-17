import '../entity/job_card_entity.dart';
import '../repository/i_technician_repository.dart';

class CreateJobCardUseCase {
  const CreateJobCardUseCase(this._repository);

  final ITechnicianRepository _repository;

  Future<List<JobCardEntity>> call({
    required String fireBaseId,
    required String phoneNumber,
    required String vin,
    required String mileage,
    required String couponNumber,
    required String isEstimation,
    required String bookingId,
  }) {
    return _repository.createServiceRequest(
      fireBaseId: fireBaseId,
      phoneNumber: phoneNumber,
      vin: vin,
      mileage: mileage,
      couponNumber: couponNumber,
      isEstimation: isEstimation,
      bookingId: bookingId,
    );
  }
}
