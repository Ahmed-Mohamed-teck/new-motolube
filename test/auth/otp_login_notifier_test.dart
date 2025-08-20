import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:newmotorlube/core/storage/secure_store.dart';
import 'package:newmotorlube/features/auth/data/model/auth_exceptions.dart';
import 'package:newmotorlube/features/auth/data/model/send_otp_response.dart';
import 'package:newmotorlube/features/auth/data/model/verify_otp_response.dart';
import 'package:newmotorlube/features/auth/data/model/tokens_model.dart';
import 'package:newmotorlube/features/auth/domain/repository/i_auth_repository.dart';
import 'package:newmotorlube/features/auth/presentation/state/otp_login_state.dart';
import 'package:newmotorlube/features/auth/presentation/view_model/otp_login_notifier.dart';

class MockRepo extends Mock implements IAuthRepository {}
class MockStore extends Mock implements SecureStore {}

void main() {
  late MockRepo repo;
  late MockStore store;
  late OtpLoginNotifier notifier;

  setUp(() {
    repo = MockRepo();
    store = MockStore();
    notifier = OtpLoginNotifier(repo, store);
  });

  test('sendOtp success -> awaitingOtp', () async {
    when(() => repo.sendOtp(any())).thenAnswer(
        (_) async => SendOtpResponse(message: '', mobileNumber: '', expiresIn: 30));
    notifier.updatePhone('+966500000000');
    await notifier.sendOtp();
    expect(notifier.state.status, OtpLoginStatus.awaitingOtp);
  });

  test('sendOtp unregistered -> registration', () async {
    when(() => repo.sendOtp(any())).thenThrow(UnregisteredUserException());
    notifier.updatePhone('+966500000000');
    await notifier.sendOtp();
    expect(notifier.state.status, OtpLoginStatus.registration);
  });

  test('verifyOtp success -> authenticated', () async {
    when(() => repo.verifyOtp(any())).thenAnswer((_) async => VerifyOtpResponse(
          message: 'OTP verified successfully',
          user: User(
              id: '1', name: 'n', mobileNumber: '+9665', email: null, isVerified: true),
          tokens: TokensModel(
              firebaseToken: 'f', jwtToken: 'j', tokenType: 'Bearer', expiresIn: 10),
        ));
    notifier
      ..updatePhone('+966500000000')
      ..updateOtp('123456');
    await notifier.verifyOtp();
    expect(notifier.state.isAuthenticated, true);
    verify(() => store.saveAuth(any())).called(1);
  });
}
