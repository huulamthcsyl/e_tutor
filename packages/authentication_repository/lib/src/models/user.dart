import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? email;
  final String id;

  const User({
    this.email, 
    required this.id
  });

  static const empty = User(id: '');
  
  @override
  // TODO: implement props
  List<Object?> get props => [email, id];
}
