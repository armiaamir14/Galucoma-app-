import 'package:glaucoma/models/user.dart';

enum AuthenticationServiceException {
  invalidAccessToken,
  invalidEmail,
  invalidPassword,
  invalidCredentials,
  invalidToken,
  failedToSendEmailVerificationMessage,
  failedToVerifyEmail,
  emailAlreadyVerified,
  tooManyRequest,
  invalidFirstName,
  invalidLastName,
  emailAlreadyInUse,
  failedToLogout,
  unknownError,
}

abstract class AuthenticationService {
  Future<String> getCurrentUserAuthToken();
  Future<User> getCurrentUser();
  Future login(String email, String password);
  Future register( String firstName, String lastName,String email, String password);
  Future logout();
}
