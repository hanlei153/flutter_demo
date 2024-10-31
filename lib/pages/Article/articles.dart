class Article {
  final String title;
  final String author;
  final String mainbody;

  Article({required this.title, required this.author, required this.mainbody});

  // 将 Article 转换为 Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'mainbody': mainbody,
    };
  }

  // 从 Map 创建 Article
  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      mainbody: map['mainbody'] ?? '',
    );
  }
}
