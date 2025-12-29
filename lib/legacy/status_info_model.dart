class StatusInfoModel {
  StatusInfoModel({
    this.status = '',
    this.message = '',
  });

  final String status;
  final String message;

  factory StatusInfoModel.fromJson(Map<String, dynamic> json) {
    return StatusInfoModel(
      status: json['status'] as String? ?? '',
      message: json['message'] as String? ?? '',
    );
  }
}
