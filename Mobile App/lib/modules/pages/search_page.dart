import 'package:flutter/material.dart';
import 'package:fungify/modules/widgets/custom_app_bar.dart';
import 'package:fungify/modules/widgets/page_content.dart';
import 'package:fungify/modules/widgets/search_content.dart';
import 'package:fungify/pipes/search_pipe.dart';
import 'package:fungify/modules/main_controller.dart';
import 'package:get/get.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final _mainController = Get.find<MainController>();
  String _searchQuery = '';
  bool _isLoading = false;
  final List<String> _mushroomList = [
    'Agaricus bisporus',
    'Amanita jacksonii',
    'Amanita muscaria',
    'Bisporella citrina',
    'Boletus edulis',
    'Cantharellus cibarius',
    'Chlorociboria aeruginosa',
    'Clathrus ruber',
    'Cordyceps sinensis',
    'Cortinarius sanguineus',
    'Cytidia salicina',
    'Geastrum saccatum',
    'Gliophorus psittacinus',
    'Helvella atra',
    'Hydnellum peckii',
    'Lactarius indigo',
    'Morchella esculenta',
    'Mycena rosea',
    'Pleurotus djamor',
    'Russula virescens',
    'Tremella fuciformis',
    'Tuber melanosporum',
  ];
  List<String> _filteredList = [];

  @override
  void initState() {
    super.initState();
    _filteredList = _mushroomList;
  }

  void _filterSearchResults(String query) {
    setState(() {
      _searchQuery = query;
      _filteredList = SearchPipe.filterSearchResults(_mushroomList, query);
    });
  }

  void _setLoading(bool value) {
    setState(() => _isLoading = value);
  }

  @override
  Widget build(BuildContext context) {
    return PageContent(
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Search Fungi'),
        body: SearchContent(
          searchController: _searchController,
          searchQuery: _searchQuery,
          isLoading: _isLoading,
          filteredList: _filteredList,
          onSearch: _filterSearchResults,
          onClear: () {
            _searchController.clear();
            _filterSearchResults('');
          },
          onItemTap: (name) => _mainController.getFungyDetails(name, _setLoading),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
