import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class webView extends StatefulWidget {

  @override
  _webViewState createState() => _webViewState();
}

class _webViewState extends State<webView> {

  void WebTry(){
    try{
      WebView(
        initialUrl: 'https://www.youtube.com/channel/UCSslzCYfi-PA6q1atGYUqSg/featured',
        javascriptMode: JavascriptMode.unrestricted,
      );
    } on SocketException {
      throw 'No Internet Connection';
    } on FormatException {
      throw 'Bad response format';
    } on HttpException {
      throw 'Unable to fetch data';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Youtube WebView'),
      ),
      body: WebView(
        initialUrl: 'https://www.youtube.com/channel/UCSslzCYfi-PA6q1atGYUqSg/featured',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
