import 'package:flutter/material.dart';
import 'package:wsmb_day1_try2/models/human.dart';
import 'package:wsmb_day1_try2/pages/edit/editDetail.dart';

class EditCard extends StatelessWidget {
  final Human human;
  const EditCard({super.key, required this.human});

  @override
  Widget build(BuildContext context) {
    var imageLink = human.image;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.lightBlue,
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundImage: NetworkImage(human.image.toString()),
                ),
                Container(
                  height: 30,
                  width: 100,
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
            TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditDetailPage(
                            human: human,
                          )));
                },
                child: Text('Edit'))
          ],
        ),
      ),
    );
  }
}
