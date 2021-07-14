import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:glaucoma/core/services/authentication_service.dart';
import 'package:glaucoma/core/services/database_service.dart';

class InitialBindings extends Bindings {
  final AuthenticationService authenticationService;
  final DatabaseService databaseService;
  final String initialRoute;

  InitialBindings({@required this.authenticationService, @required this.databaseService, @required this.initialRoute});

  @override
  void dependencies() {
    Get.put<AuthenticationService>(authenticationService);
    Get.put<DatabaseService>(databaseService);
  }
}
