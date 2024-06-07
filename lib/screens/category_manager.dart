import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:watch_list/providers/items_data.dart';


class CategoryManager extends StatelessWidget {
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final itemData = Provider.of<ItemData>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Categories'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                labelText: 'Add Category',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
            ),
            onPressed: () {
              final categoryName = textEditingController.text.trim();
              if (categoryName.isNotEmpty) {
                itemData.addCategory(categoryName);
                textEditingController.clear();
              }
            },
            child: Text('Add'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: itemData.categories.length,
              itemBuilder: (context, index) {
                final category = itemData.categories[index];
                return ListTile(
                  title: Text(category.name),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      itemData.deleteCategory(category.name);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
