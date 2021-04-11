import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthButton extends StatelessWidget {
  final bool loading;
  final String label;
  final Function onPressed;

  AuthButton({this.loading, this.label, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: loading
          ? Container(
              width: ScreenUtil.getInstance().setWidth(300),
              height: ScreenUtil.getInstance().setHeight(100),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xff17ead9),
                    Color(0xff6078ea),
                  ]),
                  borderRadius: BorderRadius.circular(6.0),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff6078ea).withOpacity(.3),
                      offset: Offset(0.0, 8.0),
                      blurRadius: 8.0,
                    )
                  ]),
              child: Center(child: CircularProgressIndicator()))
          : Container(
              width: ScreenUtil.getInstance().setWidth(300),
              height: ScreenUtil.getInstance().setHeight(100),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xff17ead9),
                    Color(0xff6078ea),
                  ]),
                  borderRadius: BorderRadius.circular(6.0),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff6078ea).withOpacity(.3),
                      offset: Offset(0.0, 8.0),
                      blurRadius: 8.0,
                    )
                  ]),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    onPressed();
                  },
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
