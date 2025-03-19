import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uhl_link/features/home/domain/entities/feed_entity.dart';

import '../../../domain/usecases/add_feed_item.dart';
import '../../../domain/usecases/get_feed_item.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final GetFeedItem getFeedItems;
  final AddFeedItem addFeedItem;

  FeedBloc({required this.getFeedItems, required this.addFeedItem})
      : super(FeedInitial()) {
    on<GetFeedItemsEvent>(onGetFeedItemsEvent);
    on<AddFeedItemEvent>(onAddFeedItemEvent);
  }

  void onGetFeedItemsEvent(
      GetFeedItemsEvent event, Emitter<FeedState> emit) async {
    emit(FeedItemsLoading());
    try {
      final items = await getFeedItems.execute();
      emit(FeedItemsLoaded(items: items));
    } catch (e) {
      emit(FeedItemsLoadingError(message: "Error during fetching items : $e"));
    }
  }

  void onAddFeedItemEvent(
      AddFeedItemEvent event, Emitter<FeedState> emit) async {
    emit(FeedAddingItem());
    try {
      final item = await addFeedItem.execute(
          event.title,
          event.description,
          event.images,
          event.link,
          event.host
          );
      if (item != null) {
        emit(FeedItemAdded(item: item));
      } else {
        emit(const FeedItemsAddingError(message: "Error during adding item."));
      }
    } catch (e) {
      emit(FeedItemsAddingError(message: "Error during fetching items : $e"));
    }
  }
}