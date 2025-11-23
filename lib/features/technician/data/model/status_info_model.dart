class StatusInfoModel {
  final String code;
  final String type;
  final String description;

  const StatusInfoModel({
    required this.code,
    required this.type,
    required this.description,
  });

  factory StatusInfoModel.fromDynamic(dynamic source) {
    if (source is Map<String, dynamic>) {
      return StatusInfoModel(
        code: (source['infoCode'] ?? '').toString(),
        type: (source['infoType'] ?? '').toString(),
        description:
            (source['infoDescriptionEN'] ??
                    source['infoDescription'] ??
                    source['infoDescriptionAR'] ??
                    source['InfoDescription'] ??
                    '')
                .toString(),
      );
    }
    if (source is Map) {
      return StatusInfoModel(
        code: (source['infoCode'] ?? '').toString(),
        type: (source['infoType'] ?? '').toString(),
        description:
            (source['infoDescriptionEN'] ??
                    source['infoDescription'] ??
                    source['infoDescriptionAR'] ??
                    source['InfoDescription'] ??
                    '')
                .toString(),
      );
    }
    return const StatusInfoModel(code: '', type: '', description: '');
  }

  bool get isSuccess {
    final normalizedType = type.toLowerCase();
    final normalizedDescription = description.toLowerCase();
    if (code == '0001') return true;
    if (normalizedType.contains('success')) return true;
    if (normalizedDescription.contains('success')) return true;
    return false;
  }
}
