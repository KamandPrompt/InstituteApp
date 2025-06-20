part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class PostItemsLoading extends PostState {}

class PostItemsLoaded extends PostState {
  final List<PostItemEntity> items;

  const PostItemsLoaded({required this.items});
}

class PostItemsLoadingError extends PostState {
  final String message;

  const PostItemsLoadingError({required this.message});
}

class PostAddingOrEditingItem extends PostState {}

class PostItemAddedOrEdited extends PostState {
  final PostItemEntity item;

  const PostItemAddedOrEdited({required this.item});
}

class PostItemsAddingOrEditingError extends PostState {
  final String message;

  const PostItemsAddingOrEditingError({required this.message});
}

class PostItemDeleting extends PostState {}

class PostItemDeletedSuccessfully extends PostState {
  final String id;

  const PostItemDeletedSuccessfully({required this.id});
}

class PostItemDeleteError extends PostState {
  final String message;

  const PostItemDeleteError({required this.message});
}