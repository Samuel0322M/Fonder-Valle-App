/*
import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:domain/use_cases/sync_offline_data_use_case.dart';

Future<void> initializeService(SyncOfflineDataUseCase syncUseCase) async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: false,
      autoStart: true,
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      onBackground: () => true,
    ),
  );

  await service.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  DartPluginRegistrant.ensureInitialized();

  Timer.periodic(const Duration(minutes: 15), (timer) async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity != ConnectivityResult.none) {
      await getIt<SyncOfflineDataUseCase>().execute(); // Llama tu lógica de sincronización
    }
  });
}
*/
