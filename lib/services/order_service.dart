import 'dart:convert';

import 'dart:io';

import '../models/order_model.dart';



class OrderService {

  static final OrderService _s = OrderService._();

  factory OrderService() => _s;



  OrderService._();



  static const _file = 'data/orders.json';

  final List<Order> _orders = [];

  bool _loaded = false;



  List<Order> get orders => List.unmodifiable(_orders);



  Future<void> init() async {

    if (_loaded) return;

    final f = File(_file);

    if (await f.exists()) {

      final raw = await f.readAsString();

      if (raw.trim().isNotEmpty) {

        final List<dynamic> d = json.decode(raw);

        _orders.addAll(d.map((e) => Order.fromJson(e as Map<String, dynamic>)));

      }

    }

    _loaded = true;

  }



  Future<void> addOrder(Order order) async {

    _orders.insert(0, order);

    await _save();

  }



  Future<void> removeOrder(String id) async {

    _orders.removeWhere((o) => o.id == id);

    await _save();

  }



  Future<void> _save() async {

    final f = File(_file);

    await f.create(recursive: true);

    await f.writeAsString(json.encode(_orders.map((o) => o.toJson()).toList()));

  }



  Order? getById(String id) {

    for (final o in _orders) {

      if (o.id == id) return o;

    }

    return null;

  }

}

