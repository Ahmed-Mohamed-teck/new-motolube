// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ar';

  static String m0(name) => "المواعيد المتاحة لـ ${name}";

  static String m1(distance) => "يبعد ${distance} كم";

  static String m2(message) => "فشل تحميل الباقات.\n${message}";

  static String m3(price) => "${price} ر.س";

  static String m4(label) => "الفئة المحددة: ${label}";

  static String m5(latitude, longitude) =>
      "الموقع المحدد: (${latitude}, ${longitude})";

  static String m6(route) => "المسار \"${route}\" غير متاح.";

  static String m7(model, plate) => "بطاقة سيارة لـ ${model}، لوحة ${plate}";

  static String m8(plate) => "لوحة المركبة ${plate}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "PleaseLoginToViewYourCarsMessage": MessageLookupByLibrary.simpleMessage(
      "يرجى تسجيل الدخول لعرض سياراتك",
    ),
    "Profile": MessageLookupByLibrary.simpleMessage("الملف الشخصي"),
    "addCar": MessageLookupByLibrary.simpleMessage("إضافة سيارة"),
    "arabic": MessageLookupByLibrary.simpleMessage("العربية"),
    "areYouOwnerThisCar": MessageLookupByLibrary.simpleMessage(
      "هل أنت مالك هذه السيارة؟",
    ),
    "authenticationErrorMessage": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ اثناء المصادقة",
    ),
    "back": MessageLookupByLibrary.simpleMessage("رجوع"),
    "basicServices": MessageLookupByLibrary.simpleMessage("الخدمات الأساسية"),
    "batteires": MessageLookupByLibrary.simpleMessage("بطاريات السيارات"),
    "bestOffers": MessageLookupByLibrary.simpleMessage("أفضل العروض"),
    "book": MessageLookupByLibrary.simpleMessage("احجز"),
    "bookServiceAllow": MessageLookupByLibrary.simpleMessage("سماح"),
    "bookServiceAppointmentConfirmedTitle":
        MessageLookupByLibrary.simpleMessage("تم تأكيد الموعد"),
    "bookServiceAvailableSlotsFor": m0,
    "bookServiceCompleteAllStepsBeforeBooking":
        MessageLookupByLibrary.simpleMessage(
          "يرجى إكمال جميع الخطوات قبل الحجز.",
        ),
    "bookServiceCreateAppointmentFailed": MessageLookupByLibrary.simpleMessage(
      "فشل إنشاء الموعد. يرجى المحاولة مرة أخرى.",
    ),
    "bookServiceCustomerInfoUnavailable": MessageLookupByLibrary.simpleMessage(
      "تعذر تحديد معلومات العميل.",
    ),
    "bookServiceDeny": MessageLookupByLibrary.simpleMessage("رفض"),
    "bookServiceDistanceAway": m1,
    "bookServiceFailedToLoadPackages": m2,
    "bookServiceLocationPermissionMessage":
        MessageLookupByLibrary.simpleMessage(
          "نحتاج إلى موقعك لعرضه على الخريطة.",
        ),
    "bookServiceLocationPermissionTitle": MessageLookupByLibrary.simpleMessage(
      "إذن الموقع",
    ),
    "bookServiceNoPackagesFoundDescription": MessageLookupByLibrary.simpleMessage(
      "لم نتمكن من العثور على أي باقات لسيارتك والفئة المحددة.\nجرّب تغيير عوامل التصفية أو تحقق مرة أخرى لاحقًا.",
    ),
    "bookServiceNoPackagesFoundTitle": MessageLookupByLibrary.simpleMessage(
      "لم يتم العثور على باقات",
    ),
    "bookServiceNoSlotsForSelectedDate": MessageLookupByLibrary.simpleMessage(
      "لا توجد مواعيد متاحة للتاريخ المحدد.",
    ),
    "bookServiceNoTechniciansInRegion": MessageLookupByLibrary.simpleMessage(
      "لا يوجد فني متاح في هذه المنطقة.",
    ),
    "bookServiceOk": MessageLookupByLibrary.simpleMessage("حسنًا"),
    "bookServicePackagesLoadAfterContinue":
        MessageLookupByLibrary.simpleMessage(
          "سيتم تحميل الباقات بمجرد المتابعة.",
        ),
    "bookServicePriceSar": m3,
    "bookServiceReadyToFindTechnicians": MessageLookupByLibrary.simpleMessage(
      "هل أنت مستعد للعثور على فنيين بالقرب من موقعك المحدد؟",
    ),
    "bookServiceRefresh": MessageLookupByLibrary.simpleMessage("تحديث"),
    "bookServiceReset": MessageLookupByLibrary.simpleMessage("إعادة تعيين"),
    "bookServiceSearchTechnicians": MessageLookupByLibrary.simpleMessage(
      "البحث عن فنيين",
    ),
    "bookServiceSelectCarBeforeContinuing":
        MessageLookupByLibrary.simpleMessage("يرجى اختيار سيارة قبل المتابعة."),
    "bookServiceSelectCarInStepOne": MessageLookupByLibrary.simpleMessage(
      "يرجى اختيار سيارة في الخطوة الأولى لعرض الباقات المتاحة.",
    ),
    "bookServiceSelectLocationBeforeContinuing":
        MessageLookupByLibrary.simpleMessage(
          "يرجى اختيار موقع على الخريطة قبل المتابعة.",
        ),
    "bookServiceSelectPackageAndLocation": MessageLookupByLibrary.simpleMessage(
      "اختر باقة خدمة وموقعًا للعثور على الفنيين القريبين.",
    ),
    "bookServiceSelectPackageBeforeContinuing":
        MessageLookupByLibrary.simpleMessage(
          "يرجى اختيار باقة خدمة قبل المتابعة.",
        ),
    "bookServiceSelectedCategory": m4,
    "bookServiceSelectedLocation": m5,
    "bookServiceSelectedPackageUnavailable":
        MessageLookupByLibrary.simpleMessage("تعذر تحديد الباقة المحددة."),
    "bookServiceSelectedVehicleUnavailable":
        MessageLookupByLibrary.simpleMessage("تعذر تحديد المركبة المحددة."),
    "bookServiceSignInToSelectCar": MessageLookupByLibrary.simpleMessage(
      "يرجى تسجيل الدخول لاختيار سيارة",
    ),
    "bookServiceStepChoosePackage": MessageLookupByLibrary.simpleMessage(
      "اختر الباقة",
    ),
    "bookServiceStepPickLocation": MessageLookupByLibrary.simpleMessage(
      "حدد الموقع",
    ),
    "bookServiceStepSelectTechnician": MessageLookupByLibrary.simpleMessage(
      "اختر الفني",
    ),
    "bookServiceStepSelectVehicle": MessageLookupByLibrary.simpleMessage(
      "اختر السيارة",
    ),
    "bookServiceTapMapToSelectLocation": MessageLookupByLibrary.simpleMessage(
      "اضغط في أي مكان على الخريطة لتحديد موقع الخدمة.",
    ),
    "bookServiceTapTechnicianForSlots": MessageLookupByLibrary.simpleMessage(
      "اضغط على فني لعرض المواعيد المتاحة لديه.",
    ),
    "bookServiceTechnicianBranchUnavailable":
        MessageLookupByLibrary.simpleMessage("تعذر تحديد فرع الفني."),
    "bookServiceTechnicianInfoUnavailable":
        MessageLookupByLibrary.simpleMessage("تعذر تحديد معلومات الفني."),
    "bookServiceTryAgain": MessageLookupByLibrary.simpleMessage(
      "حاول مرة أخرى",
    ),
    "carDetailing": MessageLookupByLibrary.simpleMessage("تنظيف السيارات"),
    "carEvaluation": MessageLookupByLibrary.simpleMessage("تقييم السيارات"),
    "carInfo": MessageLookupByLibrary.simpleMessage("معلومات السيارة"),
    "carRepair": MessageLookupByLibrary.simpleMessage("إصلاح السيارات"),
    "carWash": MessageLookupByLibrary.simpleMessage("غسيل السيارات"),
    "changeLanguage": MessageLookupByLibrary.simpleMessage("تغيير اللغة"),
    "characterVinLimit": MessageLookupByLibrary.simpleMessage(
      "رقم الهيكل 17 حرفًا",
    ),
    "characterVinLimitError": MessageLookupByLibrary.simpleMessage(
      "رقم الهيكل يجب أن يكون 17 حرفًا",
    ),
    "chatEmptyMessage": MessageLookupByLibrary.simpleMessage(
      "لا توجد رسائل بعد. ابدأ المحادثة.",
    ),
    "chatErrorLoading": MessageLookupByLibrary.simpleMessage(
      "تعذر تحميل رسائل المحادثة.",
    ),
    "chatInputHint": MessageLookupByLibrary.simpleMessage("اكتب رسالة"),
    "chatLoginRequired": MessageLookupByLibrary.simpleMessage(
      "يرجى تسجيل الدخول للتحدث مع الفني.",
    ),
    "chatMissingBookingId": MessageLookupByLibrary.simpleMessage(
      "معرّف الحجز مفقود للمحادثة.",
    ),
    "chatSendLabel": MessageLookupByLibrary.simpleMessage("إرسال"),
    "chatTitle": MessageLookupByLibrary.simpleMessage("المحادثة"),
    "chatUnavailable": MessageLookupByLibrary.simpleMessage(
      "المحادثة غير متاحة لهذا الحجز.",
    ),
    "comment": MessageLookupByLibrary.simpleMessage("تعليق"),
    "commonErrorDescription": MessageLookupByLibrary.simpleMessage(
      "يرجى التحقق من اتصالك بالإنترنت أو إعادة المحاولة.",
    ),
    "commonErrorTitle": MessageLookupByLibrary.simpleMessage("حدث خطأ ما"),
    "commonRetry": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
    "companyName": MessageLookupByLibrary.simpleMessage("اسم الشركة"),
    "companyNameError": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال اسم الشركة",
    ),
    "companyNameHint": MessageLookupByLibrary.simpleMessage(
      "مثال: شركة الخليج للسيارات",
    ),
    "contactUsAppbar": MessageLookupByLibrary.simpleMessage("اتصل بنا"),
    "contactUsInquirySentMessage": MessageLookupByLibrary.simpleMessage(
      "تم إرسال استفسارك بنجاح.",
    ),
    "contactUsInquirySentTitle": MessageLookupByLibrary.simpleMessage(
      "تم إرسال الاستفسار",
    ),
    "contactUsNav": MessageLookupByLibrary.simpleMessage("اتصل بنا"),
    "crn": MessageLookupByLibrary.simpleMessage("رقم السجل التجاري"),
    "crnError": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال رقم السجل التجاري",
    ),
    "crnHint": MessageLookupByLibrary.simpleMessage("مثال: 1234567890"),
    "crnLengthError": MessageLookupByLibrary.simpleMessage(
      "يجب أن يكون رقم السجل التجاري 10 أرقام",
    ),
    "didntReceiveOtp": MessageLookupByLibrary.simpleMessage(
      "لم تستلم رمز التحقق؟",
    ),
    "email": MessageLookupByLibrary.simpleMessage("البريد الإلكتروني"),
    "endDate": MessageLookupByLibrary.simpleMessage("تاريخ الانتهاء"),
    "english": MessageLookupByLibrary.simpleMessage("الإنجليزية"),
    "enterOtpSentTo": MessageLookupByLibrary.simpleMessage(
      "أدخل رمز التحقق المرسل إلى",
    ),
    "enterPromotionNameHint": MessageLookupByLibrary.simpleMessage(
      "أدخل اسم العرض",
    ),
    "enterProperValue": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال قيمة صحيحة",
    ),
    "enterValidEmail": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال بريد إلكتروني صالح",
    ),
    "errorSavingPromotion": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ أثناء حفظ العرض، يرجى المحاولة مرة أخرى لاحقًا.",
    ),
    "errorTitle": MessageLookupByLibrary.simpleMessage("خطأ"),
    "expiresIn": MessageLookupByLibrary.simpleMessage("ينتهي في"),
    "fillAllFields": MessageLookupByLibrary.simpleMessage(
      "يرجى ملء جميع الحقول",
    ),
    "firstName": MessageLookupByLibrary.simpleMessage("الاسم الأول"),
    "firstNameHint": MessageLookupByLibrary.simpleMessage("أدخل الاسم الأول"),
    "flatTyre": MessageLookupByLibrary.simpleMessage("إصلاح الإطارات"),
    "forceUpdateButton": MessageLookupByLibrary.simpleMessage("حدث الآن"),
    "forceUpdateMessage": MessageLookupByLibrary.simpleMessage(
      "يتوفر تحديث جديد. يرجى تحديث التطبيق للمتابعة.",
    ),
    "forceUpdateTitle": MessageLookupByLibrary.simpleMessage("يوجد تحديث متاح"),
    "homeAppbar": MessageLookupByLibrary.simpleMessage("الرئيسية"),
    "homeNav": MessageLookupByLibrary.simpleMessage("الرئيسية"),
    "insuranceClaims": MessageLookupByLibrary.simpleMessage("تأمين السيارات"),
    "lastName": MessageLookupByLibrary.simpleMessage("اسم العائلة"),
    "lastNameHint": MessageLookupByLibrary.simpleMessage("أدخل اسم العائلة"),
    "logInToContinue": MessageLookupByLibrary.simpleMessage(
      "سجل الدخول للمتابعة",
    ),
    "login": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
    "loginWelcomeMessage": MessageLookupByLibrary.simpleMessage(
      "مرحبا بك، سجل دخولك لموتورلوب",
    ),
    "mailUsAt": MessageLookupByLibrary.simpleMessage("راسلنا على"),
    "maintenanceNav": MessageLookupByLibrary.simpleMessage("الصيانة"),
    "majorServices": MessageLookupByLibrary.simpleMessage("الخدمات الرئيسية"),
    "managerHomeCouponsDescription": MessageLookupByLibrary.simpleMessage(
      "إنشاء كوبونات خصم",
    ),
    "managerHomeCouponsTitle": MessageLookupByLibrary.simpleMessage(
      "الكوبونات",
    ),
    "managerHomeCreatePromotionDescription":
        MessageLookupByLibrary.simpleMessage("إضافة عرض ترويجي جديد"),
    "managerHomeCreatePromotionTitle": MessageLookupByLibrary.simpleMessage(
      "إنشاء عرض",
    ),
    "managerHomePromotionsDescription": MessageLookupByLibrary.simpleMessage(
      "لوحة تحكم العروض",
    ),
    "managerHomePromotionsTitle": MessageLookupByLibrary.simpleMessage(
      "العروض الترويجية",
    ),
    "managerHomeRatingsDescription": MessageLookupByLibrary.simpleMessage(
      "عرض تقييمات العملاء",
    ),
    "managerHomeRatingsTitle": MessageLookupByLibrary.simpleMessage(
      "التقييمات",
    ),
    "managerHomeRouteUnavailable": m6,
    "managerHomeTitle": MessageLookupByLibrary.simpleMessage("الإدارة"),
    "manufacturer": MessageLookupByLibrary.simpleMessage("الشركة المصنعة"),
    "mobileServices": MessageLookupByLibrary.simpleMessage("الخدمات المتنقلة"),
    "model": MessageLookupByLibrary.simpleMessage("الموديل"),
    "more": MessageLookupByLibrary.simpleMessage("المزيد"),
    "moreAppbar": MessageLookupByLibrary.simpleMessage("المزيد"),
    "moreNav": MessageLookupByLibrary.simpleMessage("المزيد"),
    "myCarsNav": MessageLookupByLibrary.simpleMessage("سياراتي"),
    "name": MessageLookupByLibrary.simpleMessage("الاسم"),
    "next": MessageLookupByLibrary.simpleMessage("التالي"),
    "no": MessageLookupByLibrary.simpleMessage("لا"),
    "noCarsFound": MessageLookupByLibrary.simpleMessage(
      "لم يتم العثور على سيارات",
    ),
    "notValidUserEmail": MessageLookupByLibrary.simpleMessage(
      "البريد الإلكتروني للمستخدم غير صالح",
    ),
    "oiling": MessageLookupByLibrary.simpleMessage("الزيت"),
    "ok": MessageLookupByLibrary.simpleMessage("حسناً"),
    "onBoardingDescription1": MessageLookupByLibrary.simpleMessage(
      "تجنب عناء زيارة الورش خدمتنا المتنقلة لصيانة السيارات توفر لك الصيانة والإصلاحات الاحترافية مباشرة في موقعك.",
    ),
    "onBoardingDescription2": MessageLookupByLibrary.simpleMessage(
      "نستخدم أحدث وأفضل الحلول لتطوير مجال خدمة السيارات، لنقدم تجربة فريدة لم يسبق لك أن خضتها من قبل.",
    ),
    "onBoardingDescription3": MessageLookupByLibrary.simpleMessage(
      "ما الذي يحمي الهيكل السفلي لسيارتك؟ في موتور لوب، نحن لا نكتفي بالحماية – بل نحصّن سيارتك بمعالجة \"ريفايڤ\" المميزة بطبقة سفلية شمعية فائقة الجودة.",
    ),
    "onBoardingTitle1": MessageLookupByLibrary.simpleMessage(
      "خدمة السيارات المتنقلة",
    ),
    "onBoardingTitle2": MessageLookupByLibrary.simpleMessage("خدمة الطوارئ"),
    "onBoardingTitle3": MessageLookupByLibrary.simpleMessage(
      "اتباع معايير الوكيل",
    ),
    "ourServices": MessageLookupByLibrary.simpleMessage("خدماتنا"),
    "phoneNumber": MessageLookupByLibrary.simpleMessage("رقم الهاتف"),
    "plate": MessageLookupByLibrary.simpleMessage("اللوحة"),
    "plateLetters": MessageLookupByLibrary.simpleMessage("حروف اللوحة"),
    "plateNumbers": MessageLookupByLibrary.simpleMessage("أرقام اللوحة"),
    "profileAppbar": MessageLookupByLibrary.simpleMessage("الملف الشخصي"),
    "profileNav": MessageLookupByLibrary.simpleMessage("الملف الشخصي"),
    "promotionDescription": MessageLookupByLibrary.simpleMessage("وصف العرض"),
    "promotionName": MessageLookupByLibrary.simpleMessage("اسم العرض"),
    "promotionSavedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "تم حفظ العرض بنجاح",
    ),
    "register": MessageLookupByLibrary.simpleMessage("تسجيل"),
    "resendOTP": MessageLookupByLibrary.simpleMessage("إعادة إرسال رمز التحقق"),
    "savePromotion": MessageLookupByLibrary.simpleMessage("حفظ العرض"),
    "selectEndDate": MessageLookupByLibrary.simpleMessage(
      "اختر تاريخ الانتهاء",
    ),
    "selectManufacturer": MessageLookupByLibrary.simpleMessage(
      "اختر الشركة المصنعة",
    ),
    "selectModel": MessageLookupByLibrary.simpleMessage("اختر الموديل"),
    "selectStartDate": MessageLookupByLibrary.simpleMessage("اختر تاريخ البدء"),
    "selectYear": MessageLookupByLibrary.simpleMessage("اختر السنة"),
    "skip": MessageLookupByLibrary.simpleMessage("تخطى"),
    "start": MessageLookupByLibrary.simpleMessage("ابدأ"),
    "startDate": MessageLookupByLibrary.simpleMessage("تاريخ البدء"),
    "submit": MessageLookupByLibrary.simpleMessage("إرسال"),
    "towiling": MessageLookupByLibrary.simpleMessage("تولينغ"),
    "upcomingService": MessageLookupByLibrary.simpleMessage("الخدمة القادمة"),
    "upcomingServicesAssignedTechnicianLabel":
        MessageLookupByLibrary.simpleMessage("الفني المعتمد"),
    "upcomingServicesBookingDetailsTitle": MessageLookupByLibrary.simpleMessage(
      "تفاصيل الحجز",
    ),
    "upcomingServicesDateFallback": MessageLookupByLibrary.simpleMessage(
      "سيتم تأكيد التاريخ لاحقًا",
    ),
    "upcomingServicesEmptyMessage": MessageLookupByLibrary.simpleMessage(
      "لا توجد خدمات قادمة مجدولة.",
    ),
    "upcomingServicesErrorPrefix": MessageLookupByLibrary.simpleMessage(
      "تعذر تحميل الخدمات القادمة.",
    ),
    "upcomingServicesLoadingLocation": MessageLookupByLibrary.simpleMessage(
      "جارٍ تحميل الموقع",
    ),
    "upcomingServicesLoadingPackage": MessageLookupByLibrary.simpleMessage(
      "جارٍ تحميل اسم الباقة",
    ),
    "upcomingServicesLoadingStatus": MessageLookupByLibrary.simpleMessage(
      "جارٍ التحميل",
    ),
    "upcomingServicesLoadingTechnician": MessageLookupByLibrary.simpleMessage(
      "جارٍ تحميل اسم الفني",
    ),
    "upcomingServicesLoadingVehicle": MessageLookupByLibrary.simpleMessage(
      "جارٍ تحميل السيارة",
    ),
    "upcomingServicesLocationFallback": MessageLookupByLibrary.simpleMessage(
      "سيتم تأكيد الموقع لاحقًا",
    ),
    "upcomingServicesLoginPrompt": MessageLookupByLibrary.simpleMessage(
      "سجّل الدخول لعرض خدماتك القادمة.",
    ),
    "upcomingServicesPlateFallback": MessageLookupByLibrary.simpleMessage(
      "اللوحة غير متاحة",
    ),
    "upcomingServicesServiceLocationLabel":
        MessageLookupByLibrary.simpleMessage("موقع الخدمة"),
    "upcomingServicesServicePackageLabel": MessageLookupByLibrary.simpleMessage(
      "باقة الخدمة",
    ),
    "upcomingServicesServicePlaceholder": MessageLookupByLibrary.simpleMessage(
      "الخدمة",
    ),
    "upcomingServicesStatusCancelled": MessageLookupByLibrary.simpleMessage(
      "ملغاة",
    ),
    "upcomingServicesStatusCompleted": MessageLookupByLibrary.simpleMessage(
      "مكتملة",
    ),
    "upcomingServicesStatusExpired": MessageLookupByLibrary.simpleMessage(
      "منتهية",
    ),
    "upcomingServicesStatusNew": MessageLookupByLibrary.simpleMessage(
      "حجز جديد",
    ),
    "upcomingServicesStatusPending": MessageLookupByLibrary.simpleMessage(
      "قيد الانتظار",
    ),
    "upcomingServicesStatusUpcoming": MessageLookupByLibrary.simpleMessage(
      "قادمة",
    ),
    "upcomingServicesTechnicianFallback": MessageLookupByLibrary.simpleMessage(
      "سيتم تعيين الفني لاحقًا",
    ),
    "upcomingServicesVehiclePlaceholder": MessageLookupByLibrary.simpleMessage(
      "المركبة",
    ),
    "upcomingServicesViewButton": MessageLookupByLibrary.simpleMessage(
      "تسجيل الدخول",
    ),
    "userCarsAddCrnImage": MessageLookupByLibrary.simpleMessage(
      "أضف صورة السجل التجاري",
    ),
    "userCarsAddImageRequirement": MessageLookupByLibrary.simpleMessage(
      "يرجى إضافة صورة واحدة على الأقل.",
    ),
    "userCarsAddPhotos": MessageLookupByLibrary.simpleMessage("أضف صورًا"),
    "userCarsAddedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "تمت إضافة السيارة بنجاح",
    ),
    "userCarsBookNow": MessageLookupByLibrary.simpleMessage("احجز الآن"),
    "userCarsCarDetailsTitle": MessageLookupByLibrary.simpleMessage(
      "تفاصيل السيارة",
    ),
    "userCarsCarModelLabel": MessageLookupByLibrary.simpleMessage(
      "موديل السيارة",
    ),
    "userCarsCarName": MessageLookupByLibrary.simpleMessage("اسم السيارة"),
    "userCarsCardSemantics": m7,
    "userCarsChassis": MessageLookupByLibrary.simpleMessage("رقم الهيكل"),
    "userCarsChassisVin": MessageLookupByLibrary.simpleMessage(
      "رقم الهيكل (VIN)",
    ),
    "userCarsChooseFromGallery": MessageLookupByLibrary.simpleMessage(
      "اختر من المعرض (متعدد)",
    ),
    "userCarsCompletePlateFields": MessageLookupByLibrary.simpleMessage(
      "يرجى إكمال حقول اللوحة",
    ),
    "userCarsCopiedToClipboard": MessageLookupByLibrary.simpleMessage(
      "تم النسخ إلى الحافظة",
    ),
    "userCarsCopy": MessageLookupByLibrary.simpleMessage("نسخ"),
    "userCarsDeleteCar": MessageLookupByLibrary.simpleMessage("حذف السيارة"),
    "userCarsEditInfo": MessageLookupByLibrary.simpleMessage("تعديل المعلومات"),
    "userCarsEmptyDescription": MessageLookupByLibrary.simpleMessage(
      "لم نتمكن من العثور على أي سيارات تطابق بحثك ",
    ),
    "userCarsErrorLoadingManufacturers": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ أثناء تحميل الشركات المصنعة",
    ),
    "userCarsErrorLoadingModels": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ أثناء تحميل موديلات السيارات",
    ),
    "userCarsImagesSectionTitle": MessageLookupByLibrary.simpleMessage(
      "صور السيارة",
    ),
    "userCarsInvalidPlateLetter": MessageLookupByLibrary.simpleMessage(
      "حرف اللوحة غير صالح",
    ),
    "userCarsInvalidPlateNumber": MessageLookupByLibrary.simpleMessage(
      "رقم اللوحة غير صالح",
    ),
    "userCarsLicensePlateSemantics": m8,
    "userCarsSaveVehicle": MessageLookupByLibrary.simpleMessage("حفظ المركبة"),
    "userCarsSaving": MessageLookupByLibrary.simpleMessage("جارٍ الحفظ..."),
    "userCarsTakePhoto": MessageLookupByLibrary.simpleMessage("التقاط صورة"),
    "userCarsYearOfManufacture": MessageLookupByLibrary.simpleMessage(
      "سنة الصنع",
    ),
    "userEmail": MessageLookupByLibrary.simpleMessage(
      "البريد الإلكتروني للمستخدم",
    ),
    "userEmailHint": MessageLookupByLibrary.simpleMessage(
      "أدخل البريد الإلكتروني للمستخدم",
    ),
    "userName": MessageLookupByLibrary.simpleMessage("اسم المستخدم"),
    "userNameHint": MessageLookupByLibrary.simpleMessage("أدخل اسم المستخدم"),
    "verify": MessageLookupByLibrary.simpleMessage("تحقق"),
    "vin": MessageLookupByLibrary.simpleMessage("رقم الهيكل"),
    "year": MessageLookupByLibrary.simpleMessage("السنة"),
    "yes": MessageLookupByLibrary.simpleMessage("نعم"),
    "yourCars": MessageLookupByLibrary.simpleMessage("سياراتك"),
  };
}
