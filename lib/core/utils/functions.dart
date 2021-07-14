import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:glaucoma/core/bindings/initial_bindings.dart';
import 'package:glaucoma/core/constants/colors.dart';
import 'package:glaucoma/core/constants/routes.dart';
import 'package:glaucoma/core/services/authentication_service.dart';
import 'package:glaucoma/core/services/database_service.dart';
import 'package:glaucoma/services/getx_authentication_service.dart';
import 'package:glaucoma/services/getx_database_service.dart';

class AppFunctions {
  static Future<InitialBindings> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent.withOpacity(0)));
    await GetStorage.init();
    final AuthenticationService authenticationService = GetXAuthenticationService();
    final DatabaseService databaseService = GetXDatabaseService();
    final String token = await authenticationService.getCurrentUserAuthToken();
    final String initialRoute = token == null ? AppRoutes.auth : AppRoutes.home;
    final InitialBindings initialBindings = InitialBindings(authenticationService: authenticationService, databaseService: databaseService, initialRoute: initialRoute);
    return initialBindings;
  }

  static void showSnackBar(String message, {bool isError = false}) {
    Get.showSnackbar(
      GetBar(
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
        backgroundColor: isError ? highlight4Color : highlight1Color,
        messageText: Text(message, style: TextStyle(fontSize: 20, color: backgroundColor, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
