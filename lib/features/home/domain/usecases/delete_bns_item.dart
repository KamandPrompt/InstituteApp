import 'package:vertex/features/home/domain/repositories/buy_sell_repository.dart';

class DeleteBuySellItem {
  final BuySellRepository repository;

  DeleteBuySellItem(this.repository);

  Future<bool> execute(
    String id,
  ) {
    return repository.deleteBuySellItem(id);
  }
}
