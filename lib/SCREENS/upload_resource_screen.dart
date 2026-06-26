import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:resource_hub/mycolors.dart';
import 'package:resource_hub/PROVIDERS/resource_provider.dart';

class UploadResourceScreen extends StatefulWidget {
  const UploadResourceScreen({super.key});

  @override
  State<UploadResourceScreen> createState() => _UploadResourceScreenState();
}

class _UploadResourceScreenState extends State<UploadResourceScreen> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _capacityController = TextEditingController();

  String _selectedCategory = 'Rooms';
  bool _isSubmitting = false;
  bool _isPicking = false;
  File? _pickedImageFile;
  String? _base64Image;

  final List<String> _categories = ['Rooms', 'Equipment', 'Sports', 'Other'];
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  bool get _formIsValid =>
      _titleController.text.trim().isNotEmpty &&
      _locationController.text.trim().isNotEmpty &&
      _capacityController.text.trim().isNotEmpty;

  // ── Pick image from gallery ──
  Future<void> _pickImage() async {
    if (_isPicking) return;
    _isPicking = true;

    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (picked == null) return;

      final File file = File(picked.path);
      final List<int> bytes = await file.readAsBytes();
      final String base64 = base64Encode(bytes);

      setState(() {
        _pickedImageFile = file;
        _base64Image = base64;
      });
    } finally {
      _isPicking = false;
    }
  }

  Future<void> _onSubmit() async {
    if (!_formIsValid) {
      _showSnack('Please fill in all required fields.', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);

    final resource = {
      'title': _titleController.text.trim(),
      'location': _locationController.text.trim(),
      'capacity': _capacityController.text.trim(),
      'category': _selectedCategory,
      // store base64 string; null if no image picked
      'resourcePic': _base64Image,
      'isBase64': true,
    };

    await context.read<ResourceProvider>().addResource(resource);

    setState(() => _isSubmitting = false);
    _clearForm();
    _showSnack('Resource added successfully!');
  }

  void _clearForm() {
    _titleController.clear();
    _locationController.clear();
    _capacityController.clear();
    setState(() {
      _selectedCategory = 'Rooms';
      _pickedImageFile = null;
      _base64Image = null;
    });
  }

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError ? const Color(0xFFDC2626) : const Color(0xFF15803D),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Mycolors.primary,
        automaticallyImplyLeading: false,
        title: const Text(
          'Upload Resource',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Header card ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Mycolors.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(Icons.admin_panel_settings_outlined,
                    color: Colors.white54, size: 32),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Admin Panel',
                        style: TextStyle(color: Colors.white60, fontSize: 12)),
                    Text('Add a new resource',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          _sectionLabel('RESOURCE DETAILS'),

          _buildField(
            controller: _titleController,
            label: 'Resource Title',
            hint: 'e.g. Conference Room B',
            icon: Icons.meeting_room_outlined,
          ),
          const SizedBox(height: 12),
          _buildField(
            controller: _locationController,
            label: 'Location',
            hint: 'e.g. Block A, Floor 1',
            icon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 12),
          _buildField(
            controller: _capacityController,
            label: 'Capacity',
            hint: 'e.g. 20 people',
            icon: Icons.people_outline,
          ),

          const SizedBox(height: 20),
          _sectionLabel('CATEGORY'),

          Wrap(
            spacing: 10,
            children: _categories.map((cat) {
              final bool isSelected = _selectedCategory == cat;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = cat),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? Mycolors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? Mycolors.primary
                          : const Color(0xFFE2E8F0),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF334155),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),
          _sectionLabel('RESOURCE IMAGE'),

          // ── Image picker box ──
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _pickedImageFile != null
                      ? Mycolors.primary
                      : const Color(0xFFE2E8F0),
                  width: 1.5,
                ),
              ),
              child: _pickedImageFile != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Image.file(
                        _pickedImageFile!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate_outlined,
                            size: 40,
                            color: Mycolors.primary.withValues(alpha: 0.5)),
                        const SizedBox(height: 8),
                        const Text('Tap to pick image from gallery',
                            style: TextStyle(
                                fontSize: 13, color: Color(0xFF94A3B8))),
                      ],
                    ),
            ),
          ),

          // ── Change image button if already picked ──
          if (_pickedImageFile != null) ...[
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Change Image'),
              style: TextButton.styleFrom(
                  foregroundColor: Mycolors.primary),
            ),
          ],

          const SizedBox(height: 28),

          // ── Submit button ──
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Mycolors.primary,
                disabledBackgroundColor: const Color(0xFFE2E8F0),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Text(
                      'Add Resource →',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Color(0xFF94A3B8),
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155))),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: TextField(
            controller: controller,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  const TextStyle(fontSize: 13, color: Color(0xFFCBD5E1)),
              prefixIcon:
                  Icon(icon, size: 18, color: const Color(0xFF94A3B8)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}