part of 'bns_bloc.dart';

abstract class BuySellEvent extends Equatable {
  const BuySellEvent();

  @override
  List<Object> get props => [];
}

class GetBuySellItemsEvent extends BuySellEvent {
  const GetBuySellItemsEvent();
}

class AddOrEditBuySellItemEvent extends BuySellEvent {
  final String? id;
  final String name;
  final String productDescription;
  final FilePickerResult productImage;
  final String soldBy;
  final String maxPrice;
  final String minPrice;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String phoneNo;

  const AddOrEditBuySellItemEvent({
    required this.id,
    required this.name,
    required this.productDescription,
    required this.productImage,
    required this.soldBy,
    required this.maxPrice,
    required this.minPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.phoneNo,
  });
}

class DeleteBuySellItemEvent extends BuySellEvent {
  final String id;

  const DeleteBuySellItemEvent({required this.id});
}