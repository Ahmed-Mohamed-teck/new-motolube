import 'package:newmotorlube/features/contact_us/domain/entity/contact_us_entity.dart';

class ContactUsModel {
  late String name;
  late String email;
  late String mobileNo;
  late String comment;

  ContactUsModel({
    required this.name,
    required this.email,
    required this.mobileNo,
    required this.comment,
  });


  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'mobileNo': mobileNo,
        'comment': comment,
      };

  ContactUs toEntity() => ContactUs(
    name: name,
    email: email,
    mobileNo: mobileNo,
    message: comment,
  );
}