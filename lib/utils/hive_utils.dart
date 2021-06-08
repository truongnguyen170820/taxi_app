import 'dart:convert';
import 'package:timesoft/main.dart';
import 'package:timesoft/model/beans/user/host_login_model.dart';
import 'package:timesoft/utils/app_constant.dart';

class HiveUtils {
  static HiveUtils shared = HiveUtils();

  HostLoginModel getMemberData() {
    final data = userBox.get(AppConstants.HIVE_MEMBER_DATA);
    if(data == null)
      return HostLoginModel();
    final memberData = HostLoginModel.fromJson(jsonDecode(data));
    return memberData;
  }
}