import 'dart:convert';
import 'dart:math';

import 'package:acakkata/models/history_game_detail_model.dart';
import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/level_model.dart';
import 'package:acakkata/models/range_result_txt_model.dart';
import 'package:acakkata/models/relation_word.dart';
import 'package:acakkata/models/word_language_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  List<RelationWordModel>? _dataRelationWordList;
  List<RelationWordModel>? get dataRelationWordList => _dataRelationWordList;

  List<RangeResultTxtModel>? _dataRangeTextList;
  List<RangeResultTxtModel>? get rangeTextList => _dataRangeTextList;

  List<HistoryGameDetailModel>? _dataHistoryGameDetailList;
  List<HistoryGameDetailModel>? get dataHistoryGameDetailList =>
      _dataHistoryGameDetailList;

  int get numberCountDown => _numberCountDown;
  int get totalQuestion => _totalQuestion;

  Logger logger = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  static const NEW_DB_VERSION = 8;

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
      print("Begin check local Database...");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int versionDB = prefs.getInt("NEW_DB_VERSION") ?? 1;
      io.Directory applicationDirectory =
          await getApplicationDocumentsDirectory();
      String dbDictionaryPath = path.join(applicationDirectory.path, 'mydb.db');
      bool dbExistsDictionary = await io.File(dbDictionaryPath).exists();

      if (!dbExistsDictionary || versionDB < NEW_DB_VERSION) {
        ByteData data =
            await rootBundle.load(path.join("assets/db", 'mydb.db'));
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

        await io.File(dbDictionaryPath).writeAsBytes(bytes, flush: true);
        prefs.setInt("NEW_DB_VERSION", NEW_DB_VERSION);
      }

      _db = await openDatabase(dbDictionaryPath,
          version: NEW_DB_VERSION,
          onConfigure: onConfigure, onCreate: (db, version) async {
        var batch = db.batch();
        _createTableResultRangeV2(batch);
        await batch.commit();
      });
    } catch (e) {
      print(e);
    }
  }

  Future<bool> getWords(String? languageCode, int? lengthWord) async {
    try {
      if (_db == null) {
        throw "bd is not initiated, initiate using [init(db)] function";
      }
      late List<Map<String, dynamic>> words;

      if (languageCode == "english") {
        await _db.transaction((txn) async {
          words = await txn.query("tb_word_eng",
              columns: ["id", "word", "meaning", "length_word"],
              orderBy: "word",
              where: "length_word = ?",
              whereArgs: [lengthWord],
              limit: 4000);
        });
      } else if (languageCode == "indonesia") {
        await _db.transaction((txn) async {
          words = await txn.query("tb_word_indo",
              columns: ["id", "word", "meaning", "length_word"],
              orderBy: "word",
              where: "length_word = ?",
              whereArgs: [lengthWord],
              limit: 4000);
        });
      } else if (languageCode == "bali") {
        await _db.transaction((txn) async {
          words = await txn.query("tb_word_bali",
              columns: ["id", "word", "meaning", "length_word"],
              orderBy: "word",
              where: "length_word = ?",
              whereArgs: [lengthWord],
              limit: 4000);
        });
      } else if (languageCode == "java") {
        await _db.transaction((txn) async {
          words = await txn.query("tb_word_jawa",
              columns: ["id", "word", "meaning", "length_word"],
              orderBy: "word",
              where: "length_word = ?",
              whereArgs: [lengthWord],
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

  Future<List<Map<String, dynamic>>> getWordByRelation(
      {int? languageId, String? idRelation}) async {
    late List<Map<String, dynamic>> words;

    switch (languageId) {
      case 1:
        words = await _db.rawQuery(
            "SELECT * from tb_word_indo where id_relation=?", [idRelation]);
        break;
      case 2:
        words = await _db.rawQuery(
            "SELECT * from tb_word_eng where id_relation=?", [idRelation]);
        break;
      case 3:
        words = await _db.rawQuery(
            "SELECT * from tb_word_bali where id_relation=?", [idRelation]);
        break;
      case 4:
        words = await _db.rawQuery(
            "SELECT * from tb_word_jawa where id_relation=?", [idRelation]);
        break;
      default:
        words = await _db.rawQuery(
            "SELECT * from tb_word_indo where id_relation=?", [idRelation]);
        break;
    }

    return words;
  }

  Future<bool> getRelationalWords(
      {String? languageCode,
      int? lengthWord,
      int? languageId,
      int? questionNumber}) async {
    try {
      if (_db == null) {
        throw "bd is not initiated, initiate using [init(db)] function";
      }
      late List<Map<String, dynamic>> words;

      if (languageId == null) {
        if (languageCode == "english") {
          languageId = 2;
        } else if (languageCode == "indonesia") {
          languageId = 1;
        } else if (languageCode == "bali") {
          languageId = 3;
        } else if (languageCode == "java") {
          languageId = 4;
        }
      }

      await _db.transaction((txn) async {
        List<Map<String, dynamic>> countWordData = await txn.rawQuery(
            "SELECT COUNT(id) as count_word from tb_relation_word where language_id = ? and length_word = ?",
            [languageId, lengthWord]);
        int countWord = countWordData.first["count_word"];
        int randomOffset = Random().nextInt(countWord);

        if (randomOffset > (countWord - (questionNumber ?? 0))) {
          randomOffset = countWord - (questionNumber ?? 0);
        }
        words = await txn.rawQuery(
            "SELECT tb_relation_word.* from tb_relation_word where language_id = ? and length_word = ? limit 4000 offset ?",
            [languageId, lengthWord, randomOffset]);
      });

      _dataRelationWordList =
          words.map((e) => RelationWordModel.fromJson(e)).toList();
      _dataRelationWordList!.shuffle();

      _dataRelationWordList =
          _dataRelationWordList!.getRange(0, questionNumber ?? 5).toList();
      var i = 0;
      for (var relationWord in _dataRelationWordList!) {
        logger.d(relationWord.id);
        List<Map<String, dynamic>> listWords = await getWordByRelation(
            idRelation: relationWord.id, languageId: languageId);
        _dataRelationWordList![i].listWords =
            listWords.map((e) => WordLanguageModel.fromJson(e)).toList();
        i++;
      }

      // logger.d(json.encode(_dataRelationWordList));

      return true;
    } catch (e) {
      logger.e(e);
      throw Exception(e);
      return false;
    }
  }

  Future<bool> getRelationalWordsDict(
      {String? languageCode,
      int? lengthWord,
      int? languageId,
      int? questionNumber}) async {
    try {
      if (_db == null) {
        throw "bd is not initiated, initiate using [init(db)] function";
      }
      late List<Map<String, dynamic>> words;

      if (languageId == null) {
        if (languageCode == "english") {
          languageId = 2;
        } else if (languageCode == "indonesia") {
          languageId = 1;
        } else if (languageCode == "bali") {
          languageId = 3;
        } else if (languageCode == "java") {
          languageId = 4;
        }
      }

      await _db.transaction((txn) async {
        List<Map<String, dynamic>> countWordData = await txn.rawQuery(
            "SELECT COUNT(id) as count_word from tb_dict_word where language_id = ? and length_word = ?",
            [languageId, lengthWord]);
        int countWord = countWordData.first["count_word"];
        int randomOffset = Random().nextInt(countWord);

        if (randomOffset > (countWord - (questionNumber ?? 0))) {
          randomOffset = countWord - (questionNumber ?? 0);
        }
        words = await txn.rawQuery(
            "SELECT tb_dict_word.* from tb_dict_word where language_id = ? and length_word = ? limit 4000 offset ?",
            [languageId, lengthWord, randomOffset]);
      });

      _dataRelationWordList =
          words.map((e) => RelationWordModel.fromJson(e)).toList();
      _dataRelationWordList!.shuffle();

      _dataRelationWordList =
          _dataRelationWordList!.getRange(0, questionNumber ?? 5).toList();

      return true;
    } catch (e, stacktrace) {
      logger.e('Stacktrace: ' + stacktrace.toString());
      throw Exception(e);
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

  Future<bool> getLevel(String? languageCode) async {
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
            whereArgs: [languageCode]);
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

  Future<bool> setUpdateLevelProgress(int newScore, int? levelId) async {
    try {
      if (_db == null) {
        throw Exception("local data not found");
      }

      Map<String, dynamic> row = {"current_score": newScore};

      await _db.transaction((txn) async {
        int updateCount = await txn
            .update("tb_level", row, where: "id = ?", whereArgs: [levelId]);
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

  Future<bool> searchWord(
      {required String word, required String languageCode}) async {
    try {
      if (_db == null) {
        throw "bd is not initiated, initiate using [init(db)] function";
      }
      late List<Map<String, dynamic>> words;

      if (languageCode == "english") {
        await _db.transaction((txn) async {
          words = await txn.query("tb_word_eng",
              columns: ["id", "word", "meaning", "length_word"],
              orderBy: "word",
              where: "word like ?",
              whereArgs: ['%$word%'],
              limit: 100);
        });
      } else if (languageCode == "indonesia") {
        await _db.transaction((txn) async {
          words = await txn.query("tb_word_indo",
              columns: ["id", "word", "meaning", "length_word"],
              orderBy: "word",
              where: "word like ?",
              whereArgs: ['%$word%'],
              limit: 100);
        });
      } else if (languageCode == "bali") {
        await _db.transaction((txn) async {
          words = await txn.query("tb_word_bali",
              columns: ["id", "word", "meaning", "length_word"],
              orderBy: "word",
              where: "word like ?",
              whereArgs: ['%$word%'],
              limit: 100);
        });
      } else if (languageCode == "java") {
        await _db.transaction((txn) async {
          words = await txn.query("tb_word_jawa",
              columns: ["id", "word", "meaning", "length_word"],
              orderBy: "word",
              where: "word like ?",
              whereArgs: ['%$word%'],
              limit: 100);
        });
      }
      _dataWordList = words.map((e) => WordLanguageModel.fromJson(e)).toList();
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> saveSingleHistoryGameDetail(
      {required HistoryGameDetailModel? historyGameDetailModel}) async {
    _dataHistoryGameDetailList!.add(historyGameDetailModel!);
  }

  Future<void> resetSingleHistoryGameDetail() async {
    if (_dataHistoryGameDetailList != null) {
      _dataHistoryGameDetailList!.clear();
    } else {
      _dataHistoryGameDetailList = [];
    }
  }

  Future<void> setSingleHistoryGameDetail() async {
    _dataHistoryGameDetailList = [];
  }
}
