import 'package:class_repository/class_repository.dart';
import 'package:e_tutor/pdf_view/cubit/pdf_view_cubit.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PdfViewPage extends StatelessWidget {
  const PdfViewPage({super.key});

  static Route<void> route({String? url}) {
    return MaterialPageRoute<void>(
      builder: (context) => BlocProvider(
        create: (context) => PdfViewCubit(
          RepositoryProvider.of<ClassRepository>(context),
        )..initialize(url!),
        child: const PdfViewPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PdfViewCubit, PdfViewState>(
        builder: (context, state) {
          if (state.status == PdfViewStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.status == PdfViewStatus.success) {
            return Center(
              child: PDFViewer(document: state.pdf!,)
            );
          } else {
            return const Center(
              child: Text('Failed to load PDF'),
            );
          }
        },
      ),
    );
  }
}