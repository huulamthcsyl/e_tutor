part of 'add_member_cubit.dart';

class AddMemberState extends Equatable {
  final List<Profile> members;
  final List<Profile> selectedMembers;
  final String searchQuery;
  final String classId;

  const AddMemberState({
    this.members = const [],
    this.selectedMembers = const [],
    this.searchQuery = '',
    this.classId = '',
  });

  @override
  List<Object> get props => [members, selectedMembers, searchQuery, classId];

  AddMemberState copyWith({
    List<Profile>? members,
    List<Profile>? selectedMembers,
    String? searchQuery,
    String? classId,
  }) {
    return AddMemberState(
      members: members ?? this.members,
      selectedMembers: selectedMembers ?? this.selectedMembers,
      searchQuery: searchQuery ?? this.searchQuery,
      classId: classId ?? this.classId,
    );
  }
}
