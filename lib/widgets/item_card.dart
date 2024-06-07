import 'package:flutter/material.dart';
import 'package:watch_list/models/item.dart';
import 'package:watch_list/screens/movie_detail_page.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback toggleStatus;
  final VoidCallback delete;

  ItemCard(this.item, this.toggleStatus, this.delete, {super.key});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) => delete(),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
      ),
      child: Card(
        color: Colors.grey.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        shadowColor: Colors.teal,
        child: ListTile(
          contentPadding: const EdgeInsets.all(10.0),
          leading: item.posterPath != null && item.posterPath!.isNotEmpty
              ? ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              'https://image.tmdb.org/t/p/w92${item.posterPath}',
              width: 50,
            ),
          )
              : Icon(Icons.movie, color: Colors.white, size: 50),
          title: Row(
            children: [
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: item.isDone ? TextDecoration.lineThrough : TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
          subtitle: item.overview != null
              ? Text(item.overview!, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white70, decoration: item.isDone ? TextDecoration.lineThrough : TextDecoration.none,))
              : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: item.isDone,
                onChanged: (value) => toggleStatus(),
                checkColor: Colors.white,
                activeColor: Colors.teal,
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailPage(item),
              ),
            );
          },
        ),
      ),
    );
  }
}
