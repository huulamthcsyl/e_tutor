import 'package:bloc/bloc.dart';
import 'package:class_repository/class_repository.dart';
import 'package:e_tutor/utils/auth_service.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:formz/formz.dart';
import 'package:profile_repository/profile_repository.dart';

part 'exam_detail_state.dart';

class ExamCubit extends Cubit<ExamState> {

  final ClassRepository classRepository;

  ExamCubit(this.classRepository) : super(const ExamState());

  void initialize(String examId) async {
    emit(state.copyWith(status: ExamStatus.loading));
    try {
      final exam = await classRepository.getExamById(examId);
      final currentUser = await AuthService().getCurrentUserProfile();
      if (exam.status != "pending") {
        emit(state.copyWith(
          actionStatus: ActionStatus.ended,
        ));
      } else {
        if (exam.startTime != null && exam.endTime != null) {
          emit(state.copyWith(
            actionStatus: exam.startTime!.isAfter(DateTime.now())
                ? ActionStatus.notStarted
                :
            (exam.endTime!.isBefore(DateTime.now())
                ? ActionStatus.ended
                : ActionStatus.todo),
          ));
        }
      }
      emit(state.copyWith(
        status: ExamStatus.success,
        exam: exam,
        user: currentUser,
        studentWorks: exam.studentWorks ?? [],
      ));
    } catch (e) {
      emit(state.copyWith(status: ExamStatus.failure));
    }
  }

  void startExam() async {
    try {
      emit(state.copyWith(
        actionStatus: ActionStatus.inProgress,
      ));
    } catch (e) {
      emit(state.copyWith(status: ExamStatus.failure));
    }
  }

  void uploadStudentWork() async {
    emit(state.copyWith(uploadStatus: UploadStatus.uploading));
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );
    if (file != null) {
      final path = await classRepository.uploadExamStudentWork(
        state.exam.id!,
        file.files.first.name,
        file.files.first.bytes!,
      );
      final studentWork = Material(
        name: file.files.first.name,
        url: path,
      );
      emit(state.copyWith(
        studentWorks: [...state.studentWorks, studentWork],
        uploadStatus: UploadStatus.uploaded,
      ));
    } else {
      emit(state.copyWith(uploadStatus: UploadStatus.initial));
    }
  }

  void deleteStudentWork(Material work) async {
    emit(state.copyWith(uploadStatus: UploadStatus.uploading));
    try {
      emit(state.copyWith(
        studentWorks: state.studentWorks.where((w) => w.url != work.url).toList(),
        uploadStatus: UploadStatus.uploaded,
      ));
    } catch (e) {
      emit(state.copyWith(uploadStatus: UploadStatus.initial));
    }
  }

  void submitExam() async {
    emit(state.copyWith(submissionStatus: FormzSubmissionStatus.inProgress));
    try {
      await classRepository.submitExam(
        state.exam.id!,
        state.studentWorks
      );
      emit(state.copyWith(
        actionStatus: ActionStatus.ended,
        submissionStatus: FormzSubmissionStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(status: ExamStatus.failure));
    }
  }
}
