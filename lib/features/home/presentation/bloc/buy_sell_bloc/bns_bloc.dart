import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vertex/features/home/domain/entities/buy_sell_item_entity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:vertex/features/home/domain/usecases/delete_bns_item.dart';
import '../../../domain/usecases/add_or_edit_buy_sell_items.dart';
import '../../../domain/usecases/get_buy_sell_items.dart';

part 'bns_event.dart';
part 'bns_state.dart';

class BuySellBloc extends Bloc<BuySellEvent, BuySellState> {
  final GetBuySellItems getBuySellItems;
  final AddOrEditBuySellItem addOrEditBuySellItem;
  final DeleteBuySellItem deleteBuySellItem;

  BuySellBloc(
      {required this.getBuySellItems,
      required this.addOrEditBuySellItem,
      required this.deleteBuySellItem})
      : super(BuySellInitial()) {
    on<GetBuySellItemsEvent>(onGetBuySellItemsEvent);
    on<AddOrEditBuySellItemEvent>(onAddOrEditBuySellItemEvent);
    on<DeleteBuySellItemEvent>(onDeleteBuySellItemEvent);
  }

  void onGetBuySellItemsEvent(
      GetBuySellItemsEvent event, Emitter<BuySellState> emit) async {
    emit(BuySellItemsLoading());
    try {
      final items = await getBuySellItems.execute();
      emit(BuySellItemsLoaded(items: items));
    } catch (e) {
      emit(BuySellItemsLoadingError(message: "Error fetching items: $e"));
    }
  }

  void onAddOrEditBuySellItemEvent(
      AddOrEditBuySellItemEvent event, Emitter<BuySellState> emit) async {
    emit(BuySellAddingOrEditingItem());
    try {
      final item = await addOrEditBuySellItem.execute(
          event.id,
          event.name,
          event.productDescription,
          event.productImage,
          event.soldBy,
          event.maxPrice,
          event.minPrice,
          event.createdAt,
          event.updatedAt,
          event.phoneNo);
      if (item != null) {
        emit(BuySellItemAddedOrEdited(item: item));
      } else {
        emit(const BuySellItemsAddingOrEditingError(
            message: "Error adding item."));
      }
    } catch (e) {
      emit(BuySellItemsAddingOrEditingError(message: "Error adding item: $e"));
    }
  }

  void onDeleteBuySellItemEvent(
      DeleteBuySellItemEvent event, Emitter<BuySellState> emit) async {
    emit(BuySellItemDeleting());
    try {
      final result = await deleteBuySellItem.execute(event.id);
      if (result) {
        emit(BuySellItemDeletedSuccessfully(id: event.id));
      } else {
        emit(BuySellItemDeleteError(message: "Error deleting item."));
      }
    } catch (e) {
      emit(BuySellItemDeleteError(message: "Error deleting item: $e"));
    }
  }
}
