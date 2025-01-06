import 'package:equatable/equatable.dart';

class Material extends Equatable {
  final String name;
  final String url;

  const Material({
    required this.name,
    required this.url,
  });

  @override
  List<Object> get props => [name, url];
}
