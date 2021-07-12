import 'package:flutter/material.dart';
import 'package:news_app_api/helper/news.dart';
import 'package:news_app_api/helper/widgets.dart';

import '../models/article.dart';

class CategoryEverything extends StatefulWidget {



  @override
  _CategoryEverythingState createState() => _CategoryEverythingState();
}

class _CategoryEverythingState extends State<CategoryEverything> {
  var newslist;
  bool _loading = true;
  TextEditingController searchController = new TextEditingController();
  List<Article> _searchResult = [];

  @override
  void initState() {
    getNews();
    // TODO: implement initState
    super.initState();
  }

  void getNews() async {
    NewsForCategoryEverything news = NewsForCategoryEverything();
    await news.getNewsForCategoryEverything("everything");
    newslist = news.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Every",
              style:
              TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
            ),
            Text(
              "Thing",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            )
          ],
        ),
        actions: <Widget>[
          Opacity(
            opacity: 0,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.share,)),
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: _loading ? Center(
        child: CircularProgressIndicator(),
      ) : SingleChildScrollView(
        child: Column(
          children : [
            new Container(
              color: Theme.of(context).primaryColor,
              child: new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Card(
                  child: new ListTile(
                    leading: new Icon(Icons.search),
                    title: new TextField(
                      controller: searchController,
                      decoration: new InputDecoration(
                          hintText: 'Search', border: InputBorder.none),
                      onChanged: onSearchTextChanged,
                    ),
                    trailing: new IconButton(icon: new Icon(Icons.cancel), onPressed: () {
                      searchController.clear();
                      onSearchTextChanged('');
                    },),
                  ),
                ),
              ),
            ),
            _searchResult.length != 0 || searchController.text.isNotEmpty ?
            Column(
              children: [
                Text(_searchResult.length.toString() +" Results Found"),
                new Container(
                  child: Container(
                    margin: EdgeInsets.only(top: 16),
                    child: ListView.builder(
                        itemCount: _searchResult.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return NewsTile(
                            imgUrl: _searchResult[index].urlToImage ?? "",
                            title: _searchResult[index].title ?? "",
                            desc: _searchResult[index].description ?? "",
                            content: _searchResult[index].content ?? "",
                            posturl: _searchResult[index].articleUrl ?? "",
                          );
                        }),
                  ),
                ),
              ],
            ) :

            Container(
              child: Container(
                margin: EdgeInsets.only(top: 16),
                child: ListView.builder(
                    itemCount: newslist.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return NewsTile(
                        imgUrl: newslist[index].urlToImage ?? "",
                        title: newslist[index].title ?? "",
                        desc: newslist[index].description ?? "",
                        content: newslist[index].content ?? "",
                        posturl: newslist[index].articleUrl ?? "",
                      );
                    }),
              ),
            ),

          ]
        ),
      ),
    );
  }
  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    _searchResult=newslist
        .where((article) =>
    article.title
        .toString().toLowerCase().contains(text) ||
        article.description.toString().toLowerCase().contains(text))
        .toList();
    setState(() {});
  }
}

