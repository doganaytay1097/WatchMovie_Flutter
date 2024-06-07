import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_list/models/gradient_text.dart';
import 'package:watch_list/models/item.dart';
import 'package:watch_list/providers/color_theme_data.dart';
import 'package:watch_list/widgets/item_search.dart';
import 'package:watch_list/providers/items_data.dart';
import 'package:watch_list/screens/category_manager.dart';
import 'package:watch_list/screens/misson_adder.dart';
import 'package:watch_list/widgets/item_card.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? selectedCategory;





  @override
  Widget build(BuildContext context) {
    final itemData = Provider.of<ItemData>(context);
    final colorThemeData  = Provider.of<ColorThemeData>(context);

    List<Item> itemsToShow;
    if (selectedCategory != null) {
      final category =
      itemData.categories.firstWhere((cat) => cat.name == selectedCategory);
      itemsToShow = category.items;
    } else {
      final allItems = itemData.items +
          itemData.categories.expand((cat) => cat.items).toList();
      final uniqueItems = allItems.toSet().toList();
      itemsToShow = uniqueItems;
    }

    // Tik durumuna göre sıralama
    itemsToShow.sort((a, b) {
      if (a.isDone && !b.isDone) return 1;
      if (!a.isDone && b.isDone) return -1;
      return 0;
    });

    return Scaffold(
      backgroundColor: const Color((0xff121212)),
      appBar: AppBar(
        elevation: 10.0,
        centerTitle: true,
        title: Padding(
          padding:  const EdgeInsets.only(top: 12.0),
          child: GradientText(textPath: 'Watch List'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context, delegate: ItemSearchDelegate(itemData));
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryManager()),
                );
              },
              icon: const Icon(Icons.category),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
           Image.asset('assets/image1.png',height: 140,),
           //GradientImage(imagePath: 'assets/image2.png',),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const SizedBox(width: 40),
                Expanded(
                  flex: 50,
                  child: Text(
                    '${itemsToShow.length} Films',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Expanded(
                  flex: 27,
                  child: DropdownButton<String>(
                    hint: const Text('Select Category'),
                    value: selectedCategory,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue;
                      });
                    },
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text(
                          'All',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      ...itemData.categories
                          .map<DropdownMenuItem<String>>((category) {
                        return DropdownMenuItem<String>(
                          value: category.name,
                          child: Text(
                            category.name,
                            style: TextStyle(fontSize: 15),
                          ),
                        );
                      }).toList(),
                    ],
                    isExpanded: true,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Container(
                decoration:  BoxDecoration(
                  gradient: LinearGradient(
                    colors: colorThemeData.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                    itemCount: itemsToShow.length,
                    itemBuilder: (context, index) {
                      final item = itemsToShow[index];
                      return ItemCard(
                        item,
                            () => itemData.toggleStatusByTitle(item.title),
                            () => itemData.deleteItemByTitle(item.title),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  context: context,
                  builder: (context) =>
                      SingleChildScrollView(child: MissionAdder()),
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}

