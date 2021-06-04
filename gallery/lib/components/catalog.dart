//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// /// The [Catalog] holds items in memory, provides a synchronous access
// /// to them via [getByIndex], and notifies listeners when there is any change.
// class Catalog extends ChangeNotifier {
//   /// This is the maximum number of the items we want in memory in each
//   /// direction from the current position. For example, if the user
//   /// is currently looking at item number 400, we don't want item number
//   /// 0 to be kept in memory.
//   static const maxCacheDistance = 100;
//
//   /// The internal store of pages that we got from [fetchPage].
//   /// The key of the map is the starting index of the page, for faster
//   /// access.
//   final Map<int, ItemPage> _pages = {};
//
//   /// A set of pages (represented by their starting index) that have started
//   /// the fetch process but haven't ended it yet.
//   ///
//   /// This is to prevent fetching of a page several times in a row. When a page
//   /// is already being fetched, we don't initiate another fetch request.
//   final Set<int> _pagesBeingFetched = {};
//
//   /// The size of the catalog. This is `null` at first, and only when the user
//   /// reaches the end of the catalog, it will hold the actual number.
//   int? itemCount;
//
//   /// After the catalog is disposed, we don't allow it to call
//   /// [notifyListeners].
//   bool _isDisposed = false;
//
//   @override
//   void dispose() {
//     _isDisposed = true;
//     super.dispose();
//   }
//
//   /// This is a synchronous method that returns the item at [index].
//   ///
//   /// If the item is already in memory, this will just return it. Otherwise,
//   /// this method will initiate a fetch of the corresponding page, and will
//   /// return [Item.loading].
//   ///
//   /// The UI will be notified via [notifyListeners] when the fetch
//   /// is completed. At that time, calling this method will return the newly
//   /// fetched item.
//   Item getByIndex(int index) {
//     // Compute the starting index of the page where this item is located.
//     // For example, if [index] is `42` and [itemsPerPage] is `20`,
//     // then `index ~/ itemsPerPage` (integer division)
//     // evaluates to `2`, and `2 * 20` is `40`.
//     var startingIndex = (index ~/ itemsPerPage) * itemsPerPage;
//
//     // If the corresponding page is already in memory, return immediately.
//     if (_pages.containsKey(startingIndex)) {
//       var item = _pages[startingIndex]!.items[index - startingIndex];
//       return item;
//     }
//
//     // We don't have the data yet. Start fetching it.
//     _fetchPage(startingIndex);
//
//     // In the meantime, return a placeholder.
//     return Item.loading();
//   }
//
//   /// This method initiates fetching of the [ItemPage] at [startingIndex].
//   Future<void> _fetchPage(int startingIndex) async {
//     if (_pagesBeingFetched.contains(startingIndex)) {
//       // Page is already being fetched. Ignore the redundant call.
//       return;
//     }
//
//     _pagesBeingFetched.add(startingIndex);
//     final page = await fetchPage(startingIndex);
//     _pagesBeingFetched.remove(startingIndex);
//
//     if (!page.hasNext) {
//       // The returned page has no next page. This means we now know the size
//       // of the catalog.
//       itemCount = startingIndex + page.items.length;
//     }
//
//     // Store the new page.
//     _pages[startingIndex] = page;
//     _pruneCache(startingIndex);
//
//     if (!_isDisposed) {
//       // Notify the widgets that are listening to the catalog that they
//       // should rebuild.
//       notifyListeners();
//     }
//   }
//
//   /// Removes item pages that are too far away from [currentStartingIndex].
//   void _pruneCache(int currentStartingIndex) {
//     // It's bad practice to modify collections while iterating over them.
//     // So instead, we'll store the keys to remove in a separate Set.
//     final keysToRemove = <int>{};
//     for (final key in _pages.keys) {
//       if ((key - currentStartingIndex).abs() > maxCacheDistance) {
//         // This page's starting index is too far away from the current one.
//         // We'll remove it.
//         keysToRemove.add(key);
//       }
//     }
//     for (final key in keysToRemove) {
//       _pages.remove(key);
//     }
//   }
// }
//
//
// const int itemsPerPage = 20;
//
// class ItemPage {
//   final List<Item> items;
//
//   final int startingIndex;
//
//   final bool hasNext;
//
//   ItemPage({
//     required this.items,
//     required this.startingIndex,
//     required this.hasNext,
//   });
// }
//
// class Item {
//   final Color color;
//
//   final int price;
//
//   final String name;
//
//   Item({
//     required this.color,
//     required this.name,
//     required this.price,
//   });
//
//   Item.loading() : this(color: Colors.grey, name: '...', price: 0);
//
//   bool get isLoading => name == '...';
// }
//
//
// const catalogLength = 200;
//
// /// This function emulates a REST API call. You can imagine replacing its
// /// contents with an actual network call, keeping the signature the same.
// ///
// /// It will fetch a page of items from [startingIndex].
// Future<ItemPage> fetchPage(int startingIndex) async {
//   // We're emulating the delay inherent to making a network call.
//   await Future<void>.delayed(const Duration(milliseconds: 500));
//
//   // If the [startingIndex] is beyond the bounds of the catalog, an
//   // empty page will be returned.
//   if (startingIndex > catalogLength) {
//     return ItemPage(
//       items: [],
//       startingIndex: startingIndex,
//       hasNext: false,
//     );
//   }
//
//   // The page of items is generated here.
//   return ItemPage(
//     items: List.generate(
//         itemsPerPage,
//             (index) => Item(
//           color: Colors.primaries[index % Colors.primaries.length],
//           name: 'Color #${startingIndex + index}',
//           price: 50 + (index * 42) % 200,
//         )),
//     startingIndex: startingIndex,
//     // Returns `false` if we've reached the [catalogLength].
//     hasNext: startingIndex + itemsPerPage < catalogLength,
//   );
// }