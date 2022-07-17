


import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmdb_app/src/string.dart';

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static Future<bool> enable() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getBool(SHARED_FINGERPRINT) == false){
      return false;
    }
    else {
      return true;
    }
  }

  static Future<bool> authenticate() async {
    final isAvaiable = await hasBiometrics();
    if(!isAvaiable) return false;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool(SHARED_FINGERPRINT, true);
    try {
      return await _auth.authenticate(
        localizedReason: 'Scan Fingerprint to login',
        options: const AuthenticationOptions(
            biometricOnly: true)
      );
    } on PlatformException catch (e) {
      if (e.code == auth_error.lockedOut ||
          e.code == auth_error.permanentlyLockedOut) {
        // ...
      }
      return false;
    }
  }

  static Future<bool> hasBiometrics() async{
    try{
    return await _auth.canCheckBiometrics;
  } on PlatformException catch(e) {
      return false;
    }
  }
}