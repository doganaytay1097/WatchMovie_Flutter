import 'package:flutter/material.dart';
import 'package:watch_list/models/item.dart';
import 'package:watch_list/services/movie_services.dart';

class MovieDetailPage extends StatefulWidget {
  final Item item;

  MovieDetailPage(this.item);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  Map<String, dynamic>? movieDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
  }

  void fetchMovieDetails() async {
    try {
      final movieService = MovieService();
      final details = await movieService.fetchMovieDetails(widget.item.title);

      setState(() {
        movieDetails = details;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Film detayları getirilemedi'),
      ));
    }
  }

  String formatVoteAverage(double vote) {
    return vote.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.item.title)),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final castImages = movieDetails?['castImages'] ?? [];
    final characters = movieDetails?['characters'] ?? [];
    final voteAverage = movieDetails?['vote_average'] ?? 0.0;
    final posterUrl = movieDetails?['poster_path'] != null
        ? 'https://image.tmdb.org/t/p/w500${movieDetails?['poster_path']}'
        : '';
    final categories = widget.item.categories.isNotEmpty
        ? widget.item.categories
        : ['No categories'];

    return Description(
      name: widget.item.title,
      description: movieDetails?['overview'] ?? 'No description available',
      posterurl: posterUrl,
      vote: formatVoteAverage(voteAverage),
      bannerurl: movieDetails?['backdrop_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${movieDetails?['backdrop_path']}'
          : '',
      launchon: movieDetails?['release_date'] ?? 'N/A',
      castImages: castImages,
      character: characters,
      categories: categories,
    );
  }
}

class Description extends StatelessWidget {
  final String name, description, posterurl, vote, bannerurl, launchon;
  final List<String> categories;
  final List<String> castImages, character;

  const Description({
    Key? key,
    required this.name,
    required this.description,
    required this.posterurl,
    required this.vote,
    required this.bannerurl,
    required this.launchon,
    required this.castImages,
    required this.character,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Details'),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView(
          children: [
            SizedBox(
              height: 250,
              child: Stack(
                children: [
                  Positioned(
                    child: SizedBox(
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: bannerurl.isNotEmpty
                            ? Image.network(
                          bannerurl,
                          fit: BoxFit.cover,
                        )
                            : Center(
                          child: Text(
                            'No image available',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    child: ModifiedText(
                      text: '⭐ Average Rating - $vote',
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(10),
              child: ModifiedText(text: name, size: 25, color: Colors.white),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10),
              child: ModifiedText(
                text: 'Released On - $launchon',
                size: 15,
                color: Colors.white,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: Wrap(
                spacing: 8.0,
                children: categories
                    .map((category) => Chip(label: Text(category)))
                    .toList(),
              ),
            ),
            Row(
              children: [
                posterurl.isNotEmpty
                    ? SizedBox(
                  height: 200,
                  width: 100,
                  child: Image.network(posterurl),
                )
                    : Container(
                  height: 200,
                  width: 100,
                  color: Colors.grey,
                  child: Center(
                    child: Text(
                      'No image',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: ModifiedText(
                      text: description,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 200,
              child: castImages.isNotEmpty
                  ? ListView.builder(
                itemCount: castImages.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  String imageURL = castImages[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(imageURL),
                        ),
                        SizedBox(
                          height: 100,
                          child: Text(
                            character[index],
                            style: const TextStyle(
                                fontSize: 15, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
                  : Center(
                child: Text(
                  'No cast available',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class ModifiedText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;

  const ModifiedText(
      {Key? key, required this.text, required this.size, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
      ),
    );
  }
}
