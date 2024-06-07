import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_list/models/item.dart';
import 'package:watch_list/services/movie_services.dart';
import 'package:watch_list/models/category.dart';

class ItemData with ChangeNotifier {
  final List<Item> _items = [];
  final List<Category> _categories = [];
  static late SharedPreferences _sharedPreferences;

  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);
  UnmodifiableListView<Category> get categories => UnmodifiableListView(_categories);

  void toggleStatusByTitle(String title) {
    for (var item in _items) {
      if (item.title == title) {
        item.toggleStatus();
      }
    }
    for (var category in _categories) {
      for (var item in category.items) {
        if (item.title == title) {
          item.toggleStatus();
        }
      }
    }
    saveItems();
    saveCategories();
    notifyListeners();
  }

  void deleteItemByTitle(String title) {
    _items.removeWhere((item) => item.title == title);
    for (var category in _categories) {
      category.items.removeWhere((item) => item.title == title);
    }
    saveItems();
    saveCategories();
    notifyListeners();
  }

  Item? findItemByTitle(String title) {
    for (var item in _items) {
      if (item.title == title) return item;
    }
    for (var category in _categories) {
      for (var item in category.items) {
        if (item.title == title) return item;
      }
    }
    return null;
  }

  void toggleStatus(Item item) {
    item.toggleStatus();
    saveItems();
    notifyListeners();
  }

  void deleteItem(Item item) {
    _items.remove(item);
    saveItems();
    notifyListeners();
  }

  Future<void> addItem(String title) async {
    final movieService = MovieService();
    final movieDetails = await movieService.fetchMovieDetails(title);

    final item = Item(
      title,
      false,
      posterPath: movieDetails['poster_path'],
      overview: movieDetails['overview'],
      releaseDate: movieDetails['release_date'],
    );

    _items.add(item);
    saveItems();
    notifyListeners();
  }

  void addCategory(String name) {
    _categories.add(Category(name, []));
    saveCategories();
    notifyListeners();
  }

  void deleteCategory(String name) {
    _categories.removeWhere((cat) => cat.name == name);
    saveCategories();
    notifyListeners();
  }

  Future<void> addItemToCategory(String categoryName, String title) async {
    final category = _categories.firstWhere((cat) => cat.name == categoryName);
    final movieService = MovieService();
    final movieDetails = await movieService.fetchMovieDetails(title);

    var item = findItemByTitle(title);
    if (item == null) {
      item = Item(
        title,
        false,
        posterPath: movieDetails['poster_path'],
        overview: movieDetails['overview'],
        releaseDate: movieDetails['release_date'],
        categories: [categoryName],
      );
      _items.add(item);
    } else {
      if (!item.categories.contains(categoryName)) {
        item.categories.add(categoryName);
      }
    }

    if (!category.items.contains(item)) {
      category.items.add(item);
    }

    saveCategories();
    saveItems();
    notifyListeners();
  }

  Future<void> createPrefObject() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  void saveItems() {
    final itemsString = _items.map((item) => json.encode(item.toMap())).toList();
    _sharedPreferences.setStringList('toDo', itemsString);
  }

  void loadItems() {
    final tempList = _sharedPreferences.getStringList('toDo');
    if (tempList != null) {
      _items
        ..clear()
        ..addAll(tempList.map((item) => Item.fromMap(json.decode(item))));
    }
  }

  void saveCategories() {
    final categoriesString = _categories.map((category) => json.encode(category.toMap())).toList();
    _sharedPreferences.setStringList('categories', categoriesString);
  }

  void loadCategories() {
    final categoriesString = _sharedPreferences.getStringList('categories');
    if (categoriesString != null) {
      _categories
        ..clear()
        ..addAll(categoriesString.map((category) => Category.fromMap(json.decode(category))));
    }
  }

  List<Item> searchItems(String query) {
    final lowerCaseQuery = query.toLowerCase();
    final allItems = _items + _categories.expand((cat) => cat.items).toList();
    final uniqueItems = allItems.toSet().toList();
    return uniqueItems.where((item) => item.title.toLowerCase().contains(lowerCaseQuery)).toList();
  }

  List<Item> filterItems(bool isDone) {
    return _items.where((item) => item.isDone == isDone).toList();
  }
}
