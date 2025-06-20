import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vertex/features/home/domain/entities/post_entity.dart';
import 'package:vertex/features/home/domain/usecases/delete_post_item.dart';

import '../../../domain/usecases/add_or_edit_post_item.dart';
import '../../../domain/usecases/get_post_item.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final GetPostItem getPostItems;
  final AddOrEditPostItem addOrEditPostItem;
  final DeletePostItem deletePostItem;

  PostBloc(
      {required this.getPostItems,
      required this.addOrEditPostItem,
      required this.deletePostItem})
      : super(PostInitial()) {
    on<GetPostItemsEvent>(onGetPostItemsEvent);
    on<AddorEditPostItemEvent>(onAddOrEditPostItemEvent);
    on<DeletePostItemEvent>(onDeletePostItemEvent);
  }

  void onGetPostItemsEvent(
      GetPostItemsEvent event, Emitter<PostState> emit) async {
    emit(PostItemsLoading());
    try {
      final items = await getPostItems.execute();
      emit(PostItemsLoaded(items: items));
    } catch (e) {
      emit(PostItemsLoadingError(message: "Error during fetching items : $e"));
    }
  }

  void onAddOrEditPostItemEvent(
      AddorEditPostItemEvent event, Emitter<PostState> emit) async {
    emit(PostAddingOrEditingItem());
    try {
      final item = await addOrEditPostItem.execute(
          event.id,
          event.title,
          event.description,
          event.images,
          event.link,
          event.host,
          event.type,
          event.emailId,
          event.createdAt,
          event.updatedAt);
      if (item != null) {
        emit(PostItemAddedOrEdited(item: item));
      } else {
        emit(const PostItemsAddingOrEditingError(
            message: "Error during adding/editing post."));
      }
    } catch (e) {
      emit(PostItemsAddingOrEditingError(
          message: "Error during fetching posts: $e"));
    }
  }

  void onDeletePostItemEvent(
      DeletePostItemEvent event, Emitter<PostState> emit) async {
    emit(PostItemDeleting());
    try {
      final result = await deletePostItem.execute(event.id);
      if (result) {
        emit(PostItemDeletedSuccessfully(id: event.id));
      } else {
        emit(PostItemDeleteError(message: "Error during deleting post."));
      }
    } catch (e) {
      emit(PostItemsAddingOrEditingError(
          message: "Error during fetching posts: $e"));
    }
  }
}
