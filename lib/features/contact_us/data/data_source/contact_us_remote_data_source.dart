import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../model/contact_us_model.dart';
import 'i_contact_us_remote_data_source.dart';

class  ContactUsRemoteDataSource extends IContactUsRemoteDataSource {
  @override
  Future<bool> sendContactUsMessage({required String name, required String email, required String subject, required String message}) async{
    try {
      final doc =
      FirebaseFirestore.instance.collection('contactUs').doc();
      final rec = ContactUsModel(
        name: name,
        email: email,
        mobileNo: subject,
        comment: message,
      );
      await doc.set(rec.toJson());
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

}