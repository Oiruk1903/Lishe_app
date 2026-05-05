import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final _connectivityController = StreamController<bool>.broadcast();

  Stream<bool> get onConnectivityChanged => _connectivityController.stream;

  ConnectivityService() {
    _initialize();
  }

  void _initialize() {
    _connectivity.onConnectivityChanged.listen((result) {
      _connectivityController.add(result != ConnectivityResult.none);
    });
  }

  Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  void dispose() {
    _connectivityController.close();
  }
}
