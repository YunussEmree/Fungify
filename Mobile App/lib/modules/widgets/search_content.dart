import 'package:flutter/material.dart';
import 'package:fungify/modules/widgets/loading_indicator.dart';
import 'package:fungify/modules/widgets/search_field.dart';
import 'package:fungify/modules/widgets/mushroom_list_item.dart';

class SearchContent extends StatelessWidget {
  final TextEditingController searchController;
  final String searchQuery;
  final bool isLoading;
  final List<String> filteredList;
  final Function(String) onSearch;
  final VoidCallback onClear;
  final Function(String) onItemTap;

  const SearchContent({
    super.key,
    required this.searchController,
    required this.searchQuery,
    required this.isLoading,
    required this.filteredList,
    required this.onSearch,
    required this.onClear,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SearchField(
            controller: searchController,
            hintText: 'Enter mushroom name...',
            onChanged: onSearch,
            showClearButton: searchQuery.isNotEmpty,
            onClear: onClear,
          ),
        ),
        Expanded(
          child: isLoading
              ? const LoadingIndicator()
              : MushroomListView(
                  items: filteredList,
                  onItemTap: onItemTap,
                ),
        ),
      ],
    );
  }
}

class MushroomListView extends StatelessWidget {
  final List<String> items;
  final Function(String) onItemTap;

  const MushroomListView({
    super.key,
    required this.items,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return MushroomListItem(
          name: items[index],
          onTap: () => onItemTap(items[index]),
        );
      },
    );
  }
} 