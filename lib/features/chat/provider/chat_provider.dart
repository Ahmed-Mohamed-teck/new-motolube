import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/general_providers.dart';
import '../data/data_source/chat_remote_data_source.dart';
import '../data/data_source/i_chat_remote_data_source.dart';
import '../data/repository/chat_repository.dart';
import '../domain/repository/i_chat_repository.dart';
import '../domain/use_case/observe_chat_messages_use_case.dart';
import '../domain/use_case/send_chat_message_use_case.dart';

final chatRemoteDataSourceProvider = Provider<IChatRemoteDataSource>(
  (ref) => ChatRemoteDataSource(ref.read(firebaseFirestoreProvider)),
);

final chatRepositoryProvider = Provider<IChatRepository>(
  (ref) => ChatRepositoryImpl(ref.read(chatRemoteDataSourceProvider)),
);

final observeChatMessagesUseCaseProvider = Provider<ObserveChatMessagesUseCase>(
  (ref) => ObserveChatMessagesUseCase(ref.read(chatRepositoryProvider)),
);

final sendChatMessageUseCaseProvider = Provider<SendChatMessageUseCase>(
  (ref) => SendChatMessageUseCase(ref.read(chatRepositoryProvider)),
);
