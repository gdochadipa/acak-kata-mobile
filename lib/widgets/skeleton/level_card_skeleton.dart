import 'package:acakkata/theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LevelCardSkeleton extends StatelessWidget {
  // const LevelCardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.only(top: 13, bottom: 13, left: 10),
      decoration: BoxDecoration(
          color: backgroundColor6, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Container(
            height: 61,
            width: 63.44,
            margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Shimmer.fromColors(
              child: Container(
                width: 18,
                height: 18,
                color: kLineDarkColor,
              ),
              baseColor: kLineDarkColor,
              highlightColor: kWhiteGreyColor,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                child: Container(
                  width: 180,
                  height: 5,
                  color: kLineDarkColor,
                ),
                baseColor: kLineDarkColor,
                highlightColor: kWhiteGreyColor,
              ),
              const SizedBox(
                width: 16,
              ),
              Shimmer.fromColors(
                child: Container(
                  width: 180,
                  height: 20,
                  color: kLineDarkColor,
                ),
                baseColor: kLineDarkColor,
                highlightColor: kWhiteGreyColor,
              ),
            ],
          )
        ],
      ),
    );
  }
}
