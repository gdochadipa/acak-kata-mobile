import 'dart:developer';

import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/level_model.dart';
import 'package:acakkata/models/range_result_txt_model.dart';
import 'package:acakkata/models/word_language_model.dart';
import 'package:acakkata/models/word_language_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'dart:io' as io;

class LanguageDBProvider with ChangeNotifier {
  late Database _db;
  late int _numberCountDown;
  late int _totalQuestion;

  List<WordLanguageModel>? _dataWordList;
  List<WordLanguageModel>? get dataWordList => _dataWordList;

  List<LanguageModel>? _languageList;
  List<LanguageModel>? get languageList => _languageList;

  List<LevelModel>? _levelList;
  List<LevelModel>? get levelList => _levelList;

  List<int>? _queueQuestion;
  List<int>? get queueQuestion => _queueQuestion;

  List<RangeResultTxtModel>? _dataRangeTextList;
  List<RangeResultTxtModel>? get rangeTextList => _dataRangeTextList;

  int get numberCountDown => _numberCountDown;
  int get totalQuestion => _totalQuestion;

  setRuleGame(int? numberCountDown, int? totalQuestion) {
    _numberCountDown = numberCountDown ?? 15;
    _totalQuestion = totalQuestion ?? 15;
  }

  Future onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  void _createTableResultRangeV2(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS tb_result_range');
    batch.execute('''CREATE TABLE tb_result_range (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name_range_id TEXT,
    name_range_en TEXT,
    range_min INTEGER,
    range_max INTEGER
)''');
    batch.execute(''' 
      INSERT INTO "tb_result_range" ("id","name_range_id","name_range_en","range_min","range_max") VALUES (1,'Super','Super',90,100),
 (2,'Bagus','Good',70,89),
 (3,'Cukup','Enough',60,69),
 (4,'Kurang','Not Enough',0,56)
    ''');
  }

  Future<void> init() async {
    try {
      io.Directory applicationDirectory =
          await getApplicationDocumentsDirectory();
      String dbDictionaryPath = path.join(applicationDirectory.path, 'mydb.db');
      bool dbExistsDictionary = await io.File(dbDictionaryPath).exists();
      if (!dbExistsDictionary) {
        ByteData data =
            await rootBundle.load(path.join("assets/db", 'mydb.db'));
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

        await io.File(dbDictionaryPath).writeAsBytes(bytes, flush: true);
      }

      _db = await openDatabase(dbDictionaryPath,
          version: 1, onConfigure: onConfigure, onCreate: (db, version) async {
        var batch = db.batch();
        _createTableResultRangeV2(batch);
        await batch.commit();
      });
    } catch (e) {
      print(e);
    }
  }

  Future<bool> getWords(String? language_code, int? length_word) async {
    try {
      if (_db == null) {
        throw "bd is not initiated, initiate using [init(db)] function";
      }
      late List<Map<String, dynamic>> words;

      if (language_code == "english") {
        await _db.transaction((txn) async {
          words = await txn.query("tb_word_eng",
              columns: ["id", "word", "meaning", "length_word"],
              orderBy: "word",
              where: "length_word = ?",
              whereArgs: [length_word],
              limit: 4000);
        });
      } else if (language_code == "indonesia") {
        await _db.transaction((txn) async {
          words = await txn.query("tb_word_indo",
              columns: ["id", "word", "meaning", "length_word"],
              orderBy: "word",
              where: "length_word = ?",
              whereArgs: [length_word],
              limit: 4000);
        });
      } else if (language_code == "bali") {
        await _db.transaction((txn) async {
          words = await txn.query("tb_word_bali",
              columns: ["id", "word", "meaning", "length_word"],
              orderBy: "word",
              where: "length_word = ?",
              whereArgs: [length_word],
              limit: 4000);
        });
      } else if (language_code == "java") {
        await _db.transaction((txn) async {
          words = await txn.query("tb_word_jawa",
              columns: ["id", "word", "meaning", "length_word"],
              orderBy: "word",
              where: "length_word = ?",
              whereArgs: [length_word],
              limit: 4000);
        });
      }

      _dataWordList = words.map((e) => WordLanguageModel.fromJson(e)).toList();
      _dataWordList!.shuffle();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> getLanguage() async {
    try {
      if (_db == null) {
        throw Exception("local data not found");
      }
      late List<Map<String, dynamic>> languages;

      await _db.transaction((txn) async {
        languages = await txn.query("tb_language", columns: [
          "id",
          "language_name",
          "language_icon",
          "language_code",
          "language_name_en",
          "language_name_id"
        ]);
      });

      _languageList = languages.map((e) => LanguageModel.fromJson(e)).toList();

      return true;
    } catch (e) {
      throw Exception(e);
      return false;
    }
  }

  Future<bool> getLevel(String? language_code) async {
    try {
      if (_db == null) {
        throw Exception("local data not found");
      }
      late List<Map<String, dynamic>> levels;

      await _db.transaction((txn) async {
        levels = await txn.query("tb_level",
            columns: [
              "id",
              "level_name",
              "level_words",
              "level_time",
              "level_question_count",
              "level_lang_id",
              "level_lang_code",
              "is_unlock",
              "current_score",
              "target_score",
              "sorting_level"
            ],
            where: "level_lang_code = ?",
            whereArgs: [language_code]);
      });

      _levelList = levels.map((e) => LevelModel.fromJson(e)).toList();
      return true;
    } catch (e) {
      throw Exception(e);
      return false;
    }
  }

  Future<bool> getRangeText() async {
    try {
      if (_db == null) {
        throw Exception("local data not found");
      }
      late List<Map<String, dynamic>> rangeText;

      await _db.transaction((txn) async {
        rangeText = await txn.query('tb_result_range', columns: [
          "id",
          "name_range_id",
          "name_range_en",
          "range_min",
          "range_max"
        ]);

        _dataRangeTextList =
            rangeText.map((e) => RangeResultTxtModel.fromJson(e)).toList();
      });
      return true;
    } catch (e) {
      throw Exception(e);
      return false;
    }
  }

  Future<bool> setUpdateLevelProgress(int newScore, int? level_id) async {
    try {
      if (_db == null) {
        throw Exception("local data not found");
      }

      Map<String, dynamic> row = {"current_score": newScore};

      await _db.transaction((txn) async {
        int updateCount = await txn
            .update("tb_level", row, where: "id = ?", whereArgs: [level_id]);
        print("update tb_level ${updateCount}");
      });

      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> updateNextLevel(LevelModel? levelModel) async {
    try {
      if (_db == null) {
        throw Exception("local data not found");
      }
      late List<Map<String, dynamic>> levels;
      Map<String, dynamic> row = {"is_unlock": 1};

      int nextLevel = (levelModel!.sorting_level ?? 0) + 1;

      await _db.transaction((txn) async {
        levels = await txn.query("tb_level",
            columns: [
              "id",
              "level_name",
              "level_words",
              "level_time",
              "level_question_count",
              "level_lang_id",
              "level_lang_code",
              "is_unlock",
              "current_score",
              "target_score",
              "sorting_level"
            ],
            where: "level_lang_code = ? AND sorting_level = ?",
            limit: 1,
            orderBy: "sorting_level DESC",
            whereArgs: [levelModel.level_lang_code, nextLevel]);
        print("length ${levels.length}");

        if (levels.isNotEmpty) {
          await txn.update("tb_level", row,
              where: "level_lang_code = ? AND sorting_level = ?",
              whereArgs: [levelModel.level_lang_code, nextLevel]);
        }
      });

      return true;
    } catch (e) {
      throw Exception(e);
    }
  }
}
