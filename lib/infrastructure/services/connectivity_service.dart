import 'package:app/infrastructure/helpers/alerter.dart';
import 'package:app/infrastructure/helpers/my_logger.dart';
import 'package:connectivity/connectivity.dart';
import 'package:rxdart/rxdart.dart';

class ConnectivityService {
  ConnectivityService() {
    _connectvitiy.checkConnectivity().then((value) => updateHasConnection(value != ConnectivityResult.none));
  }

  final _connectvitiy = Connectivity();
  final _hasConnectionController = BehaviorSubject<bool>.seeded(true);

  Stream<bool> get hasConnection$ => _hasConnectionController.stream;

  void updateHasConnection(bool value) => _hasConnectionController.add(value);

  void listenForOffline() {
    _connectvitiy.onConnectivityChanged.listen((ConnectivityResult event) {
      event == ConnectivityResult.none ? updateHasConnection(false) : updateHasConnection(true);
    });

    _hasConnectionController.listen((value) {
      logger.d('- [NEW EVENT] hasConnectionController = $value');
      if (!value) Alerter.showSnackBar(message: 'İnternet əlaqəsi itdi', positive: true);
    });
  }

  void close() {
    _hasConnectionController.close();
  }
}
