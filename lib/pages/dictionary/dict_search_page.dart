import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/word_language_model.dart';
import 'package:acakkata/providers/language_db_provider.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/button/button_bounce.dart';
import 'package:acakkata/widgets/component/dict_item.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class DictSearchPage extends StatefulWidget {
  final LanguageModel? languageModel;

  const DictSearchPage({Key? key, required this.languageModel})
      : super(key: key);

  @override
  State<DictSearchPage> createState() => _DictSearchPageState();
}

class _DictSearchPageState extends State<DictSearchPage> {
  late LanguageDBProvider? languageDBProvider =
      Provider.of<LanguageDBProvider>(context, listen: false);
  bool isLoading = false;
  TextEditingController teSeach = TextEditingController();
  List<WordLanguageModel>? wordList = [];
  Logger logger = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  void filterSearch(String query) async {
    try {
      if (query.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        if (await languageDBProvider!.searchWord(
            word: query,
            languageCode: widget.languageModel!.language_code ?? '')) {
          setState(() {
            wordList = languageDBProvider!.dataWordList!;
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
          wordList = [];
        });
      }
    } catch (e) {
      logger.e(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    S? setLanguage = S.of(context);

    Widget header() {
      return AppBar(
        leading: Container(
          margin: const EdgeInsets.only(top: 5, left: 5),
          child: ButtonBounce(
            onClick: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (route) => false);
            },
            child: Center(
              child: Icon(
                Icons.arrow_back,
                color: whiteColor,
              ),
            ),
          ),
        ),
        backgroundColor: transparentColor,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Text(
              (setLanguage.code == 'en'
                  ? '${widget.languageModel!.language_name_en}'
                  : '${widget.languageModel!.language_name_id}'),
              style: whiteTextStyle.copyWith(
                  fontWeight: extraBold, fontSize: 24, color: whiteColor),
            ),
          ],
        ),
        actions: [],
      );
    }

    Widget body() {
      return Container(
        margin: const EdgeInsets.only(top: 80, left: 15, right: 15),
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                height: 80,
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                decoration: BoxDecoration(
                    color: whiteColor, borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      filterSearch(value);
                    });
                  },
                  controller: teSeach,
                  decoration: const InputDecoration(
                      hintText: 'Search...',
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      )),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: wordList!.length,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, i) {
                    // WordLanguageModel? word = wordList![i];

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: DictItem(
                        languageModel: widget.languageModel,
                        wordLanguageModel: wordList![i],
                      ),
                    );
                    // return Text("test");
                  }),
            ),
          ],
        ),
      );
    }

    return WillPopScope(
        child: Scaffold(
          backgroundColor: primaryColor5,
          body: Stack(
            fit: StackFit.expand,
            children: [header(), body()],
          ),
        ),
        onWillPop: () async => false);
  }
}
