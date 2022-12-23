const Set<Tutorial> beginGame = {
  Tutorial(
      'assets/images/guide_game/1.png',
      'Tutorial Permainan Acak Kata',
      'Tutorial Permainan Acak Kata',
      'Acak kata adalah sebuah permainan untuk menebak kosa kata yang dapat ditemukan dari kumpulan kata yang ditampilkan pada layar. \nKosa kata yang menjadi acuan permainan diambil dari 4 bahasa, Bahasa Indonesia, Bahasa Inggris, Bahasa Jawa dan Bahasa Bali',
      'Acak kata is a scramble word game. Player must find a word that can be formed. Player can play scramble word from 4 language, English, Javanese, Indonesian, dan Balinese.'),
  Tutorial(
      'assets/images/guide_game/2.png',
      'Acak Kata',
      'Tutorial ',
      'Untuk memuliai permainan klik tombol Play. Kemudian pilih bahasa yang ingin dimainkan  ',
      'Click button Play to begin game. after that, select a language the player want'),
  Tutorial(
      'assets/images/guide_game/3.png',
      'Acak Kata',
      'Tutorial ',
      'Pemain dapat memilih permainan dengan level atau permainan kustomisasi ',
      'Player can choose play with level or customization game'),
  Tutorial(
      'assets/images/guide_game/4.png',
      'Acak Kata',
      'Tutorial ',
      'Permainan dengan kustomisasi dapat mengatur jumlah soal, durasi permainan dan banyak huruf yang dapat dimainkan. \n\nPermainan dengan level dapat memainkan sesuai level kesulitan dari termudah ke yang paling sulit ',
      'Customization game can set the number of question, duration of the game and number of the characters that can be played.\n\nGame with level can be played according the level of difficulty from easiest to the most difficult ')
};

const Set<Tutorial> multiplayer = {
  Tutorial(
      'assets/images/guide_multiplayer/1.png',
      'Guide Multiplayer',
      'Tutorial Permainan Acak Kata',
      'Host pemain dapat membuat ruang permainan dengan aturan permainannya sendiri. \n\nHost dapat membagikan kode ruang permainan ke pemain lain ',
      'Host Player can create game room with their room game rooms.\n\nHost can share room code to another player'),
  Tutorial(
      'assets/images/guide_multiplayer/2.png',
      'Guide Multiplayer',
      'Tutorial Permainan Acak Kata',
      'Pemain yang ingin bergabung, tekan tombol Join Room. Masukan kode ruang permainan yang sudah dibagi oleh host, kemudian cari Room Match. Tunggu host permainan memulai permainan',
      'Another player press button Join Room. Insert room code from host, then find Room March. Wait host for start game.'),
  Tutorial(
      'assets/images/guide_multiplayer/3.png',
      'Guide Multiplayer',
      'Tutorial Permainan Acak Kata',
      'Permainan akan dimulai dengan menekan tombol bermain oleh host Room.',
      'Game will start if Host press button Play'),
  Tutorial(
      'assets/images/guide_multiplayer/4.png',
      'Guide Multiplayer',
      'Tutorial Permainan Acak Kata',
      'Sistem akan membagikan soal ke semua pemain. Pemain bermain seperti biasa',
      'System will share questions to all players. All players play as usual'),
  Tutorial(
      'assets/images/guide_multiplayer/5.png',
      'Guide Multiplayer',
      'Tutorial Permainan Acak Kata',
      'Hasil permainan akan muncul ketika semua permainan selesai. ',
      'Result game will show if after all players done play the game'),
};

const Set<Tutorial> howToPlay = {
  Tutorial(
      'assets/images/gameplay/1.png',
      'Guide Play',
      'Tutorial Permainan Acak Kata',
      'Acak kata adalah sebuah permainan untuk menebak kosa kata yang dapat ditemukan dari kumpulan kata yang ditampilkan pada layar.\n\nPermainan akan dibatasi oleh durasi, jumlah soal dan jumlah huruf dalam satu soal',
      'Acak kata is a scramble word game. Player must find a word that can be formed. Player can play scramble word from 4 language, English, Javanese, Indonesian, dan Balinese.\n\nThe Game will limited by duration, number of questions and number of characters in one question'),
  Tutorial(
      'assets/images/gameplay/2.png',
      'Guide Play',
      'Tutorial Permainan Acak Kata',
      'Pemain menebak kata dengan menekan huruf sesuai urutan kosa kata yang ditebak.\n\nJika berhasil menemukan kata yang disusun maka ',
      'Player will guess word with press button letter in the order of guessed vocabulary.\n\nif player successful, player will get point'),
  Tutorial(
      'assets/images/gameplay/3.png',
      'Guide Play',
      'Tutorial Permainan Acak Kata',
      'Terdapat durasi waktu permainan yang menjadi pantangan pemain. \n\nJika pemain gagal mendapatkan kata dari huruf yang diberikan, maka pemain akan dianggap gagal dan kehilangan poin.',
      'There is a duration of game time that is taboo for players.\n\nIf the player fails to get the word from the given letter, the player will be considered a failure and lose points.'),
  Tutorial(
      'assets/images/gameplay/4.png',
      'Guide Play',
      'Tutorial Permainan Acak Kata',
      'Terdapat beberapa tombol bantuan yang disediakan: \n1. tombol Merah : Untuk menghapus huruf yang diinputkan \n2. tombol Ungu : untuk mereset ulang kata yang diinputkan \n3. tombol Jingga : untuk mengacak kembali posisi kata \n4. tombil Hijau : untuk skip ke soal selanjutnya',
      'There are several help buttons provided:\nRed button: To delete the letters entered\nPurple button : to reset the inputted word again\nOrange button : to randomize word position again\nGreen button: to skip to the next question'),
  Tutorial(
      'assets/images/gameplay/5.png',
      'Guide Play',
      'Tutorial Permainan Acak Kata',
      'Pemain yang  berhasil menyelesaikan semua soal dengan hasil berhasil atau gagal ',
      'Players who successfully complete all questions with successful or failed results will get a score based on the speed of answering the correct answers and the number of correct answers'),
  Tutorial(
      'assets/images/gameplay/6.png',
      'Guide Play',
      'Guide Play',
      'Hasil permainan akan mucul ketika pemain menyelesaikan semua jawaban. \n\nPemain dapat mereview kembali soal yang dijawab sebelumnya',
      'Game results will appear when the player completes all the answers. Players can review the questions answered before'),
};

class Tutorial {
  final String imageUrl;

  final String titleID;

  final String titleEN;

  final String subTitleID;

  final String subTitleEN;

  const Tutorial(this.imageUrl, this.titleEN, this.titleID, this.subTitleID,
      this.subTitleEN);

  @override
  String toString() => 'Tutorial<$titleEN>';
}
