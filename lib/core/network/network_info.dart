import 'dart:developer';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

/// Abstraction for reachability checks (SOLID: depend on interface).
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

@LazySingleton(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl(this._connectivity);

  final Connectivity _connectivity;

  @override
  Future<bool> get isConnected async {
    // 1. Check if we have an active interface (Wi-Fi, Mobile Data, etc.)
    final results = await _connectivity.checkConnectivity();
    final hasInterface = results.any((r) => r != ConnectivityResult.none);
    
    log('NETWORK_INFO: Interface status: $hasInterface ($results)');

    if (!hasInterface) {
      return false;
    }

    // 2. Perform a real-world lookup to verify actual internet access.
    // We check the actual API host to ensure it's reachable.
    try {
      final result = await InternetAddress.lookup('weatherapi.com')
          .timeout(const Duration(seconds: 3));
      final isReachable = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      log('NETWORK_INFO: Host reachability: $isReachable');
      return isReachable;
    } catch (e) {
      log('NETWORK_INFO: Lookup failed: $e');
      return false;
    }
  }
}
