import 'package:newmotorlube/features/upcoming_service/data/model/upcoming_service_model.dart';

import '../../../upcoming_service/data/data_source/upcoming_service_remote_data_source.dart';
import '../entity/technician_appointment_entity.dart';
import '../repository/i_technician_repository.dart';

class GetCustomerAppointmentsUseCase {
  const GetCustomerAppointmentsUseCase(this._repository);

  final UpcomingServiceRemoteDataSourceImpl _repository;

  Future<List<UpcomingServiceModel>> call({
    required String userId,
    required String fromDate,
    required String toDate,
    required String statusId,
  }) {
    return _repository.getUpcomingServices(
      userId: userId,
      fromDate: fromDate,
      toDate: toDate,
      statusId: statusId,
    );
  }
}
