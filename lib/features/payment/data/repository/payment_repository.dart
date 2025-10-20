import '../../domain/entity/payment_initiation_request.dart';
import '../../domain/entity/payment_initiation_result.dart';
import '../../domain/repository/i_payment_repository.dart';
import '../data_source/i_payment_remote_data_source.dart';
import '../model/payment_initiation_request_model.dart';

class PaymentRepository implements IPaymentRepository {
  PaymentRepository(this._remoteDataSource);

  final IPaymentRemoteDataSource _remoteDataSource;

  @override
  Future<PaymentInitiationResult> initiatePayment(
    PaymentInitiationRequest request,
  ) {
    return _remoteDataSource.initiatePayment(
      PaymentInitiationRequestModel(
        amount: request.amount,
        currency: request.currency,
        orderId: request.orderId,
        customerId: request.customerId,
        customerEmail: request.customerEmail,
        metadata: PaymentMetadataModel(
          appVersion: request.metadata.appVersion,
          platform: request.metadata.platform,
          locale: 'ar',
          deviceId: request.metadata.deviceId,
          userAgent: request.metadata.userAgent,
        ),
        appliedCoupon: request.appliedCoupon,
        discount: request.discount,
      ),
    );
  }
}
