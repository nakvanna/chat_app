import 'package:flutter/material.dart';

class ListTileUser extends StatelessWidget {
  const ListTileUser({
    @required this.leading,
    this.title,
    this.subTitle,
    this.subTitleDate: '',
    this.subTitleBold: false,
  });

  final String leading;
  final String title;
  final String subTitle;
  final String subTitleDate;
  final bool subTitleBold;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: leading == ""
            ? Image.asset(
                'assets/images/account_image.png',
                width: 30,
              )
            : CircleAvatar(
                backgroundImage: NetworkImage(leading),
              ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: subTitleBold
                      ? Text(
                          subTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : Text(
                          subTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.black),
                        ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(subTitleDate)
              ],
            )
          ],
        ));
  }
}
