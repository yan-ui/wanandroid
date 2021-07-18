import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleDetailWebView extends StatefulWidget {
  String url;

  ArticleDetailWebView(this.url) {
    debugPrint(this.url);
  }

  @override
  _ArticleDetailWebViewState createState() => _ArticleDetailWebViewState();
}

class _ArticleDetailWebViewState extends State<ArticleDetailWebView> {

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("详情"),
      ),
      body: WebView(
        initialUrl: this.widget.url,
      ),
    );
  }
}
