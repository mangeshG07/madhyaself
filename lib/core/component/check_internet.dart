import '../exporters/app_export.dart';

Future<void> checkInternetAndShowPopup() async {
  final connectivityResult = await Connectivity().checkConnectivity();

  if (connectivityResult.contains(ConnectivityResult.none)) {
    AllDialogs().noInternetDialog();
  }
}
