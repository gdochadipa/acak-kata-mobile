import 'dart:convert';

import 'package:acakkata/models/relation_word.dart';
import 'package:acakkata/models/room_match_model.dart';
import 'package:acakkata/models/word_language_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class RoomService {
  String baseUrl = 'http://139.59.117.124:3000/api/v1/room';
  // String baseUrl = 'http://10.0.2.2:3000/api/v1/room';
  Logger logger = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );
  Future<RoomMatchModel> createRoom(
      String languageCode,
      int timeMatch,
      int maxPlayer,
      int totalQuestion,
      String token,
      DateTime datetimeMatch,
      int level,
      int lengthWord) async {
    var url = Uri.parse('$baseUrl/create-room');
    var dateUtc = DateTime.now();
    print(url);
    var headers = {'Content-Type': 'application/json', 'Authorization': token};
    var body = jsonEncode({
      'language_code': languageCode,
      'time_match': timeMatch,
      'max_player': maxPlayer,
      'total_question': totalQuestion,
      'datetime_match': datetimeMatch.toString(),
      'datetime_client': DateFormat('yyyy-MM-dd hh:mm').format(dateUtc),
      'level': level,
      'length_word': lengthWord
    });
    logger.d(body);

    var response = await http.post(url, headers: headers, body: body);
    // logger.d(response.body);
    // print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      logger.d(data);
      RoomMatchModel roomMatch = RoomMatchModel.fromJson(data);
      return roomMatch;
    } else {
      if (response.statusCode == 403) {
        var data = jsonDecode(response.body);
        throw Exception("Server: ${data['message']}");
      } else {
        throw Exception("Gagal Membuat Room ${response.statusCode}");
      }
    }
  }

  Future<RoomMatchModel> findRoomWithCode(
      String languageCode, String token, String roomCode) async {
    var url = Uri.parse('$baseUrl/search-code-room');
    print(url);
    var headers = {'Content-Type': 'application/json', 'Authorization': token};
    var body =
        jsonEncode({'language_code': languageCode, 'room_code': roomCode});

    var response = await http.post(url, headers: headers, body: body);
    logger.d(response.body);

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
      String languageId, String token, String roomCode) async {
    var headers = {'Content-Type': 'application/json', 'Authorization': token};
    var queryParameter = {'language_id': languageId, 'room_code': roomCode};
    final url = Uri.http(baseUrl, '/find-room', queryParameter);
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

  Future<bool> confirmGame(String token, String roomId) async {
    var url = Uri.parse('$baseUrl/confirm-game');
    var headers = {'Content-Type': 'application/json', 'Authorization': token};
    var body = jsonEncode({'room_id': roomId});
    var response = await http.post(url, headers: headers, body: body);
    print(response.body);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Gagal confirmasi Room');
    }
  }

  Future<bool> cancelGameFromRoom(String token, String roomId) async {
    var url = Uri.parse('$baseUrl/cancel-room');
    var headers = {'Content-Type': 'application/json', 'Authorization': token};
    var body = jsonEncode({'room_id': roomId});
    var response = await http.post(url, headers: headers, body: body);
    print(response.body);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Gagal confimrasi Room');
    }
  }

  Future<List<WordLanguageModel>> getPackageQuestion(
      String token,
      String languageCode,
      int questionNum,
      String channelCode,
      int lengthWord) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': token
      };

      final url = Uri.parse(
          '$baseUrl/package-question?language_code=$languageCode&question_num=$questionNum&channel_code=$channelCode&length_word=$lengthWord');
      // final url = Uri.http('$baseUrl', '/package-question', query_parameter);
      var response = await http.get(url, headers: headers);
      logger.d(response.body);

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'];
        List<WordLanguageModel> listWord = [];

        for (var item in data) {
          listWord.add(WordLanguageModel.fromJson(item));
        }
        return listWord;
      } else {
        throw Exception('Gagal panggil pertanyaan');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<RelationWordModel>> getPackageRelatedQuestion(
      String token,
      String languageCode,
      int questionNum,
      String channelCode,
      int lengthWord) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': token
      };

      final url = Uri.parse(
          '$baseUrl/package-question/related-word?language_code=$languageCode&question_num=$questionNum&channel_code=$channelCode&length_word=$lengthWord');

      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'];
        logger.d(data);
        List<RelationWordModel> listWord = [];

        for (var item in data) {
          RelationWordModel relationData = RelationWordModel.fromJson(item);

          listWord.add(relationData);
        }
        return listWord;
      } else {
        throw Exception('Gagal panggil pertanyaan');
      }
    } catch (e, stacktrace) {
      print('Stacktrace: ' + stacktrace.toString());
      throw Exception(e);
    }
  }

  Future<RoomMatchModel> findRoomMatchByID(
      {required String id, required String token}) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': token
      };

      final url = Uri.parse('$baseUrl/find-room-by-id?id=$id');
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];
        logger.d(data);
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
    } catch (e) {
      throw Exception(e);
    }
  }
}
