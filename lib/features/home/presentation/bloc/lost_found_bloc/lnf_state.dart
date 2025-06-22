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

class LnfAddingOrEditingItem extends LnfState {}

class LnfItemAddedOrEdited extends LnfState {
  final LostFoundItemEntity item;

  const LnfItemAddedOrEdited({required this.item});
}

class LnfItemsAddingOrEditingError extends LnfState {
  final String message;

  const LnfItemsAddingOrEditingError({required this.message});
}

class LostFoundItemDeleting extends LnfState {}

class LostFoundItemDeletedSuccessfully extends LnfState {
  final String id;

  const LostFoundItemDeletedSuccessfully({required this.id});
}

class LostFoundItemDeleteError extends LnfState {
  final String message;

  const LostFoundItemDeleteError({required this.message});
}