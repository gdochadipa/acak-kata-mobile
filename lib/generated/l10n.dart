// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Hi Welcome`
  String get welcome {
    return Intl.message(
      'Hi Welcome',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `List Language`
  String get listLanguage {
    return Intl.message(
      'List Language',
      name: 'listLanguage',
      desc: '',
      args: [],
    );
  }

  /// `en`
  String get code {
    return Intl.message(
      'en',
      name: 'code',
      desc: '',
      args: [],
    );
  }

  /// `Correct`
  String get true_string {
    return Intl.message(
      'Correct',
      name: 'true_string',
      desc: '',
      args: [],
    );
  }

  /// `Wrong`
  String get false_string {
    return Intl.message(
      'Wrong',
      name: 'false_string',
      desc: '',
      args: [],
    );
  }

  /// `of`
  String get of_string {
    return Intl.message(
      'of',
      name: 'of_string',
      desc: '',
      args: [],
    );
  }

  /// `Single Player`
  String get single_player {
    return Intl.message(
      'Single Player',
      name: 'single_player',
      desc: '',
      args: [],
    );
  }

  /// `Multi Player`
  String get multi_player {
    return Intl.message(
      'Multi Player',
      name: 'multi_player',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get exit {
    return Intl.message(
      'Exit',
      name: 'exit',
      desc: '',
      args: [],
    );
  }

  /// `Play`
  String get play {
    return Intl.message(
      'Play',
      name: 'play',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get reset {
    return Intl.message(
      'Reset',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `Answer`
  String get answer {
    return Intl.message(
      'Answer',
      name: 'answer',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to exit game? the progress will be lost`
  String get exit_game {
    return Intl.message(
      'Do you want to exit game? the progress will be lost',
      name: 'exit_game',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to exit game?`
  String get exit_game_menu {
    return Intl.message(
      'Do you want to exit game?',
      name: 'exit_game_menu',
      desc: '',
      args: [],
    );
  }

  /// `Yes, Exit`
  String get exit_game_yes {
    return Intl.message(
      'Yes, Exit',
      name: 'exit_game_yes',
      desc: '',
      args: [],
    );
  }

  /// `No, Continue`
  String get exit_game_no {
    return Intl.message(
      'No, Continue',
      name: 'exit_game_no',
      desc: '',
      args: [],
    );
  }

  /// `Letter`
  String get letter {
    return Intl.message(
      'Letter',
      name: 'letter',
      desc: '',
      args: [],
    );
  }

  /// `Second`
  String get second {
    return Intl.message(
      'Second',
      name: 'second',
      desc: '',
      args: [],
    );
  }

  /// `ques`
  String get ques {
    return Intl.message(
      'ques',
      name: 'ques',
      desc: '',
      args: [],
    );
  }

  /// `Question`
  String get question {
    return Intl.message(
      'Question',
      name: 'question',
      desc: '',
      args: [],
    );
  }

  /// `Second per ques`
  String get second_question {
    return Intl.message(
      'Second per ques',
      name: 'second_question',
      desc: '',
      args: [],
    );
  }

  /// `Challenge \n Friends`
  String get challenge {
    return Intl.message(
      'Challenge \n Friends',
      name: 'challenge',
      desc: '',
      args: [],
    );
  }

  /// `Number of Questions`
  String get question_count {
    return Intl.message(
      'Number of Questions',
      name: 'question_count',
      desc: '',
      args: [],
    );
  }

  /// `Word Length(letter)`
  String get word_length {
    return Intl.message(
      'Word Length(letter)',
      name: 'word_length',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get time {
    return Intl.message(
      'Time',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `Question Number is empty !`
  String get question_number {
    return Intl.message(
      'Question Number is empty !',
      name: 'question_number',
      desc: '',
      args: [],
    );
  }

  /// `Min 5 Ques !`
  String get question_number_error_min {
    return Intl.message(
      'Min 5 Ques !',
      name: 'question_number_error_min',
      desc: '',
      args: [],
    );
  }

  /// `Max 15 Ques !`
  String get question_number_error_max {
    return Intl.message(
      'Max 15 Ques !',
      name: 'question_number_error_max',
      desc: '',
      args: [],
    );
  }

  /// `Length word is empty !`
  String get word_length_form {
    return Intl.message(
      'Length word is empty !',
      name: 'word_length_form',
      desc: '',
      args: [],
    );
  }

  /// `Min 3 letter !`
  String get word_length_form_error_min {
    return Intl.message(
      'Min 3 letter !',
      name: 'word_length_form_error_min',
      desc: '',
      args: [],
    );
  }

  /// `Max 10 letter !`
  String get word_length_form_error_max {
    return Intl.message(
      'Max 10 letter !',
      name: 'word_length_form_error_max',
      desc: '',
      args: [],
    );
  }

  /// `Time is empty !`
  String get question_time {
    return Intl.message(
      'Time is empty !',
      name: 'question_time',
      desc: '',
      args: [],
    );
  }

  /// `Min 7 second per Ques !`
  String get question_time_error_min {
    return Intl.message(
      'Min 7 second per Ques !',
      name: 'question_time_error_min',
      desc: '',
      args: [],
    );
  }

  /// `Max 30 second per Ques !`
  String get question_time_error_max {
    return Intl.message(
      'Max 30 second per Ques !',
      name: 'question_time_error_max',
      desc: '',
      args: [],
    );
  }

  /// `Custom Level`
  String get custom_level {
    return Intl.message(
      'Custom Level',
      name: 'custom_level',
      desc: '',
      args: [],
    );
  }

  /// `Back to Home`
  String get back_to_menu {
    return Intl.message(
      'Back to Home',
      name: 'back_to_menu',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get setting {
    return Intl.message(
      'Setting',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `Save Setting`
  String get save_setting {
    return Intl.message(
      'Save Setting',
      name: 'save_setting',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Acak Kata is mobile game app for improve skill vocabulary in various language, like Balinese, Javanese, Indonesians, and English`
  String get about_cite {
    return Intl.message(
      'Acak Kata is mobile game app for improve skill vocabulary in various language, like Balinese, Javanese, Indonesians, and English',
      name: 'about_cite',
      desc: '',
      args: [],
    );
  }

  /// `Login first !`
  String get login_first {
    return Intl.message(
      'Login first !',
      name: 'login_first',
      desc: '',
      args: [],
    );
  }

  /// `Exit from Room`
  String get exit_room {
    return Intl.message(
      'Exit from Room',
      name: 'exit_room',
      desc: '',
      args: [],
    );
  }

  /// `Dictionary`
  String get find_word {
    return Intl.message(
      'Dictionary',
      name: 'find_word',
      desc: '',
      args: [],
    );
  }

  /// `Join Room`
  String get join_room {
    return Intl.message(
      'Join Room',
      name: 'join_room',
      desc: '',
      args: [],
    );
  }

  /// `Music`
  String get music {
    return Intl.message(
      'Music',
      name: 'music',
      desc: '',
      args: [],
    );
  }

  /// `Input Room Code`
  String get join_room_text {
    return Intl.message(
      'Input Room Code',
      name: 'join_room_text',
      desc: '',
      args: [],
    );
  }

  /// `Success Find Room`
  String get success_find_room {
    return Intl.message(
      'Success Find Room',
      name: 'success_find_room',
      desc: '',
      args: [],
    );
  }

  /// `Find Room`
  String get find_room {
    return Intl.message(
      'Find Room',
      name: 'find_room',
      desc: '',
      args: [],
    );
  }

  /// `Failed find a room`
  String get failed_find_room {
    return Intl.message(
      'Failed find a room',
      name: 'failed_find_room',
      desc: '',
      args: [],
    );
  }

  /// `Starting game`
  String get start_game {
    return Intl.message(
      'Starting game',
      name: 'start_game',
      desc: '',
      args: [],
    );
  }

  /// `Successfully receive settings`
  String get receive_setting {
    return Intl.message(
      'Successfully receive settings',
      name: 'receive_setting',
      desc: '',
      args: [],
    );
  }

  /// `Successfully Receive player status`
  String get receive_status_player {
    return Intl.message(
      'Successfully Receive player status',
      name: 'receive_status_player',
      desc: '',
      args: [],
    );
  }

  /// `Waiting Host`
  String get waiting_host {
    return Intl.message(
      'Waiting Host',
      name: 'waiting_host',
      desc: '',
      args: [],
    );
  }

  /// `Criticism and suggestions please contact us : baliintegratedsolution`
  String get contact_us {
    return Intl.message(
      'Criticism and suggestions please contact us : baliintegratedsolution',
      name: 'contact_us',
      desc: '',
      args: [],
    );
  }

  /// `Maximum player`
  String get max_player {
    return Intl.message(
      'Maximum player',
      name: 'max_player',
      desc: '',
      args: [],
    );
  }

  /// `End Time Game`
  String get ending_time {
    return Intl.message(
      'End Time Game',
      name: 'ending_time',
      desc: '',
      args: [],
    );
  }

  /// `Create Room Match`
  String get create_room_match {
    return Intl.message(
      'Create Room Match',
      name: 'create_room_match',
      desc: '',
      args: [],
    );
  }

  /// `Successfully create room match`
  String get successfuly_create_room {
    return Intl.message(
      'Successfully create room match',
      name: 'successfuly_create_room',
      desc: '',
      args: [],
    );
  }

  /// `See the Answers`
  String get see_answers {
    return Intl.message(
      'See the Answers',
      name: 'see_answers',
      desc: '',
      args: [],
    );
  }

  /// `Username Invalid`
  String get valid_username {
    return Intl.message(
      'Username Invalid',
      name: 'valid_username',
      desc: '',
      args: [],
    );
  }

  /// `Min 3 characters`
  String get min_char_three {
    return Intl.message(
      'Min 3 characters',
      name: 'min_char_three',
      desc: '',
      args: [],
    );
  }

  /// `Min 3 characters, one letter and one number`
  String get valid_pass {
    return Intl.message(
      'Min 3 characters, one letter and one number',
      name: 'valid_pass',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email format`
  String get valid_email {
    return Intl.message(
      'Invalid email format',
      name: 'valid_email',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'id'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
