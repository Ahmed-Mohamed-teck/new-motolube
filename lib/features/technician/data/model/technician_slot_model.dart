import '../../domain/entity/technician_slot_entity.dart';

class TechnicianSlotModel extends TechnicianSlotEntity {
  TechnicianSlotModel({
    required String slotId,
    required String label,
    String? startTime,
    String? endTime,
    String? slotTime,
    Map<String, dynamic> raw = const <String, dynamic>{},
  }) : super(
         slotId: slotId,
         label: label,
         startTime: startTime,
         endTime: endTime,
         slotTime: slotTime,
         raw: raw,
       );

  factory TechnicianSlotModel.fromDynamic(dynamic data) {
    if (data is TechnicianSlotModel) {
      return data;
    }
    if (data is Map<String, dynamic>) {
      return _fromMap(data);
    }
    if (data is Map) {
      return _fromMap(
        data.map((key, value) => MapEntry(key.toString(), value)),
      );
    }

    final value = data?.toString() ?? '';
    final trimmed = value.trim();

    return TechnicianSlotModel(
      slotId: trimmed.isNotEmpty ? trimmed : 'slot',
      label: trimmed.isNotEmpty ? trimmed : 'Slot',
      slotTime: trimmed.isNotEmpty ? trimmed : null,
      raw: <String, dynamic>{'value': data},
    );
  }

  TechnicianSlotEntity toEntity() {
    return TechnicianSlotEntity(
      slotId: slotId.isNotEmpty ? slotId : label,
      label: label,
      startTime: startTime,
      endTime: endTime,
      slotTime: slotTime,
      raw: raw,
    );
  }

  static TechnicianSlotModel _fromMap(Map<String, dynamic> json) {
    final slotId = _stringForKeys(json, const <String>[
      'slotId',
      'SlotId',
      'slot_id',
      'id',
      'Id',
      'slotCode',
      'SlotCode',
    ]);

    final start = _stringForKeys(json, const <String>[
      'startTime',
      'StartTime',
      'from',
      'From',
      'slotStart',
      'SlotStart',
      'timeFrom',
      'TimeFrom',
      'start_time',
      'Start_time',
    ]);

    final end = _stringForKeys(json, const <String>[
      'endTime',
      'EndTime',
      'to',
      'To',
      'slotEnd',
      'SlotEnd',
      'timeTo',
      'TimeTo',
      'end_time',
      'End_time',
    ]);

    final label = _stringForKeys(json, const <String>[
      'displayText',
      'DisplayText',
      'label',
      'Label',
      'slotName',
      'SlotName',
      'name',
      'Name',
      'timeRange',
      'TimeRange',
      'title',
      'Title',
      'description',
      'Description',
    ]);

    final slotTime = _stringForKeys(json, const <String>[
      'slotTime',
      'SlotTime',
      'time',
      'Time',
    ]);

    final derivedLabel =
        label ??
        slotTime ??
        _formatRange(start, end) ??
        _firstStringValue(json.values);
    final fallbackLabel =
        derivedLabel?.isNotEmpty == true ? derivedLabel!.trim() : 'Slot';
    final resolvedSlotId =
        slotId?.isNotEmpty == true
            ? slotId!.trim()
            : (derivedLabel?.isNotEmpty == true
                ? derivedLabel!.trim()
                : 'slot');

    return TechnicianSlotModel(
      slotId: resolvedSlotId,
      label: fallbackLabel,
      startTime: start,
      endTime: end,
      slotTime: slotTime,
      raw: json,
    );
  }

  static String? _stringForKeys(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
      if (value != null && value is! String) {
        final asString = value.toString().trim();
        if (asString.isNotEmpty) {
          return asString;
        }
      }
    }
    return null;
  }

  static String? _firstStringValue(Iterable<dynamic> values) {
    for (final value in values) {
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return null;
  }

  static String? _formatRange(String? start, String? end) {
    if (start == null || start.isEmpty) {
      return null;
    }
    if (end == null || end.isEmpty) {
      return start;
    }
    return '$start - $end';
  }
}
