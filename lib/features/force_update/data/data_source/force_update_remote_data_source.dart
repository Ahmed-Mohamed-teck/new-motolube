import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/app_info_model.dart';

abstract class ForceUpdateRemoteDataSource {
  Future<AppInfoModel> getAppInfo();
}

class ForceUpdateRemoteDataSourceImpl implements ForceUpdateRemoteDataSource {
  const ForceUpdateRemoteDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  static const _collection = 'appInfo';
  static const _document = 'appInfoId';

  @override
  Future<AppInfoModel> getAppInfo() async {
    final snapshot =
        await _firestore.collection(_collection).doc(_document).get();

    final data = snapshot.data();
    if (!snapshot.exists || data == null) {
      return const AppInfoModel();
    }

    return AppInfoModel.fromJson(data);
  }
}
