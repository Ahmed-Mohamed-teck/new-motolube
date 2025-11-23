import '../../domain/entity/operation_result_entity.dart';
import 'status_info_model.dart';

class OperationResultModel extends OperationResultEntity {
  OperationResultModel({
    required bool success,
    required String message,
    required String code,
    required String type,
  }) : super(
          success: success,
          message: message,
          code: code,
          type: type,
        );

  factory OperationResultModel.fromStatusInfo(
    StatusInfoModel statusInfo, {
    required String defaultSuccessMessage,
    required String defaultFailureMessage,
  }) {
    final isSuccess = statusInfo.isSuccess;
    final resolvedMessage =
        statusInfo.description.trim().isNotEmpty
            ? statusInfo.description.trim()
            : (isSuccess ? defaultSuccessMessage : defaultFailureMessage);
    return OperationResultModel(
      success: isSuccess,
      message: resolvedMessage,
      code: statusInfo.code,
      type: statusInfo.type,
    );
  }
}
