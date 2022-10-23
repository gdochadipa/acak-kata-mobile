const Set<Song> songs = {
  // Filenames with whitespace break package:audioplayers on iOS
  // (as of February 2022), so we use no whitespace.
  Song('monkey_island.mp3', 'More Monkey Island Band'),
  Song('quirky_puzzle.mp3', 'Quirky Puzzle Game Menu'),
  Song('spooky.mp3', 'Spooky Island')
};

class Song {
  final String filename;

  final String author = 'Eric Matyas';

  final String name;

  const Song(this.filename, this.name);

  @override
  String toString() => 'Song<$filename>';
}
