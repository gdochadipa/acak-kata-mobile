import 'package:acakkata/theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PlayerProfileSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: (MediaQuery.of(context).size.width - 82) / 2,
        margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 98,
              height: 98,
              decoration:
                  ShapeDecoration(color: kLineDarkColor, shape: const CircleBorder()),
            ),
            const SizedBox(
              height: 15,
            ),
            Shimmer.fromColors(
              child: Container(
                width: double.infinity,
                height: 35,
                color: kLineDarkColor,
              ),
              baseColor: kLineDarkColor,
              highlightColor: kWhiteGreyColor,
            ),
            const SizedBox(
              height: 15,
            ),
            Shimmer.fromColors(
              child: Container(
                width: double.infinity,
                height: 25,
                color: kLineDarkColor,
              ),
              baseColor: kLineDarkColor,
              highlightColor: kWhiteGreyColor,
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
