import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glaucoma/core/constants/routes.dart';
import 'package:glaucoma/core/services/authentication_service.dart';
import 'package:glaucoma/core/utils/functions.dart';

enum AuthPageState { normal, registering, logining, error }
enum AuthPageMode { register, login }
enum AuthVerificationException { passwordAndConfirmationDoNotMatch }

class AuthPageController extends GetxController {
  Rx<AuthPageState> state;
  Rx<AuthPageMode> mode;

  TextEditingController loginEmailController,
      loginPasswordController,
      registerEmailController,
      registerPasswordController,
      registerConfirmPasswordController,
      registerFirstNameController,
      registerLastNameController;

  @override
  void onInit() {
    state = AuthPageState.normal.obs;
    mode = AuthPageMode.login.obs;
    loginEmailController = TextEditingController();
    loginPasswordController = TextEditingController();
    registerEmailController = TextEditingController();
    registerPasswordController = TextEditingController();
    registerConfirmPasswordController = TextEditingController();
    registerFirstNameController = TextEditingController();
    registerLastNameController = TextEditingController();
    super.onInit();
  }

  void switchToRegisterForm() {
    mode.value = AuthPageMode.register;
  }

  void switchToLoginForm() {
    mode.value = AuthPageMode.login;
  }

  void login() async {
    if (mode.value == AuthPageMode.login && state.value == AuthPageState.normal) {
      state.value = AuthPageState.logining;
      try {
        final AuthenticationService authenticationService = Get.find<AuthenticationService>();
        final String email = loginEmailController.text.trim();
        final String password = loginPasswordController.text.trim();
        if (!email.isEmail) throw AuthenticationServiceException.invalidEmail;
        if(password.isEmpty)throw AuthenticationServiceException.invalidPassword;
        await authenticationService.login(email, password);
        AppFunctions.showSnackBar('Successfully logged in!');
        Get.offAllNamed(AppRoutes.home);
      } catch (e) {
        final error = e is AuthenticationServiceException ? e : AuthenticationServiceException.unknownError;
        _handleAuthenticationExceptions(error);
      }
      state.value = AuthPageState.normal;
    }
  }

  void register() async {
    if (mode.value == AuthPageMode.register && state.value == AuthPageState.normal) {
      state.value = AuthPageState.registering;
      try {
        final AuthenticationService authenticationService = Get.find<AuthenticationService>();
        final String firstName = registerFirstNameController.text.trim();
        final String lastName = registerLastNameController.text.trim();
        final String email = registerEmailController.text.trim();
        final String password = registerPasswordController.text.trim();
        final String passwordConfirmation = registerConfirmPasswordController.text.trim();
        if(firstName.isEmpty)throw AuthenticationServiceException.invalidFirstName;
        if(lastName.isEmpty)throw AuthenticationServiceException.invalidLastName;
        if (!email.isEmail) throw AuthenticationServiceException.invalidEmail;
        if(password.isEmpty)throw AuthenticationServiceException.invalidPassword;
        if (password != passwordConfirmation) throw AuthVerificationException.passwordAndConfirmationDoNotMatch;
        await authenticationService.register(firstName,lastName,email, password);
        AppFunctions.showSnackBar('Account was registered successfully! You can use it to login now.');
      } catch (e) {
        if (e is AuthenticationServiceException) {
          _handleAuthenticationExceptions(e);
        } else {
          if (e == AuthVerificationException.passwordAndConfirmationDoNotMatch) {
            AppFunctions.showSnackBar('Password and its confirmation don\'t match.', isError: true);
          } else {
            _handleAuthenticationExceptions(AuthenticationServiceException.unknownError);
          }
        }
      }
      state.value = AuthPageState.normal;
    }
  }

  void _handleAuthenticationExceptions(AuthenticationServiceException exception) {
    String message = '';
    if (exception == AuthenticationServiceException.emailAlreadyVerified) {
      message = 'This email have been verified already';
    } else if (exception == AuthenticationServiceException.invalidCredentials) {
      message = 'Please, check your credientials and try again';
    } else if (exception == AuthenticationServiceException.invalidEmail) {
      message = 'Enter email!';
    }else if (exception == AuthenticationServiceException.invalidFirstName) {
      message = 'Enter First Name!';
    }else if (exception == AuthenticationServiceException.invalidLastName) {
      message = 'Enter Last Name!';
    }
    else if (exception == AuthenticationServiceException.invalidPassword) {
      message = 'Enter password!';
    } else if (exception == AuthenticationServiceException.failedToSendEmailVerificationMessage) {
      message = 'Failed to send email verification message!';
    } else if (exception == AuthenticationServiceException.invalidPassword) {
      message = 'Invalid password!';
    } else if (exception == AuthenticationServiceException.failedToVerifyEmail) {
      message = 'Failed to verify the email!';
    } else if (exception == AuthenticationServiceException.emailAlreadyInUse) {
      message = 'Email already in use! Please, choose another one.';
    } else {
      message = 'Please, Enter Your Information ';
    }
    AppFunctions.showSnackBar(message, isError: true);
  }

  @override
  void onClose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    registerEmailController.dispose();
    registerPasswordController.dispose();
    registerConfirmPasswordController.dispose();
    registerFirstNameController.dispose();
    registerLastNameController.dispose();
    super.onClose();
  }
}
