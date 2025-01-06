import 'package:class_repository/class_repository.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'pdf_view_state.dart';

class PdfViewCubit extends Cubit<PdfViewState> {

  final ClassRepository _classRepository;

  PdfViewCubit(this._classRepository) : super(const PdfViewState());

  Future<void> initialize(String url) async {
    emit(state.copyWith(status: PdfViewStatus.loading));
    try {
      final pdfPath = await _classRepository.getMaterialUrl(url);
      final pdf = await PDFDocument.fromURL(pdfPath);
      emit(state.copyWith(pdf: pdf, status: PdfViewStatus.success));
    } on ClassFailure {
      emit(state.copyWith(status: PdfViewStatus.failure));
    }
  }
}
