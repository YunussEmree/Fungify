import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fungi_app/modules/widgets/gradient_container.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
          if (_searchQuery.isNotEmpty) _buildSearchResults(),
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
          const Color(0xFF8B6BFF).withAlpha(51), // 0.2 opacity
          const Color(0xFFFF6BE6).withAlpha(51), // 0.2 opacity
        ],
      ),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(
        color: const Color(0xFF8B6BFF).withAlpha(77), // 0.3 opacity
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(51), // 0.2 opacity
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
        color: const Color.fromARGB(128, 255, 255, 255), // 0.5 opacity
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
    return Expanded(
      child: GradientContainer(
        child: Center(
          child: Text(
            'Search results will be displayed here',
            style: GoogleFonts.poppins(
              color: const Color.fromARGB(179, 255, 255, 255), // 0.7 opacity
              fontSize: 16,
            ),
          ),
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
