import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glaucoma/core/constants/colors.dart';
import 'package:glaucoma/pages/auth/auth_page_controller.dart';
import 'package:glaucoma/pages/auth/widgets/authentication_button.dart';
import 'package:glaucoma/pages/auth/widgets/authentication_text_field.dart';
import 'package:glaucoma/pages/auth/widgets/authentication_text_field_label.dart';

class RegisterForm extends GetView<AuthPageController> {
  static const SizedBox _spacingBox = const SizedBox(height: 20);
  static const TextStyle _bottomTextStyle = const TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w700);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: Text('Register', textAlign: TextAlign.center, style: const TextStyle(color: textColor, fontSize: 30, fontWeight: FontWeight.w700))),
        const SizedBox(height: 40),
        AuthenticationTextFieldLabel('Full Name'),
        _spacingBox,
        Row(
          children: [
            Expanded(flex: 1, child: AuthenticationTextField(controller: controller.registerFirstNameController, hint: 'First name', icon: Icons.person)),
            SizedBox(width: 15),
            Expanded(flex: 1, child: AuthenticationTextField(controller: controller.registerLastNameController, hint: 'Last name', icon: Icons.person)),
          ],
        ),
        _spacingBox,
        AuthenticationTextFieldLabel('Email'),
        _spacingBox,
        AuthenticationTextField(controller: controller.registerEmailController, hint: 'Enter your email...', icon: Icons.mail),
        _spacingBox,
        AuthenticationTextFieldLabel('Password'),
        _spacingBox,
        AuthenticationTextField(controller: controller.registerPasswordController, hint: 'Enter your password...', icon: Icons.lock, isPassword: true),
        _spacingBox,
        AuthenticationTextFieldLabel('Confirm Password'),
        _spacingBox,
        AuthenticationTextField(controller: controller.registerConfirmPasswordController, hint: 'Enter your password again...', icon: Icons.lock, isPassword: true),
        const SizedBox(height: 30),
        AuthenticationButton(title: 'Register', loadingState: AuthPageState.registering, action: controller.register),
        _spacingBox,
        RichText(
          text: TextSpan(
            style: _bottomTextStyle,
            text: 'Have an account? ',
            children: <TextSpan>[
              TextSpan(
                text: 'Login!',
                style: _bottomTextStyle.copyWith(color: highlight1Color),
                recognizer: TapGestureRecognizer()..onTap = controller.switchToLoginForm,
              )
            ],
          ),
        ),
      ],
    );
  }
}
