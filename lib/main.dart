import 'package:flutter/material.dart';
import 'package:wanandroid/ui/page/page_article.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "任务栏的名称",
      home: ArticlePage(),
    );
  }
}


