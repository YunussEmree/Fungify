class SearchPipe {
  static List<String> filterSearchResults(List<String> list, String query) {
    if (query.isEmpty) {
      return list;
    } else {
      return list
          .where((item) =>
              item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
} 