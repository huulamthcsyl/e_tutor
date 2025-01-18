import 'package:e_tutor/class/class.dart';
import 'package:e_tutor/class_detail/class_detail.dart';
import 'package:e_tutor/utils/format_currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassView extends StatelessWidget {
  const ClassView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClassCubit, ClassState>(
      builder: (context, state) {
        switch (state.status) {
          case ClassStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case ClassStatus.success:
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: state.classes.length,
                itemBuilder: (context, index) {
                  final _class = state.classes[index];
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push<void>(
                      ClassDetailPage.route(id: _class.id),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _class.name ?? "",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _class.description!.isNotEmpty
                            ? Text(
                               _class.description ?? "",
                                style: const TextStyle(
                                fontSize: 16,
                              ),
                            )
                            : const SizedBox(),
                          const SizedBox(height: 8),
                          Text(
                            'Học phí: ${FormatCurrency.format(_class.tuition ?? 0)}đ / buổi',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          default:
            return const Center(child: Text('Failed to fetch classes'));
        }
      },
    );
  }
}
