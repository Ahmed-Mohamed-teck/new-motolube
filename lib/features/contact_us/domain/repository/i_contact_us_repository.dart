abstract class IContactUsRepository {
  /// Sends a contact us message to the server.
  ///
  /// Returns a boolean indicating whether the message was sent successfully.
  Future<bool> sendContactUsMessage({
    required String name,
    required String email,
    required String phoneNumber,
    required String message,
  });
}