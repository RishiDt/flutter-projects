import 'package:equatable/equatable.dart';

class AppErr extends Equatable {
  final String message;

  AppErr({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
