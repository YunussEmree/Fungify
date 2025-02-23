import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fungi_app/modules/widgets/gradient_container.dart';
import 'package:fungi_app/models/fungy.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fungi_app/shared/constants/app_colors.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = false;
  final List<String> _mushroomList = [
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
  List<String> _filteredList = [];
  Fungy? _selectedFungy;

  @override
  void initState() {
    super.initState();
    _filteredList = _mushroomList;
  }

  void _filterSearchResults(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredList = _mushroomList;
      } else {
        _filteredList = _mushroomList
            .where((item) =>
                item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _getFungyDetails(String name) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://192.168.8.5:8080/api/v1/image/find/$name'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        if (jsonResponse['data'] != null) {
          setState(() {
            _selectedFungy = Fungy.fromJson(jsonResponse['data']);
          });
          _showFungyDetails();
        }
      } else {
        _showErrorDialog('Mantar detayları bulunamadı');
      }
    } catch (e) {
      _showErrorDialog('Bir hata oluştu: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showFungyDetails() {
    if (_selectedFungy == null) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GradientContainer(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_selectedFungy!.fungyImageUrl.isNotEmpty)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        _selectedFungy!.fungyImageUrl,
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 200,
                          width: 200,
                          color: AppColors.grey,
                          child: const Icon(
                            Icons.error_outline,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                _buildDetailRow('İsim:', _selectedFungy!.name),
                _buildDetailRow('Zehirli:', _selectedFungy!.venomous ? 'Evet' : 'Hayır'),
                _buildDetailRow('Açıklama:', _selectedFungy!.fungyDescription),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Kapat',
                      style: GoogleFonts.poppins(
                        color: AppColors.highlight,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A0E5F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: AppColors.accentWithOpacity,
          ),
        ),
        title: Text(
          'Hata',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        content: Text(
          message,
          style: GoogleFonts.poppins(color: AppColors.whiteWithOpacity),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Tamam',
              style: GoogleFonts.poppins(color: AppColors.highlight),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildSearchField(),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.highlight,
                    ),
                  )
                : _buildMushroomList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMushroomList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredList.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: const Color(0xFF8B6BFF).withAlpha(77),
            ),
          ),
          child: ListTile(
            onTap: () => _getFungyDetails(_filteredList[index]),
            title: Text(
              _filteredList[index],
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.highlight,
              size: 20,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: AppColors.highlight,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: AppColors.whiteWithOpacity,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Mantar Ara',
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

  Widget _buildSearchField() {
    return Container(
      decoration: _buildSearchDecoration(),
      child: TextField(
        controller: _searchController,
        style: GoogleFonts.poppins(color: Colors.white),
        decoration: _buildTextFieldDecoration(),
        onChanged: _filterSearchResults,
      ),
    );
  }

  BoxDecoration _buildSearchDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.accentWithOpacity,
          AppColors.highlightWithOpacity,
        ],
      ),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(
        color: AppColors.accentWithOpacity,
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
      hintText: 'Mantar adı girin...',
      hintStyle: GoogleFonts.poppins(
        color: AppColors.whiteWithOpacity,
      ),
      prefixIcon: const Icon(
        Icons.search,
        color: AppColors.highlight,
      ),
      suffixIcon: _searchQuery.isNotEmpty
          ? IconButton(
              icon: const Icon(
                Icons.clear,
                color: AppColors.highlight,
              ),
              onPressed: () {
                _searchController.clear();
                _filterSearchResults('');
              },
            )
          : null,
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
