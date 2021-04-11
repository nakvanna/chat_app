import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GroupCreator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text('New Message'),
              centerTitle: true,
              floating: true,
              pinned: true,
              elevation: 20,
              expandedHeight: 100,
              shadowColor: Colors.black,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: EdgeInsets.only(top: 50),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: TextField(
                      autofocus: true,
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
                  title: Text('Hello $index'),
                );
              }, childCount: 50),
            ),
          ],
        ),
      ),
    );
  }
}
