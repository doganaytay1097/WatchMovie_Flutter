import 'package:flutter/material.dart';
import 'package:watch_list/models/item.dart';
import 'package:watch_list/providers/items_data.dart';
import 'package:watch_list/screens/movie_detail_page.dart';

class ItemSearchDelegate extends SearchDelegate<Item?> {
  final ItemData itemData;

  ItemSearchDelegate(this.itemData);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = itemData.searchItems(query);

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return ListTile(
          title: Text(item.title, style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailPage(item),));
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = itemData.searchItems(query);

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final item = suggestions[index];
        return ListTile(
          title: Text(item.title, style: TextStyle(color: Colors.white)),
          onTap: () {
            query = item.title;
            showResults(context);
          },
        );
      },
    );
  }
}
