import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pks_mobile/helper/custom_font_style.dart';
import 'package:pks_mobile/widgets/screen_background_color.dart';

class StudentClasses extends StatelessWidget {
  final CustomFontStyle customFontStyle = CustomFontStyle();
  final List<String> subjects = [
    'Chemistry',
    'Khmer',
    'Mathematics',
    'Physics',
    'Biology',
    'Geology',
  ];

  @override
  Widget build(BuildContext context) {
    return screenBackgroundColor(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.purple, Colors.orange],
      scaffold: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              'my classes'.tr,
              style: customFontStyle.appBarTitleTextStyle(),
            ),
            centerTitle: true,
            floating: true,
            pinned: true,
            elevation: 0,
            expandedHeight: 100,
            shadowColor: Colors.black,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(top: 100),
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    onChanged: (val) {},
                    decoration: InputDecoration(
                        icon: Icon(Icons.search),
                        hintText: 'Search ...',
                        hintStyle: TextStyle(color: Colors.black26),
                        border: InputBorder.none),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Tooltip(
                message: 'Available to join now',
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(
                      'assets/images/subjects.jpg',
                    ),
                  ),
                  title: Text('${subjects[index]}'),
                  subtitle: Text('Teach by : Mr.VICHEA'),
                  trailing: Icon(
                    Icons.circle,
                    color: Colors.green,
                  ),
                ),
              );
            }, childCount: subjects.length),
          )
        ]),
      ),
    );
  }
}
