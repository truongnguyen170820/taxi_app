import 'package:timesoft/widget/global.dart';
import 'package:flutter/material.dart';
import 'color_utils.dart';

class TextStyles {
  static final String font = 'Roboto';
  static final String font1 = 'SFUIText';
  static TextStyle copy(
      {Color color,
        double fontSize,
        FontWeight fontWeight,
        TextDecoration decoration}) =>
      TextStyle(
          color: color ?? Colors.white,
          fontSize: fontSize ?? 16,
          fontFamily: font,
          fontWeight: fontWeight ?? FontWeight.normal,
          decoration: decoration);
  static TextStyle hint = TextStyle(fontFamily: font1, fontSize: setSp(12), color: ColorUtils.gray6,);
  static TextStyle menu_text = TextStyle(fontFamily: font, color: Colors.white, fontSize: setSp(18));
  static TextStyle button_text = TextStyle(fontFamily: font, color: Colors.white, fontSize: setSp(13), fontWeight: FontWeight.bold);
  static TextStyle common_text = TextStyle(fontFamily: font1, color: ColorUtils.gray3, fontSize: setSp(12), fontWeight: FontWeight.bold);
  static TextStyle common_large = TextStyle(fontFamily: font1, color: ColorUtils.gray2, fontSize: setSp(14), fontWeight: FontWeight.bold);
  static TextStyle common_black = TextStyle(fontFamily: font1, color: ColorUtils.gray2, fontSize: setSp(13), fontWeight: FontWeight.bold);
  static TextStyle appbar_text = TextStyle(fontFamily: font, color: Colors.white, fontSize: setSp(16), fontWeight: FontWeight.bold);
  static TextStyle drawer_text = TextStyle(fontFamily: font, color: ColorUtils.gray2, fontSize: setSp(13), fontWeight: FontWeight.bold);
  static TextStyle dialog_text = TextStyle(fontFamily: font, color: Colors.black, fontSize: setSp(12), fontWeight: FontWeight.bold);
  static TextStyle text = TextStyle(fontFamily: font);
  static TextStyle textColor({Color color}) => TextStyle(fontFamily: font, color: color);
}
