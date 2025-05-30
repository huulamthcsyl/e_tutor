import 'package:e_tutor/class/class_list/class_list.dart';
import 'package:e_tutor/home/home.dart';
import 'package:e_tutor/profile/profile_page/view/profile_page_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_tutor/layout/layout.dart';

class LayoutView extends StatelessWidget {
  const LayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutBloc, LayoutState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: state.selectedTabIndex,
            children: const [
              HomePage(),
              ClassPage(),
              ProfilePage(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.selectedTabIndex,
            onTap: (index) {
              context.read<LayoutBloc>().add(TabChanged(index));
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Trang chủ',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.class_),
                label: 'Lớp học',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Cá nhân',
              ),
            ],
          ),
        );
      },
    );
  }
}