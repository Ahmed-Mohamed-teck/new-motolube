class OperationResultEntity {
  final bool success;
  final String message;
  final String code;
  final String type;

  const OperationResultEntity({
    required this.success,
    required this.message,
    required this.code,
    required this.type,
  });
}
