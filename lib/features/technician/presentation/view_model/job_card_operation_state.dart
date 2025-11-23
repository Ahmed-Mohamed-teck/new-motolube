enum JobCardOperationType {
  addCustomItem,
  deleteCustomItem,
  addPackage,
  deletePackage,
  submitChecklist,
}

sealed class JobCardOperationState {
  const JobCardOperationState();
}

class JobCardOperationInitial extends JobCardOperationState {
  const JobCardOperationInitial();
}

class JobCardOperationLoading extends JobCardOperationState {
  const JobCardOperationLoading(this.operationType);

  final JobCardOperationType operationType;
}

class JobCardOperationSuccess extends JobCardOperationState {
  const JobCardOperationSuccess(this.operationType, this.message);

  final JobCardOperationType operationType;
  final String message;
}

class JobCardOperationFailure extends JobCardOperationState {
  const JobCardOperationFailure(this.operationType, this.message);

  final JobCardOperationType operationType;
  final String message;
}
