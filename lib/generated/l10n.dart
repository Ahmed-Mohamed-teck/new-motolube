// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Mobile Car Service`
  String get onBoardingTitle1 {
    return Intl.message(
      'Mobile Car Service',
      name: 'onBoardingTitle1',
      desc: '',
      args: [],
    );
  }

  /// `Emergency Service`
  String get onBoardingTitle2 {
    return Intl.message(
      'Emergency Service',
      name: 'onBoardingTitle2',
      desc: '',
      args: [],
    );
  }

  /// `Following Dealer Standards`
  String get onBoardingTitle3 {
    return Intl.message(
      'Following Dealer Standards',
      name: 'onBoardingTitle3',
      desc: '',
      args: [],
    );
  }

  /// `Skip the hassle of workshop visits! Our expert mobile auto service brings professional maintenance & repairs right to your location.`
  String get onBoardingDescription1 {
    return Intl.message(
      'Skip the hassle of workshop visits! Our expert mobile auto service brings professional maintenance & repairs right to your location.',
      name: 'onBoardingDescription1',
      desc: '',
      args: [],
    );
  }

  /// `We use the latest and best solutions to advance the field of car service to provide a unique experience that has never been experienced before.`
  String get onBoardingDescription2 {
    return Intl.message(
      'We use the latest and best solutions to advance the field of car service to provide a unique experience that has never been experienced before.',
      name: 'onBoardingDescription2',
      desc: '',
      args: [],
    );
  }

  /// `What’s guarding your vehicle’s undercarriage? At Motor Lube, we don’t just protect – we armor your car with Revive Premium Wax-Based Undercoat Treatment.`
  String get onBoardingDescription3 {
    return Intl.message(
      'What’s guarding your vehicle’s undercarriage? At Motor Lube, we don’t just protect – we armor your car with Revive Premium Wax-Based Undercoat Treatment.',
      name: 'onBoardingDescription3',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get homeNav {
    return Intl.message(
      'Home',
      name: 'homeNav',
      desc: '',
      args: [],
    );
  }

  /// `My Cars`
  String get myCarsNav {
    return Intl.message(
      'My Cars',
      name: 'myCarsNav',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profileNav {
    return Intl.message(
      'Profile',
      name: 'profileNav',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get moreNav {
    return Intl.message(
      'More',
      name: 'moreNav',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get homeAppbar {
    return Intl.message(
      'Home',
      name: 'homeAppbar',
      desc: '',
      args: [],
    );
  }

  /// `Contanct Us`
  String get contactUsAppbar {
    return Intl.message(
      'Contanct Us',
      name: 'contactUsAppbar',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profileAppbar {
    return Intl.message(
      'Profile',
      name: 'profileAppbar',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get moreAppbar {
    return Intl.message(
      'More',
      name: 'moreAppbar',
      desc: '',
      args: [],
    );
  }

  /// `next`
  String get next {
    return Intl.message(
      'next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `start`
  String get start {
    return Intl.message(
      'start',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  /// `Basic Services`
  String get basicServices {
    return Intl.message(
      'Basic Services',
      name: 'basicServices',
      desc: '',
      args: [],
    );
  }

  /// `Major Services`
  String get majorServices {
    return Intl.message(
      'Major Services',
      name: 'majorServices',
      desc: '',
      args: [],
    );
  }

  /// `Car Repair`
  String get carRepair {
    return Intl.message(
      'Car Repair',
      name: 'carRepair',
      desc: '',
      args: [],
    );
  }

  /// `Batteries`
  String get batteires {
    return Intl.message(
      'Batteries',
      name: 'batteires',
      desc: '',
      args: [],
    );
  }

  /// `Car Evaluation`
  String get carEvaluation {
    return Intl.message(
      'Car Evaluation',
      name: 'carEvaluation',
      desc: '',
      args: [],
    );
  }

  /// `Towiling`
  String get towiling {
    return Intl.message(
      'Towiling',
      name: 'towiling',
      desc: '',
      args: [],
    );
  }

  /// `Mobile Services`
  String get mobileServices {
    return Intl.message(
      'Mobile Services',
      name: 'mobileServices',
      desc: '',
      args: [],
    );
  }

  /// `Oiling`
  String get oiling {
    return Intl.message(
      'Oiling',
      name: 'oiling',
      desc: '',
      args: [],
    );
  }

  /// `Flat Tyre`
  String get flatTyre {
    return Intl.message(
      'Flat Tyre',
      name: 'flatTyre',
      desc: '',
      args: [],
    );
  }

  /// `Car Wash`
  String get carWash {
    return Intl.message(
      'Car Wash',
      name: 'carWash',
      desc: '',
      args: [],
    );
  }

  /// `Insurance Claims`
  String get insuranceClaims {
    return Intl.message(
      'Insurance Claims',
      name: 'insuranceClaims',
      desc: '',
      args: [],
    );
  }

  /// `Car Detailing`
  String get carDetailing {
    return Intl.message(
      'Car Detailing',
      name: 'carDetailing',
      desc: '',
      args: [],
    );
  }

  /// `Our Services`
  String get ourServices {
    return Intl.message(
      'Our Services',
      name: 'ourServices',
      desc: '',
      args: [],
    );
  }

  /// `Best Offers`
  String get bestOffers {
    return Intl.message(
      'Best Offers',
      name: 'bestOffers',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get more {
    return Intl.message(
      'More',
      name: 'more',
      desc: '',
      args: [],
    );
  }

  /// `Your Cars`
  String get yourCars {
    return Intl.message(
      'Your Cars',
      name: 'yourCars',
      desc: '',
      args: [],
    );
  }

  /// `Save Promotion`
  String get savePromotion {
    return Intl.message(
      'Save Promotion',
      name: 'savePromotion',
      desc: '',
      args: [],
    );
  }

  /// `Promotion saved successfully`
  String get promotionSavedSuccessfully {
    return Intl.message(
      'Promotion saved successfully',
      name: 'promotionSavedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while saving the promotion, please try again later.`
  String get errorSavingPromotion {
    return Intl.message(
      'An error occurred while saving the promotion, please try again later.',
      name: 'errorSavingPromotion',
      desc: '',
      args: [],
    );
  }

  /// `Promotion Name`
  String get promotionName {
    return Intl.message(
      'Promotion Name',
      name: 'promotionName',
      desc: '',
      args: [],
    );
  }

  /// `Enter promotion name`
  String get enterPromotionNameHint {
    return Intl.message(
      'Enter promotion name',
      name: 'enterPromotionNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Promotion Description`
  String get promotionDescription {
    return Intl.message(
      'Promotion Description',
      name: 'promotionDescription',
      desc: '',
      args: [],
    );
  }

  /// `Select Start Date`
  String get selectStartDate {
    return Intl.message(
      'Select Start Date',
      name: 'selectStartDate',
      desc: '',
      args: [],
    );
  }

  /// `Start Date`
  String get startDate {
    return Intl.message(
      'Start Date',
      name: 'startDate',
      desc: '',
      args: [],
    );
  }

  /// `Select End Date`
  String get selectEndDate {
    return Intl.message(
      'Select End Date',
      name: 'selectEndDate',
      desc: '',
      args: [],
    );
  }

  /// `End Date`
  String get endDate {
    return Intl.message(
      'End Date',
      name: 'endDate',
      desc: '',
      args: [],
    );
  }

  /// `Please fill all fields`
  String get fillAllFields {
    return Intl.message(
      'Please fill all fields',
      name: 'fillAllFields',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `welcome back, Loging Motorlube`
  String get loginWelcomeMessage {
    return Intl.message(
      'welcome back, Loging Motorlube',
      name: 'loginWelcomeMessage',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `login`
  String get login {
    return Intl.message(
      'login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a proper value`
  String get enterProperValue {
    return Intl.message(
      'Please enter a proper value',
      name: 'enterProperValue',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get enterValidEmail {
    return Intl.message(
      'Please enter a valid email',
      name: 'enterValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get comment {
    return Intl.message(
      'Comment',
      name: 'comment',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Mail us at`
  String get mailUsAt {
    return Intl.message(
      'Mail us at',
      name: 'mailUsAt',
      desc: '',
      args: [],
    );
  }

  /// `Maintenance`
  String get maintenanceNav {
    return Intl.message(
      'Maintenance',
      name: 'maintenanceNav',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contactUsNav {
    return Intl.message(
      'Contact Us',
      name: 'contactUsNav',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred during authentication`
  String get authenticationErrorMessage {
    return Intl.message(
      'An error occurred during authentication',
      name: 'authenticationErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get errorTitle {
    return Intl.message(
      'Error',
      name: 'errorTitle',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get Profile {
    return Intl.message(
      'Profile',
      name: 'Profile',
      desc: '',
      args: [],
    );
  }

  /// `Add Car`
  String get addCar {
    return Intl.message(
      'Add Car',
      name: 'addCar',
      desc: '',
      args: [],
    );
  }

  /// `Plate`
  String get plate {
    return Intl.message(
      'Plate',
      name: 'plate',
      desc: '',
      args: [],
    );
  }

  /// `Plate Letters`
  String get plateLetters {
    return Intl.message(
      'Plate Letters',
      name: 'plateLetters',
      desc: '',
      args: [],
    );
  }

  /// `Plate Numbers`
  String get plateNumbers {
    return Intl.message(
      'Plate Numbers',
      name: 'plateNumbers',
      desc: '',
      args: [],
    );
  }

  /// `Car Info`
  String get carInfo {
    return Intl.message(
      'Car Info',
      name: 'carInfo',
      desc: '',
      args: [],
    );
  }

  /// `Select Manufacturer`
  String get selectManufacturer {
    return Intl.message(
      'Select Manufacturer',
      name: 'selectManufacturer',
      desc: '',
      args: [],
    );
  }

  /// `Model`
  String get model {
    return Intl.message(
      'Model',
      name: 'model',
      desc: '',
      args: [],
    );
  }

  /// `Select Model`
  String get selectModel {
    return Intl.message(
      'Select Model',
      name: 'selectModel',
      desc: '',
      args: [],
    );
  }

  /// `Year`
  String get year {
    return Intl.message(
      'Year',
      name: 'year',
      desc: '',
      args: [],
    );
  }

  /// `Select Year`
  String get selectYear {
    return Intl.message(
      'Select Year',
      name: 'selectYear',
      desc: '',
      args: [],
    );
  }

  /// `VIN`
  String get vin {
    return Intl.message(
      'VIN',
      name: 'vin',
      desc: '',
      args: [],
    );
  }

  /// `VIN must be 17 characters`
  String get characterVinLimit {
    return Intl.message(
      'VIN must be 17 characters',
      name: 'characterVinLimit',
      desc: '',
      args: [],
    );
  }

  /// `VIN must be 17 characters`
  String get characterVinLimitError {
    return Intl.message(
      'VIN must be 17 characters',
      name: 'characterVinLimitError',
      desc: '',
      args: [],
    );
  }

  /// `Are you the owner of this car?`
  String get areYouOwnerThisCar {
    return Intl.message(
      'Are you the owner of this car?',
      name: 'areYouOwnerThisCar',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `Company Name`
  String get companyName {
    return Intl.message(
      'Company Name',
      name: 'companyName',
      desc: '',
      args: [],
    );
  }

  /// `e.g. MotorLube Co.`
  String get companyNameHint {
    return Intl.message(
      'e.g. MotorLube Co.',
      name: 'companyNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter company name`
  String get companyNameError {
    return Intl.message(
      'Please enter company name',
      name: 'companyNameError',
      desc: '',
      args: [],
    );
  }

  /// `Commercial Registration Number (CRN)`
  String get crn {
    return Intl.message(
      'Commercial Registration Number (CRN)',
      name: 'crn',
      desc: '',
      args: [],
    );
  }

  /// `e.g. 1234567890`
  String get crnHint {
    return Intl.message(
      'e.g. 1234567890',
      name: 'crnHint',
      desc: '',
      args: [],
    );
  }

  /// `Manufacturer`
  String get manufacturer {
    return Intl.message(
      'Manufacturer',
      name: 'manufacturer',
      desc: '',
      args: [],
    );
  }

  /// `Please enter Commercial Registration Number (CRN)`
  String get crnError {
    return Intl.message(
      'Please enter Commercial Registration Number (CRN)',
      name: 'crnError',
      desc: '',
      args: [],
    );
  }

  /// `CRN must be 10 digits`
  String get crnLengthError {
    return Intl.message(
      'CRN must be 10 digits',
      name: 'crnLengthError',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get verify {
    return Intl.message(
      'Verify',
      name: 'verify',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `User Name`
  String get userName {
    return Intl.message(
      'User Name',
      name: 'userName',
      desc: '',
      args: [],
    );
  }

  /// `Enter user name`
  String get userNameHint {
    return Intl.message(
      'Enter user name',
      name: 'userNameHint',
      desc: '',
      args: [],
    );
  }

  /// `User Email`
  String get userEmail {
    return Intl.message(
      'User Email',
      name: 'userEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter user email`
  String get userEmailHint {
    return Intl.message(
      'Enter user email',
      name: 'userEmailHint',
      desc: '',
      args: [],
    );
  }

  /// `User email is not valid`
  String get notValidUserEmail {
    return Intl.message(
      'User email is not valid',
      name: 'notValidUserEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter the OTP sent to`
  String get enterOtpSentTo {
    return Intl.message(
      'Enter the OTP sent to',
      name: 'enterOtpSentTo',
      desc: '',
      args: [],
    );
  }

  /// `Expires in`
  String get expiresIn {
    return Intl.message(
      'Expires in',
      name: 'expiresIn',
      desc: '',
      args: [],
    );
  }

  /// `Didn't receive the OTP?`
  String get didntReceiveOtp {
    return Intl.message(
      'Didn\'t receive the OTP?',
      name: 'didntReceiveOtp',
      desc: '',
      args: [],
    );
  }

  /// `Resend OTP`
  String get resendOTP {
    return Intl.message(
      'Resend OTP',
      name: 'resendOTP',
      desc: '',
      args: [],
    );
  }

  /// `Change Language`
  String get changeLanguage {
    return Intl.message(
      'Change Language',
      name: 'changeLanguage',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get arabic {
    return Intl.message(
      'Arabic',
      name: 'arabic',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
