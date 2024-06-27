import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> checkConnectivity() async {
  final List<ConnectivityResult> connectivityResult =
      await (Connectivity().checkConnectivity());

  if (connectivityResult.contains(ConnectivityResult.mobile)) {
    return true;
  } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
    return true;
  } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
    return true;
  } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
    return false;
  } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
    return false;
  } else if (connectivityResult.contains(ConnectivityResult.other)) {
    return false;
  } else if (connectivityResult.contains(ConnectivityResult.none)) {
    return false;
  }
  return false;
}
