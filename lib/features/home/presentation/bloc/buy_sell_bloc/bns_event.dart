part of 'bns_bloc.dart';

abstract class BuySellEvent extends Equatable {
  const BuySellEvent();

  @override
  List<Object> get props => [];
}

class GetBuySellItemsEvent extends BuySellEvent {
  const GetBuySellItemsEvent();
}

class AddBuySellItemEvent extends BuySellEvent {
  final String productName;
  final String productDescription;
  final FilePickerResult productImage;
  final String soldBy;
  final String maxPrice; 
  final String minPrice; 
  final DateTime addDate;
  final String phoneNo;

  const AddBuySellItemEvent({
    required this.productName,
    required this.productDescription,
    required this.productImage,
    required this.soldBy,
    required this.maxPrice, // Updated field
    required this.minPrice, // New field
    required this.addDate,
    required this.phoneNo,
  });

  @override
  List<Object> get props => [
        productName,
        productDescription,
        productImage,
        soldBy,
        maxPrice,
        minPrice,
        addDate,
        phoneNo,
      ];
}

