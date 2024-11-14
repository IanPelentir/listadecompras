import 'package:flutter/material.dart';
import '/models/item.dart';
import '/services/database_service.dart';

class ItemViewModel extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<Item> _items = [];

  List<Item> get items => _items;

  // Carrega os itens do banco de dados
  Future<void> loadItems() async {
    _items = await _databaseService.getItems();
    notifyListeners();
  }

  // Adiciona um novo item
  Future<void> addItem(Item item) async {
    await _databaseService.addItem(item);
    await loadItems();
  }

  // Alterna o status de comprado/não comprado
  Future<void> toggleItemStatus(int itemId) async {
    final item = _items.firstWhere((i) => i.id == itemId);
    item.comprado = !item.comprado;
    await _databaseService.updateItem(item);
    await loadItems();
  }
}
