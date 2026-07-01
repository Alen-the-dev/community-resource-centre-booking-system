import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResourceProvider extends ChangeNotifier {
  final _client = Supabase.instance.client;
  final List<Map<String, dynamic>> _resources = [];

  List<Map<String, dynamic>> get resources => List.unmodifiable(_resources);

  ResourceProvider() {
    _loadFromSupabase();
  }

  Future<void> _loadFromSupabase() async {
    final data = await _client.from('resources').select().order('id');
    _resources.clear();
    _resources.addAll(data.map((r) => Map<String, dynamic>.from(r)));
    notifyListeners();
  }

  Future<void> addResource(Map<String, dynamic> resource) async {
    final inserted = await _client.from('resources').insert(resource).select();
    _resources.add(Map<String, dynamic>.from(inserted.first));
    notifyListeners();
  }

  Future<void> deleteResource(int index) async {
    final id = _resources[index]['id'];
    await _client.from('resources').delete().eq('id', id);
    _resources.removeAt(index);
    notifyListeners();
  }
}