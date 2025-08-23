abstract class ContactUsState{}

class ContactUsInitial extends ContactUsState {}

class SendingContactUsMessage extends ContactUsState {}

class ContactUsMessageSent extends ContactUsState{}

class ContactUsMessageFailed extends ContactUsState {
  final String errorMessage;

  ContactUsMessageFailed(this.errorMessage);
}

