import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uhl_link/features/home/domain/entities/lost_found_item_entity.dart';

import '../../../domain/usecases/add_lost_found_item.dart';
import '../../../domain/usecases/get_lost_found_items.dart';

part 'lnf_event.dart';
part 'lnf_state.dart';

class LnfBloc extends Bloc<LnfEvent, LnfState> {
  final GetLostFoundItems getLostFoundItems;
  final AddLostFoundItem addLostFoundItem;

  LnfBloc({required this.getLostFoundItems, required this.addLostFoundItem})
      : super(LnfInitial()) {
    on<GetLostFoundItemsEvent>(onGetLostFoundItemsEvent);
    on<AddLostFoundItemEvent>(onAddLostFoundItemEvent);
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

  void onAddLostFoundItemEvent(
      AddLostFoundItemEvent event, Emitter<LnfState> emit) async {
    emit(LnfAddingItem());
    try {
      final item = await addLostFoundItem.execute(
          event.from,
          event.lostOrFound,
          event.name,
          event.description,
          event.images,
          event.date,
          event.phoneNo);
      if (item != null) {
        emit(LnfItemAdded(item: item));
      } else {
        emit(const LnfItemsAddingError(message: "Error during adding item."));
      }
    } catch (e) {
      emit(LnfItemsAddingError(message: "Error during fetching items : $e"));
    }
  }
}
