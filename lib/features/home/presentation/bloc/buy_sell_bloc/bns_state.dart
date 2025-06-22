part of 'bns_bloc.dart';

abstract class BuySellState extends Equatable {
  const BuySellState();

  @override
  List<Object> get props => [];
}

class BuySellInitial extends BuySellState {}

class BuySellItemsLoading extends BuySellState {}

class BuySellItemsLoaded extends BuySellState {
  final List<BuySellItemEntity> items;

  const BuySellItemsLoaded({required this.items});
}

class BuySellItemsLoadingError extends BuySellState {
  final String message;

  const BuySellItemsLoadingError({required this.message});
}

class BuySellAddingOrEditingItem extends BuySellState {}

class BuySellItemAddedOrEdited extends BuySellState {
  final BuySellItemEntity item;

  const BuySellItemAddedOrEdited({required this.item});
}

class BuySellItemsAddingOrEditingError extends BuySellState {
  final String message;

  const BuySellItemsAddingOrEditingError({required this.message});
}

class BuySellItemDeleting extends BuySellState {}

class BuySellItemDeletedSuccessfully extends BuySellState {
  final String id;

  const BuySellItemDeletedSuccessfully({required this.id});
}

class BuySellItemDeleteError extends BuySellState {
  final String message;

  const BuySellItemDeleteError({required this.message});
}