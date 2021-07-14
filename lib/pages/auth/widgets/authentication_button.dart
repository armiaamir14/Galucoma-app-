import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glaucoma/core/constants/colors.dart';
import 'package:glaucoma/pages/auth/auth_page_controller.dart';

class AuthenticationButton extends GetView<AuthPageController> {
  static final RoundedRectangleBorder _buttonBorder = RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));

  final String title;
  final AuthPageState loadingState;
  final Function action;

  AuthenticationButton({@required this.title, @required this.loadingState, @required this.action});

  @override
  Widget build(BuildContext context) {
    return ObxValue<Rx<AuthPageState>>(
      (Rx<AuthPageState> state) {
        final AuthPageState currentState = state.value;
        final bool isLoadingState = currentState == loadingState;
        final bool isNotNormalState = currentState != AuthPageState.normal;
        final Color buttonColor = isLoadingState ? accentColor : (isNotNormalState ? accentColor : highlight1Color);
        return ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.maxFinite, minHeight: 60),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: buttonColor, shape: _buttonBorder),
            onPressed: action,
            child: isLoadingState
                ? FittedBox(child: Theme(data: ThemeData(accentColor: backgroundColor), child: CircularProgressIndicator()))
                : Text(title, style: TextStyle(fontSize: 25, color: backgroundColor, fontWeight: FontWeight.w700)),
          ),
        );
      },
      controller.state,
    );
  }
}
