import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newmotorlube/core/widget/internal_app_bar.dart';

import '../../domain/entity/technician_appointment_entity.dart';
import '../../provider/technician_provider.dart';
import '../../../../generated/l10n.dart';

class TechnicianChecklistScreen extends ConsumerStatefulWidget {
  const TechnicianChecklistScreen({super.key, required this.appointment});

  final TechnicianAppointmentEntity appointment;

  @override
  ConsumerState<TechnicianChecklistScreen> createState() =>
      _TechnicianChecklistScreenState();
}

class _TechnicianChecklistScreenState
    extends ConsumerState<TechnicianChecklistScreen> {
  final List<_ChecklistItem> _items = [];
  bool _isLoading = true;
  bool _isSaving = false;

  String get _bookingId => widget.appointment.bookingId;
  String get _srNumber => widget.appointment.srNumber;

  @override
  void initState() {
    super.initState();
    _loadChecklist();
  }

  @override
  void dispose() {
    for (final item in _items) {
      item.controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadChecklist() async {
    setState(() => _isLoading = true);
    try {
      final firestore = FirebaseFirestore.instance;
      final snapshot = await firestore
          .collection('completedChecklists')
          .where('bookingId', isEqualTo: _bookingId)
          .limit(1)
          .get();
      for (final item in _items) {
        item.controller.dispose();
      }
      _items.clear();
      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        final List<dynamic> rows = data['checklist'] ?? const [];
        for (final raw in rows) {
          if (raw is Map<String, dynamic>) {
            _items.add(
              _ChecklistItem(
                question: (raw['question'] ?? '').toString(),
                response: (raw['response'] ?? 'C').toString(),
                controller: TextEditingController(
                  text: (raw['comment'] ?? '').toString(),
                ),
              ),
            );
          }
        }
      } else {
        _createDefaultChecklist();
      }
    } catch (error) {
      _showSnack(S.of(context).failedToLoadChecklistError(error.toString()));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _createDefaultChecklist() {
    const defaults = [
      'Seats, steering and floor coverings / تلبيس المقاعد و المقود والأرضية',
      'Engine oil and filter / زيت المحرك واستبدال فلتر الزيت',
      'Engine air filter / فلتر هواء المحرك',
      'A/C filter / فلتر هواء المكيف',
      'A/C belt / سير المكيف',
      'Brake pedal and parking brake / دواسة الفرامل وفرامل الوقوف',
      'Oils and fluids (leaks + adjustment) / السوئل والتهريب وإكمال ما نقص منها',
      'Adjust tires pressure + Spare / ضغط إطارات الهواء + الاحتياطي',
      'Drive belts / السيور',
      'Engine coolant / سائل تبريد المحرك',
      'Exhaust pipes and mountings / أنابيب العادم وأجزاء التثبيت',
      'Inspect lights, horn and wipers / الأضواء، البوق والمساحات',
      'Inspect front and rear suspension / نظام التعليق الأمامي والخلفي',
      'Inspect engine battery / أداء البطارية',
      'Inspect brake pads and discs / أقمشة وأقراص الفرامل',
      'Reset service reminder / إعادة ضبط مؤشر تذكير الصيانة',
      'Spark plugs / شمعات الاحتراق',
      'Fuel filter / فلتر البنزين',
      'Brake fluid / سائل الفرامل',
      'Steering fluid / سائل التوجيه',
      'Rear differential oil / زيت الدفرنس الخلفي',
      'Front differential oil / زيت الدفرنس الأمامي',
      '4X4 Transfer fluid / زيت الدبل 4x4',
      'ATF fluid / سائل ناقل الحركة الأوتوماتيك',
    ];
    for (final item in _items) {
      item.controller.dispose();
    }
    _items
      ..clear()
      ..addAll(
        defaults.map(
          (question) => _ChecklistItem(
            question: question,
            response: 'C',
            controller: TextEditingController(),
          ),
        ),
      );
  }

  Future<void> _saveChecklist() async {
    setState(() => _isSaving = true);
    try {
      final firestore = FirebaseFirestore.instance;
      final collection = firestore.collection('completedChecklists');
      final payload = {
        'bookingId': _bookingId,
        'jobCardNumber': _srNumber,
        'checklist': _items
            .map(
              (item) => {
                'question': item.question,
                'response': item.response,
                'comment': item.controller.text,
              },
            )
            .toList(),
      };
      final existing =
          await collection.where('bookingId', isEqualTo: _bookingId).limit(1).get();
      if (existing.docs.isNotEmpty) {
        await collection.doc(existing.docs.first.id).update(payload);
      } else {
        await collection.add(payload);
      }
      await firestore.collection('bookings').doc(_bookingId).update({
        'hasCheckList': true,
      }).catchError((_) {});

      final result = await ref.read(postChecklistUseCaseProvider)(
        srNumber: _srNumber,
        checklistId: _bookingId,
        data: payload,
      );
      if (!mounted) return;
      if (result.success) {
        _showSnack(result.message.isNotEmpty ? result.message : S.of(context).checklistSubmittedMessage);
        Navigator.of(context).pop(true);
      } else {
        _showSnack(result.message.isNotEmpty ? result.message : S.of(context).failedToSubmitChecklistMessage);
      }
    } catch (error) {
      if (!mounted) return;
      _showSnack(S.of(context).failedToSaveChecklistError(error.toString()));
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InternalAppBar(title: S.of(context).vehicleChecklistTitle),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildLegend(),
                  const SizedBox(height: 16),
                  if (_items.isEmpty)
                    Column(
                      children: [
                        Text(S.of(context).noChecklistFound),
                        TextButton.icon(
                          onPressed: () {
                            setState(_createDefaultChecklist);
                          },
                          icon: const Icon(Icons.playlist_add),
                          label: Text(S.of(context).createDefaultChecklistButtonLabel),
                        ),
                      ],
                    )
                  else
                    Column(
                      children:
                          _items.asMap().entries.map(
                            (entry) => _ChecklistCard(
                              index: entry.key + 1,
                              item: entry.value,
                              onResponseChanged: (value) {
                                setState(() {
                                  entry.value.response = value;
                                });
                              },
                            ),
                          ).toList(),
                    ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _isSaving ? null : _saveChecklist,
                    icon:
                        _isSaving
                            ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Icon(Icons.save_outlined),
                    label: Text(_isSaving ? S.of(context).savingEllipsis : S.of(context).saveChecklistButtonLabel),
                  ),
                ],
              ),
    );
  }

  Widget _buildLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).legendTitle,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(S.of(context).legendCleanLabel),
        Text(S.of(context).legendReplaceLabel),
        Text(S.of(context).legendInspectLabel),
        Text(S.of(context).legendNotApplicableLabel),
      ],
    );
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _ChecklistItem {
  _ChecklistItem({
    required this.question,
    required this.response,
    required TextEditingController controller,
  }) : controller = controller;

  final String question;
  final TextEditingController controller;
  String response;
}

class _ChecklistCard extends StatelessWidget {
  const _ChecklistCard({
    required this.index,
    required this.item,
    required this.onResponseChanged,
  });

  final int index;
  final _ChecklistItem item;
  final ValueChanged<String> onResponseChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$index. ${item.question}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: ['C', 'R', 'I', 'X']
                  .map(
                    (value) => Expanded(
                      child: RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text(value),
                        value: value,
                        groupValue: item.response,
                        onChanged:
                            (selection) =>
                                selection != null
                                    ? onResponseChanged(selection)
                                    : null,
                      ),
                    ),
                  )
                  .toList(),
            ),
            TextField(
              controller: item.controller,
              decoration: InputDecoration(
                labelText: S.of(context).commentLabel,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
