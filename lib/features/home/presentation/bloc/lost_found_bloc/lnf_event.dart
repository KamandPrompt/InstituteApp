part of 'lnf_bloc.dart';

abstract class LnfEvent extends Equatable {
  const LnfEvent();

  @override
  List<Object> get props => [];
}

class GetLostFoundItemsEvent extends LnfEvent {
  const GetLostFoundItemsEvent();
}

class AddOrEditLostFoundItemEvent extends LnfEvent {
  final String? id;
  final String from;
  final String lostOrFound;
  final String name;
  final String description;
  final FilePickerResult images;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String phoneNo;

  const AddOrEditLostFoundItemEvent(
      {required this.id,
      required this.from,
      required this.lostOrFound,
      required this.name,
      required this.description,
      required this.images,
      required this.createdAt,
      required this.updatedAt,
      required this.phoneNo});
}

class DeleteLostFoundItemEvent extends LnfEvent {
  final String id;

  const DeleteLostFoundItemEvent({required this.id});
}
