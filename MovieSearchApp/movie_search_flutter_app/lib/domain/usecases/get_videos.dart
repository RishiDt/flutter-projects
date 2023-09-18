import 'package:dartz/dartz.dart';
import 'package:movie_search_flutter_app/domain/usecases/use_case.dart';

import '../entities/app_error.dart';
import '../entities/movie_params.dart';
import '../entities/video_entity.dart';
import '../repositories/movie_repository.dart';

class GetVideos extends UseCase<List<VideoEntity>, MovieParams> {
  final MovieRepository repository;

  GetVideos(this.repository);

  @override
  Future<Either<AppErr, List<VideoEntity>>> call(
      MovieParams movieParams) async {
    return await repository.getVideos(movieParams.id);
  }
}
