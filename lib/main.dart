import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glaucoma/core/bindings/initial_bindings.dart';
import 'package:glaucoma/core/constants/colors.dart';
import 'package:glaucoma/core/constants/routes.dart';
import 'package:glaucoma/core/utils/functions.dart';
import 'package:glaucoma/pages/auth/auth_page.dart';
import 'package:glaucoma/pages/auth/auth_page_bindings.dart';
import 'package:glaucoma/pages/history/history_page.dart';
import 'package:glaucoma/pages/history/history_page_bindings.dart';
import 'package:glaucoma/pages/home/home_page.dart';
import 'package:glaucoma/pages/home/home_page_bindings.dart';

void main() async {
  final InitialBindings initialBindings = await AppFunctions.init();
  runApp(
    GetMaterialApp(
      title: 'Glaucoma',
      initialBinding: initialBindings,
      initialRoute: initialBindings.initialRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(accentColor: highlight1Color),
      getPages: [
        GetPage(
          name: AppRoutes.auth,
          binding: AuthPageBindings(),
          page: () => AuthPage(),
        ),
        GetPage(
          name: AppRoutes.home,
          binding: HomePageBindings(),
          page: () => HomePage(),
        ),
        GetPage(
          name: AppRoutes.history,
          binding: HistoryPageBindings(),
          page: () => HistoryPage(),
        ),
      ],
    ),
  );
}