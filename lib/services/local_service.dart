import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/produtcs_model.dart';

class LocalService {
  Future<List<Data>> loadFakeProducts() async {
    final String response = await rootBundle.loadString(
      'assets/data/fake_products.json',
    );

    final Map<String, dynamic> jsonData = jsonDecode(response);

    return (jsonData['data'] as List).map((e) => Data.fromJson(e)).toList();
  }
}
