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

  static String m0(date) =>
      "Account deletion request submitted on ${date}. Your data will be deleted within 30 days of the request.";

  static String m1(label) => "Already on ${label}.";

  static String m2(name) => "Available slots for ${name}";

  static String m3(distance) => "${distance} km away";

  static String m4(message) => "Failed to load packages.\n${message}";

  static String m5(price) => "${price} SAR";

  static String m6(label) => "Selected category: ${label}";

  static String m7(latitude, longitude) =>
      "Selected location: (${latitude}, ${longitude})";

  static String m8(count) => "Apply (${count})";

  static String m9(id) => "ID ${id}";

  static String m10(name) => "Delete \"${name}\" from this package?";

  static String m11(error) => "Failed to load checklist: ${error}";

  static String m12(error) => "Failed to save checklist: ${error}";

  static String m13(count) => "Items (${count})";

  static String m14(srNumber) => "Job card ${srNumber} created.";

  static String m15(jobCardNumber) => "Job card: ${jobCardNumber}";

  static String m16(srNumber) => "Job Card ${srNumber}";

  static String m17(lineId) => "Line: ${lineId}";

  static String m18(number) => "Line ${number}";

  static String m19(route) => "Route \"${route}\" is not available.";

  static String m20(code) => "Package ${code}";

  static String m21(code) => "Code: ${code}";

  static String m22(price) => "Price: ${price}";

  static String m23(quantity) => "Qty: ${quantity}";

  static String m24(name, srNumber) =>
      "Are you sure you want to remove \"${name}\" from SR ${srNumber}?";

  static String m25(srLine) => "SR Line ID: ${srLine}";

  static String m26(code) => "Status ${code}";

  static String m27(id) => "Status ID ${id}";

  static String m28(count) => "${count} statuses selected";

  static String m29(id) => "Status ${id}";

  static String m30(model, plate) => "Car card for ${model}, plate ${plate}";

  static String m31(plate) => "License plate ${plate}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "PleaseLoginToViewYourCarsMessage": MessageLookupByLibrary.simpleMessage(
      "Please login to view your cars",
    ),
    "Profile": MessageLookupByLibrary.simpleMessage("Profile"),
    "accountDeletionEmailMissing": MessageLookupByLibrary.simpleMessage(
      "Unable to submit deletion request because this account has no email address.",
    ),
    "accountDeletionFailed": MessageLookupByLibrary.simpleMessage(
      "Unable to submit account deletion request. Please try again.",
    ),
    "accountDeletionIrreversible30Days": MessageLookupByLibrary.simpleMessage(
      "Account deletion is irreversible after 30 days.",
    ),
    "accountDeletionRequestSubmitted": MessageLookupByLibrary.simpleMessage(
      "Account deletion request submitted",
    ),
    "accountDeletionSubmittedMessage": m0,
    "addCar": MessageLookupByLibrary.simpleMessage("Add Car"),
    "addCouponButtonLabel": MessageLookupByLibrary.simpleMessage("Add coupon"),
    "addItemButtonLabel": MessageLookupByLibrary.simpleMessage("Add item"),
    "addItemsOrServicesTitle": MessageLookupByLibrary.simpleMessage(
      "Add items or services",
    ),
    "addPackageToJobCardButtonLabel": MessageLookupByLibrary.simpleMessage(
      "Add package to job card",
    ),
    "allButtonLabel": MessageLookupByLibrary.simpleMessage("All"),
    "alreadyOnStatusMessage": m1,
    "amountDueLabel": MessageLookupByLibrary.simpleMessage("Amount due"),
    "anyDateLabel": MessageLookupByLibrary.simpleMessage("Any date"),
    "appName": MessageLookupByLibrary.simpleMessage("Motor Lube"),
    "appVersion": MessageLookupByLibrary.simpleMessage("V 2.0.0"),
    "appliedCouponLabel": MessageLookupByLibrary.simpleMessage(
      "Applied coupon",
    ),
    "applyFiltersButtonLabel": MessageLookupByLibrary.simpleMessage(
      "Apply filters",
    ),
    "appointmentCancelledSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Appointment cancelled successfully.",
    ),
    "appointmentDetailsTitle": MessageLookupByLibrary.simpleMessage(
      "Appointment Details",
    ),
    "arabic": MessageLookupByLibrary.simpleMessage("Arabic"),
    "areYouOwnerThisCar": MessageLookupByLibrary.simpleMessage(
      "Are you the owner of this car?",
    ),
    "assignedAppointmentsWillAppearHere": MessageLookupByLibrary.simpleMessage(
      "You will see all assigned appointments here once customers book services.",
    ),
    "authenticationErrorMessage": MessageLookupByLibrary.simpleMessage(
      "An error occurred during authentication",
    ),
    "back": MessageLookupByLibrary.simpleMessage("Back"),
    "backOnline": MessageLookupByLibrary.simpleMessage("Back Online"),
    "basicServices": MessageLookupByLibrary.simpleMessage("Basic Services"),
    "batteires": MessageLookupByLibrary.simpleMessage("Batteries"),
    "bestOffers": MessageLookupByLibrary.simpleMessage("Best Offers"),
    "book": MessageLookupByLibrary.simpleMessage("Book"),
    "bookServiceAllow": MessageLookupByLibrary.simpleMessage("Allow"),
    "bookServiceAppointmentConfirmedTitle":
        MessageLookupByLibrary.simpleMessage("Appointment Confirmed"),
    "bookServiceAvailableSlotsFor": m2,
    "bookServiceCompleteAllStepsBeforeBooking":
        MessageLookupByLibrary.simpleMessage(
          "Please complete all steps before booking.",
        ),
    "bookServiceCreateAppointmentFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to create appointment. Please try again.",
    ),
    "bookServiceCustomerInfoUnavailable": MessageLookupByLibrary.simpleMessage(
      "Unable to determine customer information.",
    ),
    "bookServiceDeny": MessageLookupByLibrary.simpleMessage("Deny"),
    "bookServiceDistanceAway": m3,
    "bookServiceFailedToLoadPackages": m4,
    "bookServiceLocationPermissionMessage":
        MessageLookupByLibrary.simpleMessage(
          "We need your location to show it on the map.",
        ),
    "bookServiceLocationPermissionTitle": MessageLookupByLibrary.simpleMessage(
      "Location Permission",
    ),
    "bookServiceNoPackagesFoundDescription": MessageLookupByLibrary.simpleMessage(
      "We couldn’t find any packages for your selected car and category.\nTry changing filters or check again later.",
    ),
    "bookServiceNoPackagesFoundTitle": MessageLookupByLibrary.simpleMessage(
      "No Packages Found",
    ),
    "bookServiceNoSlotsForSelectedDate": MessageLookupByLibrary.simpleMessage(
      "No slots available for the selected date.",
    ),
    "bookServiceNoTechniciansInRegion": MessageLookupByLibrary.simpleMessage(
      "No available technician in this region.",
    ),
    "bookServiceOk": MessageLookupByLibrary.simpleMessage("OK"),
    "bookServicePackagesLoadAfterContinue":
        MessageLookupByLibrary.simpleMessage(
          "Packages will load once you continue.",
        ),
    "bookServicePriceSar": m5,
    "bookServiceReadyToFindTechnicians": MessageLookupByLibrary.simpleMessage(
      "Ready to find technicians near your chosen location?",
    ),
    "bookServiceRefresh": MessageLookupByLibrary.simpleMessage("Refresh"),
    "bookServiceReset": MessageLookupByLibrary.simpleMessage("Reset"),
    "bookServiceSearchTechnicians": MessageLookupByLibrary.simpleMessage(
      "Search Technicians",
    ),
    "bookServiceSelectCarBeforeContinuing":
        MessageLookupByLibrary.simpleMessage(
          "Please select a car before continuing.",
        ),
    "bookServiceSelectCarInStepOne": MessageLookupByLibrary.simpleMessage(
      "Please select a car in Step 1 to view available packages.",
    ),
    "bookServiceSelectLocationBeforeContinuing":
        MessageLookupByLibrary.simpleMessage(
          "Please choose a location on the map before continuing.",
        ),
    "bookServiceSelectPackageAndLocation": MessageLookupByLibrary.simpleMessage(
      "Select a service package and location to discover nearby technicians.",
    ),
    "bookServiceSelectPackageBeforeContinuing":
        MessageLookupByLibrary.simpleMessage(
          "Please select a service package before continuing.",
        ),
    "bookServiceSelectedCategory": m6,
    "bookServiceSelectedLocation": m7,
    "bookServiceSelectedPackageUnavailable":
        MessageLookupByLibrary.simpleMessage(
          "Unable to determine the selected package.",
        ),
    "bookServiceSelectedVehicleUnavailable":
        MessageLookupByLibrary.simpleMessage(
          "Unable to determine the selected vehicle.",
        ),
    "bookServiceSignInToSelectCar": MessageLookupByLibrary.simpleMessage(
      "Please sign in to select a car",
    ),
    "bookServiceStepChoosePackage": MessageLookupByLibrary.simpleMessage(
      "Choose Package",
    ),
    "bookServiceStepPickLocation": MessageLookupByLibrary.simpleMessage(
      "Pick Location",
    ),
    "bookServiceStepSelectTechnician": MessageLookupByLibrary.simpleMessage(
      "Select Technician",
    ),
    "bookServiceStepSelectVehicle": MessageLookupByLibrary.simpleMessage(
      "Select Vehicle",
    ),
    "bookServiceTapMapToSelectLocation": MessageLookupByLibrary.simpleMessage(
      "Tap anywhere on the map to select a service location.",
    ),
    "bookServiceTapTechnicianForSlots": MessageLookupByLibrary.simpleMessage(
      "Tap a technician to see their available time slots.",
    ),
    "bookServiceTechnicianBranchUnavailable":
        MessageLookupByLibrary.simpleMessage(
          "Unable to determine the technician branch.",
        ),
    "bookServiceTechnicianInfoUnavailable":
        MessageLookupByLibrary.simpleMessage(
          "Unable to determine the technician information.",
        ),
    "bookServiceTryAgain": MessageLookupByLibrary.simpleMessage("Try Again"),
    "bookingStatusPickerApply": MessageLookupByLibrary.simpleMessage("Apply"),
    "bookingStatusPickerApplyCount": m8,
    "bookingStatusPickerClear": MessageLookupByLibrary.simpleMessage("Clear"),
    "bookingStatusPickerStatusId": m9,
    "bookingStatusPickerTitle": MessageLookupByLibrary.simpleMessage(
      "Select booking statuses",
    ),
    "bookingStatusTitle": MessageLookupByLibrary.simpleMessage(
      "Booking status",
    ),
    "branchFieldLabel": MessageLookupByLibrary.simpleMessage("Branch"),
    "branchNotAssignedLabel": MessageLookupByLibrary.simpleMessage(
      "Branch not assigned",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cancelAppointmentButtonLabel": MessageLookupByLibrary.simpleMessage(
      "Cancel appointment",
    ),
    "cancelAppointmentConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to cancel this appointment?",
    ),
    "cancelAppointmentTitle": MessageLookupByLibrary.simpleMessage(
      "Cancel appointment?",
    ),
    "cancelButtonLabel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cancellationStatusUnavailable": MessageLookupByLibrary.simpleMessage(
      "Cancellation status is unavailable right now.",
    ),
    "cancellingEllipsis": MessageLookupByLibrary.simpleMessage("Cancelling..."),
    "cannotCancelAfterJobCardOpened": MessageLookupByLibrary.simpleMessage(
      "Cannot cancel after job card is opened.",
    ),
    "carDetailing": MessageLookupByLibrary.simpleMessage("Car Detailing"),
    "carEvaluation": MessageLookupByLibrary.simpleMessage("Car Evaluation"),
    "carInfo": MessageLookupByLibrary.simpleMessage("Car Info"),
    "carRepair": MessageLookupByLibrary.simpleMessage("Car Repair"),
    "carWash": MessageLookupByLibrary.simpleMessage("Car Wash"),
    "categoryLabel": MessageLookupByLibrary.simpleMessage("Category"),
    "changeLanguage": MessageLookupByLibrary.simpleMessage("Change Language"),
    "changeProfilePhoto": MessageLookupByLibrary.simpleMessage(
      "Change profile photo",
    ),
    "characterVinLimit": MessageLookupByLibrary.simpleMessage(
      "VIN must be 17 characters",
    ),
    "characterVinLimitError": MessageLookupByLibrary.simpleMessage(
      "VIN must be 17 characters",
    ),
    "chatEmptyMessage": MessageLookupByLibrary.simpleMessage(
      "No messages yet. Start the conversation.",
    ),
    "chatErrorLoading": MessageLookupByLibrary.simpleMessage(
      "Unable to load chat messages.",
    ),
    "chatInputHint": MessageLookupByLibrary.simpleMessage("Type a message"),
    "chatLoginRequired": MessageLookupByLibrary.simpleMessage(
      "Please sign in to chat with your technician.",
    ),
    "chatMissingBookingId": MessageLookupByLibrary.simpleMessage(
      "Missing booking id for chat.",
    ),
    "chatSendLabel": MessageLookupByLibrary.simpleMessage("Send"),
    "chatTitle": MessageLookupByLibrary.simpleMessage("Chat"),
    "chatUnavailable": MessageLookupByLibrary.simpleMessage(
      "Chat is not available for this booking.",
    ),
    "checklistSubmittedMessage": MessageLookupByLibrary.simpleMessage(
      "Checklist submitted.",
    ),
    "checkoutDetailsLabel": MessageLookupByLibrary.simpleMessage(
      "Checkout details",
    ),
    "comment": MessageLookupByLibrary.simpleMessage("Comment"),
    "commentLabel": MessageLookupByLibrary.simpleMessage("Comment"),
    "commonErrorDescription": MessageLookupByLibrary.simpleMessage(
      "Please check your internet connection or try again.",
    ),
    "commonErrorTitle": MessageLookupByLibrary.simpleMessage(
      "Something went wrong",
    ),
    "commonRetry": MessageLookupByLibrary.simpleMessage("Retry"),
    "commonSomethingWentWrong": MessageLookupByLibrary.simpleMessage(
      "Something went wrong.",
    ),
    "companyName": MessageLookupByLibrary.simpleMessage("Company Name"),
    "companyNameError": MessageLookupByLibrary.simpleMessage(
      "Please enter company name",
    ),
    "companyNameHint": MessageLookupByLibrary.simpleMessage(
      "e.g. MotorLube Co.",
    ),
    "companyNameLabel": MessageLookupByLibrary.simpleMessage("Company Name"),
    "completePayment": MessageLookupByLibrary.simpleMessage("Complete Payment"),
    "confirmAccountDeletion": MessageLookupByLibrary.simpleMessage(
      "Confirm Account Deletion",
    ),
    "connectionTimedOutMessage": MessageLookupByLibrary.simpleMessage(
      "Connection timed out. Please try again.",
    ),
    "contactUsAppbar": MessageLookupByLibrary.simpleMessage("Contanct Us"),
    "contactUsInquirySentMessage": MessageLookupByLibrary.simpleMessage(
      "Your inquiry has been sent successfully.",
    ),
    "contactUsInquirySentTitle": MessageLookupByLibrary.simpleMessage(
      "Inquiry sent",
    ),
    "contactUsNav": MessageLookupByLibrary.simpleMessage("Contact Us"),
    "couponCountLabel": MessageLookupByLibrary.simpleMessage("Coupon count"),
    "couponDefaultLabel": MessageLookupByLibrary.simpleMessage("Coupon"),
    "couponDiscountLabel": MessageLookupByLibrary.simpleMessage("Discount"),
    "couponListTitle": MessageLookupByLibrary.simpleMessage("Coupons"),
    "createButtonLabel": MessageLookupByLibrary.simpleMessage("Create"),
    "createCouponScreenTitle": MessageLookupByLibrary.simpleMessage(
      "Create Coupon",
    ),
    "createCouponTooltip": MessageLookupByLibrary.simpleMessage(
      "Create coupon",
    ),
    "createDefaultChecklistButtonLabel": MessageLookupByLibrary.simpleMessage(
      "Create default checklist",
    ),
    "creatingJobCardMessage": MessageLookupByLibrary.simpleMessage(
      "Creating job card... packages will appear shortly.",
    ),
    "creditManagerUserLabel": MessageLookupByLibrary.simpleMessage(
      "Credit manager user",
    ),
    "crn": MessageLookupByLibrary.simpleMessage(
      "Commercial Registration Number (CRN)",
    ),
    "crnError": MessageLookupByLibrary.simpleMessage(
      "Please enter Commercial Registration Number (CRN)",
    ),
    "crnHint": MessageLookupByLibrary.simpleMessage("e.g. 1234567890"),
    "crnLengthError": MessageLookupByLibrary.simpleMessage(
      "CRN must be 10 digits",
    ),
    "customPackageManagerTitle": MessageLookupByLibrary.simpleMessage(
      "Custom Package Manager",
    ),
    "customTagLabel": MessageLookupByLibrary.simpleMessage("Custom"),
    "customerDefaultLabel": MessageLookupByLibrary.simpleMessage("Customer"),
    "customerUserLabel": MessageLookupByLibrary.simpleMessage("Customer user"),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteAccount": MessageLookupByLibrary.simpleMessage("Delete Account"),
    "deleteButtonLabel": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteItemConfirmation": m10,
    "deleteItemTooltip": MessageLookupByLibrary.simpleMessage("Delete item"),
    "deleteTooltip": MessageLookupByLibrary.simpleMessage("Delete"),
    "didntReceiveOtp": MessageLookupByLibrary.simpleMessage(
      "Didn\'t receive the OTP?",
    ),
    "discountLabel": MessageLookupByLibrary.simpleMessage("Discount"),
    "discountPercentageLabel": MessageLookupByLibrary.simpleMessage(
      "Discount %",
    ),
    "editProfile": MessageLookupByLibrary.simpleMessage("Edit Profile"),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "emergencyTagLabel": MessageLookupByLibrary.simpleMessage("Emergency"),
    "endDate": MessageLookupByLibrary.simpleMessage("End Date"),
    "english": MessageLookupByLibrary.simpleMessage("English"),
    "enterCountError": MessageLookupByLibrary.simpleMessage("Enter count"),
    "enterNumberError": MessageLookupByLibrary.simpleMessage("Enter number"),
    "enterOtpSentTo": MessageLookupByLibrary.simpleMessage(
      "Enter the OTP sent to",
    ),
    "enterPromotionNameHint": MessageLookupByLibrary.simpleMessage(
      "Enter promotion name",
    ),
    "enterProperValue": MessageLookupByLibrary.simpleMessage(
      "Please enter a proper value",
    ),
    "enterQuantityMessage": MessageLookupByLibrary.simpleMessage(
      "Enter a quantity.",
    ),
    "enterValidEmail": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid email",
    ),
    "errorSavingPromotion": MessageLookupByLibrary.simpleMessage(
      "An error occurred while saving the promotion, please try again later.",
    ),
    "errorTitle": MessageLookupByLibrary.simpleMessage("Error"),
    "expiresIn": MessageLookupByLibrary.simpleMessage("Expires in"),
    "failedToInitiatePayment": MessageLookupByLibrary.simpleMessage(
      "Failed to initiate payment. Please try again.",
    ),
    "failedToLoadChecklistError": m11,
    "failedToSaveChecklistError": m12,
    "failedToSubmitChecklistMessage": MessageLookupByLibrary.simpleMessage(
      "Failed to submit checklist.",
    ),
    "failedToVerifyPaymentStatus": MessageLookupByLibrary.simpleMessage(
      "Failed to verify payment status. Please try again.",
    ),
    "fillAllFields": MessageLookupByLibrary.simpleMessage(
      "Please fill all fields",
    ),
    "filterApprovalsTitle": MessageLookupByLibrary.simpleMessage(
      "Filter approvals",
    ),
    "firstName": MessageLookupByLibrary.simpleMessage("First Name"),
    "firstNameHint": MessageLookupByLibrary.simpleMessage("Enter first name"),
    "flatTyre": MessageLookupByLibrary.simpleMessage("Flat Tyre"),
    "forceUpdateButton": MessageLookupByLibrary.simpleMessage("Update Now"),
    "forceUpdateMessage": MessageLookupByLibrary.simpleMessage(
      "A new update is available. Please update the app to continue.",
    ),
    "forceUpdateTitle": MessageLookupByLibrary.simpleMessage(
      "There is an update available",
    ),
    "fromDateLabel": MessageLookupByLibrary.simpleMessage("From"),
    "homeAppbar": MessageLookupByLibrary.simpleMessage("Home"),
    "homeNav": MessageLookupByLibrary.simpleMessage("Home"),
    "includedLabel": MessageLookupByLibrary.simpleMessage("Included"),
    "insuranceClaims": MessageLookupByLibrary.simpleMessage("Insurance Claims"),
    "invoiceCurrencySymbol": MessageLookupByLibrary.simpleMessage("SAR "),
    "invoiceDateLabel": MessageLookupByLibrary.simpleMessage("Date"),
    "invoiceFileUnavailableMessage": MessageLookupByLibrary.simpleMessage(
      "The invoice PDF is not available yet. Please check again later.",
    ),
    "invoiceNumberLabel": MessageLookupByLibrary.simpleMessage(
      "Invoice number",
    ),
    "invoiceOpenFailedMessage": MessageLookupByLibrary.simpleMessage(
      "Unable to open the invoice PDF.",
    ),
    "invoiceOpenPdfButton": MessageLookupByLibrary.simpleMessage("Open PDF"),
    "invoiceRefreshButton": MessageLookupByLibrary.simpleMessage("Refresh"),
    "invoiceRefreshTooltip": MessageLookupByLibrary.simpleMessage(
      "Refresh invoices",
    ),
    "invoiceServiceRequestLabel": MessageLookupByLibrary.simpleMessage(
      "Service request",
    ),
    "invoiceTotalLabel": MessageLookupByLibrary.simpleMessage("Total"),
    "invoiceValueUnavailable": MessageLookupByLibrary.simpleMessage(
      "Not available",
    ),
    "invoicesEmptyDescription": MessageLookupByLibrary.simpleMessage(
      "Your completed invoices will appear here. Pull to refresh or check again later.",
    ),
    "invoicesEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "No invoices yet",
    ),
    "invoicesMenuDescription": MessageLookupByLibrary.simpleMessage(
      "View and download your invoices",
    ),
    "invoicesSignInMessage": MessageLookupByLibrary.simpleMessage(
      "Please sign in to view your invoices.",
    ),
    "invoicesTitle": MessageLookupByLibrary.simpleMessage("Invoices"),
    "itemsCountLabel": m13,
    "jobCardCompletedSuccessfullyMessage": MessageLookupByLibrary.simpleMessage(
      "Job card completed successfully.",
    ),
    "jobCardCreatedMessage": m14,
    "jobCardNumberLabel": m15,
    "jobCardNumberMissingMessage": MessageLookupByLibrary.simpleMessage(
      "Job card number is missing.",
    ),
    "jobCardNumberUnavailableMessage": MessageLookupByLibrary.simpleMessage(
      "Job card number unavailable.",
    ),
    "jobCardOpenLoadingPackagesMessage": MessageLookupByLibrary.simpleMessage(
      "Job card is open, loading package details...",
    ),
    "jobCardPackagesTitle": MessageLookupByLibrary.simpleMessage(
      "Job card packages",
    ),
    "jobCardTitle": m16,
    "languageArabic": MessageLookupByLibrary.simpleMessage("العربية"),
    "languageEnglish": MessageLookupByLibrary.simpleMessage("English"),
    "lastName": MessageLookupByLibrary.simpleMessage("Last Name"),
    "lastNameHint": MessageLookupByLibrary.simpleMessage("Enter last name"),
    "legendCleanLabel": MessageLookupByLibrary.simpleMessage("C - Clean"),
    "legendInspectLabel": MessageLookupByLibrary.simpleMessage("I - Inspect"),
    "legendNotApplicableLabel": MessageLookupByLibrary.simpleMessage(
      "X - Not applicable",
    ),
    "legendReplaceLabel": MessageLookupByLibrary.simpleMessage("R - Replace"),
    "legendTitle": MessageLookupByLibrary.simpleMessage("Legend"),
    "lineIdChipLabel": m17,
    "lineIdentifierUnavailableMessage": MessageLookupByLibrary.simpleMessage(
      "Line identifier unavailable for this item.",
    ),
    "lineNumberFallbackLabel": m18,
    "linePriceLabel": MessageLookupByLibrary.simpleMessage("Line price"),
    "loadingBookingStatusesMessage": MessageLookupByLibrary.simpleMessage(
      "Loading booking statuses...",
    ),
    "loadingEllipsis": MessageLookupByLibrary.simpleMessage("Loading..."),
    "logInToContinue": MessageLookupByLibrary.simpleMessage(
      "Log in to continue",
    ),
    "login": MessageLookupByLibrary.simpleMessage("login"),
    "loginWelcomeMessage": MessageLookupByLibrary.simpleMessage(
      "welcome back, Loging Motorlube",
    ),
    "logout": MessageLookupByLibrary.simpleMessage("Logout"),
    "mailUsAt": MessageLookupByLibrary.simpleMessage("Mail us at"),
    "maintenanceNav": MessageLookupByLibrary.simpleMessage("Maintenance"),
    "maintenancePackageDefaultLabel": MessageLookupByLibrary.simpleMessage(
      "Maintenance package",
    ),
    "majorServices": MessageLookupByLibrary.simpleMessage("Major Services"),
    "manageButtonLabel": MessageLookupByLibrary.simpleMessage("Manage"),
    "managePackagesButtonLabel": MessageLookupByLibrary.simpleMessage(
      "Manage packages",
    ),
    "managerHomeCouponsDescription": MessageLookupByLibrary.simpleMessage(
      "Create discount coupons",
    ),
    "managerHomeCouponsTitle": MessageLookupByLibrary.simpleMessage("Coupons"),
    "managerHomeCreatePromotionDescription":
        MessageLookupByLibrary.simpleMessage("Add a new promotion"),
    "managerHomeCreatePromotionTitle": MessageLookupByLibrary.simpleMessage(
      "Create Promotion",
    ),
    "managerHomePromotionsDescription": MessageLookupByLibrary.simpleMessage(
      "Promotion control panel",
    ),
    "managerHomePromotionsTitle": MessageLookupByLibrary.simpleMessage(
      "Promotions",
    ),
    "managerHomeRatingsDescription": MessageLookupByLibrary.simpleMessage(
      "View customer ratings",
    ),
    "managerHomeRatingsTitle": MessageLookupByLibrary.simpleMessage("Ratings"),
    "managerHomeRouteUnavailable": m19,
    "managerHomeTitle": MessageLookupByLibrary.simpleMessage("Manager"),
    "managerUserLabel": MessageLookupByLibrary.simpleMessage("Manager user"),
    "manufacturer": MessageLookupByLibrary.simpleMessage("Manufacturer"),
    "missingFirebaseIdForTechnicianMessage":
        MessageLookupByLibrary.simpleMessage(
          "Missing FireBaseId for technician.",
        ),
    "missingPaymentUrlMessage": MessageLookupByLibrary.simpleMessage(
      "Missing payment URL. Please try again later.",
    ),
    "mobileServices": MessageLookupByLibrary.simpleMessage("Mobile Services"),
    "model": MessageLookupByLibrary.simpleMessage("Model"),
    "more": MessageLookupByLibrary.simpleMessage("More"),
    "moreAppbar": MessageLookupByLibrary.simpleMessage("More"),
    "moreDocumentsSectionTitle": MessageLookupByLibrary.simpleMessage(
      "Documents",
    ),
    "moreLanguageDescription": MessageLookupByLibrary.simpleMessage(
      "Switch the app display language",
    ),
    "moreNav": MessageLookupByLibrary.simpleMessage("More"),
    "morePreferencesSectionTitle": MessageLookupByLibrary.simpleMessage(
      "Preferences",
    ),
    "myCarsNav": MessageLookupByLibrary.simpleMessage("My Cars"),
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "newBookingsWillAppearMessage": MessageLookupByLibrary.simpleMessage(
      "New bookings that require approval will appear here automatically.",
    ),
    "next": MessageLookupByLibrary.simpleMessage("next"),
    "no": MessageLookupByLibrary.simpleMessage("No"),
    "noBookingStatusesAvailableMessage": MessageLookupByLibrary.simpleMessage(
      "No booking statuses available.",
    ),
    "noBookingsNeedApproval": MessageLookupByLibrary.simpleMessage(
      "No bookings need approval right now.",
    ),
    "noButtonLabel": MessageLookupByLibrary.simpleMessage("No"),
    "noCarsFound": MessageLookupByLibrary.simpleMessage("No cars found"),
    "noCategoriesAvailableMessage": MessageLookupByLibrary.simpleMessage(
      "No categories available.",
    ),
    "noChecklistFound": MessageLookupByLibrary.simpleMessage(
      "No checklist found.",
    ),
    "noCouponsAvailable": MessageLookupByLibrary.simpleMessage(
      "No coupons available.",
    ),
    "noInternetConnection": MessageLookupByLibrary.simpleMessage(
      "No Internet Connection",
    ),
    "noItemsForCategoryMessage": MessageLookupByLibrary.simpleMessage(
      "No items available for the selected category.",
    ),
    "noLineItemsFoundMessage": MessageLookupByLibrary.simpleMessage(
      "No line items found for this package.",
    ),
    "noMaintenanceRequestsYet": MessageLookupByLibrary.simpleMessage(
      "No maintenance requests yet.",
    ),
    "noPackagesFoundForJobCardMessage": MessageLookupByLibrary.simpleMessage(
      "No packages found for this job card.",
    ),
    "noPromotionsFound": MessageLookupByLibrary.simpleMessage(
      "No promotions found.",
    ),
    "noServicesAvailable": MessageLookupByLibrary.simpleMessage(
      "No services available right now.",
    ),
    "noStatusesAvailableMessage": MessageLookupByLibrary.simpleMessage(
      "No statuses available.",
    ),
    "noStatusesLabel": MessageLookupByLibrary.simpleMessage("No statuses"),
    "notApplicableAbbreviation": MessageLookupByLibrary.simpleMessage("N/A"),
    "notAssignedLabel": MessageLookupByLibrary.simpleMessage("Not assigned"),
    "notValidUserEmail": MessageLookupByLibrary.simpleMessage(
      "User email is not valid",
    ),
    "oiling": MessageLookupByLibrary.simpleMessage("Oiling"),
    "ok": MessageLookupByLibrary.simpleMessage("OK"),
    "okButtonLabel": MessageLookupByLibrary.simpleMessage("OK"),
    "onBoardingDescription1": MessageLookupByLibrary.simpleMessage(
      "Skip the hassle of workshop visits! Our expert mobile auto service brings professional maintenance & repairs right to your location.",
    ),
    "onBoardingDescription2": MessageLookupByLibrary.simpleMessage(
      "We use the latest and best solutions to advance the field of car service to provide a unique experience that has never been experienced before.",
    ),
    "onBoardingDescription3": MessageLookupByLibrary.simpleMessage(
      "What’s guarding your vehicle’s undercarriage? At Motor Lube, we don’t just protect – we armor your car with Revive Premium Wax-Based Undercoat Treatment.",
    ),
    "onBoardingTitle1": MessageLookupByLibrary.simpleMessage(
      "Mobile Car Service",
    ),
    "onBoardingTitle2": MessageLookupByLibrary.simpleMessage(
      "Emergency Service",
    ),
    "onBoardingTitle3": MessageLookupByLibrary.simpleMessage(
      "Following Dealer Standards",
    ),
    "openJobCardToViewPackagesMessage": MessageLookupByLibrary.simpleMessage(
      "Open a job card to view its associated packages.",
    ),
    "ourServices": MessageLookupByLibrary.simpleMessage("Our Services"),
    "packageCodeFallbackLabel": m20,
    "packageCodeLabel": m21,
    "packageItemsTitle": MessageLookupByLibrary.simpleMessage("Package items"),
    "packageLineIdUnavailableMessage": MessageLookupByLibrary.simpleMessage(
      "Package line ID is unavailable.",
    ),
    "packageLineUnavailableLabel": MessageLookupByLibrary.simpleMessage(
      "Package line is unavailable",
    ),
    "packageNoLineIdMessage": MessageLookupByLibrary.simpleMessage(
      "This package does not expose a line ID. Unable to add items.",
    ),
    "packagesAppliedTitle": MessageLookupByLibrary.simpleMessage(
      "Packages applied",
    ),
    "payNowButtonLabel": MessageLookupByLibrary.simpleMessage("Pay Now"),
    "paymentCompletedMessage": MessageLookupByLibrary.simpleMessage(
      "Your payment has been completed successfully.",
    ),
    "paymentFailedTitle": MessageLookupByLibrary.simpleMessage(
      "Payment Failed",
    ),
    "paymentNotCompletedMessage": MessageLookupByLibrary.simpleMessage(
      "The payment was not completed. Please try again.",
    ),
    "paymentSuccessfulTitle": MessageLookupByLibrary.simpleMessage(
      "Payment Successful",
    ),
    "phoneNumber": MessageLookupByLibrary.simpleMessage("Phone Number"),
    "phoneNumberHint": MessageLookupByLibrary.simpleMessage("5XXXXXXXX"),
    "pickDateButtonLabel": MessageLookupByLibrary.simpleMessage("Pick"),
    "pickDateRangeInstruction": MessageLookupByLibrary.simpleMessage(
      "Pick a date range and apply to refresh.",
    ),
    "planYourDay": MessageLookupByLibrary.simpleMessage("Plan your day"),
    "plate": MessageLookupByLibrary.simpleMessage("Plate"),
    "plateFieldLabel": MessageLookupByLibrary.simpleMessage("Plate"),
    "plateLetters": MessageLookupByLibrary.simpleMessage("Plate Letters"),
    "plateNumbers": MessageLookupByLibrary.simpleMessage("Plate Numbers"),
    "plateUnavailableLabel": MessageLookupByLibrary.simpleMessage(
      "Plate unavailable",
    ),
    "pleaseLogInToViewYourProfile": MessageLookupByLibrary.simpleMessage(
      "Please log in to view your profile",
    ),
    "pleaseSelectCategoryMessage": MessageLookupByLibrary.simpleMessage(
      "Please select a category.",
    ),
    "pleaseSelectDateRange": MessageLookupByLibrary.simpleMessage(
      "Please select date range",
    ),
    "pleaseSelectItemToAddMessage": MessageLookupByLibrary.simpleMessage(
      "Please select an item to add.",
    ),
    "pricePrefixedIncludedLabel": MessageLookupByLibrary.simpleMessage(
      "Price: Included",
    ),
    "pricePrefixedLabel": m22,
    "profileAppbar": MessageLookupByLibrary.simpleMessage("Profile"),
    "profileNav": MessageLookupByLibrary.simpleMessage("Profile"),
    "profilePhotoRequired": MessageLookupByLibrary.simpleMessage(
      "Please select a profile photo.",
    ),
    "profilePhotoSelectionFailed": MessageLookupByLibrary.simpleMessage(
      "Unable to select this photo. Please try again.",
    ),
    "profileUpdateFailed": MessageLookupByLibrary.simpleMessage(
      "Unable to update your profile. Please try again.",
    ),
    "profileUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Profile updated successfully.",
    ),
    "promotionDescription": MessageLookupByLibrary.simpleMessage(
      "Promotion Description",
    ),
    "promotionName": MessageLookupByLibrary.simpleMessage("Promotion Name"),
    "promotionSavedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Promotion saved successfully",
    ),
    "promotionTitle": MessageLookupByLibrary.simpleMessage("promotion"),
    "promotionsLoadErrorFallback": MessageLookupByLibrary.simpleMessage(
      "Failed to load promotions",
    ),
    "promotionsTitle": MessageLookupByLibrary.simpleMessage("Promotions"),
    "quantityLabel": MessageLookupByLibrary.simpleMessage("Quantity"),
    "quantityMustBeGreaterThanZeroMessage":
        MessageLookupByLibrary.simpleMessage(
          "Quantity must be greater than zero.",
        ),
    "quantityValueLabel": m23,
    "refreshCategoriesTooltip": MessageLookupByLibrary.simpleMessage(
      "Refresh categories",
    ),
    "refreshPackagesTooltip": MessageLookupByLibrary.simpleMessage(
      "Refresh packages",
    ),
    "refreshTooltip": MessageLookupByLibrary.simpleMessage("Refresh"),
    "register": MessageLookupByLibrary.simpleMessage("Register"),
    "removeButtonLabel": MessageLookupByLibrary.simpleMessage("Remove"),
    "removeItemTitle": MessageLookupByLibrary.simpleMessage("Remove item"),
    "removePackageConfirmation": m24,
    "removePackageTitle": MessageLookupByLibrary.simpleMessage(
      "Remove package",
    ),
    "requiredFieldError": MessageLookupByLibrary.simpleMessage("Required"),
    "resendOTP": MessageLookupByLibrary.simpleMessage("Resend OTP"),
    "resetButtonLabel": MessageLookupByLibrary.simpleMessage("Reset"),
    "resolvingPackageLineIdMessage": MessageLookupByLibrary.simpleMessage(
      "Resolving package line ID...",
    ),
    "retryButtonLabel": MessageLookupByLibrary.simpleMessage("Retry"),
    "saveChanges": MessageLookupByLibrary.simpleMessage("Save changes"),
    "saveChecklistButtonLabel": MessageLookupByLibrary.simpleMessage(
      "Save checklist",
    ),
    "savePromotion": MessageLookupByLibrary.simpleMessage("Save Promotion"),
    "savingEllipsis": MessageLookupByLibrary.simpleMessage("Saving..."),
    "scheduleFieldLabel": MessageLookupByLibrary.simpleMessage("Schedule"),
    "scheduleNotSetLabel": MessageLookupByLibrary.simpleMessage(
      "Schedule not set",
    ),
    "scheduledStatusLabel": MessageLookupByLibrary.simpleMessage("Scheduled"),
    "selectCategoryToLoadItemsMessage": MessageLookupByLibrary.simpleMessage(
      "Select a category to load items.",
    ),
    "selectEndDate": MessageLookupByLibrary.simpleMessage("Select End Date"),
    "selectEndDateLabel": MessageLookupByLibrary.simpleMessage(
      "Select end date",
    ),
    "selectManufacturer": MessageLookupByLibrary.simpleMessage(
      "Select Manufacturer",
    ),
    "selectModel": MessageLookupByLibrary.simpleMessage("Select Model"),
    "selectPackageLabel": MessageLookupByLibrary.simpleMessage(
      "Select package",
    ),
    "selectStartDate": MessageLookupByLibrary.simpleMessage(
      "Select Start Date",
    ),
    "selectStartDateLabel": MessageLookupByLibrary.simpleMessage(
      "Select start date",
    ),
    "selectYear": MessageLookupByLibrary.simpleMessage("Select Year"),
    "serviceRequestCreatedMessage": MessageLookupByLibrary.simpleMessage(
      "Service request created.",
    ),
    "showingBookingsNeedingApproval": MessageLookupByLibrary.simpleMessage(
      "Showing bookings that need approval",
    ),
    "signInAsCreditManagerMessage": MessageLookupByLibrary.simpleMessage(
      "Please sign in as a credit manager to view bookings that need approval.",
    ),
    "signInAsTechnicianMessage": MessageLookupByLibrary.simpleMessage(
      "Please sign in as a technician to view assigned maintenance requests.",
    ),
    "signInRequiredTitle": MessageLookupByLibrary.simpleMessage(
      "Sign in required",
    ),
    "skip": MessageLookupByLibrary.simpleMessage("Skip"),
    "somethingWentWrong": MessageLookupByLibrary.simpleMessage(
      "Something went wrong.",
    ),
    "srLineIdLabel": m25,
    "standardTagLabel": MessageLookupByLibrary.simpleMessage("Standard"),
    "start": MessageLookupByLibrary.simpleMessage("start"),
    "startDate": MessageLookupByLibrary.simpleMessage("Start Date"),
    "statusCodeLabel": m26,
    "statusIdLabel": m27,
    "statusLabel": MessageLookupByLibrary.simpleMessage("Status"),
    "statusUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Status updated successfully.",
    ),
    "statusesSelectedCount": m28,
    "submit": MessageLookupByLibrary.simpleMessage("Submit"),
    "tapFilterToRefineJobs": MessageLookupByLibrary.simpleMessage(
      "Tap a filter to refine assigned jobs.",
    ),
    "technicianAppError": MessageLookupByLibrary.simpleMessage(
      "Technician users should use the MotorLube Technician app.",
    ),
    "technicianFieldLabel": MessageLookupByLibrary.simpleMessage("Technician"),
    "toDateLabel": MessageLookupByLibrary.simpleMessage("To"),
    "totalPriceLabel": MessageLookupByLibrary.simpleMessage("Total price"),
    "towiling": MessageLookupByLibrary.simpleMessage("Towiling"),
    "unableToDetermineTechnicianIdMessage":
        MessageLookupByLibrary.simpleMessage(
          "Unable to determine technician identifier.",
        ),
    "unableToInitiatePayment": MessageLookupByLibrary.simpleMessage(
      "Unable to initiate payment.",
    ),
    "unableToLoadBookings": MessageLookupByLibrary.simpleMessage(
      "Unable to load bookings",
    ),
    "unableToLoadRequests": MessageLookupByLibrary.simpleMessage(
      "Unable to load requests",
    ),
    "unableToLoadServices": MessageLookupByLibrary.simpleMessage(
      "Unable to load services",
    ),
    "unableToResolvePackageLineIdMessage": MessageLookupByLibrary.simpleMessage(
      "Unable to resolve package line ID.",
    ),
    "unavailableLabel": MessageLookupByLibrary.simpleMessage("Unavailable"),
    "upcomingService": MessageLookupByLibrary.simpleMessage("Upcoming Service"),
    "upcomingServicesAssignedTechnicianLabel":
        MessageLookupByLibrary.simpleMessage("Assigned Technician"),
    "upcomingServicesBookingDetailsTitle": MessageLookupByLibrary.simpleMessage(
      "Booking Details",
    ),
    "upcomingServicesConnectionTimedOut": MessageLookupByLibrary.simpleMessage(
      "Connection timed out. Please try again.",
    ),
    "upcomingServicesDateFallback": MessageLookupByLibrary.simpleMessage(
      "Date to be confirmed",
    ),
    "upcomingServicesEmptyMessage": MessageLookupByLibrary.simpleMessage(
      "No upcoming services scheduled.",
    ),
    "upcomingServicesErrorPrefix": MessageLookupByLibrary.simpleMessage(
      "Unable to load upcoming services.",
    ),
    "upcomingServicesFilterAnyDate": MessageLookupByLibrary.simpleMessage(
      "Any date",
    ),
    "upcomingServicesFilterAnyStatus": MessageLookupByLibrary.simpleMessage(
      "Any status",
    ),
    "upcomingServicesFilterApply": MessageLookupByLibrary.simpleMessage(
      "Apply filters",
    ),
    "upcomingServicesFilterFrom": MessageLookupByLibrary.simpleMessage("From"),
    "upcomingServicesFilterLoadingStatuses":
        MessageLookupByLibrary.simpleMessage("Loading booking statuses..."),
    "upcomingServicesFilterNoStatuses": MessageLookupByLibrary.simpleMessage(
      "No statuses available.",
    ),
    "upcomingServicesFilterStatus": MessageLookupByLibrary.simpleMessage(
      "Status",
    ),
    "upcomingServicesFilterSubtitle": MessageLookupByLibrary.simpleMessage(
      "Tap a filter to refine your appointments.",
    ),
    "upcomingServicesFilterTitle": MessageLookupByLibrary.simpleMessage(
      "Plan your day",
    ),
    "upcomingServicesFilterTo": MessageLookupByLibrary.simpleMessage("To"),
    "upcomingServicesLoadingDate": MessageLookupByLibrary.simpleMessage(
      "00 Mon 0000",
    ),
    "upcomingServicesLoadingLocation": MessageLookupByLibrary.simpleMessage(
      "Loading location",
    ),
    "upcomingServicesLoadingPackage": MessageLookupByLibrary.simpleMessage(
      "Loading package title",
    ),
    "upcomingServicesLoadingPlate": MessageLookupByLibrary.simpleMessage(
      "0000 AAA",
    ),
    "upcomingServicesLoadingStatus": MessageLookupByLibrary.simpleMessage(
      "Loading",
    ),
    "upcomingServicesLoadingTechnician": MessageLookupByLibrary.simpleMessage(
      "Loading technician",
    ),
    "upcomingServicesLoadingTime": MessageLookupByLibrary.simpleMessage(
      "00:00 AM",
    ),
    "upcomingServicesLoadingVehicle": MessageLookupByLibrary.simpleMessage(
      "Loading vehicle",
    ),
    "upcomingServicesLocationFallback": MessageLookupByLibrary.simpleMessage(
      "Location to be confirmed",
    ),
    "upcomingServicesLoginPrompt": MessageLookupByLibrary.simpleMessage(
      "Log in to view your upcoming services.",
    ),
    "upcomingServicesPlateFallback": MessageLookupByLibrary.simpleMessage(
      "Plate unavailable",
    ),
    "upcomingServicesServiceLocationLabel":
        MessageLookupByLibrary.simpleMessage("Service Location"),
    "upcomingServicesServicePackageLabel": MessageLookupByLibrary.simpleMessage(
      "Service Package",
    ),
    "upcomingServicesServicePlaceholder": MessageLookupByLibrary.simpleMessage(
      "Service",
    ),
    "upcomingServicesStatusAccepted": MessageLookupByLibrary.simpleMessage(
      "Accepted",
    ),
    "upcomingServicesStatusArrived": MessageLookupByLibrary.simpleMessage(
      "Arrived",
    ),
    "upcomingServicesStatusCancelled": MessageLookupByLibrary.simpleMessage(
      "Cancelled",
    ),
    "upcomingServicesStatusCompleted": MessageLookupByLibrary.simpleMessage(
      "Completed",
    ),
    "upcomingServicesStatusEnRoute": MessageLookupByLibrary.simpleMessage(
      "En Route",
    ),
    "upcomingServicesStatusExpired": MessageLookupByLibrary.simpleMessage(
      "Expired",
    ),
    "upcomingServicesStatusFallback": m29,
    "upcomingServicesStatusNeedsApproval": MessageLookupByLibrary.simpleMessage(
      "Needs Approval",
    ),
    "upcomingServicesStatusNew": MessageLookupByLibrary.simpleMessage("New"),
    "upcomingServicesStatusOpen": MessageLookupByLibrary.simpleMessage("Open"),
    "upcomingServicesStatusPaid": MessageLookupByLibrary.simpleMessage("Paid"),
    "upcomingServicesStatusPending": MessageLookupByLibrary.simpleMessage(
      "Pending",
    ),
    "upcomingServicesStatusRejected": MessageLookupByLibrary.simpleMessage(
      "Rejected",
    ),
    "upcomingServicesStatusUpcoming": MessageLookupByLibrary.simpleMessage(
      "Upcoming",
    ),
    "upcomingServicesTechnicianFallback": MessageLookupByLibrary.simpleMessage(
      "Technician to be assigned",
    ),
    "upcomingServicesVehiclePlaceholder": MessageLookupByLibrary.simpleMessage(
      "Vehicle",
    ),
    "upcomingServicesViewButton": MessageLookupByLibrary.simpleMessage(
      "Log in",
    ),
    "userCarsAddCrnImage": MessageLookupByLibrary.simpleMessage(
      "Add CRN image",
    ),
    "userCarsAddImageRequirement": MessageLookupByLibrary.simpleMessage(
      "Please add at least one image.",
    ),
    "userCarsAddPhotos": MessageLookupByLibrary.simpleMessage("Add Photos"),
    "userCarsAddedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Car added successfully",
    ),
    "userCarsBookNow": MessageLookupByLibrary.simpleMessage("Book Now"),
    "userCarsCarDetailsTitle": MessageLookupByLibrary.simpleMessage(
      "Car details",
    ),
    "userCarsCarModelLabel": MessageLookupByLibrary.simpleMessage("Car model"),
    "userCarsCarName": MessageLookupByLibrary.simpleMessage("Car name"),
    "userCarsCardSemantics": m30,
    "userCarsChassis": MessageLookupByLibrary.simpleMessage("Chassis"),
    "userCarsChassisVin": MessageLookupByLibrary.simpleMessage("Chassis (VIN)"),
    "userCarsChooseFromGallery": MessageLookupByLibrary.simpleMessage(
      "Choose from gallery (multiple)",
    ),
    "userCarsCompletePlateFields": MessageLookupByLibrary.simpleMessage(
      "Please complete plate fields",
    ),
    "userCarsCopiedToClipboard": MessageLookupByLibrary.simpleMessage(
      "Copied to clipboard",
    ),
    "userCarsCopy": MessageLookupByLibrary.simpleMessage("Copy"),
    "userCarsDeleteCar": MessageLookupByLibrary.simpleMessage("Delete car"),
    "userCarsEditInfo": MessageLookupByLibrary.simpleMessage("Edit info"),
    "userCarsEmptyDescription": MessageLookupByLibrary.simpleMessage(
      "We couldn’t find any cars matching your search .",
    ),
    "userCarsErrorLoadingManufacturers": MessageLookupByLibrary.simpleMessage(
      "Error loading manufacturers",
    ),
    "userCarsErrorLoadingModels": MessageLookupByLibrary.simpleMessage(
      "Error loading car models",
    ),
    "userCarsImagesSectionTitle": MessageLookupByLibrary.simpleMessage(
      "Car Images",
    ),
    "userCarsInvalidPlateLetter": MessageLookupByLibrary.simpleMessage(
      "Invalid plate letter",
    ),
    "userCarsInvalidPlateNumber": MessageLookupByLibrary.simpleMessage(
      "Invalid plate number",
    ),
    "userCarsLicensePlateSemantics": m31,
    "userCarsSaveVehicle": MessageLookupByLibrary.simpleMessage("Save Vehicle"),
    "userCarsSaving": MessageLookupByLibrary.simpleMessage("Saving..."),
    "userCarsTakePhoto": MessageLookupByLibrary.simpleMessage("Take a photo"),
    "userCarsYearOfManufacture": MessageLookupByLibrary.simpleMessage(
      "Year of manufacture",
    ),
    "userEmail": MessageLookupByLibrary.simpleMessage("User Email"),
    "userEmailHint": MessageLookupByLibrary.simpleMessage("Enter user email"),
    "userIdentifierMissingMessage": MessageLookupByLibrary.simpleMessage(
      "User identifier is missing.",
    ),
    "userName": MessageLookupByLibrary.simpleMessage("User Name"),
    "userNameHint": MessageLookupByLibrary.simpleMessage("Enter user name"),
    "vehicleChecklistTitle": MessageLookupByLibrary.simpleMessage(
      "Vehicle checklist",
    ),
    "vehicleFieldLabel": MessageLookupByLibrary.simpleMessage("Vehicle"),
    "vehicleNotSetLabel": MessageLookupByLibrary.simpleMessage(
      "Vehicle not set",
    ),
    "verify": MessageLookupByLibrary.simpleMessage("Verify"),
    "vin": MessageLookupByLibrary.simpleMessage("VIN"),
    "vinFieldLabel": MessageLookupByLibrary.simpleMessage("VIN"),
    "waitForCurrentActionMessage": MessageLookupByLibrary.simpleMessage(
      "Please wait for the current action to complete.",
    ),
    "waitForCurrentDeleteActionMessage": MessageLookupByLibrary.simpleMessage(
      "Please wait for the current delete action to finish.",
    ),
    "year": MessageLookupByLibrary.simpleMessage("Year"),
    "yes": MessageLookupByLibrary.simpleMessage("Yes"),
    "yesCancelButtonLabel": MessageLookupByLibrary.simpleMessage("Yes, cancel"),
    "yourCars": MessageLookupByLibrary.simpleMessage("Your Cars"),
  };
}
