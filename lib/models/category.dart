import '../utilities/constans.dart';
import 'package:flutter/material.dart';

class Category {
  final String icon;
  final String title;
  final String subtitle;
  final Color color;
  Category({this.icon, this.subtitle, this.title, this.color});
}

List<Category> categoryList = [
  Category(
    icon: "assets/images/hairdresser_ic.png",
    title: "Hair",
    subtitle: "5",
    color: kGreen,
  ),
  Category(
    icon: "assets/images/wellness_ic.png",
    title: "Spa",
    subtitle: "59",
    color: kYellow,
  ),
  Category(
    icon: "assets/images/nails_ic.png",
    title: "Nails",
    subtitle: "23",
    color: kGrey,
  ),
  Category(
    icon: "assets/images/massage_ic.png",
    title: "Massage",
    subtitle: "10",
    color: Colors.yellow[50],
  ),
];

List<Category> showMoreCategory=[
  Category(
    icon: "assets/images/sport_ic.png",
    title: "Sport",
    subtitle: "55",
    color: Colors.blue[100],
  ),
  Category(
    icon: "assets/images/other_ic.png",
    title: "Other",
    subtitle: "15",
    color: kIndigo,
  ),
];

List<Category> allofthecategories = [
  Category(
    icon: "assets/images/hairdresser_ic.png",
    title: "Hair",
    subtitle: "5",
    color: kGreen,
  ),
  Category(
    icon: "assets/images/wellness_ic.png",
    title: "Spa",
    subtitle: "59",
    color: kYellow,
  ),
  Category(
    icon: "assets/images/nails_ic.png",
    title: "Nails",
    subtitle: "23",
    color: kGrey,
  ),
  Category(
    icon: "assets/images/massage_ic.png",
    title: "Massage",
    subtitle: "10",
    color: Colors.yellow[50],
  ),
  Category(
    icon: "assets/images/sport_ic.png",
    title: "Sport",
    subtitle: "55",
    color: Colors.blue[100],
  ),
  Category(
    icon: "assets/images/other_ic.png",
    title: "Other",
    subtitle: "15",
    color: kIndigo,
  ),
];
