import 'dart:collection';
import 'dart:math';

import 'package:acakkata/controller/audio/song.dart';
import 'package:acakkata/controller/audio/sound.dart';
import 'package:acakkata/controller/setting_controller.dart';
import 'package:audioplayers/audioplayers.dart' hide Logger;
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

class AudioController {
  static final _log = Logger('AudioController');
  late AudioCache _musicCache;

  late AudioCache _sfxCache;

  final AudioPlayer _musicPlayer;


  final List<AudioPlayer> _sfxPlayers;

  int _currentSfxPlayer = 0;

  final Queue<Song> _playlist;

  final Random _random = Random();

  SettingsController? _settings;

  ValueNotifier<AppLifecycleState>? _lifecycleNotifier;


  AudioController({int polyphony = 2})
      : assert(polyphony >= 2),
        _musicPlayer = AudioPlayer(playerId: 'musicPlayer'),
        _sfxPlayers = Iterable.generate(
            polyphony, (i) => AudioPlayer(playerId: 'sfxPlayer#$i')).toList(),
        _playlist = Queue.from(List.of(songs)..shuffle()) {
    _musicCache =
        AudioCache(prefix: 'assets/music/', fixedPlayer: _musicPlayer);
    _sfxCache =
        AudioCache(prefix: 'assets/sfx/', fixedPlayer: _sfxPlayers.first);

    _musicPlayer.onPlayerCompletion.listen(_changeSong);
  }

  void attachLifeCycleNotifier(
      ValueNotifier<AppLifecycleState> lifecycleNotifier) {
    if (_lifecycleNotifier != null) {
      _lifecycleNotifier!.removeListener(_handleAppLifecycle);
    }
    _lifecycleNotifier = lifecycleNotifier;
    _lifecycleNotifier?.addListener(_handleAppLifecycle);
  }

  void attachSettings(SettingsController settingsController) {
    if (_settings == settingsController) {
      // Already attached to this instance. Nothing to do.
      return;
    }

    if (_settings != null) {
      _settings!.muted.removeListener(_mutedHandler);
      _settings!.musicOn.removeListener(_musicOnHandler);
      _settings!.soundsOn.removeListener(_soundsOnHandler);
    }

    _settings = settingsController;

    _settings!.muted.addListener(_mutedHandler);
    _settings!.musicOn.addListener(_musicOnHandler);
    _settings!.soundsOn.addListener(_soundsOnHandler);

    if (!_settings!.muted.value && _settings!.musicOn.value) {
      _startMusic();
    }
  }

  void dispose() {
    _lifecycleNotifier?.removeListener(_handleAppLifecycle);
    _stopAllSound();
    _musicPlayer.dispose();
    for (final player in _sfxPlayers) {
      player.dispose();
    }
  }

  void _handleAppLifecycle() {
    switch (_lifecycleNotifier!.value) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _stopAllSound();
        break;
      case AppLifecycleState.resumed:
        if (!_settings!.muted.value && _settings!.musicOn.value) {
          _resumeMusic();
        }
        break;
      case AppLifecycleState.inactive:
        // No need to react to this state change.
        break;
    }
  }

  void initialize() async {
    _log.info('Preloading sound effects');
    await _sfxCache
        .loadAll(SfxType.values.expand(soundTypeToFilename).toList());
  }

  void playSfx(SfxType type, {int? queue}) {
    final muted = _settings?.muted.value ?? true;
    if (muted) {
      _log.info(() => 'Ignoring playing sound ($type) because audio is muted.');
      return;
    }
    final soundsOn = _settings?.soundsOn.value ?? false;
    if (!soundsOn) {
      _log.info(() =>
          'Ignoring playing sound ($type) because sounds are turned off.');
      return;
    }

    _log.info(() => 'Playing sound: $type');
    final options = soundTypeToFilename(type);
    final newQueue = (queue ?? _random.nextInt(options.length));
    final filename = options[newQueue];
    _log.info(() => '- Chosen filename: $filename');
    _sfxCache.play(filename, volume: soundTypeToVolume(type));
    _currentSfxPlayer = (_currentSfxPlayer + 1) % _sfxPlayers.length;
    _sfxCache.fixedPlayer = _sfxPlayers[_currentSfxPlayer];
  }

  void _changeSong(void _) {
    _log.info('lagu terakhir dimainkan.');
    // Put the song that just finished playing to the end of the playlist.
    _playlist.addLast(_playlist.removeFirst());
    // Play the next song.
    _log.info(() => 'Lagu sekarang ${_playlist.first} ');
    _musicCache.play(_playlist.first.filename);
  }

  void _musicOnHandler() {
    if (_settings!.musicOn.value) {
      // Music got turned on.
      if (!_settings!.muted.value) {
        _resumeMusic();
      }
    } else {
      // Music got turned off.
      _stopMusic();
    }
  }

  void _mutedHandler() {
    if (_settings!.muted.value) {
      // All sound just got muted.
      _stopAllSound();
    } else {
      // All sound just got un-muted.
      if (_settings!.musicOn.value) {
        _resumeMusic();
      }
    }
  }

  void _resumeMusic() async {
    _log.info('Resuming music');
    switch (_musicPlayer.state) {
      case PlayerState.PAUSED:
        _log.info('status musik pause, mencoba memulai ');
        try {
          await _musicPlayer.resume();
        } catch (e) {
          // Sometimes, resuming fails with an "Unexpected" error.
          _log.severe(e);
          _musicCache.play(_playlist.first.filename);
        }
        break;
      case PlayerState.STOPPED:
        _log.info("Status musik sedang berhenti, mencoba memulai kembali");
        _musicCache.play(_playlist.first.filename);
        break;
      case PlayerState.PLAYING:
        _log.warning('Musik sedang dimainkan');
        break;
      case PlayerState.COMPLETED:
        _log.warning('Musik selesai dimainkan, mencoba memulai kembali');
        _musicCache.play(_playlist.first.filename);
        break;
    }
  }

  void _soundsOnHandler() {
    for (final player in _sfxPlayers) {
      if (player.state == PlayerState.PLAYING) {
        player.stop();
      }
    }
  }

  void _startMusic() {
    _log.info('starting music');
    _musicCache.play(_playlist.first.filename);
  }

  void _stopAllSound() {
    if (_musicPlayer.state == PlayerState.PLAYING) {
      _musicPlayer.pause();
    }
    for (final player in _sfxPlayers) {
      player.stop();
    }
  }

  void _stopMusic() {
    _log.info('Stopping music');
    if (_musicPlayer.state == PlayerState.PLAYING) {
      _musicPlayer.pause();
    }
  }
}
