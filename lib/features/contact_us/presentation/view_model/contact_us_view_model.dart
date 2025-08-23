import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newmotorlube/features/contact_us/presentation/view_model/contact_us_state.dart';

import '../../domain/use_case/send_contact_us_meassage.dart';
import '../../provider/contact_us_provider.dart';

class ContactUsViewModel extends Notifier<ContactUsState>{
  late final SendContactUsMessageUseCase _sendContactUsMessageUseCase;

  @override
  ContactUsState build() {
    _sendContactUsMessageUseCase = ref.read(sendContactUsMessageUseCaseProvider);
    return ContactUsInitial();
  }

  Future<void> sendContactUsMessage(
      {required String name, required String phoneNumber, required String email, required String message}) async {
    state = SendingContactUsMessage();
    try {
      await _sendContactUsMessageUseCase(name, phoneNumber, email, message);
      state = ContactUsMessageSent();
    } catch (e) {
      state = ContactUsMessageFailed(e.toString());
    }
  }


}