import 'package:connectivity_plus/connectivity_plus.dart';

/// Interface for checking network connectivity
abstract class NetworkInfo {
  /// Returns true if device is connected to network
  Future<bool> get isConnected;

  /// Returns the current connectivity status
  Future<List<ConnectivityResult>> get connectivityResult;

  /// Stream of connectivity changes
  Stream<List<ConnectivityResult>> get onConnectivityChanged;
}

/// Implementation of NetworkInfo using connectivity_plus
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl(this._connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result.any(
      (connectivity) =>
          connectivity == ConnectivityResult.mobile ||
          connectivity == ConnectivityResult.wifi ||
          connectivity == ConnectivityResult.ethernet,
    );
  }

  @override
  Future<List<ConnectivityResult>> get connectivityResult async {
    return await _connectivity.checkConnectivity();
  }

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }
}
