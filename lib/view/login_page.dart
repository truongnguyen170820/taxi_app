import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:taxi_app/my_app.dart';
import 'package:taxi_app/utils/app_constant.dart';
import 'package:taxi_app/utils/color_utils.dart';
import 'package:taxi_app/utils/font_utils.dart';
import 'package:taxi_app/utils/screen/screen_utils.dart';
import 'package:taxi_app/view/home_page.dart';
import 'package:taxi_app/view/loading_dialog.dart';
import 'package:taxi_app/view/msg_dilog.dart';
import 'package:taxi_app/view/register_page.dart';
import 'package:taxi_app/widget/custombutton.dart';
import 'package:taxi_app/widget/global.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isShowPassword = true;
  bool _isRememberMe = false;
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  storage.read(key: AppConstants.KEY_USER_NAME).then((value){
    setState(() {
      if (value != null && value.isNotEmpty) _isRememberMe = true;
      _emailController.text = value;
    });
  });
    storage.read(key: AppConstants.KEY_PASSWORD).then((value){
      setState(() {
        if (value != null && value.isNotEmpty) _isRememberMe = true;
        _passController.text = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: 667, width: 375, allowFontScaling: true);
    return Scaffold(
      backgroundColor: ColorUtils.gray8,
      body: Column(
        children: [
          SizedBox(
            height: setHeight(120),
          ),
          Image.asset(getAssetsImage("ic_car_green.png")),
          SizedBox(height: setHeight(16)),
          Text(
            "Welcome back!",
            style: TextStyle(fontSize: 22, color: Color(0xff333333)),
          ),
          Text(
            "Login to continue using iCab",
            style: TextStyle(fontSize: 16, color: Color(0xff606470)),
          ),
          Container(
            margin: EdgeInsets.only(left: setWidth(8), right: setWidth(8), top: setHeight(32)),
            padding: EdgeInsets.only(left: setWidth(8), right: setWidth(8), bottom: setHeight(16)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: ColorUtils.WHITE
            ),
            child: Column(
              children: [
                _buidelItem("Email", "ic_mail.png", _emailController),
                _buidelItem("Password", "ic_lock.png", _passController,
                  widget: IconButton(
                    alignment: Alignment.centerLeft,
                    icon: Icon(
                      _isShowPassword ? Icons.visibility : Icons.visibility_off,
                      size: 18,
                      color: ColorUtils.gray6,
                    ),
                    onPressed: () {
                      setState(() {
                        _isShowPassword = !_isShowPassword;
                      });
                    },
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 0, bottom: 0),
                      height: setHeight(50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Checkbox(
                            value: _isRememberMe,
                            activeColor: Colors.blue,
                            checkColor: Colors.white,
                            onChanged: (bool newValue) {
                              setState(() {
                                _isRememberMe = newValue;
                              });
                            },
                          ),
                          Text(
                            'Lưu mật khẩu',
                            style: FontUtils.MEDIUM.copyWith(
                                color: ColorUtils.gray2, ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Text(
                      "Forgot password?",
                      style: TextStyle(fontSize: 16, color: Color(0xff606470)),
                    ),
                  ],
                ),
                // Container(
                //   margin: EdgeInsets.only(bottom: setHeight(16), top: setHeight(8)),
                //   constraints: BoxConstraints.loose(Size(double.infinity, 30)),
                //   alignment: AlignmentDirectional.centerEnd,
                //   child: Text(
                //     "Forgot password?",
                //     style: TextStyle(fontSize: 16, color: Color(0xff606470)),
                //   ),
                // ),
                ButtonCustom(
                  height: setHeight(42),
                  width: double.infinity,
                  title: "Log In",
                  textStyle: FontUtils.MEDIUM
                      .copyWith(fontSize: setSp(16), color: ColorUtils.WHITE),
                  borderRadius: 12,
                  bgColor: ColorUtils.blueAccent,
                  onTap: () {
                    _onLoginClick();
                  },
                ),
                SizedBox(height: setHeight(16)),
                RichText(
                  text: TextSpan(
                      text: "New user? ",
                      style: TextStyle(color: Color(0xff606470), fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterPage()));
                              },
                            text: "Sign up for a new account",
                            style: TextStyle(color: Color(0xff3277D8), fontSize: 16))
                      ]),
                )
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget _buidelItem(String name, String url, TextEditingController controller,
      {Widget widget}) {
    return Container(
      margin: EdgeInsets.only(top: setHeight(16)),
      decoration: BoxDecoration(
        border: Border.all(color: ColorUtils.gray2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 18, color: Colors.black),
        decoration: InputDecoration(
            suffixIcon: widget,
            hintText: name,
            prefixIcon:
                Container(width: 50, child: Image.asset(getAssetsImage(url))),
            border: OutlineInputBorder(borderSide: BorderSide.none)),
      ),
    );
  }

  void _onLoginClick() {
    String email = _emailController.text;
    String pass = _passController.text;
    if (_isRememberMe) {
      storage.write(
          key: AppConstants.KEY_USER_NAME, value: _emailController.text);
      storage.write(
          key: AppConstants.KEY_PASSWORD, value: _passController.text);
    }
    var authBloc = MyApp.of(context).authBloc;
    LoadingDialog.showLoadingDialog(context, "Loading...");
    authBloc.signIn(email, pass, () {
      LoadingDialog.hideLoadingDialog(context);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomePage()));
    }, (msg) {
      LoadingDialog.hideLoadingDialog(context);
      MsgDialog.showMsgDialog(context, "Sign-In", msg);
    });
  }
}
