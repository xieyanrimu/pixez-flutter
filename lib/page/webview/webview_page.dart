import 'package:flutter/material.dart';
import 'package:pixez/page/picture/picture_page.dart';
import 'package:pixez/page/user/user_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String url;

  const WebViewPage({Key key, this.url}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            Uri uri = Uri.parse(request.url);
            final segment = uri.pathSegments;
            if (segment.length == 1 &&
                request.url.contains("/member.php?id=")) {
              final id = uri.queryParameters['id'];
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return UserPage(
                  id: int.parse(id),
                );
              }));
              return NavigationDecision.prevent;
            }
            if (segment.length == 3 && segment[1] == 'artworks') {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return PicturePage(null, int.parse(segment[2]));
              }));
              return NavigationDecision.prevent;
            }
            // if (request.url.startsWith('https://pixiv.net/')) {
            //   print('blocking navigation to $request}');
            //   if(request.url.contains("article")){

            //   }
            //   return NavigationDecision.prevent;
            // }
            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}