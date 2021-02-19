import 'package:ScaledList/category.dart';
import 'package:flutter/material.dart';

const List<Color> kMixedColors = [
  Color(0xff71A5D7),
  Color(0xff72CCD4),
  Color(0xffFBAB57),
  Color(0xffF8B993),
  Color(0xff962D17),
  Color(0xffc657fb),
  Color(0xfffb8457),
];

class Data {
  static final List<Category> categories = [
    Category(image: "assets/images/1.png", name: "Beef"),
    Category(image: "assets/images/2.png", name: "Chicken"),
    Category(image: "assets/images/3.png", name: "Dessert"),
    Category(image: "assets/images/4.png", name: "Lamb"),
    Category(image: "assets/images/5.png", name: "Pasta"),
  ];
}
