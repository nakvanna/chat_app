import 'package:flutter/material.dart';

class MenuItems extends StatelessWidget {
  MenuItems(
      {this.colorData, this.imageAsset, this.textLabel, @required this.onTab});

  final Color colorData;
  final String imageAsset;
  final String textLabel;
  final Function onTab;

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Card(
      elevation: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: onTab,
            child: Image.asset(
              imageAsset,
              height: _size.height / 9,
              width: _size.width / 9,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Flexible(
            child: Text(
              textLabel,
              style: TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
