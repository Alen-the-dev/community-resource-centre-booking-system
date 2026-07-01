import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resource_hub/EXTRA_WIDGET/searchbar.dart';
import 'package:resource_hub/mycolors.dart';
import 'package:resource_hub/EXTRA_WIDGET/categories.dart';
import 'package:resource_hub/EXTRA_WIDGET/resources.dart';
import 'package:resource_hub/PAGES/resource_detail_page.dart';
import 'package:resource_hub/PROVIDERS/resource_provider.dart';

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  String selectedFilter = 'All';
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allResources = context.watch<ResourceProvider>().resources;

    final filteredResources = allResources.where((resource) {
      final matchesCategory = selectedFilter == 'All' ||
          resource['category'].toString().toLowerCase() ==
              selectedFilter.toLowerCase();
      final matchesSearch =
          resource['title'].toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
          resource['location'].toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
          resource['category'].toString().toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Mycolors.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good morning',
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.white60,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  'Hello, There',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
            const Spacer(),
            const CircleAvatar(
              backgroundColor: Color(0xFF818CF8),
              child: Text('A',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Searchbar(
              controller: _searchController,
              onChanged: (value) => setState(() => searchQuery = value),
              onClear: () {
                _searchController.clear();
                setState(() => searchQuery = '');
              },
            ),
          ),
          CategoriesList(
            onCategorySelected: (category) =>
                setState(() => selectedFilter = category),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'AVAILABLE RESOURCES',
              style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filteredResources.isEmpty
                ? const Center(
                    child: Text(
                      'No resources match your search.',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredResources.length,
                    itemBuilder: (context, index) {
                      final item = filteredResources[index];
                      return Resources(
                        resource: item,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ResourceDetailPage(resource: item),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}