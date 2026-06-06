abstract class ConnectionService {
  Future<bool> get isConnected;
  Stream<bool> get onConnectionChanged;
}
