import 'package:dartz/dartz.dart';

import '../entities/app_error.dart';

abstract class AuthenticationRepository {
  Future<Either<AppErr, bool>> loginUser(Map<String, dynamic> params);
  Future<Either<AppErr, void>> logoutUser();
  Future<Either<AppErr, bool>> resumeLogin();
}
