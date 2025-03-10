import '../entities/buy_sell_item_entity.dart';
import '../repositories/buy_sell_repository.dart';

class GetBuySellItems {
  final BuySellRepository repository;

  GetBuySellItems(this.repository);


  Future<List<BuySellItemEntity>> execute() {
    return repository.getBuySellItems();
  }
}