import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:toast/toast.dart';
import 'package:wanandroid/http/api.dart';
import 'package:wanandroid/ui/page/page_article_detail.dart';
import 'package:wanandroid/ui/widget/article_item.dart';

class ArticlePage extends StatefulWidget {
  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  ///banner图
  List _bannerList = [];

  ///请求到的文章数据
  List _articleList = [];

  ///分页加载，当前页码
  int currentPage = 0;

  ///总文章页数有多少
  int totalPage = 0;

  ///控制正在加载的显示
  var _isHidden = false;

  ///滑动控制器
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      ///获得ScrollController监听控件可以滚动的最大范围
      var maxScroll = _scrollController.position.maxScrollExtent;

      ///获得当前位置的像素值
      var pixels = _scrollController.position.pixels;

      ///当前滑动位置到达底部，同时还有更多数据
      if (maxScroll == pixels && currentPage < totalPage) {
        ///加载更多
        _getArticleList();
      }
    });

    ///初始化首页数据
    _pullToRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("首页"),
        ),
        body: Stack(
          children: [
            Offstage(
              offstage: _isHidden,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            Offstage(
              offstage: !_isHidden,
              child: RefreshIndicator(
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                    controller: _scrollController,
                    itemCount: _articleList.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      return buildListItem(context, index);
                    },
                  ),
                  onRefresh: _pullToRefresh),
            )
          ],
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Future<void> _pullToRefresh() async {
    currentPage = 0;

    Iterable<Future> futures = [_getBannerList(), _getArticleList()];

    await Future.wait(futures);

    _isHidden = true;

    setState(() {});
  }

  _getBannerList() async {
    /// 请求成功是map，失败是null
    var data = await Api.getBannerList();
    debugPrint("banner: " + data.toString());
    if (data == null) {
      _bannerList.clear();
    } else {
      _bannerList = data["data"];
      debugPrint("banner length: ${_bannerList.length}");
    }
  }

  _getArticleList() async {
    /// 请求成功是map，失败是null
    var articlePageData = await Api.getArticleList(currentPage);
    debugPrint(
        "page:$currentPage, articlePageData: " + articlePageData.toString());

    if (articlePageData != null) {
      var map = articlePageData['data'];
      var datas = map['datas'];

      ///文章总数
      totalPage = map["pageCount"];

      if (currentPage == 0) {
        _articleList = datas;
      } else {
        _articleList.addAll(datas);
      }

      currentPage++;

      setState(() {});
    }
  }

  Widget buildListItem(BuildContext context, int index) {
    if (index == 0) {
      //banner
      return _buildBanner();
    }

    return buildArticleItem(index);
  }

  Widget _buildBanner() {
    return Container(
        height: 180,
        child: Swiper(
          itemCount: _bannerList.length,
          itemBuilder: (BuildContext context, int index) {
            return Image.network(
              _bannerList[index]["imagePath"],
              fit: BoxFit.cover,
            );
          },
          onTap: (int index) {
            debugPrint("index:======= $index");
            onBannerItemClick(index);
          },
          pagination: new SwiperPagination(alignment: Alignment.bottomRight),
        ));
  }

  Widget buildArticleItem(int index) {
    return GestureDetector(
      child: ArticleItem(_articleList[index - 1]),
      onTap: () {
        onItemClick(index);
      },
    );
//    return Container(
//        padding: EdgeInsets.only(left: 15, right: 15),
//        height: 100,
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: [
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: [
//                Row(
//                  children: [
//                    Text("作者："),
//                    Text(
//                      _articleList[index - 1]["shareUser"].toString().isEmpty
//                          ? _articleList[index - 1]["author"]
//                          : _articleList[index - 1]["shareUser"],
//                      style: TextStyle(color: Color.fromARGB(255, 0, 191, 255)),
//                    ),
//                  ],
//                ),
//                Text(
//                  _articleList[index - 1]["niceShareDate"],
//                  maxLines: 2,
//                  overflow: TextOverflow.ellipsis,
//                )
//              ],
//            ),
//            Text(
//              _articleList[index - 1]["title"],
//              style: TextStyle(fontWeight: FontWeight.bold),
//              textAlign: TextAlign.start,
//            ),
//            Text(
//              _articleList[index - 1]["superChapterName"],
//              style: TextStyle(color: Color.fromARGB(255, 0, 191, 255)),
//            ),
//          ],
//        ));
  }

  void onItemClick(int index) {
    Route<Object?> route = MaterialPageRoute(
        builder: (BuildContext context) =>
            ArticleDetailWebView(_articleList[index - 1]["link"]));
    Navigator.push(context, route);
  }

  void onBannerItemClick(int index) {
    Route<Object?> route = MaterialPageRoute(
        builder: (BuildContext context) =>
            ArticleDetailWebView(_bannerList[index]["url"]));
    Navigator.push(context, route);
  }
}
