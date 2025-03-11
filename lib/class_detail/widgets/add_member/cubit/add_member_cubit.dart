import 'package:bloc/bloc.dart';
import 'package:class_repository/class_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:profile_repository/profile_repository.dart';

part 'add_member_state.dart';

class AddMemberCubit extends Cubit<AddMemberState> {

  final ProfileRepository _profileRepository;
  final ClassRepository _classRepository;

  AddMemberCubit(this._profileRepository, this._classRepository) : super(const AddMemberState());

  void init(String classId) {
    _profileRepository.getProfiles().listen((profiles) {
      emit(state.copyWith(members: profiles));
    });
    emit(state.copyWith(classId: classId));
  }

  void search(String query) {
    _profileRepository.searchProfiles(query).listen((profiles) {
      emit(state.copyWith(members: profiles, searchQuery: query));
    });
  }

  void toggleMember(Profile member) {
    final selectedMembers = List<Profile>.from(state.selectedMembers);
    if (selectedMembers.contains(member)) {
      selectedMembers.remove(member);
    } else {
      selectedMembers.add(member);
    }
    emit(state.copyWith(selectedMembers: selectedMembers));
  }

  void addMembers() {
    final selectedMemberIds = state.selectedMembers.map((member) => member.id).toList();
    _classRepository.addMembersToClass(state.classId, selectedMemberIds);
  }
}
