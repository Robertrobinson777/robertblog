import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

import 'page.dart';
import 'postdetail.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  // Base URL for our wordpress API
  final String apiUrl = "https://robertrobinson.in/wp-json/wp/v2/";
  var assetsImage = new AssetImage('assets/640x360.png');
  var apptitle = new Text("Robert's Blog");

  // Empty list for our posts
  List posts;
  List pages;
  var _iconAnimationController;
  var _iconAnimation;

  // Function to fetch list of posts
  Future<String> getPosts() async {
    var res = await http.get(Uri.encodeFull(apiUrl + "posts?_embed"),
        headers: {"Accept": "application/json"});

    // fill our posts list with results and update state
    setState(() {
      var resBody = json.decode(res.body);
      posts = resBody;
    });

    return "Success!";
  }

  Future<String> getPages() async {
    var pageres = await http.get(Uri.encodeFull(apiUrl + "pages"),
        headers: {"Accept": "application/json"});

    setState(() {
      var resPageBody = json.decode(pageres.body);
      pages = resPageBody;
    });
  }

  @override
  void initState() {
    super.initState();
    this.getPosts();
    this.getPages();
    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 2000));

    _iconAnimation = new CurvedAnimation(
        parent: _iconAnimationController, curve: Curves.easeIn);
    _iconAnimation.addListener(() => this.setState(() {}));

    _iconAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (pages == null || posts == null) {
      return new Scaffold(
        body: new Scaffold(
          body: new Center(
              child: new Image(
            image: assetsImage,
            width: _iconAnimation.value * 100,
            height: _iconAnimation.value * 100,
          )),
        ),
      );
    } else {
      List<Widget> drawerOptions = [];
      for (var i = 0; i < pages.length; i++) {
//      var d = drawerItems[i];
        drawerOptions.add(new ListTile(
//        leading: new Icon(d.icon),
          title: new Text(
            //d.title,
            pages[i]["title"]["rendered"],
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
          ),
//        selected: i == _selectedIndex,
          onTap: () {
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new WebViewExample(url: pages[i]),
              ),
            );
          },
        ));
      }

      return Scaffold(
        appBar: AppBar(title: apptitle, backgroundColor: Colors.redAccent),
        drawer: new Drawer(
            child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.redAccent),
              accountName: new Text('Repute'),
//                accountEmail: new Text('testemail@test.com'),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: assetsImage,
              ),
            ),
            new Column(children: drawerOptions),
//        new Column( children: <Widget>[
//        ListView.builder(
//                  itemCount: posts == null ? 0 : posts.length,
//    itemBuilder: (context, index) {
//
//                    new ListTile(
//                    title: new Text('Second Menu Item'),
//      onTap: () {
//      Navigator.push(context,
//      new MaterialPageRoute(builder: (context) => new WebViewExample()),);
//      },
//      );
////      new Divider();
//    },
//    ),
//        ], ),
          ],
        )),
        body: ListView.builder(
          itemCount: posts == null ? 0 : posts.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                Card(
                  child: Column(
                    children: <Widget>[
                      posts[index]["featured_media"] == 0
                          ? new Image(image: assetsImage)
                          : FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: posts[index]["_embedded"]
                                  ["wp:featuredmedia"][0]["source_url"],
                            ),
                      new Padding(
                          padding: EdgeInsets.all(10.0),
                          child: new ListTile(
                            title: new Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: new Text(
                                    posts[index]["title"]["rendered"])),
                            subtitle: new Text(posts[index]["excerpt"]
                                    ["rendered"]
                                .replaceAll(new RegExp(r'<[^>]*>'), '')),
                          )),
                      new ButtonTheme.bar(
                        child: new ButtonBar(
                          children: <Widget>[
                            new FlatButton(
                              child: const Text('READ MORE'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) => new ReputePost(
                                        post: posts[index],
                                        aimage: assetsImage),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      );
    }
  }
}
