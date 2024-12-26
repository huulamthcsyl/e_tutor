import 'package:equatable/equatable.dart';

class Homework extends Equatable {
  final List<String>? materials;
  final List<String>? studentWorks;
  final double? score;
  final String? feedback;

  const Homework({
    this.materials,
    this.studentWorks,
    this.score,
    this.feedback,
  });

  @override
  List<Object?> get props => [materials, studentWorks, score, feedback];
}
