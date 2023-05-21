List<String> soundTypeToFilename(SfxType type) {
  switch (type) {
    case SfxType.buttonTap:
      return [
        'bubble_click.wav',
        'click.mp3',
        'fast_lock.wav',
        'modern_click.wav',
      ];
    case SfxType.congrats:
      return [
        'correct_answer2.mp3',
      ];
    case SfxType.erase:
      return ['wrong_answer1.mp3'];
  }
}

/// Allows control over loudness of different SFX types.
double soundTypeToVolume(SfxType type) {
  switch (type) {
    case SfxType.buttonTap:
    case SfxType.congrats:
    case SfxType.erase:
      return 1.0;
  }
}

enum SfxType { buttonTap, congrats, erase }
