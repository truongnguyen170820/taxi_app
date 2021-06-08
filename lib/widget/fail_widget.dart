import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taxi_app/utils/text_style.dart';
class FailWidget extends StatelessWidget {

  String mess = "Lỗi lấy dữ liệu, chạm để thử lại.";

  FailWidget({this.mess});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            mess, style: TextStyles.common_large,
          ),
      ),
    );
  }
}