import 'package:newmotorlube/features/contact_us/domain/repository/i_contact_us_repository.dart';

import '../data_source/i_contact_us_remote_data_source.dart';

class ContactUsRepository extends IContactUsRepository {
  final IContactUsRemoteDataSource remoteDataSource;

  ContactUsRepository({required this.remoteDataSource});

  @override
  Future<bool> sendContactUsMessage({
    required String name,
    required String email,
    required String phoneNumber,
    required String message,
  }) async {
    return await remoteDataSource.sendContactUsMessage(
      name: name,
      email: email,
      subject: phoneNumber,
      message: message,
    );
  }
}