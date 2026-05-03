// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(name) => "Available slots for ${name}";

  static String m1(distance) => "${distance} km away";

  static String m2(message) => "Failed to load packages.\n${message}";

  static String m3(price) => "${price} SAR";

  static String m4(label) => "Selected category: ${label}";

  static String m5(latitude, longitude) =>
      "Selected location: (${latitude}, ${longitude})";

  static String m6(route) => "Route \"${route}\" is not available.";

  static String m7(model, plate) => "Car card for ${model}, plate ${plate}";

  static String m8(plate) => "License plate ${plate}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "PleaseLoginToViewYourCarsMessage":
            MessageLookupByLibrary.simpleMessage(
                "Please login to view your cars"),
        "Profile": MessageLookupByLibrary.simpleMessage("Profile"),
        "addCar": MessageLookupByLibrary.simpleMessage("Add Car"),
        "arabic": MessageLookupByLibrary.simpleMessage("Arabic"),
        "areYouOwnerThisCar": MessageLookupByLibrary.simpleMessage(
            "Are you the owner of this car?"),
        "authenticationErrorMessage": MessageLookupByLibrary.simpleMessage(
            "An error occurred during authentication"),
        "back": MessageLookupByLibrary.simpleMessage("Back"),
        "basicServices": MessageLookupByLibrary.simpleMessage("Basic Services"),
        "batteires": MessageLookupByLibrary.simpleMessage("Batteries"),
        "bestOffers": MessageLookupByLibrary.simpleMessage("Best Offers"),
        "book": MessageLookupByLibrary.simpleMessage("Book"),
        "bookServiceAllow": MessageLookupByLibrary.simpleMessage("Allow"),
        "bookServiceAppointmentConfirmedTitle":
            MessageLookupByLibrary.simpleMessage("Appointment Confirmed"),
        "bookServiceAvailableSlotsFor": m0,
        "bookServiceCompleteAllStepsBeforeBooking":
            MessageLookupByLibrary.simpleMessage(
                "Please complete all steps before booking."),
        "bookServiceCreateAppointmentFailed":
            MessageLookupByLibrary.simpleMessage(
                "Failed to create appointment. Please try again."),
        "bookServiceCustomerInfoUnavailable":
            MessageLookupByLibrary.simpleMessage(
                "Unable to determine customer information."),
        "bookServiceDeny": MessageLookupByLibrary.simpleMessage("Deny"),
        "bookServiceDistanceAway": m1,
        "bookServiceFailedToLoadPackages": m2,
        "bookServiceLocationPermissionMessage":
            MessageLookupByLibrary.simpleMessage(
                "We need your location to show it on the map."),
        "bookServiceLocationPermissionTitle":
            MessageLookupByLibrary.simpleMessage("Location Permission"),
        "bookServiceNoPackagesFoundDescription":
            MessageLookupByLibrary.simpleMessage(
                "We couldn’t find any packages for your selected car and category.\nTry changing filters or check again later."),
        "bookServiceNoPackagesFoundTitle":
            MessageLookupByLibrary.simpleMessage("No Packages Found"),
        "bookServiceNoSlotsForSelectedDate":
            MessageLookupByLibrary.simpleMessage(
                "No slots available for the selected date."),
        "bookServiceNoTechniciansInRegion":
            MessageLookupByLibrary.simpleMessage(
                "No available technician in this region."),
        "bookServiceOk": MessageLookupByLibrary.simpleMessage("OK"),
        "bookServicePackagesLoadAfterContinue":
            MessageLookupByLibrary.simpleMessage(
                "Packages will load once you continue."),
        "bookServicePriceSar": m3,
        "bookServiceReadyToFindTechnicians":
            MessageLookupByLibrary.simpleMessage(
                "Ready to find technicians near your chosen location?"),
        "bookServiceRefresh": MessageLookupByLibrary.simpleMessage("Refresh"),
        "bookServiceReset": MessageLookupByLibrary.simpleMessage("Reset"),
        "bookServiceSearchTechnicians":
            MessageLookupByLibrary.simpleMessage("Search Technicians"),
        "bookServiceSelectCarBeforeContinuing":
            MessageLookupByLibrary.simpleMessage(
                "Please select a car before continuing."),
        "bookServiceSelectCarInStepOne": MessageLookupByLibrary.simpleMessage(
            "Please select a car in Step 1 to view available packages."),
        "bookServiceSelectLocationBeforeContinuing":
            MessageLookupByLibrary.simpleMessage(
                "Please choose a location on the map before continuing."),
        "bookServiceSelectPackageAndLocation": MessageLookupByLibrary.simpleMessage(
            "Select a service package and location to discover nearby technicians."),
        "bookServiceSelectPackageBeforeContinuing":
            MessageLookupByLibrary.simpleMessage(
                "Please select a service package before continuing."),
        "bookServiceSelectedCategory": m4,
        "bookServiceSelectedLocation": m5,
        "bookServiceSelectedPackageUnavailable":
            MessageLookupByLibrary.simpleMessage(
                "Unable to determine the selected package."),
        "bookServiceSelectedVehicleUnavailable":
            MessageLookupByLibrary.simpleMessage(
                "Unable to determine the selected vehicle."),
        "bookServiceSignInToSelectCar": MessageLookupByLibrary.simpleMessage(
            "Please sign in to select a car"),
        "bookServiceStepChoosePackage":
            MessageLookupByLibrary.simpleMessage("Choose Package"),
        "bookServiceStepPickLocation":
            MessageLookupByLibrary.simpleMessage("Pick Location"),
        "bookServiceStepSelectTechnician":
            MessageLookupByLibrary.simpleMessage("Select Technician"),
        "bookServiceStepSelectVehicle":
            MessageLookupByLibrary.simpleMessage("Select Vehicle"),
        "bookServiceTapMapToSelectLocation":
            MessageLookupByLibrary.simpleMessage(
                "Tap anywhere on the map to select a service location."),
        "bookServiceTapTechnicianForSlots":
            MessageLookupByLibrary.simpleMessage(
                "Tap a technician to see their available time slots."),
        "bookServiceTechnicianBranchUnavailable":
            MessageLookupByLibrary.simpleMessage(
                "Unable to determine the technician branch."),
        "bookServiceTechnicianInfoUnavailable":
            MessageLookupByLibrary.simpleMessage(
                "Unable to determine the technician information."),
        "bookServiceTryAgain":
            MessageLookupByLibrary.simpleMessage("Try Again"),
        "carDetailing": MessageLookupByLibrary.simpleMessage("Car Detailing"),
        "carEvaluation": MessageLookupByLibrary.simpleMessage("Car Evaluation"),
        "carInfo": MessageLookupByLibrary.simpleMessage("Car Info"),
        "carRepair": MessageLookupByLibrary.simpleMessage("Car Repair"),
        "carWash": MessageLookupByLibrary.simpleMessage("Car Wash"),
        "changeLanguage":
            MessageLookupByLibrary.simpleMessage("Change Language"),
        "characterVinLimit":
            MessageLookupByLibrary.simpleMessage("VIN must be 17 characters"),
        "characterVinLimitError":
            MessageLookupByLibrary.simpleMessage("VIN must be 17 characters"),
        "chatEmptyMessage": MessageLookupByLibrary.simpleMessage(
            "No messages yet. Start the conversation."),
        "chatErrorLoading": MessageLookupByLibrary.simpleMessage(
            "Unable to load chat messages."),
        "chatInputHint": MessageLookupByLibrary.simpleMessage("Type a message"),
        "chatLoginRequired": MessageLookupByLibrary.simpleMessage(
            "Please sign in to chat with your technician."),
        "chatMissingBookingId": MessageLookupByLibrary.simpleMessage(
            "Missing booking id for chat."),
        "chatSendLabel": MessageLookupByLibrary.simpleMessage("Send"),
        "chatTitle": MessageLookupByLibrary.simpleMessage("Chat"),
        "chatUnavailable": MessageLookupByLibrary.simpleMessage(
            "Chat is not available for this booking."),
        "comment": MessageLookupByLibrary.simpleMessage("Comment"),
        "commonErrorDescription": MessageLookupByLibrary.simpleMessage(
            "Please check your internet connection or try again."),
        "commonErrorTitle":
            MessageLookupByLibrary.simpleMessage("Something went wrong"),
        "commonRetry": MessageLookupByLibrary.simpleMessage("Retry"),
        "companyName": MessageLookupByLibrary.simpleMessage("Company Name"),
        "companyNameError":
            MessageLookupByLibrary.simpleMessage("Please enter company name"),
        "companyNameHint":
            MessageLookupByLibrary.simpleMessage("e.g. MotorLube Co."),
        "contactUsAppbar": MessageLookupByLibrary.simpleMessage("Contanct Us"),
        "contactUsNav": MessageLookupByLibrary.simpleMessage("Contact Us"),
        "crn": MessageLookupByLibrary.simpleMessage(
            "Commercial Registration Number (CRN)"),
        "crnError": MessageLookupByLibrary.simpleMessage(
            "Please enter Commercial Registration Number (CRN)"),
        "crnHint": MessageLookupByLibrary.simpleMessage("e.g. 1234567890"),
        "crnLengthError":
            MessageLookupByLibrary.simpleMessage("CRN must be 10 digits"),
        "didntReceiveOtp":
            MessageLookupByLibrary.simpleMessage("Didn\'t receive the OTP?"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "endDate": MessageLookupByLibrary.simpleMessage("End Date"),
        "english": MessageLookupByLibrary.simpleMessage("English"),
        "enterOtpSentTo":
            MessageLookupByLibrary.simpleMessage("Enter the OTP sent to"),
        "enterPromotionNameHint":
            MessageLookupByLibrary.simpleMessage("Enter promotion name"),
        "enterProperValue":
            MessageLookupByLibrary.simpleMessage("Please enter a proper value"),
        "enterValidEmail":
            MessageLookupByLibrary.simpleMessage("Please enter a valid email"),
        "errorSavingPromotion": MessageLookupByLibrary.simpleMessage(
            "An error occurred while saving the promotion, please try again later."),
        "errorTitle": MessageLookupByLibrary.simpleMessage("Error"),
        "expiresIn": MessageLookupByLibrary.simpleMessage("Expires in"),
        "fillAllFields":
            MessageLookupByLibrary.simpleMessage("Please fill all fields"),
        "firstName": MessageLookupByLibrary.simpleMessage("First Name"),
        "firstNameHint":
            MessageLookupByLibrary.simpleMessage("Enter first name"),
        "flatTyre": MessageLookupByLibrary.simpleMessage("Flat Tyre"),
        "forceUpdateButton": MessageLookupByLibrary.simpleMessage("Update Now"),
        "forceUpdateMessage": MessageLookupByLibrary.simpleMessage(
            "A new update is available. Please update the app to continue."),
        "forceUpdateTitle": MessageLookupByLibrary.simpleMessage(
            "There is an update available"),
        "homeAppbar": MessageLookupByLibrary.simpleMessage("Home"),
        "homeNav": MessageLookupByLibrary.simpleMessage("Home"),
        "insuranceClaims":
            MessageLookupByLibrary.simpleMessage("Insurance Claims"),
        "lastName": MessageLookupByLibrary.simpleMessage("Last Name"),
        "lastNameHint": MessageLookupByLibrary.simpleMessage("Enter last name"),
        "logInToContinue":
            MessageLookupByLibrary.simpleMessage("Log in to continue"),
        "login": MessageLookupByLibrary.simpleMessage("login"),
        "loginWelcomeMessage": MessageLookupByLibrary.simpleMessage(
            "welcome back, Loging Motorlube"),
        "mailUsAt": MessageLookupByLibrary.simpleMessage("Mail us at"),
        "maintenanceNav": MessageLookupByLibrary.simpleMessage("Maintenance"),
        "majorServices": MessageLookupByLibrary.simpleMessage("Major Services"),
        "managerHomeCouponsDescription":
            MessageLookupByLibrary.simpleMessage("Create discount coupons"),
        "managerHomeCouponsTitle":
            MessageLookupByLibrary.simpleMessage("Coupons"),
        "managerHomeCreatePromotionDescription":
            MessageLookupByLibrary.simpleMessage("Add a new promotion"),
        "managerHomeCreatePromotionTitle":
            MessageLookupByLibrary.simpleMessage("Create Promotion"),
        "managerHomePromotionsDescription":
            MessageLookupByLibrary.simpleMessage("Promotion control panel"),
        "managerHomePromotionsTitle":
            MessageLookupByLibrary.simpleMessage("Promotions"),
        "managerHomeRatingsDescription":
            MessageLookupByLibrary.simpleMessage("View customer ratings"),
        "managerHomeRatingsTitle":
            MessageLookupByLibrary.simpleMessage("Ratings"),
        "managerHomeRouteUnavailable": m6,
        "managerHomeTitle": MessageLookupByLibrary.simpleMessage("Manager"),
        "manufacturer": MessageLookupByLibrary.simpleMessage("Manufacturer"),
        "mobileServices":
            MessageLookupByLibrary.simpleMessage("Mobile Services"),
        "model": MessageLookupByLibrary.simpleMessage("Model"),
        "more": MessageLookupByLibrary.simpleMessage("More"),
        "moreAppbar": MessageLookupByLibrary.simpleMessage("More"),
        "moreNav": MessageLookupByLibrary.simpleMessage("More"),
        "myCarsNav": MessageLookupByLibrary.simpleMessage("My Cars"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "next": MessageLookupByLibrary.simpleMessage("next"),
        "no": MessageLookupByLibrary.simpleMessage("No"),
        "noCarsFound": MessageLookupByLibrary.simpleMessage("No cars found"),
        "notValidUserEmail":
            MessageLookupByLibrary.simpleMessage("User email is not valid"),
        "oiling": MessageLookupByLibrary.simpleMessage("Oiling"),
        "onBoardingDescription1": MessageLookupByLibrary.simpleMessage(
            "Skip the hassle of workshop visits! Our expert mobile auto service brings professional maintenance & repairs right to your location."),
        "onBoardingDescription2": MessageLookupByLibrary.simpleMessage(
            "We use the latest and best solutions to advance the field of car service to provide a unique experience that has never been experienced before."),
        "onBoardingDescription3": MessageLookupByLibrary.simpleMessage(
            "What’s guarding your vehicle’s undercarriage? At Motor Lube, we don’t just protect – we armor your car with Revive Premium Wax-Based Undercoat Treatment."),
        "onBoardingTitle1":
            MessageLookupByLibrary.simpleMessage("Mobile Car Service"),
        "onBoardingTitle2":
            MessageLookupByLibrary.simpleMessage("Emergency Service"),
        "onBoardingTitle3":
            MessageLookupByLibrary.simpleMessage("Following Dealer Standards"),
        "ourServices": MessageLookupByLibrary.simpleMessage("Our Services"),
        "phoneNumber": MessageLookupByLibrary.simpleMessage("Phone Number"),
        "plate": MessageLookupByLibrary.simpleMessage("Plate"),
        "plateLetters": MessageLookupByLibrary.simpleMessage("Plate Letters"),
        "plateNumbers": MessageLookupByLibrary.simpleMessage("Plate Numbers"),
        "profileAppbar": MessageLookupByLibrary.simpleMessage("Profile"),
        "profileNav": MessageLookupByLibrary.simpleMessage("Profile"),
        "promotionDescription":
            MessageLookupByLibrary.simpleMessage("Promotion Description"),
        "promotionName": MessageLookupByLibrary.simpleMessage("Promotion Name"),
        "promotionSavedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Promotion saved successfully"),
        "register": MessageLookupByLibrary.simpleMessage("Register"),
        "resendOTP": MessageLookupByLibrary.simpleMessage("Resend OTP"),
        "savePromotion": MessageLookupByLibrary.simpleMessage("Save Promotion"),
        "selectEndDate":
            MessageLookupByLibrary.simpleMessage("Select End Date"),
        "selectManufacturer":
            MessageLookupByLibrary.simpleMessage("Select Manufacturer"),
        "selectModel": MessageLookupByLibrary.simpleMessage("Select Model"),
        "selectStartDate":
            MessageLookupByLibrary.simpleMessage("Select Start Date"),
        "selectYear": MessageLookupByLibrary.simpleMessage("Select Year"),
        "skip": MessageLookupByLibrary.simpleMessage("Skip"),
        "start": MessageLookupByLibrary.simpleMessage("start"),
        "startDate": MessageLookupByLibrary.simpleMessage("Start Date"),
        "submit": MessageLookupByLibrary.simpleMessage("Submit"),
        "towiling": MessageLookupByLibrary.simpleMessage("Towiling"),
        "upcomingService":
            MessageLookupByLibrary.simpleMessage("Upcoming Service"),
        "upcomingServicesAssignedTechnicianLabel":
            MessageLookupByLibrary.simpleMessage("Assigned Technician"),
        "upcomingServicesBookingDetailsTitle":
            MessageLookupByLibrary.simpleMessage("Booking Details"),
        "upcomingServicesDateFallback":
            MessageLookupByLibrary.simpleMessage("Date to be confirmed"),
        "upcomingServicesEmptyMessage": MessageLookupByLibrary.simpleMessage(
            "No upcoming services scheduled."),
        "upcomingServicesErrorPrefix": MessageLookupByLibrary.simpleMessage(
            "Unable to load upcoming services."),
        "upcomingServicesLoadingLocation":
            MessageLookupByLibrary.simpleMessage("Loading location"),
        "upcomingServicesLoadingPackage":
            MessageLookupByLibrary.simpleMessage("Loading package title"),
        "upcomingServicesLoadingStatus":
            MessageLookupByLibrary.simpleMessage("Loading"),
        "upcomingServicesLoadingTechnician":
            MessageLookupByLibrary.simpleMessage("Loading technician"),
        "upcomingServicesLoadingVehicle":
            MessageLookupByLibrary.simpleMessage("Loading vehicle"),
        "upcomingServicesLocationFallback":
            MessageLookupByLibrary.simpleMessage("Location to be confirmed"),
        "upcomingServicesLoginPrompt": MessageLookupByLibrary.simpleMessage(
            "Log in to view your upcoming services."),
        "upcomingServicesPlateFallback":
            MessageLookupByLibrary.simpleMessage("Plate unavailable"),
        "upcomingServicesServiceLocationLabel":
            MessageLookupByLibrary.simpleMessage("Service Location"),
        "upcomingServicesServicePackageLabel":
            MessageLookupByLibrary.simpleMessage("Service Package"),
        "upcomingServicesServicePlaceholder":
            MessageLookupByLibrary.simpleMessage("Service"),
        "upcomingServicesStatusCancelled":
            MessageLookupByLibrary.simpleMessage("Cancelled"),
        "upcomingServicesStatusCompleted":
            MessageLookupByLibrary.simpleMessage("Completed"),
        "upcomingServicesStatusExpired":
            MessageLookupByLibrary.simpleMessage("Expired"),
        "upcomingServicesStatusNew":
            MessageLookupByLibrary.simpleMessage("New Booking"),
        "upcomingServicesStatusPending":
            MessageLookupByLibrary.simpleMessage("Pending"),
        "upcomingServicesStatusUpcoming":
            MessageLookupByLibrary.simpleMessage("Upcoming"),
        "upcomingServicesTechnicianFallback":
            MessageLookupByLibrary.simpleMessage("Technician to be assigned"),
        "upcomingServicesVehiclePlaceholder":
            MessageLookupByLibrary.simpleMessage("Vehicle"),
        "upcomingServicesViewButton":
            MessageLookupByLibrary.simpleMessage("Log in"),
        "userCarsAddCrnImage":
            MessageLookupByLibrary.simpleMessage("Add CRN image"),
        "userCarsAddImageRequirement": MessageLookupByLibrary.simpleMessage(
            "Please add at least one image."),
        "userCarsAddPhotos": MessageLookupByLibrary.simpleMessage("Add Photos"),
        "userCarsAddedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Car added successfully"),
        "userCarsBookNow": MessageLookupByLibrary.simpleMessage("Book Now"),
        "userCarsCarDetailsTitle":
            MessageLookupByLibrary.simpleMessage("Car details"),
        "userCarsCarModelLabel":
            MessageLookupByLibrary.simpleMessage("Car model"),
        "userCarsCarName": MessageLookupByLibrary.simpleMessage("Car name"),
        "userCarsCardSemantics": m7,
        "userCarsChassis": MessageLookupByLibrary.simpleMessage("Chassis"),
        "userCarsChassisVin":
            MessageLookupByLibrary.simpleMessage("Chassis (VIN)"),
        "userCarsChooseFromGallery": MessageLookupByLibrary.simpleMessage(
            "Choose from gallery (multiple)"),
        "userCarsCompletePlateFields": MessageLookupByLibrary.simpleMessage(
            "Please complete plate fields"),
        "userCarsCopiedToClipboard":
            MessageLookupByLibrary.simpleMessage("Copied to clipboard"),
        "userCarsCopy": MessageLookupByLibrary.simpleMessage("Copy"),
        "userCarsDeleteCar": MessageLookupByLibrary.simpleMessage("Delete car"),
        "userCarsEditInfo": MessageLookupByLibrary.simpleMessage("Edit info"),
        "userCarsEmptyDescription": MessageLookupByLibrary.simpleMessage(
            "We couldn’t find any cars matching your search ."),
        "userCarsErrorLoadingManufacturers":
            MessageLookupByLibrary.simpleMessage("Error loading manufacturers"),
        "userCarsErrorLoadingModels":
            MessageLookupByLibrary.simpleMessage("Error loading car models"),
        "userCarsImagesSectionTitle":
            MessageLookupByLibrary.simpleMessage("Car Images"),
        "userCarsInvalidPlateLetter":
            MessageLookupByLibrary.simpleMessage("Invalid plate letter"),
        "userCarsInvalidPlateNumber":
            MessageLookupByLibrary.simpleMessage("Invalid plate number"),
        "userCarsLicensePlateSemantics": m8,
        "userCarsSaveVehicle":
            MessageLookupByLibrary.simpleMessage("Save Vehicle"),
        "userCarsSaving": MessageLookupByLibrary.simpleMessage("Saving..."),
        "userCarsTakePhoto":
            MessageLookupByLibrary.simpleMessage("Take a photo"),
        "userCarsYearOfManufacture":
            MessageLookupByLibrary.simpleMessage("Year of manufacture"),
        "userEmail": MessageLookupByLibrary.simpleMessage("User Email"),
        "userEmailHint":
            MessageLookupByLibrary.simpleMessage("Enter user email"),
        "userName": MessageLookupByLibrary.simpleMessage("User Name"),
        "userNameHint": MessageLookupByLibrary.simpleMessage("Enter user name"),
        "verify": MessageLookupByLibrary.simpleMessage("Verify"),
        "vin": MessageLookupByLibrary.simpleMessage("VIN"),
        "year": MessageLookupByLibrary.simpleMessage("Year"),
        "yes": MessageLookupByLibrary.simpleMessage("Yes"),
        "yourCars": MessageLookupByLibrary.simpleMessage("Your Cars")
      };
}
