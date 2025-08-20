import '../../../../core/utils/enum.dart';

class AuthFlowState {
  final AuthFlowStep step;
  final String? fullPhone; // cached after validation/compose
  final bool loading;
  const AuthFlowState({this.step = AuthFlowStep.enterPhone, this.fullPhone, this.loading = false});

  AuthFlowState copyWith({AuthFlowStep? step, String? fullPhone, bool? loading}) =>
      AuthFlowState(step: step ?? this.step, fullPhone: fullPhone ?? this.fullPhone, loading: loading ?? this.loading);
}

