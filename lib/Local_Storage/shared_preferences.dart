import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:my_app/pages/Article/articles.dart';

class LocalStorageManager {
  // stringList value
  Future<void> setStringList(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, value);
  }

  Future<List<String>?> getStringList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  // bool value
  Future<void> setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<bool> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  // string value
  Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? 'null';
  }

  Future<void> removeString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  Future<void> saveFavoriteArticle(Article article) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = await prefs.getStringList('favorites') ?? [];

    String articleJson = jsonEncode(article.toMap());
    if (!favorites.contains(articleJson)) {
      favorites.add(articleJson); // 添加文章的 JSON 字符串
    }
    await prefs.setStringList('favorites', favorites);
  }

  Future<void> removeFavoriteArticle(Article article) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = await prefs.getStringList('favorites') ?? [];

    String articleJson = jsonEncode(article.toMap());
    favorites.remove(articleJson); // 从收藏中移除
    await prefs.setStringList('favorites', favorites);
  }

  Future<List<Article>> getFavoriteArticles() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    // 将 JSON 字符串转换为 Article 对象列表
    return favorites
        .map((articleJson) => Article.fromMap(jsonDecode(articleJson)))
        .toList();
  }

  Future<bool> isArticleFavorited(Article article) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    String articleJson = jsonEncode(article.toMap());
    return favorites.contains(articleJson); // 判断文章是否在收藏列表中
  }
}
