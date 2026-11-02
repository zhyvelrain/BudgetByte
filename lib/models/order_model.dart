/// A single product line in an order.
library;

class CartLine {

  final String itemId;

  final String name;

  final String emoji;

  final double unitPrice;

  final int quantity;



  CartLine({

    required this.itemId,

    required this.name,

    required this.emoji,

    required this.unitPrice,

    required this.quantity,

  });



  double get subtotal => unitPrice * quantity;



  Map<String, dynamic> toJson() => {

    'itemId': itemId,

    'name': name,

    'emoji': emoji,

    'unitPrice': unitPrice,

    'quantity': quantity,

  };



  factory CartLine.fromJson(Map<String, dynamic> j) => CartLine(

    itemId: j['itemId'],

    name: j['name'],

    emoji: j['emoji'],

    unitPrice: (j['unitPrice'] as num).toDouble(),

    quantity: j['quantity'],

  );

}



/// An order (cart snapshot + status).

class Order {
  final String id;
  final String userId;
  final String status; // pending / paying / shipped / received / review
  final String note;
  final double total;
  final String createdAt;

  final List<CartLine> lines;

  Order({
    required this.id,
    required this.userId,
    required this.status,
    this.note = '',
    required this.total,
    required this.createdAt,
    this.lines = const [],
  });

  Order copyWith({
    String? id,
    String? userId,
    String? status,
    String? note,
    double? total,
    String? createdAt,
    List<CartLine>? lines,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      note: note ?? this.note,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
      lines: lines ?? this.lines,
    );
  }


  factory Order.fromJson(Map<String, dynamic> j) => Order(

    id: j['id'],

    userId: j['userId'],

    status: j['status'],

    note: j['note'],

    total: (j['total'] as num).toDouble(),

    createdAt: j['createdAt'],

    lines: (j['lines'] as List<dynamic>?)

        ?.map((e) => CartLine.fromJson(e as Map<String, dynamic>))

        .toList() ?? [],

  );



  Map<String, dynamic> toJson() => {

    'id': id,

    'userId': userId,

    'status': status,

    'note': note,

    'total': total,

    'createdAt': createdAt,

    'lines': lines.map((l) => l.toJson()).toList(),

  };

}

