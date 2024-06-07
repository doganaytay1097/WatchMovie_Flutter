import 'package:watch_list/models/item.dart';

class Category {
  final String name;
  final List<Item> items;

  Category(this.name, this.items);

  Category.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        items = (map['items'] as List).map((item) => Item.fromMap(item)).toList();

  Map<String, dynamic> toMap() => {'name': name, 'items': items.map((item) => item.toMap()).toList()};
}
