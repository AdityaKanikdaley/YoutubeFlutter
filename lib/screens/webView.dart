import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class webView extends StatefulWidget {
  @override
  _webViewState createState() => _webViewState();
}

class _webViewState extends State<webView> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Youtube WebView'),
        ),
        body: WebView(
          initialUrl: 'https://www.youtube.com/',
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}