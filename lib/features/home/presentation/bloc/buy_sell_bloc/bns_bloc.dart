import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uhl_link/features/home/domain/entities/buy_sell_item_entity.dart';
import 'package:file_picker/file_picker.dart';
import '../../../domain/usecases/add_buy_sell_items.dart';
import '../../../domain/usecases/get_buy_sell_items.dart';

part 'bns_event.dart';
part 'bns_state.dart';

class BuySellBloc extends Bloc<BuySellEvent, BuySellState> {
  final GetBuySellItems getBuySellItems;
  final AddBuySellItem addBuySellItem;

  BuySellBloc({required this.getBuySellItems, required this.addBuySellItem})
      : super(BuySellInitial()) {
    on<GetBuySellItemsEvent>(onGetBuySellItemsEvent);
    on<AddBuySellItemEvent>(onAddBuySellItemEvent);
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

  void onAddBuySellItemEvent(
      AddBuySellItemEvent event, Emitter<BuySellState> emit) async {
    emit(BuySellAddingItem());
    try {
      final item = await addBuySellItem.execute(
          event.productName,
          event.productDescription,
          event.productImage,
          event.soldBy,
          event.maxPrice, 
          event.minPrice,
          event.addDate,
          event.phoneNo);
      if (item != null) {
        emit(BuySellItemAdded(item: item));
      } else {
        emit(const BuySellItemsAddingError(message: "Error adding item."));
      }
    } catch (e) {
      emit(BuySellItemsAddingError(message: "Error adding item: $e"));
    }
  }
}

