import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieService {
  final String apikey = 'd9e063e604b5c938e70876c537f01c20';
  // final String readaccesstoken =
  //     'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkOWUwNjNlNjA0YjVjOTM4ZTcwODc2YzUzN2YwMWMyMCIsInN1YiI6IjY1OTM5MDU0NjUxZmNmNWViYThmYjFjZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.dvYTroDlmHiRcMd8kDpi5pBg7rCWW4P0EwrI0gOUPgw';

  Future<Map<String, dynamic>> fetchMovieDetails(String movieName) async {
    final queryParameters = {
      'api_key': apikey,
      'query': movieName,
    };
    final uri = Uri.https('api.themoviedb.org', '/3/search/movie', queryParameters);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'].isNotEmpty) {
        final movieId = data['results'][0]['id'];
        return await fetchMovieById(movieId);
      } else {
        throw Exception('Film bulunamadı');
      }
    } else {
      throw Exception('API isteği başarısız oldu');
    }
  }

  Future<Map<String, dynamic>> fetchMovieById(int movieId) async {
    final queryParameters = {
      'api_key': apikey,
    };
    final uri = Uri.https('api.themoviedb.org', '/3/movie/$movieId', queryParameters);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final movieDetails = json.decode(response.body);
      final castDetails = await fetchCastDetails(movieId);
      movieDetails['castImages'] = castDetails['castImages'];
      movieDetails['characters'] = castDetails['characters'];
      return movieDetails;
    } else {
      throw Exception('API isteği başarısız oldu');
    }
  }

  Future<Map<String, List<String>>> fetchCastDetails(int movieId) async {
    final queryParameters = {
      'api_key': apikey,
    };
    final uri = Uri.https('api.themoviedb.org', '/3/movie/$movieId/credits', queryParameters);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final castImages = (data['cast'] as List).map((castMember) {
        return castMember['profile_path'] != null
            ? 'https://image.tmdb.org/t/p/w500${castMember['profile_path']}'
            : 'https://via.placeholder.com/150';
      }).toList();

      final characters = (data['cast'] as List).map((castMember) {
        return castMember['character'];
      }).toList();

      return {
        'castImages': List<String>.from(castImages),
        'characters': List<String>.from(characters),
      };
    } else {
      throw Exception('API isteği başarısız oldu');
    }
  }
}
