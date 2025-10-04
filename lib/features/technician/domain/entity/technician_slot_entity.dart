class TechnicianSlotEntity {
  final String slotId;
  final String label;
  final String? startTime;
  final String? endTime;
  final String? slotTime;
  final Map<String, dynamic> raw;

  const TechnicianSlotEntity({
    required this.slotId,
    required this.label,
    this.startTime,
    this.endTime,
    this.slotTime,
    this.raw = const <String, dynamic>{},
  });
}
