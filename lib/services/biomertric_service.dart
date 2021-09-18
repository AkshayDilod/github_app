import 'package:local_auth/local_auth.dart';

class AuthWithBiometric {
  final _auth = LocalAuthentication();
  checkLocalAuthAvailable() async {
    bool canCheckBiometrics = await _auth.canCheckBiometrics;
    print('local auth is available::' + canCheckBiometrics.toString());
  }

  listOfAvailableBiometric() async {
    List<BiometricType> availableBiometrics =
        await _auth.getAvailableBiometrics();
    for (var item in availableBiometrics) {
      print(item);
    }
  }

  Future<bool> authenticationUserWithBiometric() async {
    bool isSupported = await _auth.isDeviceSupported();
    bool res = false;
    // ignore: deprecated_member_use
    bool authenticated = await _auth.authenticateWithBiometrics(
        localizedReason: 'Scan your fingerprint to authenticate',
        useErrorDialogs: true,
        stickyAuth: true);
    if (authenticated) {
      res = true;
    }
    return res;
  }
}
