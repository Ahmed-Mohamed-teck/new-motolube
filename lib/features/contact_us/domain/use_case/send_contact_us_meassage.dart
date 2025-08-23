import 'package:newmotorlube/features/contact_us/domain/repository/i_contact_us_repository.dart';

class SendContactUsMessageUseCase {
  final IContactUsRepository _contactUsRepository;

  SendContactUsMessageUseCase(this._contactUsRepository);

  Future<bool> call(String name,String phoneNumber,String email,String message) async {
    return await _contactUsRepository.sendContactUsMessage(
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      message: message,
    );
  }
}