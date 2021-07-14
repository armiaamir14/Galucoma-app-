import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glaucoma/core/constants/colors.dart';
import 'package:glaucoma/core/constants/routes.dart';
import 'package:glaucoma/core/services/authentication_service.dart';
import 'package:glaucoma/models/patient.dart';
import 'package:glaucoma/pages/home/home_page_controller.dart';
import 'package:glaucoma/pages/home/widgets/new_patient_floating_button.dart';

class HomePage extends GetView<HomePageController> {
  static const String _emptyListMessage = 'You have no\npatients, add at\nleast one to\nshow it here.';
  static const String _errorMessage = 'We\'re having a\n trouble showing your\npatients list! Please\n try refreshing\nthe page.';
  static const TextStyle _messageTextStyle = const TextStyle(color: textColor, fontWeight: FontWeight.w700, fontSize: 35);
  static const TextStyle _columnLabelTextStyle = const TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 15);
  static const TextStyle _cellValueTextStyle = const TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 13);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: highlight1Color,
      color: backgroundColor,
      onRefresh: () async => controller.loadPatients(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: controller.scaffoldKey,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          iconTheme: IconThemeData(color: textColor),
          actions: [
            TextButton.icon(
              onPressed: () async {
                final AuthenticationService authenticationService = Get.find<AuthenticationService>();
                Get.offAllNamed(AppRoutes.auth);
                await authenticationService.logout();
              },
              icon: Icon(
                Icons.logout,
                color: highlight4Color,
              ),
              label: Text(
                'Logout',
                style: TextStyle(color: highlight4Color),
              ),
            ),
          ],
          title: Text('Patients', style: TextStyle(color: textColor, fontWeight: FontWeight.w700)),
        ),
        body: ObxValue<Rx<HomePageState>>(
          (Rx<HomePageState> rxState) {
            final HomePageState state = rxState.value;
            if (state == HomePageState.loading) {
              return Center(child: Theme(data: ThemeData(accentColor: textColor), child: CircularProgressIndicator()));
            } else if (state == HomePageState.loaded) {
              final List<Patient> patients = controller.patients;
              if (patients.isEmpty) {
                return Center(child: Text(_emptyListMessage, textAlign: TextAlign.center, style: _messageTextStyle));
              } else {
                return SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('First Name', style: _columnLabelTextStyle)),
                        DataColumn(label: Text('Last Name', style: _columnLabelTextStyle)),
                        DataColumn(label: Text('Age', style: _columnLabelTextStyle)),
                        DataColumn(label: Text('Gender', style: _columnLabelTextStyle)),
                      ],
                      rows: patients
                          .map<DataRow>((Patient p) => DataRow(cells: <DataCell>[
                                DataCell(GestureDetector(onTap: () => controller.showPatientOptions(context, p), child: Text(p.firstName, style: _cellValueTextStyle))),
                                DataCell(GestureDetector(onTap: () => controller.showPatientOptions(context, p), child: Text(p.lastName, style: _cellValueTextStyle))),
                                DataCell(GestureDetector(onTap: () => controller.showPatientOptions(context, p), child: Text(p.age.toString(), style: _cellValueTextStyle))),
                                DataCell(GestureDetector(onTap: () => controller.showPatientOptions(context, p), child: Text(p.gender.capitalizeFirst, style: _cellValueTextStyle))),
                              ]))
                          .toList(),
                    ),
                  ),
                );
              }
            } else {
              return Center(child: Text(_errorMessage, textAlign: TextAlign.center, style: _messageTextStyle));
            }
          },
          controller.state,
        ),
        floatingActionButton: NewPatientFloatingButton(),
      ),
    );
  }
}
