

//Calling NetworkInfo().isConnected is really only a nickname for calling DataConnectionChecker().hasConnection.
// We're hiding the 3rd party library behind an interface of our own class.
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo{
  Future <bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo{
  final InternetConnectionChecker internetConnectionChecker;

  NetworkInfoImpl(this.internetConnectionChecker);

  @override
  Future<bool> get isConnected => internetConnectionChecker.hasConnection;
}