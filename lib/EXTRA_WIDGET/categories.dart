import 'package:flutter/material.dart';

class CategoriesList extends StatefulWidget {
  final Function(String) onCategorySelected;

  const CategoriesList({super.key, required this.onCategorySelected});

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  int _selectedIndex = 0;
  
  // Clean text-only categories matching your resource data backend exactly
  final List<Map<String, String>> _categories = [
    {'label': 'All'},
    {'label': 'Rooms'},
    {'label': 'Equipment'},
    {'label': 'sports'}, 
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final bool isActive = _selectedIndex == index;
          final String labelText = _categories[index]['label']!;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
              widget.onCategorySelected(labelText);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), // Slightly wider padding since there's no icon
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF1A1A2E) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive ? const Color(0xFF1A1A2E) : const Color(0xFFE2E8F0),
                  width: 1,
                ),
                boxShadow: isActive ? [
                  BoxShadow(
                    color: const Color(0xFF1A1A2E).withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ] : null,
              ),
              child: Text(
                // Capitalize 'sports' dynamically for the UI display so it looks clean
                labelText == 'sports' ? 'Sports' : labelText,
                style: TextStyle(
                  color: isActive ? Colors.white : const Color(0xFF64748B),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}