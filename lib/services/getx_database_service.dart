import 'dart:io';
import 'package:get/get.dart';
import 'package:glaucoma/core/services/authentication_service.dart';
import 'package:glaucoma/core/services/database_service.dart';
import 'package:glaucoma/models/scan_history.dart';
import 'package:glaucoma/models/patient.dart';

class GetXDatabaseService extends GetConnect implements DatabaseService {
  static const _AUTH_HEADER = 'Authorization';

  @override
  void onInit() {
    httpClient.baseUrl = 'https://glac-detect.herokuapp.com';
    httpClient.defaultContentType = 'application/json';
  }

  Future<String> _getAuthorizationToken() async {
    final AuthenticationService authenticationService = Get.find<AuthenticationService>();
    final String token = await authenticationService.getCurrentUserAuthToken();
    if (token != null) {
      return 'Bearer $token';
    } else {
      throw DatabaseServiceException.tokenNotFound;
    }
  }

  Map<String, dynamic> _getRequestBodyFromPatient(Patient patient) => {'fname': patient.firstName, 'lname': patient.lastName,
    'gender': patient.gender ?? 'male', 'age': patient.age};

  bool isInvalidTokenResponse(Response response) => response.body == 'Unauthorized';

  @override
  Future createNewPatient(Patient patient) async {
    try {
      final String token = await _getAuthorizationToken();
      if (token != null) {
        final Response response = await post('/patient/new', _getRequestBodyFromPatient(patient), headers: {_AUTH_HEADER: token});
        if (response.status.hasError) {
          if (isInvalidTokenResponse(response)) {
            throw DatabaseServiceException.invalidToken;
          } else {
            throw DatabaseServiceException.unknownError;
          }
        }
      } else {
        throw DatabaseServiceException.tokenNotFound;
      }
    } catch (e) {
      if (e is DatabaseServiceException) {
        rethrow;
      } else {
        throw DatabaseServiceException.unknownError;
      }
    }
  }

  @override
  Future deletePatient(Patient patient) async {
    try {
      final String token = await _getAuthorizationToken();
      final Response response = await delete('/patient/${patient.id}/delete', headers: {_AUTH_HEADER: token});
      if (response.status.hasError) throw DatabaseServiceException.failedToAddPatient;
    } catch (e) {
      if (e is DatabaseServiceException) {
        rethrow;
      } else {
        throw DatabaseServiceException.failedToDeletePatient;
      }
    }
  }

  @override
  Future deleteScanHistory(ScanHistory history) async {
    try {
      final String token = await _getAuthorizationToken();
      final Response response = await delete('/patient/${history.patientId}/history/${history.id}', headers: {_AUTH_HEADER: token});
      if (response.status.hasError) throw DatabaseServiceException.failedToDeleteScan;
    } catch (e) {
      if (e is DatabaseServiceException) {
        rethrow;
      } else {
        throw DatabaseServiceException.failedToDeleteScan;
      }
    }
  }

  @override
  Future editPatient(Patient patient) async {
    try {
      final String token = await _getAuthorizationToken();
      final Response response = await put('/patient/${patient.id}/edit', _getRequestBodyFromPatient(patient), headers: {_AUTH_HEADER: token});
      if (response.status.hasError) throw DatabaseServiceException.failedToEditPatient;
    } catch (e) {
      if (e is DatabaseServiceException) rethrow;
      throw DatabaseServiceException.failedToEditPatient;
    }
  }

  @override
  Future<List<ScanHistory>> getAllScanHistory(Patient patient) async {
    try {
      final String token = await _getAuthorizationToken();
      final Response response = await get('/patient/${patient.id}/history', headers: {_AUTH_HEADER: token});
      if (response.status.hasError) {
        throw DatabaseServiceException.failedToGetScanHistory;
      } else {
        return (response.body['history'] as List<dynamic>).map((dynamic historyData) => ScanHistory.fromJson(historyData)).toList();
      }
    } catch (e) {
      if (e is DatabaseServiceException) {
        rethrow;
      } else {
        throw DatabaseServiceException.failedToGetScanHistory;
      }
    }
  }

  @override
  Future<Patient> getPatient(String patientId) async {
    try {
      final String token = await _getAuthorizationToken();
      final Response response = await get('/patient/$patientId', headers: {_AUTH_HEADER: token});
      if (response.status.hasError) {
        throw DatabaseServiceException.failedToGetPatient;
      } else {
        return Patient.fromJson(response.body['patient']);
      }
    } catch (e) {
      if (e is DatabaseServiceException) rethrow;
      throw DatabaseServiceException.failedToGetPatient;
    }
  }

  @override
  Future<List<Patient>> getPatients() async {
    try {
      final String token = await _getAuthorizationToken();
      final Response response = await get('/patient', headers: {_AUTH_HEADER: token});
      if (response.hasError) {
        if (isInvalidTokenResponse(response)) {
          throw DatabaseServiceException.invalidToken;
        } else {
          throw DatabaseServiceException.failedToGetAllPatients;
        }
      } else {
        return (response.body['patient'] as List<dynamic>).map<Patient>((dynamic patientData) => Patient.fromJson(patientData)).toList();
      }
    } catch (e) {
      if (e is DatabaseServiceException) {
        rethrow;
      } else {
        throw DatabaseServiceException.failedToGetAllPatients;
      }
    }
  }

  @override
  Future makeScan(String patientId, File image, String notes, String eye) async {
    try {
      final String token = await _getAuthorizationToken();
      final String fileName = image.path.split('/').last;
      final imageBytes = await image.readAsBytes();

      await post('/user/update_credits',{'credits':2},headers: {_AUTH_HEADER: token});

      final FormData formData = FormData(
        {
          'image': MultipartFile(imageBytes, filename: fileName),
          'eye': eye ?? 'left',
          'notes': notes ?? '',
          '_patientId': patientId,
        },
      );
      final Response response = await post(
        '/scan/new' ,
        formData,
        contentType: 'multipart/form-data',
        headers: {_AUTH_HEADER: token},
      );
      if (response.status.hasError) {
        throw DatabaseServiceException.unknownError;
      }
    } catch (e) {
      if (e is DatabaseServiceException) {
        rethrow;
      } else {
        throw DatabaseServiceException.unknownError;
      }
    }
  }
}
