part of 'feed_bloc.dart';

abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object> get props => [];
}

class FeedInitial extends FeedState {}

class FeedItemsLoading extends FeedState {}

class FeedItemsLoaded extends FeedState {
  final List<FeedItemEntity> items;

  const FeedItemsLoaded({required this.items});
}

class FeedItemsLoadingError extends FeedState {
  final String message;

  const FeedItemsLoadingError({required this.message});
}

class FeedAddingItem extends FeedState {}

class FeedItemAdded extends FeedState {
  final FeedItemEntity item;

  const FeedItemAdded({required this.item});
}

class FeedItemsAddingError extends FeedState {
  final String message;

  const FeedItemsAddingError({required this.message});
}