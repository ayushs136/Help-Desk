import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Card(
        child: Stack(
          children: [
            SizedBox(height: 20),
            Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Image(
                    image: NetworkImage(
                        'https://specials-images.forbesimg.com/imageserve/5efa33eed4034b0007bf4b5c/960x0.jpg'))),
            Text(
              "Harry Potter and \nthe Chamber of Secrets",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
