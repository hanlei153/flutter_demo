import 'package:flutter/material.dart';
import 'package:my_app/Local_Storage/shared_preferences.dart';
import 'articles.dart';

class ArticleDetails extends StatefulWidget {
  final Article article;

  ArticleDetails({Key? key, required this.article}) : super(key: key);

  @override
  _ArticleDetailsState createState() => _ArticleDetailsState();
}

class _ArticleDetailsState extends State<ArticleDetails> {
  bool isFavorited = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  // 加载收藏状态
  Future<void> _loadFavoriteStatus() async {
    bool favorited =
        await LocalStorageManager().isArticleFavorited(widget.article);
    setState(() {
      isFavorited = favorited;
    });
  }

  void _toggleFavorite() async {
    setState(() {
      isFavorited = !isFavorited;
    });

    if (isFavorited) {
      await LocalStorageManager().saveFavoriteArticle(widget.article);
    } else {
      await LocalStorageManager().removeFavoriteArticle(widget.article);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.article.title)),
      body: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.article.title,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorited
                            ? Icons.favorite
                            : Icons.favorite_border, // 根据状态显示图标
                        color: isFavorited ? Colors.red : Colors.grey,
                      ), // 收藏按钮的图标
                      onPressed: _toggleFavorite,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'By ${widget.article.author}',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 16),
                Text(
                  widget.article.mainbody,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          )),
    );
  }
}
