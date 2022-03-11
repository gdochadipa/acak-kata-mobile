import 'dart:convert';
import 'dart:io';

import 'package:acakkata/models/room_match_model.dart';
import 'package:acakkata/models/word_language_model.dart';
import 'package:http/http.dart' as http;

class RoomService {
  String baseUrl = 'http://10.0.2.2:3000/api/v1/room';

  Future<RoomMatchModel> createRoom(String language_id, int time_watch,
      int max_player, int total_question, String token) async {
    var url = Uri.parse('$baseUrl/create-room');
    print(url);
    var headers = {'Content-Type': 'application/json', 'Authorization': token};
    var body = jsonEncode({
      'language_id': language_id,
      'time_watch': time_watch,
      'max_player': max_player,
      'total_question': total_question
    });

    var response = await http.post(url, headers: headers, body: body);
    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      RoomMatchModel roomMatch = RoomMatchModel.fromJson(data);
      return roomMatch;
    } else {
      if (response.statusCode == 403) {
        var data = jsonDecode(response.body);
        throw Exception(data['message']);
      } else {
        throw Exception("Gagal Membuat Room");
      }
    }
  }

  Future<RoomMatchModel> findRoomWithCode(
      String language_id, String token, String room_code) async {
    var url = Uri.parse('$baseUrl/search-code-room');
    print(url);
    var headers = {'Content-Type': 'application/json', 'Authorization': token};
    var body = jsonEncode({'language_id': language_id, 'room_code': room_code});

    var response = await http.post(url, headers: headers, body: body);
    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      RoomMatchModel roomMatch = RoomMatchModel.fromJson(data);

      return roomMatch;
    } else {
      if (response.statusCode == 403) {
        var data = jsonDecode(response.body);
        throw Exception(data['message']);
      } else {
        throw Exception("Gagal Mencari Room");
      }
    }
  }

  Future<RoomMatchModel> checkingRoomWithRoomCode(
      String language_id, String token, String room_code) async {
    var headers = {'Content-Type': 'application/json', 'Authorization': token};
    var query_parameter = {'language_id': language_id, 'room_code': room_code};
    final url = Uri.http('$baseUrl', '/find-room', query_parameter);
    print(url);

    var response = await http.get(url, headers: headers);
    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      RoomMatchModel roomMatch = RoomMatchModel.fromJson(data);

      return roomMatch;
    } else {
      if (response.statusCode == 403) {
        var data = jsonDecode(response.body);
        throw Exception(data['message']);
      } else {
        throw Exception("Gagal Mencari Room");
      }
    }
  }

  Future<bool> confirmGame(String token, String room_id) async {
    var url = Uri.parse('$baseUrl/confirm-game');
    var headers = {'Content-Type': 'application/json', 'Authorization': token};
    var body = jsonEncode({'room_id': room_id});
    var response = await http.post(url, headers: headers, body: body);
    print(response.body);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Gagal confirmasi Room');
    }
  }

  Future<bool> cancelGameFromRoom(String token, String room_id) async {
    var url = Uri.parse('$baseUrl/cancel-room');
    var headers = {'Content-Type': 'application/json', 'Authorization': token};
    var body = jsonEncode({'room_id': room_id});
    var response = await http.post(url, headers: headers, body: body);
    print(response.body);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Gagal confimrasi Room');
    }
  }

  Future<List<WordLanguageModel>> getPackageQuestion(
      String token, String language_id, int question_num) async {
    var headers = {'Content-Type': 'application/json', 'Authorization': token};
    var query_parameter = {
      'language_id': language_id,
      'question_num': question_num
    };
    final url = Uri.http('$baseUrl', '/package-question', query_parameter);
    var response = await http.get(url, headers: headers);
    print(response.body);

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      List<WordLanguageModel> listWord = [];

      for (var item in data) {
        listWord.add(WordLanguageModel.fromJson(item));
      }
      return listWord;
    } else {
      throw Exception('Gagal confimrasi Room');
    }
  }
}
