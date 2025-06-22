import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vertex/features/home/domain/entities/lost_found_item_entity.dart';
import 'package:vertex/features/home/domain/usecases/delete_lnf_item.dart';

import '../../../domain/usecases/add_or_edit_lost_found_item.dart';
import '../../../domain/usecases/get_lost_found_items.dart';

part 'lnf_event.dart';
part 'lnf_state.dart';

class LnfBloc extends Bloc<LnfEvent, LnfState> {
  final GetLostFoundItems getLostFoundItems;
  final AddOrEditLostFoundItem addOrEditLostFoundItem;
  final DeleteLnFItem deleteLostFoundItem;

  LnfBloc(
      {required this.getLostFoundItems,
      required this.addOrEditLostFoundItem,
      required this.deleteLostFoundItem})
      : super(LnfInitial()) {
    on<GetLostFoundItemsEvent>(onGetLostFoundItemsEvent);
    on<AddOrEditLostFoundItemEvent>(onAddOrEditLostFoundItemEvent);
    on<DeleteLostFoundItemEvent>(onDeleteLostFoundItemEvent);
  }

  void onGetLostFoundItemsEvent(
      GetLostFoundItemsEvent event, Emitter<LnfState> emit) async {
    emit(LnfItemsLoading());
    try {
      final items = await getLostFoundItems.execute();
      emit(LnfItemsLoaded(items: items));
    } catch (e) {
      emit(LnfItemsLoadingError(message: "Error during fetching items : $e"));
    }
  }

  void onAddOrEditLostFoundItemEvent(
      AddOrEditLostFoundItemEvent event, Emitter<LnfState> emit) async {
    emit(LnfAddingOrEditingItem());
    try {
      final item = await addOrEditLostFoundItem.execute(
          event.id,
          event.from,
          event.lostOrFound,
          event.name,
          event.description,
          event.images,
          event.createdAt,
          event.updatedAt,
          event.phoneNo);
      if (item != null) {
        emit(LnfItemAddedOrEdited(item: item));
      } else {
        emit(const LnfItemsAddingOrEditingError(
            message: "Error during adding item."));
      }
    } catch (e) {
      emit(LnfItemsAddingOrEditingError(
          message: "Error during fetching items : $e"));
    }
  }

  void onDeleteLostFoundItemEvent(
      DeleteLostFoundItemEvent event, Emitter<LnfState> emit) async {
    emit(LostFoundItemDeleting());
    try {
      final isDeleted =
          await addOrEditLostFoundItem.repository.deleteLostFoundItem(event.id);
      if (isDeleted) {
        emit(LostFoundItemDeletedSuccessfully(id: event.id));
      } else {
        emit(const LostFoundItemDeleteError(
            message: "Error during deleting item."));
      }
    } catch (e) {
      emit(
          LostFoundItemDeleteError(message: "Error during deleting item : $e"));
    }
  }
}
