// 收藏页布局
import 'package:flutter/material.dart';
import 'package:my_app/Local_Storage/shared_preferences.dart';
import 'package:my_app/pages/Article/articles.dart';
import 'package:my_app/pages/Article/article_card.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Article> favoriteArticles = [];
  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favoritesManager = LocalStorageManager();
    final articles = await favoritesManager.getFavoriteArticles();
    setState(() {
      favoriteArticles = articles;
    });
  }

  Future<bool?> _confirmDismiss(Article article) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('确认取消收藏'),
          content: Text('您确定要取消收藏 ${article.title} 吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // 取消
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // 确认
              child: Text('确认'),
            ),
          ],
        );
      },
    );
  }

  void _removeFavorite(Article article) {
    setState(() {
      favoriteArticles.remove(article); // 从列表中移除收藏的文章
    });
    // 在这里添加代码，将文章从本地存储中删除
    LocalStorageManager().removeFavoriteArticle(article); // 假设你有这个方法
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () async {
            await LocalStorageManager().removeString('favorites');
          },
          child: Text('收藏'),
        ),
      ),
      body: favoriteArticles.isEmpty
          ? Center(
              child: Text('No favorites yet.'),
            )
          : ListView.builder(
              itemCount: favoriteArticles.length,
              itemBuilder: (context, index) {
                final article = favoriteArticles[index];
                return Padding(
                    padding: EdgeInsets.all(5),
                    child: Dismissible(
                        key: Key(article.title),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          return await _confirmDismiss(article); // 确认删除
                        },
                        onDismissed: (direction) {
                          setState(() {
                            _removeFavorite(article);
                          });
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.close, color: Colors.white),
                        ),
                        child: ArticleCard(article: article)));
              },
            ),
    );
  }
}
