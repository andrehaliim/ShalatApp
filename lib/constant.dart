import 'package:flutter/material.dart';

String constantUrl = 'https://api.myquran.com/v1';
int constantTimeout = 10;
double constantWidth = 0.0;
double constantHeight = 0.0;

void setConstantSize(BuildContext context) {
  constantWidth = MediaQuery.of(context).size.width;
  constantHeight = MediaQuery.of(context).size.height;
}