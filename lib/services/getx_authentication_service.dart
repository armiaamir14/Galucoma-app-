import 'package:get/get.dart' as getx;
import 'package:get_storage/get_storage.dart';
import 'package:glaucoma/core/services/authentication_service.dart';
import 'package:glaucoma/core/services/database_service.dart';
import 'package:glaucoma/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class GetXAuthenticationService extends getx.GetConnect implements AuthenticationService {
  static const _ACCESS_TOKEN_KEY = 'accessToken';

  final GetStorage _getStorage = GetStorage();
  User _user;

  @override
  void onInit() {
    // httpClient.baseUrl = 'https://glac-detect.herokuapp.com';
    httpClient.defaultContentType = 'application/json';
    super.onInit();
  }

  @override
  Future<String> getCurrentUserAuthToken() async {
    final String accessToken = _getStorage.read<String>(_ACCESS_TOKEN_KEY);
    return accessToken;
  }

  @override
  Future<User> getCurrentUser() async => _user;

  @override
  Future login(String email, String password) async {
    try {

      var login_url = Uri.parse("https://glac-detect.herokuapp.com/user/login");

      var response = await http.post(login_url,

          headers: {"Content-Type": "application/json"},
          body: json.encode({"password": password, "email": email}));

      print("Response ==== ${response.body}");
      print("Code  ==== ${response.statusCode}");
      var jsonResponse = json.decode(response.body);
      final String errMessage = jsonResponse['err'];
      if (response.statusCode==200) {
        if (response.body == 'Unauthorized') throw DatabaseServiceException.Unauthorized;
        final String token = jsonResponse['token'];
        print("==== $token");
        if (token != null) {
          _getStorage.write('accessToken', token);
        } else {
          throw AuthenticationServiceException.invalidToken;
        }
      } else if(errMessage == "Email is not verfied") {
      throw AuthenticationServiceException.invalidEmail;
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
  Future register(String fname, String lname, String email,
      String password) async {
    var signup_url = Uri.parse("https://glac-detect.herokuapp.com/user/signup");
    try {
      var response = await http.post(signup_url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "password": password,
            "email": email,
            "fname": fname,
            "lname": lname,
          }));
      print("email=$email");
      var data = response;
      print("data === $data");
      print("to Sign up body ======= ${response.statusCode}");

      var jsonResponse = json.decode(response.body);

      if (response.statusCode != 200) {
        final String errMessage = jsonResponse['err'];
        if (errMessage == 'A user with the given username is already registered') {
          throw AuthenticationServiceException.emailAlreadyInUse;
        } else if (errMessage == '"body.email" must be a valid email') {
          throw AuthenticationServiceException.invalidEmail;
        }else if(errMessage== '"body.fname" must be a valid email'){
          throw AuthenticationServiceException.invalidFirstName;
        }else if(errMessage== '"body.lname" must be a valid email'){
          throw AuthenticationServiceException.invalidLastName;
        }else if(errMessage== '"body.password" must be a valid email'){
          throw AuthenticationServiceException.invalidPassword;
        }
      }
    } catch (e) {
      if (e is AuthenticationServiceException) {
        rethrow;
      } else {
        throw AuthenticationServiceException.unknownError;
      }
    }
  }

  @override
  Future logout() async {
    try {
      await _getStorage.remove(_ACCESS_TOKEN_KEY);
    } catch (e) {
      throw AuthenticationServiceException.failedToLogout;
    }
  }
}
