import 'package:flutter/material.dart';
import 'articles.dart';
import 'package:my_app/router/navigation.dart';
import 'package:my_app/pages/Article/article_details.dart';

// 文章卡片布局
class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.only(top: 0),
        child: Container(
          height: 160,
          child: ListTile(
            title: Text.rich(TextSpan(children: [
              TextSpan(
                text: '${article.title}   ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextSpan(
                text: article.author,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              )
            ])),
            subtitle: Text(article.mainbody,
                maxLines: 5, overflow: TextOverflow.ellipsis),
            isThreeLine: true,
            onTap: () {
              navigateToPages(
                  context,
                  () => ArticleDetails(
                        article: article,
                      ),
                  SlideDirection.right);
            },
          ),
        ));
  }
}
