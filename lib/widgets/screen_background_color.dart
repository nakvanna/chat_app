import 'package:flutter/material.dart';

Container screenBackgroundColor(
    {Scaffold scaffold, List<Color> colors, Alignment begin, Alignment end}) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: begin,
        end: end,
        colors: colors,
      ),
    ),
    child: scaffold,
  );
}
