import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:rxdart/rxdart.dart';

@Injectable()
class InternetConnectivityUniversalUtil {
  InternetConnectivityUniversalUtil._internal();

  static final InternetConnectivityUniversalUtil _instance =
      InternetConnectivityUniversalUtil._internal();

  factory InternetConnectivityUniversalUtil() {
    return _instance;
  }

  final Connectivity _connectivity = Connectivity();
  final InternetConnection _internetChecker = InternetConnection();

  late final StreamController<bool> _controller;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  StreamSubscription<InternetStatus>? _internetStatusSubscription;

  final BehaviorSubject<bool> _statusSubject = BehaviorSubject.seeded(false);

  ValueStream<bool> get internetStatusStream => _statusSubject.stream;

  Stream<bool> get onConnectivityChanged => _controller.stream;

  bool _isInitialized = false;

  Future<void> initialize() async {
    print('🔄 InternetConnectivityUniversalUtil: Initializing...');

    await _connectivitySubscription?.cancel();
    await _internetStatusSubscription?.cancel();

    if (_isInitialized) {
      print('⚠️ InternetConnectivityUniversalUtil ya fue inicializado.');
      return;
    }
    
    _isInitialized = true;

    _controller = StreamController<bool>.broadcast();

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (results) async {
        print(
            '🌐 InternetConnectivityUniversalUtil: Network interface results changed: $results');
        final hasConnection = await _checkInternetAccess(results);
        _emitStatus(hasConnection);
      },
      onError: (e) {
        print(
            '🚨 InternetConnectivityUniversalUtil: Error in connectivity_plus stream: $e');
        _emitStatus(false);
      },
      onDone: () {
        print(
            '🚪 InternetConnectivityUniversalUtil: connectivity_plus stream done.');
        _emitStatus(false);
      },
    );

    _internetStatusSubscription = _internetChecker.onStatusChange.listen(
      (status) {
        print(
            '🌍 InternetConnectivityUniversalUtil: Actual internet status changed: $status');
        final hasConnection = status == InternetStatus.connected;
        _emitStatus(hasConnection);
      },
      onError: (e) {
        print(
            '🚨 InternetConnectivityUniversalUtil: Error in internet_connection_checker_plus stream: $e');
        _emitStatus(false);
      },
      onDone: () {
        print(
            '🚪 InternetConnectivityUniversalUtil: internet_connection_checker_plus stream done.');
        _emitStatus(false);
      },
    );

    await _emitInitialStatus();
  }

  void _emitStatus(bool status) {
    if (!_controller.isClosed) {
      _controller.add(status);
      _statusSubject.add(status);
    }
  }

  Future<void> _emitInitialStatus() async {
    final status = await _internetChecker.hasInternetAccess;
    print(
        '✅ InternetConnectivityUniversalUtil: Initial internet access status: $status');
    _emitStatus(status);
  }

  Future<bool> _checkInternetAccess(List<ConnectivityResult> results) async {
    if (results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.ethernet)) {
      final hasInternet = await _internetChecker.hasInternetAccess;
      print(
          '🔍 InternetConnectivityUniversalUtil: Deeper internet access check (based on network type $results): $hasInternet');
      return hasInternet;
    }
    print(
        '❌ InternetConnectivityUniversalUtil: No relevant network interface detected: $results');
    return false;
  }

  Future<bool> get hasInternet async {
    return await _internetChecker.hasInternetAccess;
  }

  Future<void> dispose() async {
    print('🗑️ InternetConnectivityUniversalUtil: Disposing...');
    await _connectivitySubscription?.cancel();
    await _internetStatusSubscription?.cancel();
    await _controller.close();
  }
}
