import '../../domain/entity/create_appointment_result.dart';
import '../../domain/entity/service_package_entity.dart';
import '../../domain/repository/i_book_service_repository.dart';
import '../data_source/i_book_service_remote_data_source.dart';

class BookServiceRepository implements IBookServiceRepository {
  final IBookServiceRemoteDataSource _remoteDataSource;

  BookServiceRepository(this._remoteDataSource);

  @override
  Future<List<ServicePackageEntity>> getPackagesForVehicle({
    required String customerId,
    required String vehicleId,
    String? category,
  }) async {
    final models = await _remoteDataSource.getPackagesForVehicle(
      customerId: customerId,
      vehicleId: vehicleId,
      category: category,
    );
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<CreateAppointmentResult> createAppointment({
    required String bookingDate,
    required String branchId,
    required String userId,
    required String latitude,
    required String longitude,
    required String mileage,
    required String partyId,
    required String vehicleId,
    required String packageId,
    required String selectedSlot,
    required bool isImmediateAppointment,
    required String slotTime,
  }) async {
    final payload = <String, dynamic>{
      'bookingDate': bookingDate,
      'branchId': branchId,
      'userId': userId,
      'latitude': latitude,
      'longitude': longitude,
      'mileage': mileage,
      'partyId': partyId,
      'vehicleId': vehicleId,
      'packageId': packageId,
      'selectedSlot': selectedSlot,
      'isImmediatelyAppointment': isImmediateAppointment.toString(),
      'slotTime': slotTime,
    };

    final response = await _remoteDataSource.createAppointment(
      payload: payload,
    );
    return response.toEntity();
  }
}
