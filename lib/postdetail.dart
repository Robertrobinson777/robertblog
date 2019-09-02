import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:transparent_image/transparent_image.dart';

class ReputePost extends StatelessWidget {
  var post;
  var aimage;

  ReputePost({Key key, @required this.post, @required this.aimage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(post['title']['rendered']),
        backgroundColor: Colors.redAccent,
      ),
      body: new Padding(
        padding: EdgeInsets.all(16.0),
        child: new ListView(
          children: <Widget>[
            post["featured_media"] == 0
                ? new Image(image: aimage)
                : new FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: post["_embedded"]["wp:featuredmedia"][0]
                        ["source_url"],
                  ),
            HtmlWidget(
              post['content']['rendered'],
              webView: true,
            ),
//            new Text(post['content']['rendered'].replaceAll(new RegExp(r'<[^>]*>'), ''))
//            new Html(data: post['content']['rendered'])
//            new HtmlView(
//              data: post['content']['rendered'],
////              baseURL: "", // optional, type String
//              onLaunchFail: (url) {
//                // optional, type Function
//                print("launch $url failed");
//              },
////              scrollable: false, //false to use MarksownBody and true to use Marksown
//            )
//                onLaunchFail: (url) { // optional, type Function
//                  print("launch $url failed");
//                })
          ],
        ),
      ),
    );
  }
}
