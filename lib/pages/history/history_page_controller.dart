import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glaucoma/core/services/database_service.dart';
import 'package:glaucoma/core/utils/functions.dart';
import 'package:glaucoma/models/patient.dart';
import 'package:glaucoma/models/scan_history.dart';
import 'package:glaucoma/pages/history/widgets/history_options_dialog.dart';
import 'package:glaucoma/pages/history/widgets/new_scan_bottom_sheet.dart';
import 'package:image_picker/image_picker.dart';

enum HistoryPageState { loading, loaded, error }
enum ScanningState { normal, loading }
enum Eye { left, right }

class HistoryPageController extends GetxController {
  Patient patient;
  List<ScanHistory> history;
  Rx<HistoryPageState> state;
  Rx<ScanningState> scanningState;
  GlobalKey<ScaffoldState> scaffoldKey;
  RxBool isBottomSheetOpen;
  Rx<Eye> selectedEye;
  TextEditingController notesController;
  PersistentBottomSheetController bottomSheetController;
  ImagePicker _imagePicker;
  Rx<File> imageFile;

  @override
  void onInit() {
    scaffoldKey = GlobalKey();
    patient = Get.arguments[0];
    state = HistoryPageState.loading.obs;
    scanningState = ScanningState.normal.obs;
    isBottomSheetOpen = false.obs;
    selectedEye = Eye.left.obs;
    notesController = TextEditingController();
    _imagePicker = ImagePicker();
    imageFile = Rx<File>(null);
    loadHistory();
    super.onInit();
  }

  void pickImage() async {
    final PickedFile pickedImageFile = await _imagePicker.getImage(source: ImageSource.gallery);
    if (pickedImageFile != null) {
      imageFile.value = File(pickedImageFile.path);
    }
  }

  void showHistoryOptions(BuildContext context, ScanHistory scanHistory) async => showDialog(context: context, builder: (context) => HistoryOptionsMenu(scanHistory));

  void openBottomSheet() async {
    if (!isBottomSheetOpen.value) {
      if (scanningState.value != ScanningState.loading) {
        notesController.clear();
        selectedEye.value = Eye.left;
      }
      bottomSheetController = scaffoldKey.currentState.showBottomSheet((context) => ScanBottomSheet());
      isBottomSheetOpen.value = true;
      await bottomSheetController.closed;
      isBottomSheetOpen.value = false;
      if (scanningState.value != ScanningState.loading) {
        imageFile?.value = null;
      }
    } else {
      bottomSheetController.close();
      isBottomSheetOpen.value = false;
    }
  }

  void deleteHistory(ScanHistory scanHistory) async {
    try {
      Get.back();
      final DatabaseService databaseService = Get.find<DatabaseService>();
      await databaseService.deleteScanHistory(scanHistory);
      AppFunctions.showSnackBar('Scan history record was deleted successfully!');
      loadHistory();
    } catch (e) {
      AppFunctions.showSnackBar('Failed to delete scan history record', isError: true);
    }
  }

  void loadHistory() async {
    state.value = HistoryPageState.loading;
    try {
      final DatabaseService databaseService = Get.find<DatabaseService>();
      history = await databaseService.getAllScanHistory(patient);
      state.value = HistoryPageState.loaded;
    } catch (e) {
      state.value = HistoryPageState.error;
      rethrow;
    }
  }

  void makeScan() async {
    if (scanningState.value == ScanningState.normal) {
      try {
        scanningState.value = ScanningState.loading;
        final DatabaseService databaseService = Get.find<DatabaseService>();
        final String eye = selectedEye.value == Eye.left ? 'left' : 'right';
        final String notes = notesController.text.trim();
        final int result = await databaseService.makeScan(patient.id, imageFile.value, notes, eye);
        final String resultConverted = result == 0 ? 'NEGATIVE' : 'POSITIVE';
        AppFunctions.showSnackBar('Scanned was made successfully!.'/*Result is $resultConverted'*/ );
        openBottomSheet();
        loadHistory();
      } catch (e) {
        AppFunctions.showSnackBar('Failed to make scan! Please check the information you\'ve entered!', isError: true);
      }
      scanningState.value = ScanningState.normal;
    }
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}
