import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FormCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      // height: ScreenUtil.getInstance().setHeight(500),
      decoration: BoxDecoration(
          color: Colors.white60,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, 15.0),
              blurRadius: 15.0,
            ),
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, -10.0),
              blurRadius: 10.0,
            )
          ]
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Login',
              style: TextStyle(
                  fontSize: ScreenUtil.getInstance().setSp(45),
                  letterSpacing: .6,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(30),
            ),
            Text(
              'Username',
              style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(32),),
            ),
            TextField(
              decoration: InputDecoration(
                  hintText: 'email',
                  hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey)
              ),
            ),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(30),
            ),
            Text(
              'password',
              style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(32),),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                  hintText: 'password',
                  hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey)
              ),
            ),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(35),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  'Forget password?',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: ScreenUtil.getInstance().setSp(28),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
