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

  /// `Contact Us`
  String get contactUsNav {
    return Intl.message(
      'Contact Us',
      name: 'contactUsNav',
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

  /// `phoneNumber`
  String get phoneNumber {
    return Intl.message(
      'phoneNumber',
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
