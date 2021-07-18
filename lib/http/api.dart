import 'package:dio/dio.dart';
import 'package:wanandroid/http/http_manager.dart';

typedef void OnResult(Map<String, dynamic> data);

class Api {

  static const String baseUrl = "https://www.wanandroid.com";

  static const String ARTICLE_LIST = "/article/list/";

  static const String BANNER = "/banner/json";

  static getBannerList() async {
    return HttpManager.getInstance().request(BANNER);
  }

  static getArticleList(int page) async {
    return HttpManager.getInstance().request('$ARTICLE_LIST$page/json');
  }

}
