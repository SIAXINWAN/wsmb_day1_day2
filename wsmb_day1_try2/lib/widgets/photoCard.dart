import 'package:flutter/material.dart';
import 'package:wsmb_day1_try2/models/human.dart';

class PhotoCard extends StatelessWidget {
  final Human human;
  const PhotoCard({super.key, required this.human});

  @override
  Widget build(BuildContext context) {
    var imageLink = human.image;
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightBlue,
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(1)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(human.image.toString()),
          ),
          Container(
            child: Image.network(
              imageLink ??
                  'https://firebasestorage.googleapis.com/v0/b/wsmb-try1.appspot.com/o/vehicle%2F1721706260095.jpg?alt=media&token=9b331ad6-2781-4ecc-9c04-be4884005184',
              fit: BoxFit.fill,
            ),
          ),
          Text(human.name),
          Text(human.icno),
          Text(human.gender ? 'Male' : 'Female')
        ],
      ),
    );
  }
}
