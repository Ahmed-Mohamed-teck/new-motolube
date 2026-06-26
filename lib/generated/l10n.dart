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
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
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
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
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
    return Intl.message('Home', name: 'homeNav', desc: '', args: []);
  }

  /// `My Cars`
  String get myCarsNav {
    return Intl.message('My Cars', name: 'myCarsNav', desc: '', args: []);
  }

  /// `Profile`
  String get profileNav {
    return Intl.message('Profile', name: 'profileNav', desc: '', args: []);
  }

  /// `More`
  String get moreNav {
    return Intl.message('More', name: 'moreNav', desc: '', args: []);
  }

  /// `Home`
  String get homeAppbar {
    return Intl.message('Home', name: 'homeAppbar', desc: '', args: []);
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
    return Intl.message('Profile', name: 'profileAppbar', desc: '', args: []);
  }

  /// `More`
  String get moreAppbar {
    return Intl.message('More', name: 'moreAppbar', desc: '', args: []);
  }

  /// `next`
  String get next {
    return Intl.message('next', name: 'next', desc: '', args: []);
  }

  /// `start`
  String get start {
    return Intl.message('start', name: 'start', desc: '', args: []);
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
    return Intl.message('Car Repair', name: 'carRepair', desc: '', args: []);
  }

  /// `Batteries`
  String get batteires {
    return Intl.message('Batteries', name: 'batteires', desc: '', args: []);
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
    return Intl.message('Towiling', name: 'towiling', desc: '', args: []);
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
    return Intl.message('Oiling', name: 'oiling', desc: '', args: []);
  }

  /// `Flat Tyre`
  String get flatTyre {
    return Intl.message('Flat Tyre', name: 'flatTyre', desc: '', args: []);
  }

  /// `Car Wash`
  String get carWash {
    return Intl.message('Car Wash', name: 'carWash', desc: '', args: []);
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
    return Intl.message('Best Offers', name: 'bestOffers', desc: '', args: []);
  }

  /// `More`
  String get more {
    return Intl.message('More', name: 'more', desc: '', args: []);
  }

  /// `Your Cars`
  String get yourCars {
    return Intl.message('Your Cars', name: 'yourCars', desc: '', args: []);
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
    return Intl.message('Start Date', name: 'startDate', desc: '', args: []);
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
    return Intl.message('End Date', name: 'endDate', desc: '', args: []);
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
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
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
    return Intl.message('login', name: 'login', desc: '', args: []);
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
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
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Account deletion request submitted`
  String get accountDeletionRequestSubmitted {
    return Intl.message(
      'Account deletion request submitted',
      name: 'accountDeletionRequestSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Account Deletion`
  String get confirmAccountDeletion {
    return Intl.message(
      'Confirm Account Deletion',
      name: 'confirmAccountDeletion',
      desc: '',
      args: [],
    );
  }

  /// `Account deletion is irreversible after 30 days.`
  String get accountDeletionIrreversible30Days {
    return Intl.message(
      'Account deletion is irreversible after 30 days.',
      name: 'accountDeletionIrreversible30Days',
      desc: '',
      args: [],
    );
  }

  /// `Account deletion request submitted on {date}. Your data will be deleted within 30 days of the request.`
  String accountDeletionSubmittedMessage(String date) {
    return Intl.message(
      'Account deletion request submitted on $date. Your data will be deleted within 30 days of the request.',
      name: 'accountDeletionSubmittedMessage',
      desc: '',
      args: [date],
    );
  }

  /// `Unable to submit deletion request because this account has no email address.`
  String get accountDeletionEmailMissing {
    return Intl.message(
      'Unable to submit deletion request because this account has no email address.',
      name: 'accountDeletionEmailMissing',
      desc: '',
      args: [],
    );
  }

  /// `Unable to submit account deletion request. Please try again.`
  String get accountDeletionFailed {
    return Intl.message(
      'Unable to submit account deletion request. Please try again.',
      name: 'accountDeletionFailed',
      desc: '',
      args: [],
    );
  }

  /// `Please log in to view your profile`
  String get pleaseLogInToViewYourProfile {
    return Intl.message(
      'Please log in to view your profile',
      name: 'pleaseLogInToViewYourProfile',
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
    return Intl.message('Comment', name: 'comment', desc: '', args: []);
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `Mail us at`
  String get mailUsAt {
    return Intl.message('Mail us at', name: 'mailUsAt', desc: '', args: []);
  }

  /// `Inquiry sent`
  String get contactUsInquirySentTitle {
    return Intl.message(
      'Inquiry sent',
      name: 'contactUsInquirySentTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your inquiry has been sent successfully.`
  String get contactUsInquirySentMessage {
    return Intl.message(
      'Your inquiry has been sent successfully.',
      name: 'contactUsInquirySentMessage',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
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
    return Intl.message('Contact Us', name: 'contactUsNav', desc: '', args: []);
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
    return Intl.message('Error', name: 'errorTitle', desc: '', args: []);
  }

  /// `There is an update available`
  String get forceUpdateTitle {
    return Intl.message(
      'There is an update available',
      name: 'forceUpdateTitle',
      desc: '',
      args: [],
    );
  }

  /// `A new update is available. Please update the app to continue.`
  String get forceUpdateMessage {
    return Intl.message(
      'A new update is available. Please update the app to continue.',
      name: 'forceUpdateMessage',
      desc: '',
      args: [],
    );
  }

  /// `Update Now`
  String get forceUpdateButton {
    return Intl.message(
      'Update Now',
      name: 'forceUpdateButton',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get Profile {
    return Intl.message('Profile', name: 'Profile', desc: '', args: []);
  }

  /// `Add Car`
  String get addCar {
    return Intl.message('Add Car', name: 'addCar', desc: '', args: []);
  }

  /// `Plate`
  String get plate {
    return Intl.message('Plate', name: 'plate', desc: '', args: []);
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
    return Intl.message('Car Info', name: 'carInfo', desc: '', args: []);
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
    return Intl.message('Model', name: 'model', desc: '', args: []);
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
    return Intl.message('Year', name: 'year', desc: '', args: []);
  }

  /// `Select Year`
  String get selectYear {
    return Intl.message('Select Year', name: 'selectYear', desc: '', args: []);
  }

  /// `VIN`
  String get vin {
    return Intl.message('VIN', name: 'vin', desc: '', args: []);
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
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
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
    return Intl.message('e.g. 1234567890', name: 'crnHint', desc: '', args: []);
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
    return Intl.message('Verify', name: 'verify', desc: '', args: []);
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `User Name`
  String get userName {
    return Intl.message('User Name', name: 'userName', desc: '', args: []);
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

  /// `First Name`
  String get firstName {
    return Intl.message('First Name', name: 'firstName', desc: '', args: []);
  }

  /// `Enter first name`
  String get firstNameHint {
    return Intl.message(
      'Enter first name',
      name: 'firstNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get lastName {
    return Intl.message('Last Name', name: 'lastName', desc: '', args: []);
  }

  /// `Enter last name`
  String get lastNameHint {
    return Intl.message(
      'Enter last name',
      name: 'lastNameHint',
      desc: '',
      args: [],
    );
  }

  /// `User Email`
  String get userEmail {
    return Intl.message('User Email', name: 'userEmail', desc: '', args: []);
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
    return Intl.message('Expires in', name: 'expiresIn', desc: '', args: []);
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
    return Intl.message('Resend OTP', name: 'resendOTP', desc: '', args: []);
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
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Arabic`
  String get arabic {
    return Intl.message('Arabic', name: 'arabic', desc: '', args: []);
  }

  /// `Select Vehicle`
  String get bookServiceStepSelectVehicle {
    return Intl.message(
      'Select Vehicle',
      name: 'bookServiceStepSelectVehicle',
      desc: '',
      args: [],
    );
  }

  /// `Choose Package`
  String get bookServiceStepChoosePackage {
    return Intl.message(
      'Choose Package',
      name: 'bookServiceStepChoosePackage',
      desc: '',
      args: [],
    );
  }

  /// `Pick Location`
  String get bookServiceStepPickLocation {
    return Intl.message(
      'Pick Location',
      name: 'bookServiceStepPickLocation',
      desc: '',
      args: [],
    );
  }

  /// `Select Technician`
  String get bookServiceStepSelectTechnician {
    return Intl.message(
      'Select Technician',
      name: 'bookServiceStepSelectTechnician',
      desc: '',
      args: [],
    );
  }

  /// `Unable to determine customer information.`
  String get bookServiceCustomerInfoUnavailable {
    return Intl.message(
      'Unable to determine customer information.',
      name: 'bookServiceCustomerInfoUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Selected category: {label}`
  String bookServiceSelectedCategory(String label) {
    return Intl.message(
      'Selected category: $label',
      name: 'bookServiceSelectedCategory',
      desc: '',
      args: [label],
    );
  }

  /// `Reset`
  String get bookServiceReset {
    return Intl.message('Reset', name: 'bookServiceReset', desc: '', args: []);
  }

  /// `Please select a car before continuing.`
  String get bookServiceSelectCarBeforeContinuing {
    return Intl.message(
      'Please select a car before continuing.',
      name: 'bookServiceSelectCarBeforeContinuing',
      desc: '',
      args: [],
    );
  }

  /// `Please select a service package before continuing.`
  String get bookServiceSelectPackageBeforeContinuing {
    return Intl.message(
      'Please select a service package before continuing.',
      name: 'bookServiceSelectPackageBeforeContinuing',
      desc: '',
      args: [],
    );
  }

  /// `Please choose a location on the map before continuing.`
  String get bookServiceSelectLocationBeforeContinuing {
    return Intl.message(
      'Please choose a location on the map before continuing.',
      name: 'bookServiceSelectLocationBeforeContinuing',
      desc: '',
      args: [],
    );
  }

  /// `Please complete all steps before booking.`
  String get bookServiceCompleteAllStepsBeforeBooking {
    return Intl.message(
      'Please complete all steps before booking.',
      name: 'bookServiceCompleteAllStepsBeforeBooking',
      desc: '',
      args: [],
    );
  }

  /// `Unable to determine the selected package.`
  String get bookServiceSelectedPackageUnavailable {
    return Intl.message(
      'Unable to determine the selected package.',
      name: 'bookServiceSelectedPackageUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Unable to determine the technician branch.`
  String get bookServiceTechnicianBranchUnavailable {
    return Intl.message(
      'Unable to determine the technician branch.',
      name: 'bookServiceTechnicianBranchUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Unable to determine the technician information.`
  String get bookServiceTechnicianInfoUnavailable {
    return Intl.message(
      'Unable to determine the technician information.',
      name: 'bookServiceTechnicianInfoUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Unable to determine the selected vehicle.`
  String get bookServiceSelectedVehicleUnavailable {
    return Intl.message(
      'Unable to determine the selected vehicle.',
      name: 'bookServiceSelectedVehicleUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Appointment Confirmed`
  String get bookServiceAppointmentConfirmedTitle {
    return Intl.message(
      'Appointment Confirmed',
      name: 'bookServiceAppointmentConfirmedTitle',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get bookServiceOk {
    return Intl.message('OK', name: 'bookServiceOk', desc: '', args: []);
  }

  /// `Failed to create appointment. Please try again.`
  String get bookServiceCreateAppointmentFailed {
    return Intl.message(
      'Failed to create appointment. Please try again.',
      name: 'bookServiceCreateAppointmentFailed',
      desc: '',
      args: [],
    );
  }

  /// `Please sign in to select a car`
  String get bookServiceSignInToSelectCar {
    return Intl.message(
      'Please sign in to select a car',
      name: 'bookServiceSignInToSelectCar',
      desc: '',
      args: [],
    );
  }

  /// `Please select a car in Step 1 to view available packages.`
  String get bookServiceSelectCarInStepOne {
    return Intl.message(
      'Please select a car in Step 1 to view available packages.',
      name: 'bookServiceSelectCarInStepOne',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load packages.\n{message}`
  String bookServiceFailedToLoadPackages(String message) {
    return Intl.message(
      'Failed to load packages.\n$message',
      name: 'bookServiceFailedToLoadPackages',
      desc: '',
      args: [message],
    );
  }

  /// `Try Again`
  String get bookServiceTryAgain {
    return Intl.message(
      'Try Again',
      name: 'bookServiceTryAgain',
      desc: '',
      args: [],
    );
  }

  /// `No Packages Found`
  String get bookServiceNoPackagesFoundTitle {
    return Intl.message(
      'No Packages Found',
      name: 'bookServiceNoPackagesFoundTitle',
      desc: '',
      args: [],
    );
  }

  /// `We couldn’t find any packages for your selected car and category.\nTry changing filters or check again later.`
  String get bookServiceNoPackagesFoundDescription {
    return Intl.message(
      'We couldn’t find any packages for your selected car and category.\nTry changing filters or check again later.',
      name: 'bookServiceNoPackagesFoundDescription',
      desc: '',
      args: [],
    );
  }

  /// `{price} SAR`
  String bookServicePriceSar(String price) {
    return Intl.message(
      '$price SAR',
      name: 'bookServicePriceSar',
      desc: '',
      args: [price],
    );
  }

  /// `Packages will load once you continue.`
  String get bookServicePackagesLoadAfterContinue {
    return Intl.message(
      'Packages will load once you continue.',
      name: 'bookServicePackagesLoadAfterContinue',
      desc: '',
      args: [],
    );
  }

  /// `Tap anywhere on the map to select a service location.`
  String get bookServiceTapMapToSelectLocation {
    return Intl.message(
      'Tap anywhere on the map to select a service location.',
      name: 'bookServiceTapMapToSelectLocation',
      desc: '',
      args: [],
    );
  }

  /// `Selected location: ({latitude}, {longitude})`
  String bookServiceSelectedLocation(String latitude, String longitude) {
    return Intl.message(
      'Selected location: ($latitude, $longitude)',
      name: 'bookServiceSelectedLocation',
      desc: '',
      args: [latitude, longitude],
    );
  }

  /// `Select a service package and location to discover nearby technicians.`
  String get bookServiceSelectPackageAndLocation {
    return Intl.message(
      'Select a service package and location to discover nearby technicians.',
      name: 'bookServiceSelectPackageAndLocation',
      desc: '',
      args: [],
    );
  }

  /// `No available technician in this region.`
  String get bookServiceNoTechniciansInRegion {
    return Intl.message(
      'No available technician in this region.',
      name: 'bookServiceNoTechniciansInRegion',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get bookServiceRefresh {
    return Intl.message(
      'Refresh',
      name: 'bookServiceRefresh',
      desc: '',
      args: [],
    );
  }

  /// `Ready to find technicians near your chosen location?`
  String get bookServiceReadyToFindTechnicians {
    return Intl.message(
      'Ready to find technicians near your chosen location?',
      name: 'bookServiceReadyToFindTechnicians',
      desc: '',
      args: [],
    );
  }

  /// `Search Technicians`
  String get bookServiceSearchTechnicians {
    return Intl.message(
      'Search Technicians',
      name: 'bookServiceSearchTechnicians',
      desc: '',
      args: [],
    );
  }

  /// `{distance} km away`
  String bookServiceDistanceAway(String distance) {
    return Intl.message(
      '$distance km away',
      name: 'bookServiceDistanceAway',
      desc: '',
      args: [distance],
    );
  }

  /// `Tap a technician to see their available time slots.`
  String get bookServiceTapTechnicianForSlots {
    return Intl.message(
      'Tap a technician to see their available time slots.',
      name: 'bookServiceTapTechnicianForSlots',
      desc: '',
      args: [],
    );
  }

  /// `No slots available for the selected date.`
  String get bookServiceNoSlotsForSelectedDate {
    return Intl.message(
      'No slots available for the selected date.',
      name: 'bookServiceNoSlotsForSelectedDate',
      desc: '',
      args: [],
    );
  }

  /// `Available slots for {name}`
  String bookServiceAvailableSlotsFor(String name) {
    return Intl.message(
      'Available slots for $name',
      name: 'bookServiceAvailableSlotsFor',
      desc: '',
      args: [name],
    );
  }

  /// `Location Permission`
  String get bookServiceLocationPermissionTitle {
    return Intl.message(
      'Location Permission',
      name: 'bookServiceLocationPermissionTitle',
      desc: '',
      args: [],
    );
  }

  /// `We need your location to show it on the map.`
  String get bookServiceLocationPermissionMessage {
    return Intl.message(
      'We need your location to show it on the map.',
      name: 'bookServiceLocationPermissionMessage',
      desc: '',
      args: [],
    );
  }

  /// `Deny`
  String get bookServiceDeny {
    return Intl.message('Deny', name: 'bookServiceDeny', desc: '', args: []);
  }

  /// `Allow`
  String get bookServiceAllow {
    return Intl.message('Allow', name: 'bookServiceAllow', desc: '', args: []);
  }

  /// `No cars found`
  String get noCarsFound {
    return Intl.message(
      'No cars found',
      name: 'noCarsFound',
      desc: '',
      args: [],
    );
  }

  /// `Please login to view your cars`
  String get PleaseLoginToViewYourCarsMessage {
    return Intl.message(
      'Please login to view your cars',
      name: 'PleaseLoginToViewYourCarsMessage',
      desc: '',
      args: [],
    );
  }

  /// `We couldn’t find any cars matching your search .`
  String get userCarsEmptyDescription {
    return Intl.message(
      'We couldn’t find any cars matching your search .',
      name: 'userCarsEmptyDescription',
      desc: '',
      args: [],
    );
  }

  /// `Log in to continue`
  String get logInToContinue {
    return Intl.message(
      'Log in to continue',
      name: 'logInToContinue',
      desc: '',
      args: [],
    );
  }

  /// `Booking Details`
  String get upcomingServicesBookingDetailsTitle {
    return Intl.message(
      'Booking Details',
      name: 'upcomingServicesBookingDetailsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Service Package`
  String get upcomingServicesServicePackageLabel {
    return Intl.message(
      'Service Package',
      name: 'upcomingServicesServicePackageLabel',
      desc: '',
      args: [],
    );
  }

  /// `Service Location`
  String get upcomingServicesServiceLocationLabel {
    return Intl.message(
      'Service Location',
      name: 'upcomingServicesServiceLocationLabel',
      desc: '',
      args: [],
    );
  }

  /// `Assigned Technician`
  String get upcomingServicesAssignedTechnicianLabel {
    return Intl.message(
      'Assigned Technician',
      name: 'upcomingServicesAssignedTechnicianLabel',
      desc: '',
      args: [],
    );
  }

  /// `Location to be confirmed`
  String get upcomingServicesLocationFallback {
    return Intl.message(
      'Location to be confirmed',
      name: 'upcomingServicesLocationFallback',
      desc: '',
      args: [],
    );
  }

  /// `Technician to be assigned`
  String get upcomingServicesTechnicianFallback {
    return Intl.message(
      'Technician to be assigned',
      name: 'upcomingServicesTechnicianFallback',
      desc: '',
      args: [],
    );
  }

  /// `Plate unavailable`
  String get upcomingServicesPlateFallback {
    return Intl.message(
      'Plate unavailable',
      name: 'upcomingServicesPlateFallback',
      desc: '',
      args: [],
    );
  }

  /// `Date to be confirmed`
  String get upcomingServicesDateFallback {
    return Intl.message(
      'Date to be confirmed',
      name: 'upcomingServicesDateFallback',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get upcomingServicesStatusPending {
    return Intl.message(
      'Pending',
      name: 'upcomingServicesStatusPending',
      desc: '',
      args: [],
    );
  }

  /// `Expired`
  String get upcomingServicesStatusExpired {
    return Intl.message(
      'Expired',
      name: 'upcomingServicesStatusExpired',
      desc: '',
      args: [],
    );
  }

  /// `Upcoming`
  String get upcomingServicesStatusUpcoming {
    return Intl.message(
      'Upcoming',
      name: 'upcomingServicesStatusUpcoming',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get upcomingServicesStatusCompleted {
    return Intl.message(
      'Completed',
      name: 'upcomingServicesStatusCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Cancelled`
  String get upcomingServicesStatusCancelled {
    return Intl.message(
      'Cancelled',
      name: 'upcomingServicesStatusCancelled',
      desc: '',
      args: [],
    );
  }

  /// `New Booking`
  String get upcomingServicesStatusNew {
    return Intl.message(
      'New Booking',
      name: 'upcomingServicesStatusNew',
      desc: '',
      args: [],
    );
  }

  /// `Loading vehicle`
  String get upcomingServicesLoadingVehicle {
    return Intl.message(
      'Loading vehicle',
      name: 'upcomingServicesLoadingVehicle',
      desc: '',
      args: [],
    );
  }

  /// `Loading package title`
  String get upcomingServicesLoadingPackage {
    return Intl.message(
      'Loading package title',
      name: 'upcomingServicesLoadingPackage',
      desc: '',
      args: [],
    );
  }

  /// `Loading location`
  String get upcomingServicesLoadingLocation {
    return Intl.message(
      'Loading location',
      name: 'upcomingServicesLoadingLocation',
      desc: '',
      args: [],
    );
  }

  /// `Loading technician`
  String get upcomingServicesLoadingTechnician {
    return Intl.message(
      'Loading technician',
      name: 'upcomingServicesLoadingTechnician',
      desc: '',
      args: [],
    );
  }

  /// `Loading`
  String get upcomingServicesLoadingStatus {
    return Intl.message(
      'Loading',
      name: 'upcomingServicesLoadingStatus',
      desc: '',
      args: [],
    );
  }

  /// `No upcoming services scheduled.`
  String get upcomingServicesEmptyMessage {
    return Intl.message(
      'No upcoming services scheduled.',
      name: 'upcomingServicesEmptyMessage',
      desc: '',
      args: [],
    );
  }

  /// `Unable to load upcoming services.`
  String get upcomingServicesErrorPrefix {
    return Intl.message(
      'Unable to load upcoming services.',
      name: 'upcomingServicesErrorPrefix',
      desc: '',
      args: [],
    );
  }

  /// `Log in to view your upcoming services.`
  String get upcomingServicesLoginPrompt {
    return Intl.message(
      'Log in to view your upcoming services.',
      name: 'upcomingServicesLoginPrompt',
      desc: '',
      args: [],
    );
  }

  /// `Log in`
  String get upcomingServicesViewButton {
    return Intl.message(
      'Log in',
      name: 'upcomingServicesViewButton',
      desc: '',
      args: [],
    );
  }

  /// `Service`
  String get upcomingServicesServicePlaceholder {
    return Intl.message(
      'Service',
      name: 'upcomingServicesServicePlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle`
  String get upcomingServicesVehiclePlaceholder {
    return Intl.message(
      'Vehicle',
      name: 'upcomingServicesVehiclePlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Upcoming Service`
  String get upcomingService {
    return Intl.message(
      'Upcoming Service',
      name: 'upcomingService',
      desc: '',
      args: [],
    );
  }

  /// `Plan your day`
  String get upcomingServicesFilterTitle {
    return Intl.message(
      'Plan your day',
      name: 'upcomingServicesFilterTitle',
      desc: '',
      args: [],
    );
  }

  /// `Tap a filter to refine your appointments.`
  String get upcomingServicesFilterSubtitle {
    return Intl.message(
      'Tap a filter to refine your appointments.',
      name: 'upcomingServicesFilterSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Any status`
  String get upcomingServicesFilterAnyStatus {
    return Intl.message(
      'Any status',
      name: 'upcomingServicesFilterAnyStatus',
      desc: '',
      args: [],
    );
  }

  /// `Any date`
  String get upcomingServicesFilterAnyDate {
    return Intl.message(
      'Any date',
      name: 'upcomingServicesFilterAnyDate',
      desc: '',
      args: [],
    );
  }

  /// `Loading booking statuses...`
  String get upcomingServicesFilterLoadingStatuses {
    return Intl.message(
      'Loading booking statuses...',
      name: 'upcomingServicesFilterLoadingStatuses',
      desc: '',
      args: [],
    );
  }

  /// `No statuses available.`
  String get upcomingServicesFilterNoStatuses {
    return Intl.message(
      'No statuses available.',
      name: 'upcomingServicesFilterNoStatuses',
      desc: '',
      args: [],
    );
  }

  /// `From`
  String get upcomingServicesFilterFrom {
    return Intl.message(
      'From',
      name: 'upcomingServicesFilterFrom',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get upcomingServicesFilterTo {
    return Intl.message(
      'To',
      name: 'upcomingServicesFilterTo',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get upcomingServicesFilterStatus {
    return Intl.message(
      'Status',
      name: 'upcomingServicesFilterStatus',
      desc: '',
      args: [],
    );
  }

  /// `Apply filters`
  String get upcomingServicesFilterApply {
    return Intl.message(
      'Apply filters',
      name: 'upcomingServicesFilterApply',
      desc: '',
      args: [],
    );
  }

  /// `Status {id}`
  String upcomingServicesStatusFallback(String id) {
    return Intl.message(
      'Status $id',
      name: 'upcomingServicesStatusFallback',
      desc: '',
      args: [id],
    );
  }

  /// `Connection timed out. Please try again.`
  String get upcomingServicesConnectionTimedOut {
    return Intl.message(
      'Connection timed out. Please try again.',
      name: 'upcomingServicesConnectionTimedOut',
      desc: '',
      args: [],
    );
  }

  /// `Select booking statuses`
  String get bookingStatusPickerTitle {
    return Intl.message(
      'Select booking statuses',
      name: 'bookingStatusPickerTitle',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get bookingStatusPickerClear {
    return Intl.message(
      'Clear',
      name: 'bookingStatusPickerClear',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get bookingStatusPickerApply {
    return Intl.message(
      'Apply',
      name: 'bookingStatusPickerApply',
      desc: '',
      args: [],
    );
  }

  /// `Apply ({count})`
  String bookingStatusPickerApplyCount(int count) {
    return Intl.message(
      'Apply ($count)',
      name: 'bookingStatusPickerApplyCount',
      desc: '',
      args: [count],
    );
  }

  /// `ID {id}`
  String bookingStatusPickerStatusId(String id) {
    return Intl.message(
      'ID $id',
      name: 'bookingStatusPickerStatusId',
      desc: '',
      args: [id],
    );
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `Book`
  String get book {
    return Intl.message('Book', name: 'book', desc: '', args: []);
  }

  /// `Something went wrong`
  String get commonErrorTitle {
    return Intl.message(
      'Something went wrong',
      name: 'commonErrorTitle',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong.`
  String get commonSomethingWentWrong {
    return Intl.message(
      'Something went wrong.',
      name: 'commonSomethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Please check your internet connection or try again.`
  String get commonErrorDescription {
    return Intl.message(
      'Please check your internet connection or try again.',
      name: 'commonErrorDescription',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get commonRetry {
    return Intl.message('Retry', name: 'commonRetry', desc: '', args: []);
  }

  /// `Take a photo`
  String get userCarsTakePhoto {
    return Intl.message(
      'Take a photo',
      name: 'userCarsTakePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Choose from gallery (multiple)`
  String get userCarsChooseFromGallery {
    return Intl.message(
      'Choose from gallery (multiple)',
      name: 'userCarsChooseFromGallery',
      desc: '',
      args: [],
    );
  }

  /// `Please complete plate fields`
  String get userCarsCompletePlateFields {
    return Intl.message(
      'Please complete plate fields',
      name: 'userCarsCompletePlateFields',
      desc: '',
      args: [],
    );
  }

  /// `Invalid plate letter`
  String get userCarsInvalidPlateLetter {
    return Intl.message(
      'Invalid plate letter',
      name: 'userCarsInvalidPlateLetter',
      desc: '',
      args: [],
    );
  }

  /// `Invalid plate number`
  String get userCarsInvalidPlateNumber {
    return Intl.message(
      'Invalid plate number',
      name: 'userCarsInvalidPlateNumber',
      desc: '',
      args: [],
    );
  }

  /// `Car added successfully`
  String get userCarsAddedSuccessfully {
    return Intl.message(
      'Car added successfully',
      name: 'userCarsAddedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Error loading manufacturers`
  String get userCarsErrorLoadingManufacturers {
    return Intl.message(
      'Error loading manufacturers',
      name: 'userCarsErrorLoadingManufacturers',
      desc: '',
      args: [],
    );
  }

  /// `Error loading car models`
  String get userCarsErrorLoadingModels {
    return Intl.message(
      'Error loading car models',
      name: 'userCarsErrorLoadingModels',
      desc: '',
      args: [],
    );
  }

  /// `Car Images`
  String get userCarsImagesSectionTitle {
    return Intl.message(
      'Car Images',
      name: 'userCarsImagesSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add Photos`
  String get userCarsAddPhotos {
    return Intl.message(
      'Add Photos',
      name: 'userCarsAddPhotos',
      desc: '',
      args: [],
    );
  }

  /// `Please add at least one image.`
  String get userCarsAddImageRequirement {
    return Intl.message(
      'Please add at least one image.',
      name: 'userCarsAddImageRequirement',
      desc: '',
      args: [],
    );
  }

  /// `Saving...`
  String get userCarsSaving {
    return Intl.message(
      'Saving...',
      name: 'userCarsSaving',
      desc: '',
      args: [],
    );
  }

  /// `Save Vehicle`
  String get userCarsSaveVehicle {
    return Intl.message(
      'Save Vehicle',
      name: 'userCarsSaveVehicle',
      desc: '',
      args: [],
    );
  }

  /// `Add CRN image`
  String get userCarsAddCrnImage {
    return Intl.message(
      'Add CRN image',
      name: 'userCarsAddCrnImage',
      desc: '',
      args: [],
    );
  }

  /// `Car details`
  String get userCarsCarDetailsTitle {
    return Intl.message(
      'Car details',
      name: 'userCarsCarDetailsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Car name`
  String get userCarsCarName {
    return Intl.message(
      'Car name',
      name: 'userCarsCarName',
      desc: '',
      args: [],
    );
  }

  /// `Car model`
  String get userCarsCarModelLabel {
    return Intl.message(
      'Car model',
      name: 'userCarsCarModelLabel',
      desc: '',
      args: [],
    );
  }

  /// `Chassis (VIN)`
  String get userCarsChassisVin {
    return Intl.message(
      'Chassis (VIN)',
      name: 'userCarsChassisVin',
      desc: '',
      args: [],
    );
  }

  /// `Year of manufacture`
  String get userCarsYearOfManufacture {
    return Intl.message(
      'Year of manufacture',
      name: 'userCarsYearOfManufacture',
      desc: '',
      args: [],
    );
  }

  /// `Edit info`
  String get userCarsEditInfo {
    return Intl.message(
      'Edit info',
      name: 'userCarsEditInfo',
      desc: '',
      args: [],
    );
  }

  /// `Delete car`
  String get userCarsDeleteCar {
    return Intl.message(
      'Delete car',
      name: 'userCarsDeleteCar',
      desc: '',
      args: [],
    );
  }

  /// `Chassis`
  String get userCarsChassis {
    return Intl.message('Chassis', name: 'userCarsChassis', desc: '', args: []);
  }

  /// `Book Now`
  String get userCarsBookNow {
    return Intl.message(
      'Book Now',
      name: 'userCarsBookNow',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get userCarsCopy {
    return Intl.message('Copy', name: 'userCarsCopy', desc: '', args: []);
  }

  /// `Copied to clipboard`
  String get userCarsCopiedToClipboard {
    return Intl.message(
      'Copied to clipboard',
      name: 'userCarsCopiedToClipboard',
      desc: '',
      args: [],
    );
  }

  /// `License plate {plate}`
  String userCarsLicensePlateSemantics(String plate) {
    return Intl.message(
      'License plate $plate',
      name: 'userCarsLicensePlateSemantics',
      desc: 'Semantics label announcing a license plate value',
      args: [plate],
    );
  }

  /// `Car card for {model}, plate {plate}`
  String userCarsCardSemantics(String model, String plate) {
    return Intl.message(
      'Car card for $model, plate $plate',
      name: 'userCarsCardSemantics',
      desc: 'Semantics label describing a car card item',
      args: [model, plate],
    );
  }

  /// `Manager`
  String get managerHomeTitle {
    return Intl.message(
      'Manager',
      name: 'managerHomeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Coupons`
  String get managerHomeCouponsTitle {
    return Intl.message(
      'Coupons',
      name: 'managerHomeCouponsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Create discount coupons`
  String get managerHomeCouponsDescription {
    return Intl.message(
      'Create discount coupons',
      name: 'managerHomeCouponsDescription',
      desc: '',
      args: [],
    );
  }

  /// `Ratings`
  String get managerHomeRatingsTitle {
    return Intl.message(
      'Ratings',
      name: 'managerHomeRatingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `View customer ratings`
  String get managerHomeRatingsDescription {
    return Intl.message(
      'View customer ratings',
      name: 'managerHomeRatingsDescription',
      desc: '',
      args: [],
    );
  }

  /// `Promotions`
  String get managerHomePromotionsTitle {
    return Intl.message(
      'Promotions',
      name: 'managerHomePromotionsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Promotion control panel`
  String get managerHomePromotionsDescription {
    return Intl.message(
      'Promotion control panel',
      name: 'managerHomePromotionsDescription',
      desc: '',
      args: [],
    );
  }

  /// `Create Promotion`
  String get managerHomeCreatePromotionTitle {
    return Intl.message(
      'Create Promotion',
      name: 'managerHomeCreatePromotionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add a new promotion`
  String get managerHomeCreatePromotionDescription {
    return Intl.message(
      'Add a new promotion',
      name: 'managerHomeCreatePromotionDescription',
      desc: '',
      args: [],
    );
  }

  /// `Route "{route}" is not available.`
  String managerHomeRouteUnavailable(String route) {
    return Intl.message(
      'Route "$route" is not available.',
      name: 'managerHomeRouteUnavailable',
      desc: '',
      args: [route],
    );
  }

  /// `Chat`
  String get chatTitle {
    return Intl.message('Chat', name: 'chatTitle', desc: '', args: []);
  }

  /// `Chat is not available for this booking.`
  String get chatUnavailable {
    return Intl.message(
      'Chat is not available for this booking.',
      name: 'chatUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Please sign in to chat with your technician.`
  String get chatLoginRequired {
    return Intl.message(
      'Please sign in to chat with your technician.',
      name: 'chatLoginRequired',
      desc: '',
      args: [],
    );
  }

  /// `No messages yet. Start the conversation.`
  String get chatEmptyMessage {
    return Intl.message(
      'No messages yet. Start the conversation.',
      name: 'chatEmptyMessage',
      desc: '',
      args: [],
    );
  }

  /// `Type a message`
  String get chatInputHint {
    return Intl.message(
      'Type a message',
      name: 'chatInputHint',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get chatSendLabel {
    return Intl.message('Send', name: 'chatSendLabel', desc: '', args: []);
  }

  /// `Unable to load chat messages.`
  String get chatErrorLoading {
    return Intl.message(
      'Unable to load chat messages.',
      name: 'chatErrorLoading',
      desc: '',
      args: [],
    );
  }

  /// `Missing booking id for chat.`
  String get chatMissingBookingId {
    return Intl.message(
      'Missing booking id for chat.',
      name: 'chatMissingBookingId',
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
