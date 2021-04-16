import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pks_mobile/helper/custom_font_style.dart';
import 'package:pks_mobile/widgets/screen_background_color.dart';

class TeacherClasses extends StatelessWidget {
  final CustomFontStyle customFontStyle = CustomFontStyle();
  final List<String> classes = [
    'Grade 12 A',
    'Grade 10 B',
    'Grade 11 B',
    'Grade 9 A',
    'Grade 12 A',
    'Grade 11 D',
    'Grade 10 C',
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
              'my grades'.tr,
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
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/images/subjects.jpg',
                  ),
                ),
                title: Text('${classes[index]}'),
                subtitle: Text('Teach time : 09:00 AM'),
                trailing: Icon(
                  Icons.circle,
                  color: Colors.green,
                ),
              );
            }, childCount: classes.length),
          )
        ]),
      ),
    );
  }
}
