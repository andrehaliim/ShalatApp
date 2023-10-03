import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shalat_app/constant.dart';
import 'package:shalat_app/model.dart';

Future<ShalatModel>getShalatData(String cityId) async {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat("yyyy/MM/dd").format(now);
  String url = '$constantUrl/sholat/jadwal/$cityId/$formattedDate';

  try {
    final response =
    await http.get(Uri.parse(url)).timeout(Duration(
      seconds: constantTimeout,
    ));

    //Debug
    debugPrint(url);
    debugPrint(response.body);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      final data = jsonData['data'];
      final shalatdata = ShalatModel.fromJson(data);

      return shalatdata;
    } else {
      throw Exception('Failed to get shalat data (${response.statusCode})');
    }
  } catch (error) {
    throw Exception('Failed to fetch shalat data');
  }
}

Future<List<Map<String, String>>> getCityList() async {
  String url = '$constantUrl/sholat/kota/semua';

  try {
    final response =
    await http.get(Uri.parse(url)).timeout(Duration(
      seconds: constantTimeout,
    ));

    //Debug
    debugPrint(url);
    debugPrint(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<Map<String, String>> fetchedOptions = [];

      for (var item in data) {
        fetchedOptions.add({
          'id': item['id'],
          'lokasi': item['lokasi'],
        });
      }

      return fetchedOptions;
    } else {
      throw Exception('Failed to get shalat data (${response.statusCode})');
    }
  } catch (error) {
    throw Exception('Failed to fetch shalat data');
  }
}