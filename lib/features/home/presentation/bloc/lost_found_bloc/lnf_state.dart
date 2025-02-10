part of 'lnf_bloc.dart';

abstract class LnfState extends Equatable {
  const LnfState();

  @override
  List<Object> get props => [];
}

class LnfInitial extends LnfState {}

class LnfItemsLoading extends LnfState {}

class LnfItemsLoaded extends LnfState {
  final List<LostFoundItemEntity> items;

  const LnfItemsLoaded({required this.items});
}

class LnfItemsLoadingError extends LnfState {
  final String message;

  const LnfItemsLoadingError({required this.message});
}

class LnfAddingItem extends LnfState {}

class LnfItemAdded extends LnfState {
  final LostFoundItemEntity item;

  const LnfItemAdded({required this.item});
}

class LnfItemsAddingError extends LnfState {
  final String message;

  const LnfItemsAddingError({required this.message});
}
