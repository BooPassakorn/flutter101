import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workshop/core/config/routes.dart';
import 'package:workshop/core/config/shared_preferences_key.dart';

class AuthController extends GetxController {
  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  final String _clientId = 'mobile';
  final String _redirectUrl = 'dolappeal://auth';
  final List<String> _scopes = <String>['openid', 'email', 'profile'];

  /// ข้อมูล url ต่างๆมาจาก Keylcoak : https://apidcdev.dol.go.th/auth/realms/master/.well-know/openid-configuration
  final AuthorizationServiceConfiguration _serviceConfiguration =
      const AuthorizationServiceConfiguration(
    authorizationEndpoint:
        'https://apidcdev.dol.go.th/auth/realms/master/protocol/openid-connect/auth',
    tokenEndpoint:
        'https://apidcdev.dol.go.th/auth/realms/master/protocol/openid-connect/token',
    endSessionEndpoint:
        'https://apidcdev.dol.go.th/auth/realms/master/protocol/openid-connect/logout',
  );

  final _prefs = const FlutterSecureStorage();

  /// Test user : thitimo.n
  Future<void> signInWithAutoCodeExchange(
      {bool preferEphemeralSession = false}) async {
    try {
      /// ถ้าเคย Login จะได้ Token กลบัมาเลยไม่่แสดงหน้า Login ให้ผู้ใช้กรอก User/Pase อีก
      // show that we can also explicitly specify the endpoints rather than getting from the details from the discovery
      // final AuthorizationTokenResponse? result =
      // await _appAuth.authorizeAndExchangCode(
      //   AuthorizationTokenRequest(
      //     _clientId,
      //     _redirectUrl,
      //     serviceConfiguration: _serviceConfiguration,
      //     scopes: _scopes,
      //     preferEphemeralSession: preferEphemeralSession,
      //   ),
      // );

      /// แบบนี้จะเป็นการ Force user ไปหน้า Login ถึงแม้ จะเคย Login แล้ว
      // this code block demonstrates passing in values for the prompt parameter. in this case it prompt the user login
      final AuthorizationTokenRequest? result =
          (await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(_clientId, _redirectUrl,
            serviceConfiguration: _serviceConfiguration,
            scopes: _scopes,
            promptValues: ['login']),
      )) as AuthorizationTokenRequest?;

      if (result != null) {
        _processAuthTokenResponse(result);
      }
    } catch (_) {}
  }

  void _processAuthTokenResponse(AuthorizationTokenRequest result) async {
    // TODO : Save token to SharedPreference
    final prefs = await SharedPreferences.getInstance();

    if (result.clientSecret?.isNotEmpty == true &&
        result.refreshToken?.isNotEmpty == true) {
      // await prefs.setString(
      //     SharedPreferenceKey.KEY_ACCESS_TOKEN, result.clientSecret!);
      // await prefs.setString(
      //     SharedPreferenceKey.KEY_REFRESH_TOKEN, result.refreshToken!);
      // await prefs.setString(
      //     SharedPreferenceKey.KEY_TOKEN_ID, result.refreshToken!);
      //
      // // final String? action = prefs.getString(SharedPreferenceKey.KEY_ACCESS_TOKEN);
      // // print(action);
      // print(await prefs.getString(SharedPreferenceKey.KEY_ACCESS_TOKEN));

      await _prefs.write(key: SharedPreferenceKey.KEY_ACCESS_TOKEN, value: result.clientSecret);
      await _prefs.write(key: SharedPreferenceKey.KEY_REFRESH_TOKEN, value: result.refreshToken);
      await _prefs.write(key: SharedPreferenceKey.KEY_TOKEN_ID, value: result.refreshToken);
      print(await _prefs.read(key: SharedPreferenceKey.KEY_ACCESS_TOKEN));

      Get.offAllNamed(Routes.mainPage);
      // Get.toNamed(Routes.mainPage);
    }
  }

  void bypassLogin() {
    Get.offAllNamed(
        Routes.mainPage); //ไม่เอาตัวเองลง stack และล้าง stack ออกด้วย

    // Get.toNamed(Routes.mainPage);
  }

  void endSession() async {
    try {
      // final prefs = await SharedPreferences.getInstance();
      // final String? tokenId = prefs.getString(SharedPreferenceKey.KEY_TOKEN_ID);
      final String? tokenId = await _prefs.read(key: SharedPreferenceKey.KEY_TOKEN_ID);

      if(tokenId?.isNotEmpty == true){
        await _appAuth.endSession(
          EndSessionRequest(
              idTokenHint: tokenId,
              postLogoutRedirectUrl: _redirectUrl,
              serviceConfiguration: _serviceConfiguration),
        );
      }

      await SharedPreferenceKey.clearAll();
      Get.offAllNamed(Routes.rootPage);
      print(await _prefs.read(key: SharedPreferenceKey.KEY_ACCESS_TOKEN));
    } catch (_) {
      if (kDebugMode) {
        print(_);
      }
    }
  }
}
