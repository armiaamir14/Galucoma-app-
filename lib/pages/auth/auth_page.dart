import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glaucoma/core/constants/colors.dart';
import 'package:glaucoma/pages/auth/auth_page_controller.dart';
import 'package:glaucoma/pages/auth/widgets/authentication_text_field.dart';
import 'package:glaucoma/pages/auth/widgets/login_form.dart';
import 'package:glaucoma/pages/auth/widgets/register_form.dart';

class AuthPage extends GetView<AuthPageController> {
  static const TextStyle _headerTextStyle = const TextStyle(color: textColor, fontSize: 50, fontWeight: FontWeight.w700);
  static const TextStyle _descriptionTextStyle = const TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.w400);
  static const SizedBox _spacingBox = const SizedBox(height: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Glaucoma', style: _headerTextStyle),
                _spacingBox,
                Text('Diagnose your patients with more\nconfidence & accuracy.', textAlign: TextAlign.center,
                    style: _descriptionTextStyle.copyWith(color: textColor.withOpacity(0.7))),
                const SizedBox(height: 40),
                ObxValue<Rx<AuthPageMode>>(
                  (Rx<AuthPageMode> mode) {
                    final AuthPageMode currentMode = mode.value;
                    final bool isLoginMode = currentMode == AuthPageMode.login;
                    return AnimatedSwitcher(duration: const Duration(milliseconds: 200), child: isLoginMode ? LoginForm() : RegisterForm());
                  },
                  controller.mode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
