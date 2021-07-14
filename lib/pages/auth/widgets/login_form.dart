import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glaucoma/core/constants/colors.dart';
import 'package:glaucoma/pages/auth/auth_page_controller.dart';
import 'package:glaucoma/pages/auth/widgets/authentication_button.dart';
import 'package:glaucoma/pages/auth/widgets/authentication_text_field.dart';
import 'package:glaucoma/pages/auth/widgets/authentication_text_field_label.dart';

class LoginForm extends GetView<AuthPageController> {
  static const SizedBox _spacingBox = const SizedBox(height: 20);
  static const TextStyle _bottomTextStyle = const TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w700);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: Text('Login', textAlign: TextAlign.center, style: const TextStyle(color: textColor, fontSize: 30, fontWeight: FontWeight.w700))),
        const SizedBox(height: 40),
        AuthenticationTextFieldLabel('Email'),
        _spacingBox,
        AuthenticationTextField(controller: controller.loginEmailController, hint: 'Enter your email...', icon: Icons.mail),
        _spacingBox,
        AuthenticationTextFieldLabel('Password'),
        _spacingBox,
        AuthenticationTextField(controller: controller.loginPasswordController, hint: 'Enter your password...', icon: Icons.lock, isPassword: true),
        const SizedBox(height: 30),
        AuthenticationButton(title: 'Login', loadingState: AuthPageState.logining, action: controller.login),
        _spacingBox,
        RichText(
          text: TextSpan(
            style: _bottomTextStyle,
            text: 'Don\'t have an account? ',
            children: <TextSpan>[
              TextSpan(
                text: 'Register!',
                style: _bottomTextStyle.copyWith(color: highlight1Color),
                recognizer: TapGestureRecognizer()..onTap = controller.switchToRegisterForm,
              )
            ],
          ),
        ),
      ],
    );
  }
}
