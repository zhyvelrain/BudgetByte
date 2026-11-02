/// A single product in the ByteBudget catalog.
class Item {
  final String id;
  final String name;
  final String category;
  final String sku;
  final double basePrice;
  final String emoji;
  final String description;

  Item({
    required this.id,
    required this.name,
    required this.category,
    required this.sku,
    required this.basePrice,
    required this.emoji,
    required this.description,
  });
}
