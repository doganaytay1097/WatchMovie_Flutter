class Item {
  final String title;
  bool isDone;
  String? posterPath;
  String? overview;
  String? releaseDate; // Yeni alan
  List<String> categories;

  Item(this.title, this.isDone, {this.posterPath, this.overview, this.releaseDate, this.categories = const []});

  void toggleStatus() {
    isDone = !isDone;
  }

  Item.fromMap(Map<String, dynamic> map)
      : title = map['title'],
        isDone = map['isDone'],
        posterPath = map['posterPath'],
        overview = map['overview'],
        releaseDate = map['releaseDate'], // Yeni alanı ekledik
        categories = List<String>.from(map['categories']);

  Map<String, dynamic> toMap() => {
    'title': title,
    'isDone': isDone,
    'posterPath': posterPath,
    'overview': overview,
    'releaseDate': releaseDate, // Yeni alanı ekledik
    'categories': categories,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Item &&
              runtimeType == other.runtimeType &&
              title == other.title;

  @override
  int get hashCode => title.hashCode;
}
