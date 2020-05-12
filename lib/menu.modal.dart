import 'package:flutter/material.dart';

class Menu {
  final String title;
  final IconData icon;
  final Widget routeTo;
  final Color lightColor;
  final Color darkColor;

  Menu({this.title, this.icon, this.routeTo, this.lightColor, this.darkColor});
}
