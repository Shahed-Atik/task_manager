import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

extension PagingStateExt<PageKeyType, ItemType>
    on PagingState<PageKeyType, ItemType> {
  PagingState<PageKeyType, ItemType> copyWithError({
    required dynamic error,
  }) {
    return PagingState<PageKeyType, ItemType>(
      nextPageKey: nextPageKey,
      error: error,
      itemList: nextPageKey == 0 ? null : itemList?.cast<ItemType>(),
    );
  }
}
