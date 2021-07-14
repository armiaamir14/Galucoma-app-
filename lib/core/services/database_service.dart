import 'dart:io';

import 'package:glaucoma/models/patient.dart';
import 'package:glaucoma/models/scan_history.dart';

enum DatabaseServiceException {
  invalidToken,
  tokenNotFound,
  invalidEmail,
  Unauthorized,
  patientNotFound,
  failedToAddPatient,
  failedToEditPatient,
  failedToDeletePatient,
  failedToAddScan,
  failedToDeleteScan,
  failedToGetScanHistory,
  failedToGetPatient,
  failedToGetAllPatients,
  unknownError,
}

abstract class DatabaseService {
  Future<List<Patient>> getPatients();
  Future createNewPatient(Patient patient);
  Future<Patient> getPatient(String patientId);
  Future deletePatient(Patient patient);
  Future editPatient(Patient patient);
  Future makeScan(String patientId, File image, String notes, String eye);
  Future<List<ScanHistory>> getAllScanHistory(Patient patient);
  Future deleteScanHistory(ScanHistory history);
}
