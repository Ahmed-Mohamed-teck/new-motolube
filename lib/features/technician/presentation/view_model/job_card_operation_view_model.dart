import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/use_case/add_custom_package_item_use_case.dart';
import '../../domain/use_case/add_package_to_job_card_use_case.dart';
import '../../domain/use_case/delete_custom_package_item_use_case.dart';
import '../../domain/use_case/delete_package_from_job_card_use_case.dart';
import '../../domain/use_case/post_checklist_use_case.dart';
import 'job_card_operation_state.dart';

class JobCardOperationViewModel
    extends StateNotifier<JobCardOperationState> {
  JobCardOperationViewModel(
    this._addCustomPackageItemUseCase,
    this._deleteCustomPackageItemUseCase,
    this._addPackageToJobCardUseCase,
    this._deletePackageFromJobCardUseCase,
    this._postChecklistUseCase,
  ) : super(const JobCardOperationInitial());

  final AddCustomPackageItemUseCase _addCustomPackageItemUseCase;
  final DeleteCustomPackageItemUseCase _deleteCustomPackageItemUseCase;
  final AddPackageToJobCardUseCase _addPackageToJobCardUseCase;
  final DeletePackageFromJobCardUseCase _deletePackageFromJobCardUseCase;
  final PostChecklistUseCase _postChecklistUseCase;

  Future<void> addItem({
    required String jobCardNumber,
    required String lineId,
    required String categoryId,
    required String inventoryItemId,
    required String qty,
    required String userId,
  }) async {
    state = const JobCardOperationLoading(JobCardOperationType.addCustomItem);
    try {
      final result = await _addCustomPackageItemUseCase(
        jobCardNumber: jobCardNumber,
        lineId: lineId,
        categoryId: categoryId,
        inventoryItemId: inventoryItemId,
        qty: qty,
        userId: userId,
      );
      if (result.success) {
        state = JobCardOperationSuccess(
          JobCardOperationType.addCustomItem,
          result.message.isNotEmpty
              ? result.message
              : 'Item added successfully.',
        );
      } else {
        state = JobCardOperationFailure(
          JobCardOperationType.addCustomItem,
          result.message.isNotEmpty
              ? result.message
              : 'Failed to add item.',
        );
      }
    } catch (error) {
      state = JobCardOperationFailure(
        JobCardOperationType.addCustomItem,
        _humanizeMessage(error.toString()),
      );
    }
  }

  Future<void> deleteItem({required String srLineId}) async {
    state = const JobCardOperationLoading(
      JobCardOperationType.deleteCustomItem,
    );
    try {
      final result = await _deleteCustomPackageItemUseCase(
        srLineId: srLineId,
      );
      if (result.success) {
        state = JobCardOperationSuccess(
          JobCardOperationType.deleteCustomItem,
          result.message.isNotEmpty
              ? result.message
              : 'Item deleted successfully.',
        );
      } else {
        state = JobCardOperationFailure(
          JobCardOperationType.deleteCustomItem,
          result.message.isNotEmpty
              ? result.message
              : 'Failed to delete item.',
        );
      }
    } catch (error) {
      state = JobCardOperationFailure(
        JobCardOperationType.deleteCustomItem,
        _humanizeMessage(error.toString()),
      );
    }
  }

  Future<void> addPackage({
    required String srNumber,
    required String packageId,
    required String userId,
    String campaignLineId = '',
  }) async {
    state = const JobCardOperationLoading(JobCardOperationType.addPackage);
    try {
      final result = await _addPackageToJobCardUseCase(
        srNumber: srNumber,
        packageId: packageId,
        userId: userId,
        campaignLineId: campaignLineId,
      );
      if (result.success) {
        state = JobCardOperationSuccess(
          JobCardOperationType.addPackage,
          result.message.isNotEmpty
              ? result.message
              : 'Package added successfully.',
        );
      } else {
        state = JobCardOperationFailure(
          JobCardOperationType.addPackage,
          result.message.isNotEmpty
              ? result.message
              : 'Failed to add package.',
        );
      }
    } catch (error) {
      state = JobCardOperationFailure(
        JobCardOperationType.addPackage,
        _humanizeMessage(error.toString()),
      );
    }
  }

  Future<void> submitChecklist({
    required String srNumber,
    required String checklistId,
    required Map<String, dynamic> data,
  }) async {
    state = const JobCardOperationLoading(JobCardOperationType.submitChecklist);
    try {
      final result = await _postChecklistUseCase(
        srNumber: srNumber,
        checklistId: checklistId,
        data: data,
      );
      if (result.success) {
        state = JobCardOperationSuccess(
          JobCardOperationType.submitChecklist,
          result.message.isNotEmpty
              ? result.message
              : 'Checklist submitted successfully.',
        );
      } else {
        state = JobCardOperationFailure(
          JobCardOperationType.submitChecklist,
          result.message.isNotEmpty
              ? result.message
              : 'Failed to submit checklist.',
        );
      }
    } catch (error) {
      state = JobCardOperationFailure(
        JobCardOperationType.submitChecklist,
        _humanizeMessage(error.toString()),
      );
    }
  }

  Future<void> deletePackage({
    required String packageLineId,
    required String userId,
  }) async {
    state = const JobCardOperationLoading(JobCardOperationType.deletePackage);
    try {
      final result = await _deletePackageFromJobCardUseCase(
        packageLineId: packageLineId,
        userId: userId,
      );
      if (result.success) {
        state = JobCardOperationSuccess(
          JobCardOperationType.deletePackage,
          result.message.isNotEmpty
              ? result.message
              : 'Package deleted successfully.',
        );
      } else {
        state = JobCardOperationFailure(
          JobCardOperationType.deletePackage,
          result.message.isNotEmpty
              ? result.message
              : 'Failed to delete package.',
        );
      }
    } catch (error) {
      state = JobCardOperationFailure(
        JobCardOperationType.deletePackage,
        _humanizeMessage(error.toString()),
      );
    }
  }

  void reset() {
    state = const JobCardOperationInitial();
  }

  String _humanizeMessage(String message) {
    if (message.toLowerCase().contains('timeout')) {
      return 'Connection timed out. Please try again.';
    }
    if (message.toLowerCase().contains('socket')) {
      return 'Network connection issue. Please retry.';
    }
    return message.isNotEmpty ? message : 'Something went wrong.';
  }
}
