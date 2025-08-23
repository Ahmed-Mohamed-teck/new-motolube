import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newmotorlube/features/contact_us/data/data_source/contact_us_remote_data_source.dart';
import 'package:newmotorlube/features/contact_us/data/data_source/i_contact_us_remote_data_source.dart';
import 'package:newmotorlube/features/contact_us/presentation/view_model/contact_us_state.dart';
import 'package:newmotorlube/features/contact_us/presentation/view_model/contact_us_view_model.dart';

import '../data/repository/contact_us_repository.dart';
import '../domain/repository/i_contact_us_repository.dart';
import '../domain/use_case/send_contact_us_meassage.dart';

final remoteDataSourceProvider = Provider<IContactUsRemoteDataSource>(
  (ref) => ContactUsRemoteDataSource(),
);


final contactUsRemoteProvider = Provider<IContactUsRepository>(
  (ref) => ContactUsRepository(remoteDataSource: ref.read(remoteDataSourceProvider)),
);

final sendContactUsMessageUseCaseProvider = Provider<SendContactUsMessageUseCase>(
  (ref) => SendContactUsMessageUseCase(ref.read(contactUsRemoteProvider)),
);

final contactUsViewModelProvider = NotifierProvider<ContactUsViewModel,ContactUsState>(
  () => ContactUsViewModel(),
);