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

  static String m0(date) =>
      "تم تقديم طلب حذف الحساب بتاريخ ${date}. سيتم حذف بياناتك خلال 30 يوما من تقديم الطلب.";

  static String m1(label) => "موجود حاليًا في حالة ${label}.";

  static String m2(name) => "المواعيد المتاحة لـ ${name}";

  static String m3(distance) => "يبعد ${distance} كم";

  static String m4(message) => "فشل تحميل الباقات.\n${message}";

  static String m5(price) => "${price} ر.س";

  static String m6(label) => "الفئة المحددة: ${label}";

  static String m7(latitude, longitude) =>
      "الموقع المحدد: (${latitude}, ${longitude})";

  static String m8(count) => "تطبيق (${count})";

  static String m9(id) => "المعرّف ${id}";

  static String m10(name) => "حذف \"${name}\" من هذه الباقة؟";

  static String m11(error) => "فشل تحميل قائمة الفحص: ${error}";

  static String m12(error) => "فشل حفظ قائمة الفحص: ${error}";

  static String m13(count) => "العناصر (${count})";

  static String m14(srNumber) => "تم إنشاء بطاقة العمل ${srNumber}.";

  static String m15(jobCardNumber) => "بطاقة العمل: ${jobCardNumber}";

  static String m16(srNumber) => "بطاقة العمل ${srNumber}";

  static String m17(lineId) => "البند: ${lineId}";

  static String m18(number) => "البند ${number}";

  static String m19(route) => "المسار \"${route}\" غير متاح.";

  static String m20(code) => "باقة ${code}";

  static String m21(code) => "الرمز: ${code}";

  static String m22(price) => "السعر: ${price}";

  static String m23(quantity) => "الكمية: ${quantity}";

  static String m24(name, srNumber) =>
      "هل أنت متأكد أنك تريد إزالة \"${name}\" من طلب الخدمة ${srNumber}؟";

  static String m25(srLine) => "رقم بند طلب الخدمة: ${srLine}";

  static String m26(code) => "الحالة ${code}";

  static String m27(id) => "رقم الحالة ${id}";

  static String m28(count) => "${count} حالات محددة";

  static String m29(id) => "الحالة ${id}";

  static String m30(model, plate) => "بطاقة سيارة لـ ${model}، لوحة ${plate}";

  static String m31(plate) => "لوحة المركبة ${plate}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "PleaseLoginToViewYourCarsMessage": MessageLookupByLibrary.simpleMessage(
      "يرجى تسجيل الدخول لعرض سياراتك",
    ),
    "Profile": MessageLookupByLibrary.simpleMessage("الملف الشخصي"),
    "accountDeletionEmailMissing": MessageLookupByLibrary.simpleMessage(
      "تعذر تقديم طلب حذف الحساب لأن الحساب لا يحتوي على بريد إلكتروني.",
    ),
    "accountDeletionFailed": MessageLookupByLibrary.simpleMessage(
      "تعذر تقديم طلب حذف الحساب. يرجى المحاولة مرة أخرى.",
    ),
    "accountDeletionIrreversible30Days": MessageLookupByLibrary.simpleMessage(
      "سيتم حذف الحساب نهائيا بعد 30 يوما",
    ),
    "accountDeletionRequestSubmitted": MessageLookupByLibrary.simpleMessage(
      "تم تقديم طلب حذف الحساب",
    ),
    "accountDeletionSubmittedMessage": m0,
    "addCar": MessageLookupByLibrary.simpleMessage("إضافة سيارة"),
    "addCouponButtonLabel": MessageLookupByLibrary.simpleMessage("إضافة قسيمة"),
    "addItemButtonLabel": MessageLookupByLibrary.simpleMessage("إضافة عنصر"),
    "addItemsOrServicesTitle": MessageLookupByLibrary.simpleMessage(
      "إضافة عناصر أو خدمات",
    ),
    "addPackageToJobCardButtonLabel": MessageLookupByLibrary.simpleMessage(
      "إضافة باقة إلى بطاقة العمل",
    ),
    "allButtonLabel": MessageLookupByLibrary.simpleMessage("الكل"),
    "alreadyOnStatusMessage": m1,
    "amountDueLabel": MessageLookupByLibrary.simpleMessage("المبلغ المستحق"),
    "anyDateLabel": MessageLookupByLibrary.simpleMessage("أي تاريخ"),
    "appName": MessageLookupByLibrary.simpleMessage("موتور لوب"),
    "appVersion": MessageLookupByLibrary.simpleMessage("V 2.0.0"),
    "appliedCouponLabel": MessageLookupByLibrary.simpleMessage(
      "القسيمة المطبقة",
    ),
    "applyFiltersButtonLabel": MessageLookupByLibrary.simpleMessage(
      "تطبيق الفلاتر",
    ),
    "appointmentCancelledSuccessfully": MessageLookupByLibrary.simpleMessage(
      "تم إلغاء الموعد بنجاح.",
    ),
    "appointmentDetailsTitle": MessageLookupByLibrary.simpleMessage(
      "تفاصيل الموعد",
    ),
    "arabic": MessageLookupByLibrary.simpleMessage("العربية"),
    "areYouOwnerThisCar": MessageLookupByLibrary.simpleMessage(
      "هل أنت مالك هذه السيارة؟",
    ),
    "assignedAppointmentsWillAppearHere": MessageLookupByLibrary.simpleMessage(
      "ستظهر هنا جميع المواعيد المخصصة لك بعد أن يقوم العملاء بحجز الخدمات.",
    ),
    "authenticationErrorMessage": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ اثناء المصادقة",
    ),
    "back": MessageLookupByLibrary.simpleMessage("رجوع"),
    "backOnline": MessageLookupByLibrary.simpleMessage("متصل الآن"),
    "basicServices": MessageLookupByLibrary.simpleMessage("الخدمات الأساسية"),
    "batteires": MessageLookupByLibrary.simpleMessage("بطاريات السيارات"),
    "bestOffers": MessageLookupByLibrary.simpleMessage("أفضل العروض"),
    "book": MessageLookupByLibrary.simpleMessage("احجز"),
    "bookServiceAllow": MessageLookupByLibrary.simpleMessage("سماح"),
    "bookServiceAppointmentConfirmedTitle":
        MessageLookupByLibrary.simpleMessage("تم تأكيد الموعد"),
    "bookServiceAvailableSlotsFor": m2,
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
    "bookServiceDistanceAway": m3,
    "bookServiceFailedToLoadPackages": m4,
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
    "bookServicePriceSar": m5,
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
    "bookServiceSelectedCategory": m6,
    "bookServiceSelectedLocation": m7,
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
    "bookingStatusPickerApply": MessageLookupByLibrary.simpleMessage("تطبيق"),
    "bookingStatusPickerApplyCount": m8,
    "bookingStatusPickerClear": MessageLookupByLibrary.simpleMessage("مسح"),
    "bookingStatusPickerStatusId": m9,
    "bookingStatusPickerTitle": MessageLookupByLibrary.simpleMessage(
      "اختر حالات الحجز",
    ),
    "bookingStatusTitle": MessageLookupByLibrary.simpleMessage("حالة الحجز"),
    "branchFieldLabel": MessageLookupByLibrary.simpleMessage("الفرع"),
    "branchNotAssignedLabel": MessageLookupByLibrary.simpleMessage(
      "لم يتم تحديد الفرع",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "cancelAppointmentButtonLabel": MessageLookupByLibrary.simpleMessage(
      "إلغاء الموعد",
    ),
    "cancelAppointmentConfirmation": MessageLookupByLibrary.simpleMessage(
      "هل أنت متأكد أنك تريد إلغاء هذا الموعد؟",
    ),
    "cancelAppointmentTitle": MessageLookupByLibrary.simpleMessage(
      "إلغاء الموعد؟",
    ),
    "cancelButtonLabel": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "cancellationStatusUnavailable": MessageLookupByLibrary.simpleMessage(
      "حالة الإلغاء غير متاحة حاليًا.",
    ),
    "cancellingEllipsis": MessageLookupByLibrary.simpleMessage(
      "جارٍ الإلغاء...",
    ),
    "cannotCancelAfterJobCardOpened": MessageLookupByLibrary.simpleMessage(
      "لا يمكن الإلغاء بعد فتح بطاقة العمل.",
    ),
    "carDetailing": MessageLookupByLibrary.simpleMessage("تنظيف السيارات"),
    "carEvaluation": MessageLookupByLibrary.simpleMessage("تقييم السيارات"),
    "carInfo": MessageLookupByLibrary.simpleMessage("معلومات السيارة"),
    "carRepair": MessageLookupByLibrary.simpleMessage("إصلاح السيارات"),
    "carWash": MessageLookupByLibrary.simpleMessage("غسيل السيارات"),
    "categoryLabel": MessageLookupByLibrary.simpleMessage("الفئة"),
    "changeLanguage": MessageLookupByLibrary.simpleMessage("تغيير اللغة"),
    "changeProfilePhoto": MessageLookupByLibrary.simpleMessage(
      "تغيير صورة الملف الشخصي",
    ),
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
    "checklistSubmittedMessage": MessageLookupByLibrary.simpleMessage(
      "تم إرسال قائمة الفحص.",
    ),
    "checkoutDetailsLabel": MessageLookupByLibrary.simpleMessage(
      "تفاصيل الدفع",
    ),
    "comment": MessageLookupByLibrary.simpleMessage("تعليق"),
    "commentLabel": MessageLookupByLibrary.simpleMessage("تعليق"),
    "commonErrorDescription": MessageLookupByLibrary.simpleMessage(
      "يرجى التحقق من اتصالك بالإنترنت أو إعادة المحاولة.",
    ),
    "commonErrorTitle": MessageLookupByLibrary.simpleMessage("حدث خطأ ما"),
    "commonRetry": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
    "commonSomethingWentWrong": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ ما.",
    ),
    "companyName": MessageLookupByLibrary.simpleMessage("اسم الشركة"),
    "companyNameError": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال اسم الشركة",
    ),
    "companyNameHint": MessageLookupByLibrary.simpleMessage(
      "مثال: شركة الخليج للسيارات",
    ),
    "companyNameLabel": MessageLookupByLibrary.simpleMessage("اسم الشركة"),
    "completePayment": MessageLookupByLibrary.simpleMessage("إتمام الدفع"),
    "confirmAccountDeletion": MessageLookupByLibrary.simpleMessage(
      "تأكيد حذف الحساب",
    ),
    "connectionTimedOutMessage": MessageLookupByLibrary.simpleMessage(
      "انتهت مهلة الاتصال. يرجى المحاولة مرة أخرى.",
    ),
    "contactUsAppbar": MessageLookupByLibrary.simpleMessage("اتصل بنا"),
    "contactUsInquirySentMessage": MessageLookupByLibrary.simpleMessage(
      "تم إرسال استفسارك بنجاح.",
    ),
    "contactUsInquirySentTitle": MessageLookupByLibrary.simpleMessage(
      "تم إرسال الاستفسار",
    ),
    "contactUsNav": MessageLookupByLibrary.simpleMessage("اتصل بنا"),
    "couponCountLabel": MessageLookupByLibrary.simpleMessage("عدد القسائم"),
    "couponDefaultLabel": MessageLookupByLibrary.simpleMessage("قسيمة"),
    "couponDiscountLabel": MessageLookupByLibrary.simpleMessage("الخصم"),
    "couponListTitle": MessageLookupByLibrary.simpleMessage("القسائم"),
    "createButtonLabel": MessageLookupByLibrary.simpleMessage("إنشاء"),
    "createCouponScreenTitle": MessageLookupByLibrary.simpleMessage(
      "إنشاء قسيمة",
    ),
    "createCouponTooltip": MessageLookupByLibrary.simpleMessage("إنشاء قسيمة"),
    "createDefaultChecklistButtonLabel": MessageLookupByLibrary.simpleMessage(
      "إنشاء قائمة فحص افتراضية",
    ),
    "creatingJobCardMessage": MessageLookupByLibrary.simpleMessage(
      "جارٍ إنشاء بطاقة العمل... ستظهر الباقات قريبًا.",
    ),
    "creditManagerUserLabel": MessageLookupByLibrary.simpleMessage(
      "مستخدم مدير الائتمان",
    ),
    "crn": MessageLookupByLibrary.simpleMessage("رقم السجل التجاري"),
    "crnError": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال رقم السجل التجاري",
    ),
    "crnHint": MessageLookupByLibrary.simpleMessage("مثال: 1234567890"),
    "crnLengthError": MessageLookupByLibrary.simpleMessage(
      "يجب أن يكون رقم السجل التجاري 10 أرقام",
    ),
    "customPackageManagerTitle": MessageLookupByLibrary.simpleMessage(
      "إدارة الباقات المخصصة",
    ),
    "customTagLabel": MessageLookupByLibrary.simpleMessage("مخصص"),
    "customerDefaultLabel": MessageLookupByLibrary.simpleMessage("عميل"),
    "customerUserLabel": MessageLookupByLibrary.simpleMessage("مستخدم عميل"),
    "delete": MessageLookupByLibrary.simpleMessage("حذف"),
    "deleteAccount": MessageLookupByLibrary.simpleMessage("حذف الحساب"),
    "deleteButtonLabel": MessageLookupByLibrary.simpleMessage("حذف"),
    "deleteItemConfirmation": m10,
    "deleteItemTooltip": MessageLookupByLibrary.simpleMessage("حذف العنصر"),
    "deleteTooltip": MessageLookupByLibrary.simpleMessage("حذف"),
    "didntReceiveOtp": MessageLookupByLibrary.simpleMessage(
      "لم تستلم رمز التحقق؟",
    ),
    "discountLabel": MessageLookupByLibrary.simpleMessage("الخصم"),
    "discountPercentageLabel": MessageLookupByLibrary.simpleMessage(
      "نسبة الخصم %",
    ),
    "editProfile": MessageLookupByLibrary.simpleMessage("تعديل الملف الشخصي"),
    "email": MessageLookupByLibrary.simpleMessage("البريد الإلكتروني"),
    "emergencyTagLabel": MessageLookupByLibrary.simpleMessage("حالة طارئة"),
    "endDate": MessageLookupByLibrary.simpleMessage("تاريخ الانتهاء"),
    "english": MessageLookupByLibrary.simpleMessage("الإنجليزية"),
    "enterCountError": MessageLookupByLibrary.simpleMessage("أدخل العدد"),
    "enterNumberError": MessageLookupByLibrary.simpleMessage("أدخل رقمًا"),
    "enterOtpSentTo": MessageLookupByLibrary.simpleMessage(
      "أدخل رمز التحقق المرسل إلى",
    ),
    "enterPromotionNameHint": MessageLookupByLibrary.simpleMessage(
      "أدخل اسم العرض",
    ),
    "enterProperValue": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال قيمة صحيحة",
    ),
    "enterQuantityMessage": MessageLookupByLibrary.simpleMessage(
      "أدخل الكمية.",
    ),
    "enterValidEmail": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال بريد إلكتروني صالح",
    ),
    "errorSavingPromotion": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ أثناء حفظ العرض، يرجى المحاولة مرة أخرى لاحقًا.",
    ),
    "errorTitle": MessageLookupByLibrary.simpleMessage("خطأ"),
    "expiresIn": MessageLookupByLibrary.simpleMessage("ينتهي في"),
    "failedToInitiatePayment": MessageLookupByLibrary.simpleMessage(
      "فشل بدء عملية الدفع. يرجى المحاولة مرة أخرى.",
    ),
    "failedToLoadChecklistError": m11,
    "failedToSaveChecklistError": m12,
    "failedToSubmitChecklistMessage": MessageLookupByLibrary.simpleMessage(
      "فشل إرسال قائمة الفحص.",
    ),
    "failedToVerifyPaymentStatus": MessageLookupByLibrary.simpleMessage(
      "فشل التحقق من حالة الدفع. يرجى المحاولة مرة أخرى.",
    ),
    "fillAllFields": MessageLookupByLibrary.simpleMessage(
      "يرجى ملء جميع الحقول",
    ),
    "filterApprovalsTitle": MessageLookupByLibrary.simpleMessage(
      "تصفية الموافقات",
    ),
    "firstName": MessageLookupByLibrary.simpleMessage("الاسم الأول"),
    "firstNameHint": MessageLookupByLibrary.simpleMessage("أدخل الاسم الأول"),
    "flatTyre": MessageLookupByLibrary.simpleMessage("إصلاح الإطارات"),
    "forceUpdateButton": MessageLookupByLibrary.simpleMessage("حدث الآن"),
    "forceUpdateMessage": MessageLookupByLibrary.simpleMessage(
      "يتوفر تحديث جديد. يرجى تحديث التطبيق للمتابعة.",
    ),
    "forceUpdateTitle": MessageLookupByLibrary.simpleMessage("يوجد تحديث متاح"),
    "fromDateLabel": MessageLookupByLibrary.simpleMessage("من"),
    "homeAppbar": MessageLookupByLibrary.simpleMessage("الرئيسية"),
    "homeNav": MessageLookupByLibrary.simpleMessage("الرئيسية"),
    "includedLabel": MessageLookupByLibrary.simpleMessage("مشمول"),
    "insuranceClaims": MessageLookupByLibrary.simpleMessage("تأمين السيارات"),
    "itemsCountLabel": m13,
    "jobCardCompletedSuccessfullyMessage": MessageLookupByLibrary.simpleMessage(
      "تم إنجاز بطاقة العمل بنجاح.",
    ),
    "jobCardCreatedMessage": m14,
    "jobCardNumberLabel": m15,
    "jobCardNumberMissingMessage": MessageLookupByLibrary.simpleMessage(
      "رقم بطاقة العمل مفقود.",
    ),
    "jobCardNumberUnavailableMessage": MessageLookupByLibrary.simpleMessage(
      "رقم بطاقة العمل غير متاح.",
    ),
    "jobCardOpenLoadingPackagesMessage": MessageLookupByLibrary.simpleMessage(
      "بطاقة العمل مفتوحة، جارٍ تحميل تفاصيل الباقة...",
    ),
    "jobCardPackagesTitle": MessageLookupByLibrary.simpleMessage(
      "باقات بطاقة العمل",
    ),
    "jobCardTitle": m16,
    "languageArabic": MessageLookupByLibrary.simpleMessage("العربية"),
    "languageEnglish": MessageLookupByLibrary.simpleMessage("English"),
    "lastName": MessageLookupByLibrary.simpleMessage("اسم العائلة"),
    "lastNameHint": MessageLookupByLibrary.simpleMessage("أدخل اسم العائلة"),
    "legendCleanLabel": MessageLookupByLibrary.simpleMessage("C - نظيف"),
    "legendInspectLabel": MessageLookupByLibrary.simpleMessage("I - فحص"),
    "legendNotApplicableLabel": MessageLookupByLibrary.simpleMessage(
      "X - غير ينطبق",
    ),
    "legendReplaceLabel": MessageLookupByLibrary.simpleMessage("R - استبدال"),
    "legendTitle": MessageLookupByLibrary.simpleMessage("الدليل"),
    "lineIdChipLabel": m17,
    "lineIdentifierUnavailableMessage": MessageLookupByLibrary.simpleMessage(
      "معرف البند غير متاح لهذا العنصر.",
    ),
    "lineNumberFallbackLabel": m18,
    "linePriceLabel": MessageLookupByLibrary.simpleMessage("سعر البند"),
    "loadingBookingStatusesMessage": MessageLookupByLibrary.simpleMessage(
      "جارٍ تحميل حالات الحجز...",
    ),
    "loadingEllipsis": MessageLookupByLibrary.simpleMessage("جارٍ التحميل..."),
    "logInToContinue": MessageLookupByLibrary.simpleMessage(
      "سجل الدخول للمتابعة",
    ),
    "login": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
    "loginWelcomeMessage": MessageLookupByLibrary.simpleMessage(
      "مرحبا بك، سجل دخولك لموتورلوب",
    ),
    "logout": MessageLookupByLibrary.simpleMessage("تسجيل الخروج"),
    "mailUsAt": MessageLookupByLibrary.simpleMessage("راسلنا على"),
    "maintenanceNav": MessageLookupByLibrary.simpleMessage("الصيانة"),
    "maintenancePackageDefaultLabel": MessageLookupByLibrary.simpleMessage(
      "باقة الصيانة",
    ),
    "majorServices": MessageLookupByLibrary.simpleMessage("الخدمات الرئيسية"),
    "manageButtonLabel": MessageLookupByLibrary.simpleMessage("إدارة"),
    "managePackagesButtonLabel": MessageLookupByLibrary.simpleMessage(
      "إدارة الباقات",
    ),
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
    "managerHomeRouteUnavailable": m19,
    "managerHomeTitle": MessageLookupByLibrary.simpleMessage("الإدارة"),
    "managerUserLabel": MessageLookupByLibrary.simpleMessage("مستخدم مدير"),
    "manufacturer": MessageLookupByLibrary.simpleMessage("الشركة المصنعة"),
    "missingFirebaseIdForTechnicianMessage":
        MessageLookupByLibrary.simpleMessage("معرف Firebase مفقود للفني."),
    "missingPaymentUrlMessage": MessageLookupByLibrary.simpleMessage(
      "رابط الدفع مفقود. يرجى المحاولة مرة أخرى لاحقًا.",
    ),
    "mobileServices": MessageLookupByLibrary.simpleMessage("الخدمات المتنقلة"),
    "model": MessageLookupByLibrary.simpleMessage("الموديل"),
    "more": MessageLookupByLibrary.simpleMessage("المزيد"),
    "moreAppbar": MessageLookupByLibrary.simpleMessage("المزيد"),
    "moreNav": MessageLookupByLibrary.simpleMessage("المزيد"),
    "myCarsNav": MessageLookupByLibrary.simpleMessage("سياراتي"),
    "name": MessageLookupByLibrary.simpleMessage("الاسم"),
    "newBookingsWillAppearMessage": MessageLookupByLibrary.simpleMessage(
      "ستظهر هنا تلقائيًا الحجوزات الجديدة التي تتطلب موافقة.",
    ),
    "next": MessageLookupByLibrary.simpleMessage("التالي"),
    "no": MessageLookupByLibrary.simpleMessage("لا"),
    "noBookingStatusesAvailableMessage": MessageLookupByLibrary.simpleMessage(
      "لا توجد حالات حجز متاحة.",
    ),
    "noBookingsNeedApproval": MessageLookupByLibrary.simpleMessage(
      "لا توجد حجوزات تحتاج إلى موافقة حاليًا.",
    ),
    "noButtonLabel": MessageLookupByLibrary.simpleMessage("لا"),
    "noCarsFound": MessageLookupByLibrary.simpleMessage(
      "لم يتم العثور على سيارات",
    ),
    "noCategoriesAvailableMessage": MessageLookupByLibrary.simpleMessage(
      "لا توجد فئات متاحة.",
    ),
    "noChecklistFound": MessageLookupByLibrary.simpleMessage(
      "لم يتم العثور على قائمة فحص.",
    ),
    "noCouponsAvailable": MessageLookupByLibrary.simpleMessage(
      "لا توجد قسائم متاحة.",
    ),
    "noInternetConnection": MessageLookupByLibrary.simpleMessage(
      "لا يوجد اتصال بالإنترنت",
    ),
    "noItemsForCategoryMessage": MessageLookupByLibrary.simpleMessage(
      "لا توجد عناصر متاحة للفئة المحددة.",
    ),
    "noLineItemsFoundMessage": MessageLookupByLibrary.simpleMessage(
      "لا توجد بنود لهذه الباقة.",
    ),
    "noMaintenanceRequestsYet": MessageLookupByLibrary.simpleMessage(
      "لا توجد طلبات صيانة حتى الآن.",
    ),
    "noPackagesFoundForJobCardMessage": MessageLookupByLibrary.simpleMessage(
      "لا توجد باقات لهذه بطاقة العمل.",
    ),
    "noPromotionsFound": MessageLookupByLibrary.simpleMessage("لا توجد عروض."),
    "noServicesAvailable": MessageLookupByLibrary.simpleMessage(
      "لا توجد خدمات متاحة حاليًا.",
    ),
    "noStatusesAvailableMessage": MessageLookupByLibrary.simpleMessage(
      "لا توجد حالات متاحة.",
    ),
    "noStatusesLabel": MessageLookupByLibrary.simpleMessage("لا توجد حالات"),
    "notApplicableAbbreviation": MessageLookupByLibrary.simpleMessage(
      "غير متاح",
    ),
    "notAssignedLabel": MessageLookupByLibrary.simpleMessage("لم يتم التعيين"),
    "notValidUserEmail": MessageLookupByLibrary.simpleMessage(
      "البريد الإلكتروني للمستخدم غير صالح",
    ),
    "oiling": MessageLookupByLibrary.simpleMessage("الزيت"),
    "ok": MessageLookupByLibrary.simpleMessage("حسناً"),
    "okButtonLabel": MessageLookupByLibrary.simpleMessage("حسنًا"),
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
    "openJobCardToViewPackagesMessage": MessageLookupByLibrary.simpleMessage(
      "افتح بطاقة عمل لعرض الباقات المرتبطة بها.",
    ),
    "ourServices": MessageLookupByLibrary.simpleMessage("خدماتنا"),
    "packageCodeFallbackLabel": m20,
    "packageCodeLabel": m21,
    "packageItemsTitle": MessageLookupByLibrary.simpleMessage("عناصر الباقة"),
    "packageLineIdUnavailableMessage": MessageLookupByLibrary.simpleMessage(
      "رقم بند الباقة غير متاح.",
    ),
    "packageLineUnavailableLabel": MessageLookupByLibrary.simpleMessage(
      "بند الباقة غير متاح",
    ),
    "packageNoLineIdMessage": MessageLookupByLibrary.simpleMessage(
      "لا توفر هذه الباقة رقم بند. لا يمكن إضافة عناصر.",
    ),
    "packagesAppliedTitle": MessageLookupByLibrary.simpleMessage(
      "الباقات المطبقة",
    ),
    "payNowButtonLabel": MessageLookupByLibrary.simpleMessage("ادفع الآن"),
    "paymentCompletedMessage": MessageLookupByLibrary.simpleMessage(
      "تمت عملية الدفع بنجاح.",
    ),
    "paymentFailedTitle": MessageLookupByLibrary.simpleMessage(
      "فشلت عملية الدفع",
    ),
    "paymentNotCompletedMessage": MessageLookupByLibrary.simpleMessage(
      "لم تكتمل عملية الدفع. يرجى المحاولة مرة أخرى.",
    ),
    "paymentSuccessfulTitle": MessageLookupByLibrary.simpleMessage(
      "تمت عملية الدفع بنجاح",
    ),
    "phoneNumber": MessageLookupByLibrary.simpleMessage("رقم الهاتف"),
    "phoneNumberHint": MessageLookupByLibrary.simpleMessage("5XXXXXXXX"),
    "pickDateButtonLabel": MessageLookupByLibrary.simpleMessage("اختيار"),
    "pickDateRangeInstruction": MessageLookupByLibrary.simpleMessage(
      "اختر فترة زمنية وطبّق لتحديث البيانات.",
    ),
    "planYourDay": MessageLookupByLibrary.simpleMessage("خطط ليومك"),
    "plate": MessageLookupByLibrary.simpleMessage("اللوحة"),
    "plateFieldLabel": MessageLookupByLibrary.simpleMessage("اللوحة"),
    "plateLetters": MessageLookupByLibrary.simpleMessage("حروف اللوحة"),
    "plateNumbers": MessageLookupByLibrary.simpleMessage("أرقام اللوحة"),
    "plateUnavailableLabel": MessageLookupByLibrary.simpleMessage(
      "اللوحة غير متاحة",
    ),
    "pleaseLogInToViewYourProfile": MessageLookupByLibrary.simpleMessage(
      "يرجى تسجيل الدخول لعرض ملفك الشخصي",
    ),
    "pleaseSelectCategoryMessage": MessageLookupByLibrary.simpleMessage(
      "يرجى اختيار فئة.",
    ),
    "pleaseSelectDateRange": MessageLookupByLibrary.simpleMessage(
      "يرجى تحديد الفترة الزمنية",
    ),
    "pleaseSelectItemToAddMessage": MessageLookupByLibrary.simpleMessage(
      "يرجى اختيار عنصر لإضافته.",
    ),
    "pricePrefixedIncludedLabel": MessageLookupByLibrary.simpleMessage(
      "السعر: مشمول",
    ),
    "pricePrefixedLabel": m22,
    "profileAppbar": MessageLookupByLibrary.simpleMessage("الملف الشخصي"),
    "profileNav": MessageLookupByLibrary.simpleMessage("الملف الشخصي"),
    "profilePhotoRequired": MessageLookupByLibrary.simpleMessage(
      "يرجى اختيار صورة للملف الشخصي.",
    ),
    "profilePhotoSelectionFailed": MessageLookupByLibrary.simpleMessage(
      "تعذر اختيار هذه الصورة. يرجى المحاولة مرة أخرى.",
    ),
    "profileUpdateFailed": MessageLookupByLibrary.simpleMessage(
      "تعذر تحديث ملفك الشخصي. يرجى المحاولة مرة أخرى.",
    ),
    "profileUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "تم تحديث الملف الشخصي بنجاح.",
    ),
    "promotionDescription": MessageLookupByLibrary.simpleMessage("وصف العرض"),
    "promotionName": MessageLookupByLibrary.simpleMessage("اسم العرض"),
    "promotionSavedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "تم حفظ العرض بنجاح",
    ),
    "promotionTitle": MessageLookupByLibrary.simpleMessage("العرض"),
    "promotionsLoadErrorFallback": MessageLookupByLibrary.simpleMessage(
      "فشل تحميل العروض",
    ),
    "promotionsTitle": MessageLookupByLibrary.simpleMessage("العروض"),
    "quantityLabel": MessageLookupByLibrary.simpleMessage("الكمية"),
    "quantityMustBeGreaterThanZeroMessage":
        MessageLookupByLibrary.simpleMessage("يجب أن تكون الكمية أكبر من صفر."),
    "quantityValueLabel": m23,
    "refreshCategoriesTooltip": MessageLookupByLibrary.simpleMessage(
      "تحديث الفئات",
    ),
    "refreshPackagesTooltip": MessageLookupByLibrary.simpleMessage(
      "تحديث الباقات",
    ),
    "refreshTooltip": MessageLookupByLibrary.simpleMessage("تحديث"),
    "register": MessageLookupByLibrary.simpleMessage("تسجيل"),
    "removeButtonLabel": MessageLookupByLibrary.simpleMessage("إزالة"),
    "removeItemTitle": MessageLookupByLibrary.simpleMessage("إزالة العنصر"),
    "removePackageConfirmation": m24,
    "removePackageTitle": MessageLookupByLibrary.simpleMessage("إزالة الباقة"),
    "requiredFieldError": MessageLookupByLibrary.simpleMessage("مطلوب"),
    "resendOTP": MessageLookupByLibrary.simpleMessage("إعادة إرسال رمز التحقق"),
    "resetButtonLabel": MessageLookupByLibrary.simpleMessage("إعادة تعيين"),
    "resolvingPackageLineIdMessage": MessageLookupByLibrary.simpleMessage(
      "جارٍ تحديد رقم بند الباقة...",
    ),
    "retryButtonLabel": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
    "saveChanges": MessageLookupByLibrary.simpleMessage("حفظ التغييرات"),
    "saveChecklistButtonLabel": MessageLookupByLibrary.simpleMessage(
      "حفظ قائمة الفحص",
    ),
    "savePromotion": MessageLookupByLibrary.simpleMessage("حفظ العرض"),
    "savingEllipsis": MessageLookupByLibrary.simpleMessage("جارٍ الحفظ..."),
    "scheduleFieldLabel": MessageLookupByLibrary.simpleMessage("الجدول"),
    "scheduleNotSetLabel": MessageLookupByLibrary.simpleMessage(
      "لم يتم تحديد الجدول",
    ),
    "scheduledStatusLabel": MessageLookupByLibrary.simpleMessage("مجدول"),
    "selectCategoryToLoadItemsMessage": MessageLookupByLibrary.simpleMessage(
      "اختر فئة لتحميل العناصر.",
    ),
    "selectEndDate": MessageLookupByLibrary.simpleMessage(
      "اختر تاريخ الانتهاء",
    ),
    "selectEndDateLabel": MessageLookupByLibrary.simpleMessage(
      "اختر تاريخ الانتهاء",
    ),
    "selectManufacturer": MessageLookupByLibrary.simpleMessage(
      "اختر الشركة المصنعة",
    ),
    "selectModel": MessageLookupByLibrary.simpleMessage("اختر الموديل"),
    "selectPackageLabel": MessageLookupByLibrary.simpleMessage("اختر الباقة"),
    "selectStartDate": MessageLookupByLibrary.simpleMessage("اختر تاريخ البدء"),
    "selectStartDateLabel": MessageLookupByLibrary.simpleMessage(
      "اختر تاريخ البدء",
    ),
    "selectYear": MessageLookupByLibrary.simpleMessage("اختر السنة"),
    "serviceRequestCreatedMessage": MessageLookupByLibrary.simpleMessage(
      "تم إنشاء طلب الخدمة.",
    ),
    "showingBookingsNeedingApproval": MessageLookupByLibrary.simpleMessage(
      "عرض الحجوزات التي تحتاج إلى موافقة",
    ),
    "signInAsCreditManagerMessage": MessageLookupByLibrary.simpleMessage(
      "يرجى تسجيل الدخول كمدير ائتمان لعرض الحجوزات التي تحتاج إلى موافقة.",
    ),
    "signInAsTechnicianMessage": MessageLookupByLibrary.simpleMessage(
      "يرجى تسجيل الدخول كفني لعرض طلبات الصيانة المخصصة لك.",
    ),
    "signInRequiredTitle": MessageLookupByLibrary.simpleMessage(
      "تسجيل الدخول مطلوب",
    ),
    "skip": MessageLookupByLibrary.simpleMessage("تخطى"),
    "somethingWentWrong": MessageLookupByLibrary.simpleMessage("حدث خطأ ما."),
    "srLineIdLabel": m25,
    "standardTagLabel": MessageLookupByLibrary.simpleMessage("عادي"),
    "start": MessageLookupByLibrary.simpleMessage("ابدأ"),
    "startDate": MessageLookupByLibrary.simpleMessage("تاريخ البدء"),
    "statusCodeLabel": m26,
    "statusIdLabel": m27,
    "statusLabel": MessageLookupByLibrary.simpleMessage("الحالة"),
    "statusUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "تم تحديث الحالة بنجاح.",
    ),
    "statusesSelectedCount": m28,
    "submit": MessageLookupByLibrary.simpleMessage("إرسال"),
    "tapFilterToRefineJobs": MessageLookupByLibrary.simpleMessage(
      "اضغط على أحد الفلاتر لتحديد المهام المخصصة لك.",
    ),
    "technicianAppError": MessageLookupByLibrary.simpleMessage(
      "يجب على مستخدمي الفنيين استخدام تطبيق Motor Lube للفنيين.",
    ),
    "technicianFieldLabel": MessageLookupByLibrary.simpleMessage("الفني"),
    "toDateLabel": MessageLookupByLibrary.simpleMessage("إلى"),
    "totalPriceLabel": MessageLookupByLibrary.simpleMessage("السعر الإجمالي"),
    "towiling": MessageLookupByLibrary.simpleMessage("تولينغ"),
    "unableToDetermineTechnicianIdMessage":
        MessageLookupByLibrary.simpleMessage("تعذر تحديد معرف الفني."),
    "unableToInitiatePayment": MessageLookupByLibrary.simpleMessage(
      "تعذر بدء عملية الدفع.",
    ),
    "unableToLoadBookings": MessageLookupByLibrary.simpleMessage(
      "تعذر تحميل الحجوزات",
    ),
    "unableToLoadRequests": MessageLookupByLibrary.simpleMessage(
      "تعذر تحميل الطلبات",
    ),
    "unableToLoadServices": MessageLookupByLibrary.simpleMessage(
      "تعذر تحميل الخدمات",
    ),
    "unableToResolvePackageLineIdMessage": MessageLookupByLibrary.simpleMessage(
      "تعذر تحديد رقم بند الباقة.",
    ),
    "unavailableLabel": MessageLookupByLibrary.simpleMessage("غير متاح"),
    "upcomingService": MessageLookupByLibrary.simpleMessage("الخدمة القادمة"),
    "upcomingServicesAssignedTechnicianLabel":
        MessageLookupByLibrary.simpleMessage("الفني المعتمد"),
    "upcomingServicesBookingDetailsTitle": MessageLookupByLibrary.simpleMessage(
      "تفاصيل الحجز",
    ),
    "upcomingServicesConnectionTimedOut": MessageLookupByLibrary.simpleMessage(
      "انتهت مهلة الاتصال. يرجى المحاولة مرة أخرى.",
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
    "upcomingServicesFilterAnyDate": MessageLookupByLibrary.simpleMessage(
      "أي تاريخ",
    ),
    "upcomingServicesFilterAnyStatus": MessageLookupByLibrary.simpleMessage(
      "أي حالة",
    ),
    "upcomingServicesFilterApply": MessageLookupByLibrary.simpleMessage(
      "تطبيق عوامل التصفية",
    ),
    "upcomingServicesFilterFrom": MessageLookupByLibrary.simpleMessage("من"),
    "upcomingServicesFilterLoadingStatuses":
        MessageLookupByLibrary.simpleMessage("جارٍ تحميل حالات الحجز..."),
    "upcomingServicesFilterNoStatuses": MessageLookupByLibrary.simpleMessage(
      "لا توجد حالات متاحة.",
    ),
    "upcomingServicesFilterStatus": MessageLookupByLibrary.simpleMessage(
      "الحالة",
    ),
    "upcomingServicesFilterSubtitle": MessageLookupByLibrary.simpleMessage(
      "اضغط على عامل تصفية لتحسين مواعيدك.",
    ),
    "upcomingServicesFilterTitle": MessageLookupByLibrary.simpleMessage(
      "خطط يومك",
    ),
    "upcomingServicesFilterTo": MessageLookupByLibrary.simpleMessage("إلى"),
    "upcomingServicesLoadingDate": MessageLookupByLibrary.simpleMessage(
      "00 Mon 0000",
    ),
    "upcomingServicesLoadingLocation": MessageLookupByLibrary.simpleMessage(
      "جارٍ تحميل الموقع",
    ),
    "upcomingServicesLoadingPackage": MessageLookupByLibrary.simpleMessage(
      "جارٍ تحميل اسم الباقة",
    ),
    "upcomingServicesLoadingPlate": MessageLookupByLibrary.simpleMessage(
      "0000 AAA",
    ),
    "upcomingServicesLoadingStatus": MessageLookupByLibrary.simpleMessage(
      "جارٍ التحميل",
    ),
    "upcomingServicesLoadingTechnician": MessageLookupByLibrary.simpleMessage(
      "جارٍ تحميل اسم الفني",
    ),
    "upcomingServicesLoadingTime": MessageLookupByLibrary.simpleMessage(
      "00:00 AM",
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
    "upcomingServicesStatusAccepted": MessageLookupByLibrary.simpleMessage(
      "مقبولة",
    ),
    "upcomingServicesStatusArrived": MessageLookupByLibrary.simpleMessage(
      "وصلت",
    ),
    "upcomingServicesStatusCancelled": MessageLookupByLibrary.simpleMessage(
      "ملغاة",
    ),
    "upcomingServicesStatusCompleted": MessageLookupByLibrary.simpleMessage(
      "مكتملة",
    ),
    "upcomingServicesStatusEnRoute": MessageLookupByLibrary.simpleMessage(
      "في الطريق",
    ),
    "upcomingServicesStatusExpired": MessageLookupByLibrary.simpleMessage(
      "منتهية",
    ),
    "upcomingServicesStatusFallback": m29,
    "upcomingServicesStatusNeedsApproval": MessageLookupByLibrary.simpleMessage(
      "تحتاج موافقة",
    ),
    "upcomingServicesStatusNew": MessageLookupByLibrary.simpleMessage("جديدة"),
    "upcomingServicesStatusOpen": MessageLookupByLibrary.simpleMessage(
      "مفتوحة",
    ),
    "upcomingServicesStatusPaid": MessageLookupByLibrary.simpleMessage(
      "مدفوعة",
    ),
    "upcomingServicesStatusPending": MessageLookupByLibrary.simpleMessage(
      "قيد الانتظار",
    ),
    "upcomingServicesStatusRejected": MessageLookupByLibrary.simpleMessage(
      "مرفوضة",
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
    "userCarsCardSemantics": m30,
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
    "userCarsLicensePlateSemantics": m31,
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
    "userIdentifierMissingMessage": MessageLookupByLibrary.simpleMessage(
      "معرف المستخدم مفقود.",
    ),
    "userName": MessageLookupByLibrary.simpleMessage("اسم المستخدم"),
    "userNameHint": MessageLookupByLibrary.simpleMessage("أدخل اسم المستخدم"),
    "vehicleChecklistTitle": MessageLookupByLibrary.simpleMessage(
      "قائمة فحص المركبة",
    ),
    "vehicleFieldLabel": MessageLookupByLibrary.simpleMessage("المركبة"),
    "vehicleNotSetLabel": MessageLookupByLibrary.simpleMessage(
      "لم يتم تحديد المركبة",
    ),
    "verify": MessageLookupByLibrary.simpleMessage("تحقق"),
    "vin": MessageLookupByLibrary.simpleMessage("رقم الهيكل"),
    "vinFieldLabel": MessageLookupByLibrary.simpleMessage("رقم الهيكل"),
    "waitForCurrentActionMessage": MessageLookupByLibrary.simpleMessage(
      "يرجى الانتظار حتى تنتهي العملية الحالية.",
    ),
    "waitForCurrentDeleteActionMessage": MessageLookupByLibrary.simpleMessage(
      "يرجى الانتظار حتى تنتهي عملية الحذف الحالية.",
    ),
    "year": MessageLookupByLibrary.simpleMessage("السنة"),
    "yes": MessageLookupByLibrary.simpleMessage("نعم"),
    "yesCancelButtonLabel": MessageLookupByLibrary.simpleMessage("نعم، إلغاء"),
    "yourCars": MessageLookupByLibrary.simpleMessage("سياراتك"),
  };
}
