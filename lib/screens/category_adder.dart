
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:watch_list/providers/items_data.dart';


class CategoryAdder extends StatelessWidget {
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              maxLines: 1,
              style: const TextStyle(fontSize: 20, color: Colors.black),
              controller: textEditingController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: 'Add Category',
              ),
              autofocus: true,
            ),
            TextButton(
              onPressed: () {
                final categoryName = textEditingController.text.trim();
                if (categoryName.isNotEmpty) {
                  Provider.of<ItemData>(context, listen: false).addCategory(categoryName);
                  Navigator.pop(context);
                }
              },
              child: Text(
                'ADD',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
