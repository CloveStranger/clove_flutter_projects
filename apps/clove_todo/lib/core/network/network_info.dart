/// Interface for checking network connectivity
abstract class NetworkInfo {
  /// Returns true if device is connected to network
  Future<bool> get isConnected;
}

