

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_list/providers/items_data.dart';

class MissionAdder extends StatefulWidget {
  @override
  _MissionAdderState createState() => _MissionAdderState();
}

class _MissionAdderState extends State<MissionAdder> {
  final TextEditingController textEditingController = TextEditingController();
  List<String> selectedCategories = [];
  bool isTitleCase = false;

  @override
  Widget build(BuildContext context) {
    final itemData = Provider.of<ItemData>(context);

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              maxLines: 2,
              minLines: 1,
              style: const TextStyle(fontSize: 20, color: Colors.black),
              controller: textEditingController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: 'Add Mission',
              ),
              autofocus: true,
            ),
           Wrap(
              spacing: 3.0,
              children: itemData.categories.map((category) {
                return ChoiceChip(
                  label: Text(category.name),
                  selected: selectedCategories.contains(category.name),
                  selectedColor: Theme.of(context).primaryColor,
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: selectedCategories.contains(category.name)
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedCategories.add(category.name);
                      } else {
                        selectedCategories.remove(category.name);
                      }
                    });
                  },
                );
              }).toList(),
            ),
        
            TextButton(
              onPressed: () {
                String missionTitle = textEditingController.text.trim();
                if (isTitleCase) {
                  missionTitle = missionTitle.split(' ').map((word) {
                    return word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '';
                  }).join(' ');
                }
                if (missionTitle.isNotEmpty) {
                  for (String category in selectedCategories) {
                    itemData.addItemToCategory(category, missionTitle);
                  }
                  if (selectedCategories.isEmpty) {
                    itemData.addItem(missionTitle);
                  }
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
