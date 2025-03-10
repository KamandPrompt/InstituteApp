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

class BuySellAddingItem extends BuySellState {}

class BuySellItemAdded extends BuySellState {
  final BuySellItemEntity item;

  const BuySellItemAdded({required this.item});
}

class BuySellItemsAddingError extends BuySellState {
  final String message;

  const BuySellItemsAddingError({required this.message});
}

