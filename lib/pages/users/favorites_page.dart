// 收藏页布局
import 'package:flutter/material.dart';
import 'package:hanlei_is_app/Local_Storage/shared_preferences.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<String> favorites = [];
  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favoritesManager = LocalStorageManager();
    final LoadFavoritesList = await favoritesManager.getStringList('favorites');
    setState(() {
      favorites = LoadFavoritesList ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('收藏'),
        ),
        body: favorites.isEmpty
            ? Center(
                child: Text('No favorites yet.'),
              )
            : ListView(
                children: favorites
                    .map((item) => ListTile(title: Text(item)))
                    .toList(),
              ));
  }
}
