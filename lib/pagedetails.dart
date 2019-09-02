import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:transparent_image/transparent_image.dart';

class ReputePage extends StatelessWidget {
  var page;

  ReputePage({Key key, @required var this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(page['title']['rendered']),
        backgroundColor: Colors.redAccent,
      ),
      body: new Padding(
        padding: EdgeInsets.all(16.0),
        child: new ListView(
          children: <Widget>[
            new FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: page["featured_media"] == 0
                  ? 'images/placeholder.png'
                  : page["_embedded"]["wp:featuredmedia"][0]["source_url"],
            ),
//            new Text(page['content']['rendered'].replaceAll(new RegExp(r'<[^>]*>'), ''))
            new Html(data: page['content']['rendered'])
//                onLaunchFail: (url) { // optional, type Function
//                  print("launch $url failed");
//                })
          ],
        ),
      ),
    );
  }
}
