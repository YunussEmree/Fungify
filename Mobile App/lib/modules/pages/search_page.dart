import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fungi_app/modules/widgets/gradient_container.dart';
import 'package:get/get.dart';
import 'package:fungi_app/modules/main_controller.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> mushroomNames = [
    'Amanita muscaria',
    'Chlorociboria aeruginosa',
    'Cytidia salicina',
    'Helvella atra',
    'Mycena rosea',
    'Tuber melanosporum',
    'Agaricus bisporus',
    'Bisporella citrina',
    'Clathrus ruber',
    'Geastrum saccatum',
    'Hydnellum peckii',
    'Pleurotus djamor',
    'Alloclavaria purpurea',
    'Boletus edulis',
    'Cordyceps sinensis',
    'Gliophorus psittacinus',
    'Lactarius indigo',
    'Russula virescens',
    'Amanita jacksonii',
    'Cantharellus cibarius',
    'Cortinarius sanguineus',
    'Gyromitra fastigiata',
    'Morchella esculenta',
    'Tremella fuciformis',
  ];

  List<String> get filteredMushrooms => mushroomNames
      .where((name) =>
          name.toLowerCase().contains(_searchQuery.toLowerCase()))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A0E5F),
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Search',
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildSearchField(),
          const SizedBox(height: 20),
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: _buildSearchDecoration(),
      child: TextField(
        controller: _searchController,
        style: GoogleFonts.poppins(color: Colors.white),
        decoration: _buildTextFieldDecoration(),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  BoxDecoration _buildSearchDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF8B6BFF).withAlpha(51),
          const Color(0xFFFF6BE6).withAlpha(51),
        ],
      ),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(
        color: const Color(0xFF8B6BFF).withAlpha(77),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(51),
          blurRadius: 10,
          spreadRadius: 1,
        ),
      ],
    );
  }

  InputDecoration _buildTextFieldDecoration() {
    return InputDecoration(
      hintText: 'Enter mushroom name...',
      hintStyle: GoogleFonts.poppins(
        color: const Color.fromARGB(128, 255, 255, 255),
      ),
      prefixIcon: const Icon(
        Icons.search,
        color: Color(0xFFFF6BE6),
      ),
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchQuery.isEmpty) {
      return _buildAllMushrooms();
    }
    return _buildFilteredMushrooms();
  }

  Widget _buildAllMushrooms() {
    return ListView.builder(
      itemCount: mushroomNames.length,
      itemBuilder: (context, index) {
        return _buildMushroomItem(mushroomNames[index]);
      },
    );
  }

  Widget _buildFilteredMushrooms() {
    final filtered = filteredMushrooms;
    if (filtered.isEmpty) {
      return Center(
        child: Text(
          'No mushrooms found',
          style: GoogleFonts.poppins(
            color: const Color.fromARGB(179, 255, 255, 255),
            fontSize: 16,
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return _buildMushroomItem(filtered[index]);
      },
    );
  }

  Widget _buildMushroomItem(String mushroomName) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF8B6BFF).withAlpha(51),
            const Color(0xFFFF6BE6).withAlpha(51),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF8B6BFF).withAlpha(77),
          width: 1,
        ),
      ),
      child: ListTile(
        title: Text(
          mushroomName,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        onTap: () => _onMushroomSelected(mushroomName),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Color(0xFFFF6BE6),
          size: 20,
        ),
      ),
    );
  }

  void _onMushroomSelected(String mushroomName) {
    // TODO: Backend hazır olduğunda burada API çağrısı yapılacak
    debugPrint('Selected mushroom: $mushroomName');
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF2A0E5F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: const Color(0xFF8B6BFF).withAlpha(77),
            width: 1,
          ),
        ),
        title: Text(
          'Selected Mushroom',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          mushroomName,
          style: GoogleFonts.poppins(
            color: const Color.fromARGB(230, 255, 255, 255),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'OK',
              style: GoogleFonts.poppins(
                color: const Color(0xFFFF6BE6),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
