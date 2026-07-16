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

  /// `Change profile photo`
  String get changeProfilePhoto {
    return Intl.message(
      'Change profile photo',
      name: 'changeProfilePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Please select a profile photo.`
  String get profilePhotoRequired {
    return Intl.message(
      'Please select a profile photo.',
      name: 'profilePhotoRequired',
      desc: '',
      args: [],
    );
  }

  /// `Unable to select this photo. Please try again.`
  String get profilePhotoSelectionFailed {
    return Intl.message(
      'Unable to select this photo. Please try again.',
      name: 'profilePhotoSelectionFailed',
      desc: '',
      args: [],
    );
  }

  /// `Save changes`
  String get saveChanges {
    return Intl.message(
      'Save changes',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }

  /// `Profile updated successfully.`
  String get profileUpdatedSuccessfully {
    return Intl.message(
      'Profile updated successfully.',
      name: 'profileUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Unable to update your profile. Please try again.`
  String get profileUpdateFailed {
    return Intl.message(
      'Unable to update your profile. Please try again.',
      name: 'profileUpdateFailed',
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

  /// `New`
  String get upcomingServicesStatusNew {
    return Intl.message(
      'New',
      name: 'upcomingServicesStatusNew',
      desc: '',
      args: [],
    );
  }

  /// `Accepted`
  String get upcomingServicesStatusAccepted {
    return Intl.message(
      'Accepted',
      name: 'upcomingServicesStatusAccepted',
      desc: '',
      args: [],
    );
  }

  /// `Rejected`
  String get upcomingServicesStatusRejected {
    return Intl.message(
      'Rejected',
      name: 'upcomingServicesStatusRejected',
      desc: '',
      args: [],
    );
  }

  /// `En Route`
  String get upcomingServicesStatusEnRoute {
    return Intl.message(
      'En Route',
      name: 'upcomingServicesStatusEnRoute',
      desc: '',
      args: [],
    );
  }

  /// `Arrived`
  String get upcomingServicesStatusArrived {
    return Intl.message(
      'Arrived',
      name: 'upcomingServicesStatusArrived',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get upcomingServicesStatusOpen {
    return Intl.message(
      'Open',
      name: 'upcomingServicesStatusOpen',
      desc: '',
      args: [],
    );
  }

  /// `Paid`
  String get upcomingServicesStatusPaid {
    return Intl.message(
      'Paid',
      name: 'upcomingServicesStatusPaid',
      desc: '',
      args: [],
    );
  }

  /// `Needs Approval`
  String get upcomingServicesStatusNeedsApproval {
    return Intl.message(
      'Needs Approval',
      name: 'upcomingServicesStatusNeedsApproval',
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

  /// `Back Online`
  String get backOnline {
    return Intl.message('Back Online', name: 'backOnline', desc: '', args: []);
  }

  /// `No Internet Connection`
  String get noInternetConnection {
    return Intl.message(
      'No Internet Connection',
      name: 'noInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `العربية`
  String get languageArabic {
    return Intl.message('العربية', name: 'languageArabic', desc: '', args: []);
  }

  /// `English`
  String get languageEnglish {
    return Intl.message('English', name: 'languageEnglish', desc: '', args: []);
  }

  /// `Something went wrong.`
  String get somethingWentWrong {
    return Intl.message(
      'Something went wrong.',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `5XXXXXXXX`
  String get phoneNumberHint {
    return Intl.message(
      '5XXXXXXXX',
      name: 'phoneNumberHint',
      desc: '',
      args: [],
    );
  }

  /// `Coupons`
  String get couponListTitle {
    return Intl.message('Coupons', name: 'couponListTitle', desc: '', args: []);
  }

  /// `Refresh`
  String get refreshTooltip {
    return Intl.message('Refresh', name: 'refreshTooltip', desc: '', args: []);
  }

  /// `Create coupon`
  String get createCouponTooltip {
    return Intl.message(
      'Create coupon',
      name: 'createCouponTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Add coupon`
  String get addCouponButtonLabel {
    return Intl.message(
      'Add coupon',
      name: 'addCouponButtonLabel',
      desc: '',
      args: [],
    );
  }

  /// `No coupons available.`
  String get noCouponsAvailable {
    return Intl.message(
      'No coupons available.',
      name: 'noCouponsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Coupon`
  String get couponDefaultLabel {
    return Intl.message(
      'Coupon',
      name: 'couponDefaultLabel',
      desc: '',
      args: [],
    );
  }

  /// `Discount`
  String get couponDiscountLabel {
    return Intl.message(
      'Discount',
      name: 'couponDiscountLabel',
      desc: '',
      args: [],
    );
  }

  /// `Please select date range`
  String get pleaseSelectDateRange {
    return Intl.message(
      'Please select date range',
      name: 'pleaseSelectDateRange',
      desc: '',
      args: [],
    );
  }

  /// `Create Coupon`
  String get createCouponScreenTitle {
    return Intl.message(
      'Create Coupon',
      name: 'createCouponScreenTitle',
      desc: '',
      args: [],
    );
  }

  /// `Company Name`
  String get companyNameLabel {
    return Intl.message(
      'Company Name',
      name: 'companyNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Required`
  String get requiredFieldError {
    return Intl.message(
      'Required',
      name: 'requiredFieldError',
      desc: '',
      args: [],
    );
  }

  /// `Discount %`
  String get discountPercentageLabel {
    return Intl.message(
      'Discount %',
      name: 'discountPercentageLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter number`
  String get enterNumberError {
    return Intl.message(
      'Enter number',
      name: 'enterNumberError',
      desc: '',
      args: [],
    );
  }

  /// `Coupon count`
  String get couponCountLabel {
    return Intl.message(
      'Coupon count',
      name: 'couponCountLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter count`
  String get enterCountError {
    return Intl.message(
      'Enter count',
      name: 'enterCountError',
      desc: '',
      args: [],
    );
  }

  /// `From`
  String get fromDateLabel {
    return Intl.message('From', name: 'fromDateLabel', desc: '', args: []);
  }

  /// `Select start date`
  String get selectStartDateLabel {
    return Intl.message(
      'Select start date',
      name: 'selectStartDateLabel',
      desc: '',
      args: [],
    );
  }

  /// `Pick`
  String get pickDateButtonLabel {
    return Intl.message(
      'Pick',
      name: 'pickDateButtonLabel',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get toDateLabel {
    return Intl.message('To', name: 'toDateLabel', desc: '', args: []);
  }

  /// `Select end date`
  String get selectEndDateLabel {
    return Intl.message(
      'Select end date',
      name: 'selectEndDateLabel',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get createButtonLabel {
    return Intl.message(
      'Create',
      name: 'createButtonLabel',
      desc: '',
      args: [],
    );
  }

  /// `No services available right now.`
  String get noServicesAvailable {
    return Intl.message(
      'No services available right now.',
      name: 'noServicesAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Unable to load services`
  String get unableToLoadServices {
    return Intl.message(
      'Unable to load services',
      name: 'unableToLoadServices',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retryButtonLabel {
    return Intl.message('Retry', name: 'retryButtonLabel', desc: '', args: []);
  }

  /// `Technician users should use the MotorLube Technician app.`
  String get technicianAppError {
    return Intl.message(
      'Technician users should use the MotorLube Technician app.',
      name: 'technicianAppError',
      desc: '',
      args: [],
    );
  }

  /// `Manager user`
  String get managerUserLabel {
    return Intl.message(
      'Manager user',
      name: 'managerUserLabel',
      desc: '',
      args: [],
    );
  }

  /// `Credit manager user`
  String get creditManagerUserLabel {
    return Intl.message(
      'Credit manager user',
      name: 'creditManagerUserLabel',
      desc: '',
      args: [],
    );
  }

  /// `Customer user`
  String get customerUserLabel {
    return Intl.message(
      'Customer user',
      name: 'customerUserLabel',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get allButtonLabel {
    return Intl.message('All', name: 'allButtonLabel', desc: '', args: []);
  }

  /// `Showing bookings that need approval`
  String get showingBookingsNeedingApproval {
    return Intl.message(
      'Showing bookings that need approval',
      name: 'showingBookingsNeedingApproval',
      desc: '',
      args: [],
    );
  }

  /// `Connection timed out. Please try again.`
  String get connectionTimedOutMessage {
    return Intl.message(
      'Connection timed out. Please try again.',
      name: 'connectionTimedOutMessage',
      desc: '',
      args: [],
    );
  }

  /// `Any date`
  String get anyDateLabel {
    return Intl.message('Any date', name: 'anyDateLabel', desc: '', args: []);
  }

  /// `Customer`
  String get customerDefaultLabel {
    return Intl.message(
      'Customer',
      name: 'customerDefaultLabel',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle not set`
  String get vehicleNotSetLabel {
    return Intl.message(
      'Vehicle not set',
      name: 'vehicleNotSetLabel',
      desc: '',
      args: [],
    );
  }

  /// `Plate unavailable`
  String get plateUnavailableLabel {
    return Intl.message(
      'Plate unavailable',
      name: 'plateUnavailableLabel',
      desc: '',
      args: [],
    );
  }

  /// `Branch not assigned`
  String get branchNotAssignedLabel {
    return Intl.message(
      'Branch not assigned',
      name: 'branchNotAssignedLabel',
      desc: '',
      args: [],
    );
  }

  /// `Scheduled`
  String get scheduledStatusLabel {
    return Intl.message(
      'Scheduled',
      name: 'scheduledStatusLabel',
      desc: '',
      args: [],
    );
  }

  /// `Schedule not set`
  String get scheduleNotSetLabel {
    return Intl.message(
      'Schedule not set',
      name: 'scheduleNotSetLabel',
      desc: '',
      args: [],
    );
  }

  /// `No bookings need approval right now.`
  String get noBookingsNeedApproval {
    return Intl.message(
      'No bookings need approval right now.',
      name: 'noBookingsNeedApproval',
      desc: '',
      args: [],
    );
  }

  /// `New bookings that require approval will appear here automatically.`
  String get newBookingsWillAppearMessage {
    return Intl.message(
      'New bookings that require approval will appear here automatically.',
      name: 'newBookingsWillAppearMessage',
      desc: '',
      args: [],
    );
  }

  /// `Unable to load bookings`
  String get unableToLoadBookings {
    return Intl.message(
      'Unable to load bookings',
      name: 'unableToLoadBookings',
      desc: '',
      args: [],
    );
  }

  /// `Sign in required`
  String get signInRequiredTitle {
    return Intl.message(
      'Sign in required',
      name: 'signInRequiredTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please sign in as a credit manager to view bookings that need approval.`
  String get signInAsCreditManagerMessage {
    return Intl.message(
      'Please sign in as a credit manager to view bookings that need approval.',
      name: 'signInAsCreditManagerMessage',
      desc: '',
      args: [],
    );
  }

  /// `Filter approvals`
  String get filterApprovalsTitle {
    return Intl.message(
      'Filter approvals',
      name: 'filterApprovalsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Pick a date range and apply to refresh.`
  String get pickDateRangeInstruction {
    return Intl.message(
      'Pick a date range and apply to refresh.',
      name: 'pickDateRangeInstruction',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get resetButtonLabel {
    return Intl.message('Reset', name: 'resetButtonLabel', desc: '', args: []);
  }

  /// `Apply filters`
  String get applyFiltersButtonLabel {
    return Intl.message(
      'Apply filters',
      name: 'applyFiltersButtonLabel',
      desc: '',
      args: [],
    );
  }

  /// `Complete Payment`
  String get completePayment {
    return Intl.message(
      'Complete Payment',
      name: 'completePayment',
      desc: '',
      args: [],
    );
  }

  /// `Unable to initiate payment.`
  String get unableToInitiatePayment {
    return Intl.message(
      'Unable to initiate payment.',
      name: 'unableToInitiatePayment',
      desc: '',
      args: [],
    );
  }

  /// `Failed to initiate payment. Please try again.`
  String get failedToInitiatePayment {
    return Intl.message(
      'Failed to initiate payment. Please try again.',
      name: 'failedToInitiatePayment',
      desc: '',
      args: [],
    );
  }

  /// `Failed to verify payment status. Please try again.`
  String get failedToVerifyPaymentStatus {
    return Intl.message(
      'Failed to verify payment status. Please try again.',
      name: 'failedToVerifyPaymentStatus',
      desc: '',
      args: [],
    );
  }

  /// `Motor Lube`
  String get appName {
    return Intl.message('Motor Lube', name: 'appName', desc: '', args: []);
  }

  /// `V 2.0.0`
  String get appVersion {
    return Intl.message('V 2.0.0', name: 'appVersion', desc: '', args: []);
  }

  /// `Promotions`
  String get promotionsTitle {
    return Intl.message(
      'Promotions',
      name: 'promotionsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load promotions`
  String get promotionsLoadErrorFallback {
    return Intl.message(
      'Failed to load promotions',
      name: 'promotionsLoadErrorFallback',
      desc: '',
      args: [],
    );
  }

  /// `No promotions found.`
  String get noPromotionsFound {
    return Intl.message(
      'No promotions found.',
      name: 'noPromotionsFound',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get deleteTooltip {
    return Intl.message('Delete', name: 'deleteTooltip', desc: '', args: []);
  }

  /// `promotion`
  String get promotionTitle {
    return Intl.message(
      'promotion',
      name: 'promotionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loadingEllipsis {
    return Intl.message(
      'Loading...',
      name: 'loadingEllipsis',
      desc: '',
      args: [],
    );
  }

  /// `Unavailable`
  String get unavailableLabel {
    return Intl.message(
      'Unavailable',
      name: 'unavailableLabel',
      desc: '',
      args: [],
    );
  }

  /// `No statuses`
  String get noStatusesLabel {
    return Intl.message(
      'No statuses',
      name: 'noStatusesLabel',
      desc: '',
      args: [],
    );
  }

  /// `Loading booking statuses...`
  String get loadingBookingStatusesMessage {
    return Intl.message(
      'Loading booking statuses...',
      name: 'loadingBookingStatusesMessage',
      desc: '',
      args: [],
    );
  }

  /// `No statuses available.`
  String get noStatusesAvailableMessage {
    return Intl.message(
      'No statuses available.',
      name: 'noStatusesAvailableMessage',
      desc: '',
      args: [],
    );
  }

  /// `Status ID {id}`
  String statusIdLabel(int id) {
    return Intl.message(
      'Status ID $id',
      name: 'statusIdLabel',
      desc: '',
      args: [id],
    );
  }

  /// `{count} statuses selected`
  String statusesSelectedCount(int count) {
    return Intl.message(
      '$count statuses selected',
      name: 'statusesSelectedCount',
      desc: '',
      args: [count],
    );
  }

  /// `No maintenance requests yet.`
  String get noMaintenanceRequestsYet {
    return Intl.message(
      'No maintenance requests yet.',
      name: 'noMaintenanceRequestsYet',
      desc: '',
      args: [],
    );
  }

  /// `You will see all assigned appointments here once customers book services.`
  String get assignedAppointmentsWillAppearHere {
    return Intl.message(
      'You will see all assigned appointments here once customers book services.',
      name: 'assignedAppointmentsWillAppearHere',
      desc: '',
      args: [],
    );
  }

  /// `Unable to load requests`
  String get unableToLoadRequests {
    return Intl.message(
      'Unable to load requests',
      name: 'unableToLoadRequests',
      desc: '',
      args: [],
    );
  }

  /// `Please sign in as a technician to view assigned maintenance requests.`
  String get signInAsTechnicianMessage {
    return Intl.message(
      'Please sign in as a technician to view assigned maintenance requests.',
      name: 'signInAsTechnicianMessage',
      desc: '',
      args: [],
    );
  }

  /// `Plan your day`
  String get planYourDay {
    return Intl.message(
      'Plan your day',
      name: 'planYourDay',
      desc: '',
      args: [],
    );
  }

  /// `Tap a filter to refine assigned jobs.`
  String get tapFilterToRefineJobs {
    return Intl.message(
      'Tap a filter to refine assigned jobs.',
      name: 'tapFilterToRefineJobs',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get statusLabel {
    return Intl.message('Status', name: 'statusLabel', desc: '', args: []);
  }

  /// `Failed to load checklist: {error}`
  String failedToLoadChecklistError(String error) {
    return Intl.message(
      'Failed to load checklist: $error',
      name: 'failedToLoadChecklistError',
      desc: '',
      args: [error],
    );
  }

  /// `Checklist submitted.`
  String get checklistSubmittedMessage {
    return Intl.message(
      'Checklist submitted.',
      name: 'checklistSubmittedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Failed to submit checklist.`
  String get failedToSubmitChecklistMessage {
    return Intl.message(
      'Failed to submit checklist.',
      name: 'failedToSubmitChecklistMessage',
      desc: '',
      args: [],
    );
  }

  /// `Failed to save checklist: {error}`
  String failedToSaveChecklistError(String error) {
    return Intl.message(
      'Failed to save checklist: $error',
      name: 'failedToSaveChecklistError',
      desc: '',
      args: [error],
    );
  }

  /// `Vehicle checklist`
  String get vehicleChecklistTitle {
    return Intl.message(
      'Vehicle checklist',
      name: 'vehicleChecklistTitle',
      desc: '',
      args: [],
    );
  }

  /// `No checklist found.`
  String get noChecklistFound {
    return Intl.message(
      'No checklist found.',
      name: 'noChecklistFound',
      desc: '',
      args: [],
    );
  }

  /// `Create default checklist`
  String get createDefaultChecklistButtonLabel {
    return Intl.message(
      'Create default checklist',
      name: 'createDefaultChecklistButtonLabel',
      desc: '',
      args: [],
    );
  }

  /// `Saving...`
  String get savingEllipsis {
    return Intl.message(
      'Saving...',
      name: 'savingEllipsis',
      desc: '',
      args: [],
    );
  }

  /// `Save checklist`
  String get saveChecklistButtonLabel {
    return Intl.message(
      'Save checklist',
      name: 'saveChecklistButtonLabel',
      desc: '',
      args: [],
    );
  }

  /// `Legend`
  String get legendTitle {
    return Intl.message('Legend', name: 'legendTitle', desc: '', args: []);
  }

  /// `C - Clean`
  String get legendCleanLabel {
    return Intl.message(
      'C - Clean',
      name: 'legendCleanLabel',
      desc: '',
      args: [],
    );
  }

  /// `R - Replace`
  String get legendReplaceLabel {
    return Intl.message(
      'R - Replace',
      name: 'legendReplaceLabel',
      desc: '',
      args: [],
    );
  }

  /// `I - Inspect`
  String get legendInspectLabel {
    return Intl.message(
      'I - Inspect',
      name: 'legendInspectLabel',
      desc: '',
      args: [],
    );
  }

  /// `X - Not applicable`
  String get legendNotApplicableLabel {
    return Intl.message(
      'X - Not applicable',
      name: 'legendNotApplicableLabel',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get commentLabel {
    return Intl.message('Comment', name: 'commentLabel', desc: '', args: []);
  }

  /// `Status updated successfully.`
  String get statusUpdatedSuccessfully {
    return Intl.message(
      'Status updated successfully.',
      name: 'statusUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Appointment Details`
  String get appointmentDetailsTitle {
    return Intl.message(
      'Appointment Details',
      name: 'appointmentDetailsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Manage packages`
  String get managePackagesButtonLabel {
    return Intl.message(
      'Manage packages',
      name: 'managePackagesButtonLabel',
      desc: '',
      args: [],
    );
  }

  /// `No booking statuses available.`
  String get noBookingStatusesAvailableMessage {
    return Intl.message(
      'No booking statuses available.',
      name: 'noBookingStatusesAvailableMessage',
      desc: '',
      args: [],
    );
  }

  /// `Job card number unavailable.`
  String get jobCardNumberUnavailableMessage {
    return Intl.message(
      'Job card number unavailable.',
      name: 'jobCardNumberUnavailableMessage',
      desc: '',
      args: [],
    );
  }

  /// `Unable to determine technician identifier.`
  String get unableToDetermineTechnicianIdMessage {
    return Intl.message(
      'Unable to determine technician identifier.',
      name: 'unableToDetermineTechnicianIdMessage',
      desc: '',
      args: [],
    );
  }

  /// `Already on {label}.`
  String alreadyOnStatusMessage(String label) {
    return Intl.message(
      'Already on $label.',
      name: 'alreadyOnStatusMessage',
      desc: '',
      args: [label],
    );
  }

  /// `Missing FireBaseId for technician.`
  String get missingFirebaseIdForTechnicianMessage {
    return Intl.message(
      'Missing FireBaseId for technician.',
      name: 'missingFirebaseIdForTechnicianMessage',
      desc: '',
      args: [],
    );
  }

  /// `Job card {srNumber} created.`
  String jobCardCreatedMessage(String srNumber) {
    return Intl.message(
      'Job card $srNumber created.',
      name: 'jobCardCreatedMessage',
      desc: '',
      args: [srNumber],
    );
  }

  /// `Service request created.`
  String get serviceRequestCreatedMessage {
    return Intl.message(
      'Service request created.',
      name: 'serviceRequestCreatedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Job card number is missing.`
  String get jobCardNumberMissingMessage {
    return Intl.message(
      'Job card number is missing.',
      name: 'jobCardNumberMissingMessage',
      desc: '',
      args: [],
    );
  }

  /// `User identifier is missing.`
  String get userIdentifierMissingMessage {
    return Intl.message(
      'User identifier is missing.',
      name: 'userIdentifierMissingMessage',
      desc: '',
      args: [],
    );
  }

  /// `Job card completed successfully.`
  String get jobCardCompletedSuccessfullyMessage {
    return Intl.message(
      'Job card completed successfully.',
      name: 'jobCardCompletedSuccessfullyMessage',
      desc: '',
      args: [],
    );
  }

  /// `Booking status`
  String get bookingStatusTitle {
    return Intl.message(
      'Booking status',
      name: 'bookingStatusTitle',
      desc: '',
      args: [],
    );
  }

  /// `Status {code}`
  String statusCodeLabel(String code) {
    return Intl.message(
      'Status $code',
      name: 'statusCodeLabel',
      desc: '',
      args: [code],
    );
  }

  /// `Maintenance package`
  String get maintenancePackageDefaultLabel {
    return Intl.message(
      'Maintenance package',
      name: 'maintenancePackageDefaultLabel',
      desc: '',
      args: [],
    );
  }

  /// `Branch`
  String get branchFieldLabel {
    return Intl.message('Branch', name: 'branchFieldLabel', desc: '', args: []);
  }

  /// `Not assigned`
  String get notAssignedLabel {
    return Intl.message(
      'Not assigned',
      name: 'notAssignedLabel',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle`
  String get vehicleFieldLabel {
    return Intl.message(
      'Vehicle',
      name: 'vehicleFieldLabel',
      desc: '',
      args: [],
    );
  }

  /// `Plate`
  String get plateFieldLabel {
    return Intl.message('Plate', name: 'plateFieldLabel', desc: '', args: []);
  }

  /// `Schedule`
  String get scheduleFieldLabel {
    return Intl.message(
      'Schedule',
      name: 'scheduleFieldLabel',
      desc: '',
      args: [],
    );
  }

  /// `VIN`
  String get vinFieldLabel {
    return Intl.message('VIN', name: 'vinFieldLabel', desc: '', args: []);
  }

  /// `Technician`
  String get technicianFieldLabel {
    return Intl.message(
      'Technician',
      name: 'technicianFieldLabel',
      desc: '',
      args: [],
    );
  }

  /// `Job card is open, loading package details...`
  String get jobCardOpenLoadingPackagesMessage {
    return Intl.message(
      'Job card is open, loading package details...',
      name: 'jobCardOpenLoadingPackagesMessage',
      desc: '',
      args: [],
    );
  }

  /// `Creating job card... packages will appear shortly.`
  String get creatingJobCardMessage {
    return Intl.message(
      'Creating job card... packages will appear shortly.',
      name: 'creatingJobCardMessage',
      desc: '',
      args: [],
    );
  }

  /// `Open a job card to view its associated packages.`
  String get openJobCardToViewPackagesMessage {
    return Intl.message(
      'Open a job card to view its associated packages.',
      name: 'openJobCardToViewPackagesMessage',
      desc: '',
      args: [],
    );
  }

  /// `Job card packages`
  String get jobCardPackagesTitle {
    return Intl.message(
      'Job card packages',
      name: 'jobCardPackagesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Refresh packages`
  String get refreshPackagesTooltip {
    return Intl.message(
      'Refresh packages',
      name: 'refreshPackagesTooltip',
      desc: '',
      args: [],
    );
  }

  /// `No packages found for this job card.`
  String get noPackagesFoundForJobCardMessage {
    return Intl.message(
      'No packages found for this job card.',
      name: 'noPackagesFoundForJobCardMessage',
      desc: '',
      args: [],
    );
  }

  /// `Select package`
  String get selectPackageLabel {
    return Intl.message(
      'Select package',
      name: 'selectPackageLabel',
      desc: '',
      args: [],
    );
  }

  /// `Package {code}`
  String packageCodeFallbackLabel(String code) {
    return Intl.message(
      'Package $code',
      name: 'packageCodeFallbackLabel',
      desc: '',
      args: [code],
    );
  }

  /// `Add package to job card`
  String get addPackageToJobCardButtonLabel {
    return Intl.message(
      'Add package to job card',
      name: 'addPackageToJobCardButtonLabel',
      desc: '',
      args: [],
    );
  }

  /// `Included`
  String get includedLabel {
    return Intl.message('Included', name: 'includedLabel', desc: '', args: []);
  }

  /// `Emergency`
  String get emergencyTagLabel {
    return Intl.message(
      'Emergency',
      name: 'emergencyTagLabel',
      desc: '',
      args: [],
    );
  }

  /// `Custom`
  String get customTagLabel {
    return Intl.message('Custom', name: 'customTagLabel', desc: '', args: []);
  }

  /// `Code: {code}`
  String packageCodeLabel(String code) {
    return Intl.message(
      'Code: $code',
      name: 'packageCodeLabel',
      desc: '',
      args: [code],
    );
  }

  /// `Line price`
  String get linePriceLabel {
    return Intl.message(
      'Line price',
      name: 'linePriceLabel',
      desc: '',
      args: [],
    );
  }

  /// `Custom Package Manager`
  String get customPackageManagerTitle {
    return Intl.message(
      'Custom Package Manager',
      name: 'customPackageManagerTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add items or services`
  String get addItemsOrServicesTitle {
    return Intl.message(
      'Add items or services',
      name: 'addItemsOrServicesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Resolving package line ID...`
  String get resolvingPackageLineIdMessage {
    return Intl.message(
      'Resolving package line ID...',
      name: 'resolvingPackageLineIdMessage',
      desc: '',
      args: [],
    );
  }

  /// `Quantity`
  String get quantityLabel {
    return Intl.message('Quantity', name: 'quantityLabel', desc: '', args: []);
  }

  /// `Package line is unavailable`
  String get packageLineUnavailableLabel {
    return Intl.message(
      'Package line is unavailable',
      name: 'packageLineUnavailableLabel',
      desc: '',
      args: [],
    );
  }

  /// `Add item`
  String get addItemButtonLabel {
    return Intl.message(
      'Add item',
      name: 'addItemButtonLabel',
      desc: '',
      args: [],
    );
  }

  /// `This package does not expose a line ID. Unable to add items.`
  String get packageNoLineIdMessage {
    return Intl.message(
      'This package does not expose a line ID. Unable to add items.',
      name: 'packageNoLineIdMessage',
      desc: '',
      args: [],
    );
  }

  /// `No categories available.`
  String get noCategoriesAvailableMessage {
    return Intl.message(
      'No categories available.',
      name: 'noCategoriesAvailableMessage',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get categoryLabel {
    return Intl.message('Category', name: 'categoryLabel', desc: '', args: []);
  }

  /// `Refresh categories`
  String get refreshCategoriesTooltip {
    return Intl.message(
      'Refresh categories',
      name: 'refreshCategoriesTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Select a category to load items.`
  String get selectCategoryToLoadItemsMessage {
    return Intl.message(
      'Select a category to load items.',
      name: 'selectCategoryToLoadItemsMessage',
      desc: '',
      args: [],
    );
  }

  /// `No items available for the selected category.`
  String get noItemsForCategoryMessage {
    return Intl.message(
      'No items available for the selected category.',
      name: 'noItemsForCategoryMessage',
      desc: '',
      args: [],
    );
  }

  /// `Items ({count})`
  String itemsCountLabel(int count) {
    return Intl.message(
      'Items ($count)',
      name: 'itemsCountLabel',
      desc: '',
      args: [count],
    );
  }

  /// `Please select a category.`
  String get pleaseSelectCategoryMessage {
    return Intl.message(
      'Please select a category.',
      name: 'pleaseSelectCategoryMessage',
      desc: '',
      args: [],
    );
  }

  /// `Please select an item to add.`
  String get pleaseSelectItemToAddMessage {
    return Intl.message(
      'Please select an item to add.',
      name: 'pleaseSelectItemToAddMessage',
      desc: '',
      args: [],
    );
  }

  /// `Enter a quantity.`
  String get enterQuantityMessage {
    return Intl.message(
      'Enter a quantity.',
      name: 'enterQuantityMessage',
      desc: '',
      args: [],
    );
  }

  /// `Quantity must be greater than zero.`
  String get quantityMustBeGreaterThanZeroMessage {
    return Intl.message(
      'Quantity must be greater than zero.',
      name: 'quantityMustBeGreaterThanZeroMessage',
      desc: '',
      args: [],
    );
  }

  /// `Package line ID is unavailable.`
  String get packageLineIdUnavailableMessage {
    return Intl.message(
      'Package line ID is unavailable.',
      name: 'packageLineIdUnavailableMessage',
      desc: '',
      args: [],
    );
  }

  /// `Please wait for the current delete action to finish.`
  String get waitForCurrentDeleteActionMessage {
    return Intl.message(
      'Please wait for the current delete action to finish.',
      name: 'waitForCurrentDeleteActionMessage',
      desc: '',
      args: [],
    );
  }

  /// `Line identifier unavailable for this item.`
  String get lineIdentifierUnavailableMessage {
    return Intl.message(
      'Line identifier unavailable for this item.',
      name: 'lineIdentifierUnavailableMessage',
      desc: '',
      args: [],
    );
  }

  /// `Remove item`
  String get removeItemTitle {
    return Intl.message(
      'Remove item',
      name: 'removeItemTitle',
      desc: '',
      args: [],
    );
  }

  /// `Delete "{name}" from this package?`
  String deleteItemConfirmation(String name) {
    return Intl.message(
      'Delete "$name" from this package?',
      name: 'deleteItemConfirmation',
      desc: '',
      args: [name],
    );
  }

  /// `Cancel`
  String get cancelButtonLabel {
    return Intl.message(
      'Cancel',
      name: 'cancelButtonLabel',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get deleteButtonLabel {
    return Intl.message(
      'Delete',
      name: 'deleteButtonLabel',
      desc: '',
      args: [],
    );
  }

  /// `Unable to resolve package line ID.`
  String get unableToResolvePackageLineIdMessage {
    return Intl.message(
      'Unable to resolve package line ID.',
      name: 'unableToResolvePackageLineIdMessage',
      desc: '',
      args: [],
    );
  }

  /// `Job card: {jobCardNumber}`
  String jobCardNumberLabel(String jobCardNumber) {
    return Intl.message(
      'Job card: $jobCardNumber',
      name: 'jobCardNumberLabel',
      desc: '',
      args: [jobCardNumber],
    );
  }

  /// `Standard`
  String get standardTagLabel {
    return Intl.message(
      'Standard',
      name: 'standardTagLabel',
      desc: '',
      args: [],
    );
  }

  /// `Line: {lineId}`
  String lineIdChipLabel(String lineId) {
    return Intl.message(
      'Line: $lineId',
      name: 'lineIdChipLabel',
      desc: '',
      args: [lineId],
    );
  }

  /// `N/A`
  String get notApplicableAbbreviation {
    return Intl.message(
      'N/A',
      name: 'notApplicableAbbreviation',
      desc: '',
      args: [],
    );
  }

  /// `Package items`
  String get packageItemsTitle {
    return Intl.message(
      'Package items',
      name: 'packageItemsTitle',
      desc: '',
      args: [],
    );
  }

  /// `No line items found for this package.`
  String get noLineItemsFoundMessage {
    return Intl.message(
      'No line items found for this package.',
      name: 'noLineItemsFoundMessage',
      desc: '',
      args: [],
    );
  }

  /// `Line {number}`
  String lineNumberFallbackLabel(String number) {
    return Intl.message(
      'Line $number',
      name: 'lineNumberFallbackLabel',
      desc: '',
      args: [number],
    );
  }

  /// `SR Line ID: {srLine}`
  String srLineIdLabel(String srLine) {
    return Intl.message(
      'SR Line ID: $srLine',
      name: 'srLineIdLabel',
      desc: '',
      args: [srLine],
    );
  }

  /// `Qty: {quantity}`
  String quantityValueLabel(int quantity) {
    return Intl.message(
      'Qty: $quantity',
      name: 'quantityValueLabel',
      desc: '',
      args: [quantity],
    );
  }

  /// `Delete item`
  String get deleteItemTooltip {
    return Intl.message(
      'Delete item',
      name: 'deleteItemTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Job Card {srNumber}`
  String jobCardTitle(String srNumber) {
    return Intl.message(
      'Job Card $srNumber',
      name: 'jobCardTitle',
      desc: '',
      args: [srNumber],
    );
  }

  /// `Please wait for the current action to complete.`
  String get waitForCurrentActionMessage {
    return Intl.message(
      'Please wait for the current action to complete.',
      name: 'waitForCurrentActionMessage',
      desc: '',
      args: [],
    );
  }

  /// `Remove package`
  String get removePackageTitle {
    return Intl.message(
      'Remove package',
      name: 'removePackageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to remove "{name}" from SR {srNumber}?`
  String removePackageConfirmation(String name, String srNumber) {
    return Intl.message(
      'Are you sure you want to remove "$name" from SR $srNumber?',
      name: 'removePackageConfirmation',
      desc: '',
      args: [name, srNumber],
    );
  }

  /// `Remove`
  String get removeButtonLabel {
    return Intl.message(
      'Remove',
      name: 'removeButtonLabel',
      desc: '',
      args: [],
    );
  }

  /// `Packages applied`
  String get packagesAppliedTitle {
    return Intl.message(
      'Packages applied',
      name: 'packagesAppliedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Price: {price}`
  String pricePrefixedLabel(String price) {
    return Intl.message(
      'Price: $price',
      name: 'pricePrefixedLabel',
      desc: '',
      args: [price],
    );
  }

  /// `Price: Included`
  String get pricePrefixedIncludedLabel {
    return Intl.message(
      'Price: Included',
      name: 'pricePrefixedIncludedLabel',
      desc: '',
      args: [],
    );
  }

  /// `Manage`
  String get manageButtonLabel {
    return Intl.message(
      'Manage',
      name: 'manageButtonLabel',
      desc: '',
      args: [],
    );
  }

  /// `Total price`
  String get totalPriceLabel {
    return Intl.message(
      'Total price',
      name: 'totalPriceLabel',
      desc: '',
      args: [],
    );
  }

  /// `Missing payment URL. Please try again later.`
  String get missingPaymentUrlMessage {
    return Intl.message(
      'Missing payment URL. Please try again later.',
      name: 'missingPaymentUrlMessage',
      desc: '',
      args: [],
    );
  }

  /// `Payment Successful`
  String get paymentSuccessfulTitle {
    return Intl.message(
      'Payment Successful',
      name: 'paymentSuccessfulTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your payment has been completed successfully.`
  String get paymentCompletedMessage {
    return Intl.message(
      'Your payment has been completed successfully.',
      name: 'paymentCompletedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Payment Failed`
  String get paymentFailedTitle {
    return Intl.message(
      'Payment Failed',
      name: 'paymentFailedTitle',
      desc: '',
      args: [],
    );
  }

  /// `The payment was not completed. Please try again.`
  String get paymentNotCompletedMessage {
    return Intl.message(
      'The payment was not completed. Please try again.',
      name: 'paymentNotCompletedMessage',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get okButtonLabel {
    return Intl.message('OK', name: 'okButtonLabel', desc: '', args: []);
  }

  /// `Cancel appointment?`
  String get cancelAppointmentTitle {
    return Intl.message(
      'Cancel appointment?',
      name: 'cancelAppointmentTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to cancel this appointment?`
  String get cancelAppointmentConfirmation {
    return Intl.message(
      'Are you sure you want to cancel this appointment?',
      name: 'cancelAppointmentConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get noButtonLabel {
    return Intl.message('No', name: 'noButtonLabel', desc: '', args: []);
  }

  /// `Yes, cancel`
  String get yesCancelButtonLabel {
    return Intl.message(
      'Yes, cancel',
      name: 'yesCancelButtonLabel',
      desc: '',
      args: [],
    );
  }

  /// `Appointment cancelled successfully.`
  String get appointmentCancelledSuccessfully {
    return Intl.message(
      'Appointment cancelled successfully.',
      name: 'appointmentCancelledSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Checkout details`
  String get checkoutDetailsLabel {
    return Intl.message(
      'Checkout details',
      name: 'checkoutDetailsLabel',
      desc: '',
      args: [],
    );
  }

  /// `Amount due`
  String get amountDueLabel {
    return Intl.message(
      'Amount due',
      name: 'amountDueLabel',
      desc: '',
      args: [],
    );
  }

  /// `Discount`
  String get discountLabel {
    return Intl.message('Discount', name: 'discountLabel', desc: '', args: []);
  }

  /// `Applied coupon`
  String get appliedCouponLabel {
    return Intl.message(
      'Applied coupon',
      name: 'appliedCouponLabel',
      desc: '',
      args: [],
    );
  }

  /// `Pay Now`
  String get payNowButtonLabel {
    return Intl.message(
      'Pay Now',
      name: 'payNowButtonLabel',
      desc: '',
      args: [],
    );
  }

  /// `Cancelling...`
  String get cancellingEllipsis {
    return Intl.message(
      'Cancelling...',
      name: 'cancellingEllipsis',
      desc: '',
      args: [],
    );
  }

  /// `Cancel appointment`
  String get cancelAppointmentButtonLabel {
    return Intl.message(
      'Cancel appointment',
      name: 'cancelAppointmentButtonLabel',
      desc: '',
      args: [],
    );
  }

  /// `Cannot cancel after job card is opened.`
  String get cannotCancelAfterJobCardOpened {
    return Intl.message(
      'Cannot cancel after job card is opened.',
      name: 'cannotCancelAfterJobCardOpened',
      desc: '',
      args: [],
    );
  }

  /// `Cancellation status is unavailable right now.`
  String get cancellationStatusUnavailable {
    return Intl.message(
      'Cancellation status is unavailable right now.',
      name: 'cancellationStatusUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `0000 AAA`
  String get upcomingServicesLoadingPlate {
    return Intl.message(
      '0000 AAA',
      name: 'upcomingServicesLoadingPlate',
      desc: '',
      args: [],
    );
  }

  /// `00 Mon 0000`
  String get upcomingServicesLoadingDate {
    return Intl.message(
      '00 Mon 0000',
      name: 'upcomingServicesLoadingDate',
      desc: '',
      args: [],
    );
  }

  /// `00:00 AM`
  String get upcomingServicesLoadingTime {
    return Intl.message(
      '00:00 AM',
      name: 'upcomingServicesLoadingTime',
      desc: '',
      args: [],
    );
  }

  /// `Invoices`
  String get invoicesTitle {
    return Intl.message('Invoices', name: 'invoicesTitle', desc: '', args: []);
  }

  /// `View and download your invoices`
  String get invoicesMenuDescription {
    return Intl.message(
      'View and download your invoices',
      name: 'invoicesMenuDescription',
      desc: '',
      args: [],
    );
  }

  /// `Please sign in to view your invoices.`
  String get invoicesSignInMessage {
    return Intl.message(
      'Please sign in to view your invoices.',
      name: 'invoicesSignInMessage',
      desc: '',
      args: [],
    );
  }

  /// `No invoices yet`
  String get invoicesEmptyTitle {
    return Intl.message(
      'No invoices yet',
      name: 'invoicesEmptyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your completed invoices will appear here. Pull to refresh or check again later.`
  String get invoicesEmptyDescription {
    return Intl.message(
      'Your completed invoices will appear here. Pull to refresh or check again later.',
      name: 'invoicesEmptyDescription',
      desc: '',
      args: [],
    );
  }

  /// `Invoice number`
  String get invoiceNumberLabel {
    return Intl.message(
      'Invoice number',
      name: 'invoiceNumberLabel',
      desc: '',
      args: [],
    );
  }

  /// `Service request`
  String get invoiceServiceRequestLabel {
    return Intl.message(
      'Service request',
      name: 'invoiceServiceRequestLabel',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get invoiceDateLabel {
    return Intl.message('Date', name: 'invoiceDateLabel', desc: '', args: []);
  }

  /// `Total`
  String get invoiceTotalLabel {
    return Intl.message('Total', name: 'invoiceTotalLabel', desc: '', args: []);
  }

  /// `Open PDF`
  String get invoiceOpenPdfButton {
    return Intl.message(
      'Open PDF',
      name: 'invoiceOpenPdfButton',
      desc: '',
      args: [],
    );
  }

  /// `Refresh invoices`
  String get invoiceRefreshTooltip {
    return Intl.message(
      'Refresh invoices',
      name: 'invoiceRefreshTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get invoiceRefreshButton {
    return Intl.message(
      'Refresh',
      name: 'invoiceRefreshButton',
      desc: '',
      args: [],
    );
  }

  /// `The invoice PDF is not available yet. Please check again later.`
  String get invoiceFileUnavailableMessage {
    return Intl.message(
      'The invoice PDF is not available yet. Please check again later.',
      name: 'invoiceFileUnavailableMessage',
      desc: '',
      args: [],
    );
  }

  /// `Unable to open the invoice PDF.`
  String get invoiceOpenFailedMessage {
    return Intl.message(
      'Unable to open the invoice PDF.',
      name: 'invoiceOpenFailedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Not available`
  String get invoiceValueUnavailable {
    return Intl.message(
      'Not available',
      name: 'invoiceValueUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `SAR `
  String get invoiceCurrencySymbol {
    return Intl.message(
      'SAR ',
      name: 'invoiceCurrencySymbol',
      desc: '',
      args: [],
    );
  }

  /// `Documents`
  String get moreDocumentsSectionTitle {
    return Intl.message(
      'Documents',
      name: 'moreDocumentsSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Preferences`
  String get morePreferencesSectionTitle {
    return Intl.message(
      'Preferences',
      name: 'morePreferencesSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Switch the app display language`
  String get moreLanguageDescription {
    return Intl.message(
      'Switch the app display language',
      name: 'moreLanguageDescription',
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
