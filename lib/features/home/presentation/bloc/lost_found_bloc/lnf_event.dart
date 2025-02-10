part of 'lnf_bloc.dart';

abstract class LnfEvent extends Equatable {
  const LnfEvent();

  @override
  List<Object> get props => [];
}

class GetLostFoundItemsEvent extends LnfEvent {
  const GetLostFoundItemsEvent();
}

class AddLostFoundItemEvent extends LnfEvent {
  final String from;
  final String lostOrFound;
  final String name;
  final String description;
  final List<String> images;
  final DateTime date;
  final String phoneNo;

  const AddLostFoundItemEvent(
      {required this.from,
      required this.lostOrFound,
      required this.name,
      required this.description,
      required this.images,
      required this.date,
      required this.phoneNo});
}
