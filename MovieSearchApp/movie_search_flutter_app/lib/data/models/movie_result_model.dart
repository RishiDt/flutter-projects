//collects result movies that could be for particular request

import 'package:movie_search_flutter_app/data/models/movie_model.dart';

class MovieResultModel {
  late final List<MovieModel> movies; //maps result object of result json

  MovieResultModel({required this.movies});

  MovieResultModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      movies = <MovieModel>[];
      json['results'].forEach((v) {
        movies!.add(new MovieModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.movies != null) {
      data['results'] = this.movies!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
