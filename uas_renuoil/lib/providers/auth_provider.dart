import 'package:flutter/material.dart';
import '../providers/biometric_service.dart';

class AuthProvider extends ChangeNotifier {
  final BiometricService _biometricService = BiometricService();
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<bool> checkBiometricsAvailable() async {
    return await _biometricService.isBiometricsAvailable();
  }

  Future<bool> authenticateWithBiometrics() async {
    final bool isAvailable = await checkBiometricsAvailable();
    if (!isAvailable) {
      return false;
    }

    final bool success = await _biometricService.authenticate();
    _isAuthenticated = success;
    notifyListeners();
    return success;
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}