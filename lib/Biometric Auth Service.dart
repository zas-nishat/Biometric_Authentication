import 'package:local_auth/local_auth.dart';

class AuthService {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> authenticate() async {
    final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
    if (canAuthenticateWithBiometrics) {
      try {
        final bool didAuthenticate = await _auth.authenticate(
          localizedReason: 'Please authenticate to access the app',
          options: const AuthenticationOptions(biometricOnly: false),
        );
        return didAuthenticate;
      } catch (e) {
        print(e);
        return false; // Return false if there's an error
      }
    } else {
      return false; // Return false if biometrics are unavailable
    }
  }
}
