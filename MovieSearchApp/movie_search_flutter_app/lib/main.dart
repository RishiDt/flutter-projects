import 'dart:async';
import 'package:flutter/services.dart';
import 'package:movie_search_flutter_app/presentation/widgets/movie_app.dart';

import 'di/get_it.dart' as getIt;

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]));
  // unawaited(getIt.init());

  runApp(MaterialApp(
    home: MovieApp(),
  ));
}
