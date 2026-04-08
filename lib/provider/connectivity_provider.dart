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
      // Double-check with a real DNS lookup to catch "connected but no internet".
      // Try multiple hosts for redundancy (google.com may be blocked in some regions,
      // and iOS simulator can behave differently with DNS).
      final hosts = ['google.com', 'apple.com', 'cloudflare.com'];
      bool connected = false;

      for (final host in hosts) {
        try {
          final result = await InternetAddress.lookup(host)
              .timeout(const Duration(seconds: 3));
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            connected = true;
            break;
          }
        } catch (_) {
          // Try the next host
          continue;
        }
      }

      _updateStatus(connected);
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
