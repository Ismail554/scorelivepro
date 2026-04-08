import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityProvider extends ChangeNotifier {
  bool _isConnected = true;
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  bool get isConnected => _isConnected;

  ConnectivityProvider() {
    _init();
  }

  Future<void> _init() async {
    // Initial check
    await _checkConnection();

    // Listen for changes
    _subscription = Connectivity().onConnectivityChanged.listen((results) async {
      await _checkConnection();
    });
  }

  Future<void> _checkConnection() async {
    final results = await Connectivity().checkConnectivity();
    final hasNetwork = results.any((r) => r != ConnectivityResult.none);

    if (hasNetwork) {
      // Double-check with a real DNS lookup to catch "connected but no internet"
      try {
        final result = await InternetAddress.lookup('google.com')
            .timeout(const Duration(seconds: 3));
        _updateStatus(result.isNotEmpty && result[0].rawAddress.isNotEmpty);
      } on SocketException catch (_) {
        _updateStatus(false);
      } on TimeoutException catch (_) {
        _updateStatus(false);
      }
    } else {
      _updateStatus(false);
    }
  }

  void _updateStatus(bool connected) {
    if (_isConnected != connected) {
      _isConnected = connected;
      notifyListeners();
    }
  }

  /// Manual retry for the user
  Future<void> retry() async {
    await _checkConnection();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
