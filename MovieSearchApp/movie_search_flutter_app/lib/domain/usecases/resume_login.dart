import 'package:dartz/dartz.dart';
import 'package:movie_search_flutter_app/domain/entities/Resume_login_request_params%20copy.dart';
import 'package:movie_search_flutter_app/domain/usecases/use_case.dart';

import '../entities/app_error.dart';
import '../entities/no_params.dart';
import '../repositories/authentication_repository.dart';

class ResumeLogin extends UseCase<void, NoParams> {
  final AuthenticationRepository _authenticationRepository;

  ResumeLogin(this._authenticationRepository);

  @override
  Future<Either<AppErr, void>> call(NoParams noparams) {
    return _authenticationRepository.resumeLogin();
  }
}
