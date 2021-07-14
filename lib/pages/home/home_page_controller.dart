import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glaucoma/core/constants/routes.dart';
import 'package:glaucoma/core/services/database_service.dart';
import 'package:glaucoma/core/utils/functions.dart';
import 'package:glaucoma/models/patient.dart';
import 'package:glaucoma/pages/home/widgets/patient_bottom_sheet.dart';
import 'package:glaucoma/pages/home/widgets/patient_options_dialog/patient_options_dialog.dart';

enum HomePageState { loading, loaded, error }
enum Gender { male, female }
enum SavingPatientState { normal, saving }
enum SavingPatientValidationException { invalidFirstName, invalidLastName }

class HomePageController extends GetxController {
  static const String _SESSION_EXPIRED_MESSAGE = 'Session expired, please, login again!';

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController firstNameController, lastNameController;
  Rx<Gender> gender;
  RxInt selectedAge;
  Rx<HomePageState> state;
  Rx<SavingPatientState> savingState;
  List<Patient> patients;
  PersistentBottomSheetController bottomSheetController;
  RxBool isBottomSheetOpen;
  Patient patientToEdit;

  @override
  void onInit() {
    state = HomePageState.loading.obs;
    savingState = SavingPatientState.normal.obs;
    gender = Gender.male.obs;
    selectedAge = 0.obs;
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    isBottomSheetOpen = false.obs;
    loadPatients();
    super.onInit();
  }

  void loadPatients() async {
    try {
      state.value = HomePageState.loading;
      final DatabaseService databaseService = Get.find<DatabaseService>();
      patients = await databaseService.getPatients();
      state.value = HomePageState.loaded;
    } catch (e) {
      state.value = HomePageState.error;
      if (e == DatabaseServiceException.invalidToken) {
        Get.offAllNamed(AppRoutes.auth);
        AppFunctions.showSnackBar(_SESSION_EXPIRED_MESSAGE, isError: true);
      }
    }
  }

  void openBottomSheet() async {
    final bool shouldEditPatient = patientToEdit != null;
    if (!isBottomSheetOpen.value) {
      firstNameController.text = shouldEditPatient ? patientToEdit.firstName : '';
      lastNameController.text = shouldEditPatient ? patientToEdit.lastName : '';
      selectedAge.value = shouldEditPatient ? patientToEdit.age : 0;
      gender.value = shouldEditPatient ? (patientToEdit.gender == 'male' ? Gender.male : Gender.female) : Gender.male;
      bottomSheetController = scaffoldKey.currentState.showBottomSheet((context) => PatientBottomSheet(selectedAge.value));
      isBottomSheetOpen.value = true;
      await bottomSheetController.closed;
      isBottomSheetOpen.value = false;
      patientToEdit = null;
    } else {
      bottomSheetController.close();
      isBottomSheetOpen.value = false;
    }
  }

  void showPatientOptions(BuildContext context, Patient patient) => showDialog(context: context, builder: (BuildContext context) => PatientOptionsDialog(patient));

  void editPatient(Patient patient) {
    patientToEdit = patient;
    openBottomSheet();
  }

  void savePatient() async {
    savingState.value = SavingPatientState.saving;
    try {
      final String firstName = firstNameController.text.trim();
      final String lastName = lastNameController.text.trim();
      final int age = selectedAge.value;
      final String selectedGender = gender.value == Gender.male ? 'male' : 'female';
      if (firstName.length < 3) throw SavingPatientValidationException.invalidFirstName;
      if (lastName.length < 3) throw SavingPatientValidationException.invalidLastName;
      final DatabaseService databaseService = Get.find<DatabaseService>();
      final bool shouldEditPatient = patientToEdit != null;
      if (shouldEditPatient) {
        final Patient newPatientData = Patient(age: age, doctorId: patientToEdit.doctorId, id: patientToEdit.id, firstName: firstName, lastName: lastName, gender: selectedGender);
        await databaseService.editPatient(newPatientData);
      } else {
        await databaseService.createNewPatient(Patient(firstName: firstName, lastName: lastName, age: age, gender: selectedGender));
      }
      AppFunctions.showSnackBar('The Patient was added successfully! Refreshing list!');
      loadPatients();
      openBottomSheet();
    } catch (e) {
      String message = 'Unknown Error!';
      if (e is SavingPatientValidationException) {
        if (e == SavingPatientValidationException.invalidFirstName) {
          message = 'Invalid first name!';
        }
        if (e == SavingPatientValidationException.invalidLastName) {
          message = 'Invalid last name!';
        }
      } else if (e is DatabaseServiceException) {
        if (e == DatabaseServiceException.failedToAddPatient) {
          message = 'Failed to add patient!';
        } else if (e == DatabaseServiceException.invalidToken) {
          Get.offAllNamed(AppRoutes.auth);
          AppFunctions.showSnackBar('Session expired, please, login again!', isError: true);
        }
      }
      AppFunctions.showSnackBar(message, isError: true);
    }
    savingState.value = SavingPatientState.normal;
  }

  void deletePatient(Patient patient) async {
    try {
      final DatabaseService databaseService = Get.find<DatabaseService>();
      await databaseService.deletePatient(patient);
      AppFunctions.showSnackBar('The patient was deleted successfully! Refreshing the list!');
      loadPatients();
    } catch (e) {
      if (e == DatabaseServiceException.invalidToken) {
        Get.offAllNamed(AppRoutes.auth);
        AppFunctions.showSnackBar(_SESSION_EXPIRED_MESSAGE, isError: true);
      } else {
        AppFunctions.showSnackBar('Failed to delete the patient!', isError: true);
      }
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.onClose();
  }
}
