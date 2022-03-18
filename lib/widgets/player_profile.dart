import 'package:acakkata/models/room_match_model.dart';
import 'package:acakkata/theme.dart';
import 'package:flutter/material.dart';

class PlayerProfile extends StatelessWidget {
  // const PlayerProfile({
  //   Key? key,
  //   required this.roomMatch,
  //   required this.isReadyPlayer,
  // }) : super(key: key);

  PlayerProfile(this.roomMatch, this.isReadyPlayer, this.item);

  final RoomMatchModel? roomMatch;
  final List<bool> isReadyPlayer;
  final int item;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: (MediaQuery.of(context).size.width - 82) / 2,
        margin: EdgeInsets.only(top: 10, left: 5, right: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 98,
              height: 98,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/photo_profile.png',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              '${roomMatch!.room_match_detail![item].player!.name}',
              style:
                  primaryTextStyle.copyWith(fontSize: 18, fontWeight: medium),
            ),
            Text(
              '#${roomMatch!.room_match_detail![item].player!.userCode}',
              style: thirdTextStyle.copyWith(fontSize: 14, fontWeight: regular),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              isReadyPlayer[item] ? 'Ready' : 'Not Ready',
              style:
                  thirdTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
