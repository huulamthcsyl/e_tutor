part of 'pdf_view_cubit.dart';

enum PdfViewStatus { initial, loading, success, failure }

class PdfViewState extends Equatable {
  final PdfViewStatus status;
  final PDFDocument? pdf;

  const PdfViewState({
    this.status = PdfViewStatus.initial,
    this.pdf,
  });

  @override
  List<Object> get props => [status];

  PdfViewState copyWith({
    PdfViewStatus? status,
    PDFDocument? pdf,
  }) {
    return PdfViewState(
      status: status ?? this.status,
      pdf: pdf ?? this.pdf,
    );
  }
}
