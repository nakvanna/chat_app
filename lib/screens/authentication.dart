import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pks_mobile/controllers/auth_controller.dart';
import 'package:pks_mobile/widgets/custom_icon.dart';
import 'package:pks_mobile/widgets/login_form.dart';
import 'package:pks_mobile/widgets/signup_form.dart';
import 'package:pks_mobile/widgets/social_icon.dart';

class Authentication extends GetView<AuthController> {
  final _isSigUp = RxBool(false);
  final _isGoogleLogin = RxBool(false);

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: ScreenUtil.getInstance().setWidth(120),
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Opacity(
                  opacity: .6,
                  child: Image.asset(
                    'assets/images/login.png',
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  constraints: BoxConstraints(maxHeight: double.infinity),
                ),
              ),
              Image.asset(
                'assets/images/building.png',
                fit: BoxFit.fill,
              ),
            ],
          ),
          SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.fromLTRB(28.0, 60.0, 28.0, bottom),
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/logo.jpg',
                      width: ScreenUtil.getInstance().setWidth(110),
                      height: ScreenUtil.getInstance().setHeight(110),
                    ),
                    Text(
                      'LOGO',
                      style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(46),
                        letterSpacing: .6,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(110),
                ),
                Obx(() => _isSigUp.value == false ? LoginForm() : SignUpForm()),
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(40),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    horizontalLine(),
                    Text(
                      'Social Login',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    horizontalLine(),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(40),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SocialIcon(
                      colors: [
                        Color(0xff102397),
                        Color(0xff187adf),
                        Color(0xff00eaf8),
                      ],
                      loading: false,
                      iconData: CustomIcon.facebook,
                      onPressed: () {},
                    ),
                    Obx(
                      () => SocialIcon(
                        colors: [
                          Color(0xffff4f38),
                          Color(0xffff355d),
                        ],
                        iconData: CustomIcon.googlePLus,
                        loading: _isGoogleLogin.value,
                        onPressed: () async {
                          _isGoogleLogin.value = true;
                          await controller.googleSignIn();
                          _isGoogleLogin.value = false;
                        },
                      ),
                    ),
                    SocialIcon(
                      colors: [
                        Color(0xff17ead9),
                        Color(0xff6078ea),
                      ],
                      loading: false,
                      iconData: CustomIcon.twitter,
                      onPressed: () {},
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(40),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'New User? ',
                      style: TextStyle(),
                    ),
                    InkWell(
                      onTap: () {
                        _isSigUp.value = !_isSigUp.value;
                      },
                      child: Obx(() {
                        return _isSigUp.value == false
                            ? Text(
                                'SIGNUP',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff5d74e3)),
                              )
                            : Text(
                                'SIGNIN',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff5d74e3)),
                              );
                      }),
                    )
                  ],
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
