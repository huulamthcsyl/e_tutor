import 'package:class_repository/class_repository.dart';
import 'package:e_tutor/class_detail/widgets/add_member/add_member.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_repository/profile_repository.dart';

class AddMemberDialog extends StatelessWidget {

  const AddMemberDialog({super.key});

  static Route<void> route(String classId) {
    return MaterialPageRoute<void>(
      builder: (context) => BlocProvider(
        create: (context) => AddMemberCubit(
          context.read<ProfileRepository>(),
          context.read<ClassRepository>(),
        )..init(classId),
        child: const AddMemberDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddMemberCubit, AddMemberState>(
      builder: (context, state) {
        return Dialog.fullscreen(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Thêm thành viên',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _SearchInput(),
                const SizedBox(height: 16),
                _MemberList(),
                const SizedBox(height: 16),
                _Button(selectedMembers: state.selectedMembers),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SearchInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (query) {
        context.read<AddMemberCubit>().search(query);
      },
      decoration: const InputDecoration(
        hintText: 'Tìm kiếm',
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}

class _MemberList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddMemberCubit, AddMemberState>(
      buildWhen: (previous, current) => previous.members != current.members || previous.selectedMembers != current.selectedMembers,
      builder: (context, state) {
        return Column(
          children: state.members
              .map(
                (member) =>
                GestureDetector(
                  onTap: () {
                    context.read<AddMemberCubit>().toggleMember(member);
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        value: state.selectedMembers.contains(member),
                        onChanged: (_) {
                          context.read<AddMemberCubit>().toggleMember(member);
                        },
                      ),
                      Text(member.name ?? ''),
                    ],
                  ),
                )
          )
              .toList(),
        );
      },
    );
  }
}

class _Button extends StatelessWidget {

  const _Button({required this.selectedMembers});

  final List<Profile> selectedMembers;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Hủy'),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {
            context.read<AddMemberCubit>().addMembers();
            Navigator.of(context).pop(selectedMembers);
          },
          child: const Text('Thêm'),
        ),
      ],
    );
  }
}
