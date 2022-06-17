import 'package:acakkata/models/language_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LanguageService {
  String baseUrl = 'http://10.0.2.2:3000/api/v1/language';

  Future<List<LanguageModel>> getLanguage() async {
    var url = Uri.parse('$baseUrl/language');
    var headers = {'Content-Type': 'application/json'};

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['data'];

      List<LanguageModel> listLanguage = [];

      for (var item in data) {
        listLanguage.add(LanguageModel.fromJson(item));
      }
      return listLanguage;
    } else {
      throw Exception('Gagal Get Language!');
    }
  }
}
