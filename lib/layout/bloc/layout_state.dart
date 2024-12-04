part of 'layout_bloc.dart';

class LayoutState extends Equatable {
  const LayoutState({int selectedTabIndex = 0}) : this._(selectedTabIndex: selectedTabIndex);

  const LayoutState._({this.selectedTabIndex = 0});

  final int selectedTabIndex;
  
  @override
  List<Object> get props => [selectedTabIndex];
}

