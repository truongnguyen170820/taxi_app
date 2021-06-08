import 'package:timesoft/model/beans/user/host_login_model.dart';

class GlobalCache {
  static GlobalCache _instance;
  // ignore: close_sinks
  // StreamController<String> deptStreamCtrl = StreamController.broadcast();
  // get getDepStream => deptStreamCtrl.stream;

  factory GlobalCache() => _instance ??= new GlobalCache._();
  GlobalCache._();
  String gymHomeConfig;
  String spaHomeConfig;
  HostLoginModel loginData;
  HostLoginModel getUser() {
    return loginData;
  }

  void setData(HostLoginModel _member) {
    this.loginData = _member;
  }
}
