import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app_api/helper/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../helper/news.dart';
import 'category_everything.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool _loading;
  var newsList;
  RefreshController _refreshController;

  void getNews() async {
    News news = News();
    await news.getTopHeadLinesNews();
    newsList = news.news;
    setState(() {
      _loading = false;
    });
  }
  void enterRefresh() {
    _refreshController.requestRefresh();
  }
  @override
  void initState() {
    _loading = true;
    _refreshController = RefreshController();

    // TODO: implement initState
    super.initState();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Top",
              style:
              TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
            ),
            Text(
              "HeadLines",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            )
          ],
        ),
        actions: [
          Container(
              padding: EdgeInsets.all(8),
              height: 70,
              child:GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => CategoryEverything()
                  ));
                },
                child: Container(
                  margin: EdgeInsets.only(right: 14),
                  child: Stack(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          imageUrl: "https://images.unsplash.com/photo-1507679799987-c73779587ccf?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1502&q=80",
                          height: 60,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 60,
                        width: 120,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.black26
                        ),
                        child: Text(
                          "Everything",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                ),
              )
          ),
        ],

        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          header: WaterDropHeader(),
          // enablePullUp: true,
          onRefresh: () {
            getNews();
            Future.delayed(const Duration(milliseconds: 200)).then((val) {
              if (mounted)
                setState(() {
                  _refreshController.refreshCompleted();
                });
            });
          },
          onLoading: () {
            Future.delayed(const Duration(milliseconds: 200)).then((val) {
              if (mounted)
                setState(() {
                  _refreshController.loadComplete();
                });
            });
          },
          // onOffsetChange: _onOffsetCallback,
              child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        /// Categories


                        /// News Article
                        Container(
                          margin: EdgeInsets.only(top: 16),
                          child: ListView.builder(
                              itemCount: newsList.length,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return NewsTile(
                                  imgUrl: newsList[index].urlToImage ?? "",
                                  title: newsList[index].title ?? "",
                                  desc: newsList[index].description ?? "",
                                  content: newsList[index].content ?? "",
                                  posturl: newsList[index].articleUrl ?? "",
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
            ),
      ),
    );
  }
}