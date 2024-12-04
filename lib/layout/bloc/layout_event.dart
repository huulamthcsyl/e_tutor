part of 'layout_bloc.dart';

sealed class LayoutEvent extends Equatable {
  const LayoutEvent();

  @override
  List<Object> get props => [];
}

final class TabChanged extends LayoutEvent {
  const TabChanged(this.index);
  
  final int index;

  @override
  List<Object> get props => [index];
}
