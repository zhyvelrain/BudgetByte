import 'dart:convert';
import 'dart:io';
import '../models/item_model.dart';

class ItemsService {
  static final ItemsService _instance = ItemsService._();
  factory ItemsService() => _instance;

  ItemsService._();

  static const _file = 'data/items.json';

  List<Item> _items = [];
  final Map<String, int> _buyCounts = {};
  bool _loaded = false;

  List<Item> get items => List.unmodifiable(_items);
  Map<String, int> get buyCounts => Map.unmodifiable(_buyCounts);

  Future<void> init() async {
    if (_loaded) return;
    _items = [
      Item(id: 'i1', name: 'Mechanical Keyboard', category: 'Keyboard', sku: 'KB-001', basePrice: 4999.0, emoji: 'kbd', description: 'Hot-swap, RGB, mil-spec switches.'),
      Item(id: 'i2', name: 'Wireless Mouse', category: 'Mouse', sku: 'MS-002', basePrice: 1299.0, emoji: 'mouse', description: 'Silent clicks, 16000 DPI, 2.4GHz + Bluetooth.'),
      Item(id: 'i3', name: '27" 4K Monitor', category: 'Monitor', sku: 'MN-003', basePrice: 12999.0, emoji: 'mon', description: 'IPS, 144Hz, HDR, 99% sRGB.'),
      Item(id: 'i4', name: 'Gaming Headset', category: 'Audio', sku: 'HS-004', basePrice: 2499.0, emoji: 'headset', description: '7.1 surround, memory-foam, 3.5mm + USB.'),
      Item(id: 'i5', name: 'USB-C Hub', category: 'Accessory', sku: 'UH-005', basePrice: 1899.0, emoji: 'hub', description: '7-in-1, 100W PD, aluminum.'),
      Item(id: 'i6', name: 'Laptop Stand', category: 'Accessory', sku: 'LS-006', basePrice: 1499.0, emoji: 'stand', description: 'Aluminum, adjustable, cooling fans.'),
      Item(id: 'i7', name: 'Webcam 1080p', category: 'Camera', sku: 'WC-007', basePrice: 1699.0, emoji: 'cam', description: 'Auto-focus, 1080p, privacy shutter.'),
      Item(id: 'i8', name: 'Keyboard Wrist Rest', category: 'Accessory', sku: 'WR-008', basePrice: 799.0, emoji: 'wrist', description: 'Memory foam, gel palm rest.'),
      Item(id: 'i9', name: 'Monitor Arm', category: 'Monitor', sku: 'MA-009', basePrice: 2799.0, emoji: 'arm', description: 'Clamp-style, dual monitor, gas lift.'),
      Item(id: 'i10', name: 'Wireless Charging Pad', category: 'Accessory', sku: 'CP-010', basePrice: 1199.0, emoji: 'charge', description: '15W, aluminum, Qi-certified.'),
    ];
    _loaded = true;
    await _persistCounts();
  }

  int getDiscount(Item item) {
    final n = (_buyCounts[item.id] ?? 0) + 1;
    final pct = 100 - 15 * (n / 10).clamp(0.0, 1.0);
    return pct.round();
  }

  Future<void> _persistCounts() async {
    final f = File(_file);
    await f.create(recursive: true);
    await f.writeAsString(json.encode(_buyCounts));
  }
}
