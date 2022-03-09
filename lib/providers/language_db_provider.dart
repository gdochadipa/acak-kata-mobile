import 'dart:developer';

import 'package:acakkata/models/word_language_model.dart';
import 'package:acakkata/models/word_language_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'dart:io' as io;

class LanguageDBProvider1 with ChangeNotifier {
  late Database _db;
  late int _numberCountDown;
  late int _totalQuestion;

  List<WordLanguageModel>? _dataWordList;
  List<WordLanguageModel>? get dataWordList => _dataWordList;

  List<int>? _queueQuestion;
  List<int>? get queueQuestion => _queueQuestion;

  int get numberCountDown => _numberCountDown;
  int get totalQuestion => _totalQuestion;

  setRuleGame(int? numberCountDown, int? totalQuestion) {
    _numberCountDown = numberCountDown ?? 15;
    _totalQuestion = totalQuestion ?? 15;
  }

  Future<void> init() async {
    io.Directory applicationDirectory =
        await getApplicationDocumentsDirectory();
    String dbDictionaryPath = path.join(applicationDirectory.path, 'mydb.db');
    bool dbExistsDictionary = await io.File(dbDictionaryPath).exists();
    if (!dbExistsDictionary) {
      ByteData data = await rootBundle.load(path.join("assets/db", 'mydb.db'));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await io.File(dbDictionaryPath).writeAsBytes(bytes, flush: true);
    }

    _db = await openDatabase(dbDictionaryPath);
  }

  Future<bool> getWords(String language_code) async {
    try {
      if (_db == null) {
        throw "bd is not initiated, initiate using [init(db)] function";
      }
      late List<Map<String, dynamic>> words;

      if (language_code == "english") {
        await _db.transaction((txn) async {
          words = await txn.query("tb_word_eng",
              columns: ["id", "word", "meaning"], orderBy: "word", limit: 2000);
        });
      } else if (language_code == "indonesia") {
        await _db.transaction((txn) async {
          words = await txn.query("tb_word_indo",
              columns: ["id", "word", "meaning"], orderBy: "word", limit: 2000);
        });
      } else if (language_code == "bali") {
        await _db.transaction((txn) async {
          words = await txn.query("tb_word_bali",
              columns: ["id", "word", "meaning"], orderBy: "word", limit: 2000);
        });
      } else if (language_code == "java") {
        await _db.transaction((txn) async {
          words = await txn.query("tb_word_jawa",
              columns: ["id", "word", "meaning"], orderBy: "word", limit: 2000);
        });
      }

      _dataWordList = words.map((e) => WordLanguageModel.fromJson(e)).toList();
      _dataWordList!.shuffle();

      return true;
    } catch (e) {
      return false;
    }
  }
}
