import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/theme.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class AnswerModal extends StatefulWidget {
  const AnswerModal({
    Key? key,
    required this.setLanguage,
    required this.resultAnswerStatus,
  }) : super(key: key);

  final S? setLanguage;
  final bool resultAnswerStatus;

  @override
  State<AnswerModal> createState() => _AnswerModalState();
}

class _AnswerModalState extends State<AnswerModal> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Dialog(
        insetAnimationCurve: Curves.easeInOut,
        backgroundColor: Colors.transparent,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: SizedBox(
            height: 350,
            child: Container(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                  child: Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                        border:
                            Border.all(width: 6, color: Colors.transparent)),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElasticIn(
                              delay: const Duration(milliseconds: 50),
                              child: Container(
                                margin: const EdgeInsets.only(
                                    bottom: 32, left: 15, right: 15),
                                child: Center(
                                  child: widget.resultAnswerStatus
                                      ? Image.asset(
                                          'assets/images/light_bulb.png',
                                          width: 175,
                                          height: 175,
                                        )
                                      : Image.asset(
                                          'assets/images/book.png',
                                          width: 175,
                                          height: 175,
                                        ),
                                ),
                              )),
                          const SizedBox(
                            height: 15,
                          ),
                          ElasticIn(
                              duration: const Duration(milliseconds: 50),
                              child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 15, right: 15, top: 5, bottom: 5),
                                  child: Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: widget.resultAnswerStatus
                                              ? greenColor
                                              : redColor,
                                          border: Border.all(
                                              color: widget.resultAnswerStatus
                                                  ? greenColor2
                                                  : redColor2,
                                              width: 4),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                                color: widget.resultAnswerStatus
                                                    ? greenColor3
                                                    : redColor3,
                                                offset: const Offset(0, 4))
                                          ]),
                                      child: Container(
                                        margin: const EdgeInsets.all(15),
                                        child: Text(
                                          widget.resultAnswerStatus
                                              ? widget.setLanguage!.true_string
                                              : widget
                                                  .setLanguage!.false_string,
                                          style: whiteTextStyle.copyWith(
                                              fontSize: 20, fontWeight: bold),
                                        ),
                                      ),
                                    ),
                                  ))),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
            )),
      ),
    );
  }
}
