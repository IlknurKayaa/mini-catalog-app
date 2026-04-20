import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:minicatalog/models/produtcs_model.dart';

class ApiService {
  Future<ProdutcModel> fetchPRoduct() async {
    final response = await http
        .get(Uri.parse("https://www.wantapi.com/products.php"))
        .timeout(
          Duration(seconds: 2),
          onTimeout: () {
            throw Exception("Timeout");
          },
        );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ProdutcModel.fromJson(data);
    } else {
      throw Exception("Yüklenirken ibr hata oluştur...");
    }
  }
}
