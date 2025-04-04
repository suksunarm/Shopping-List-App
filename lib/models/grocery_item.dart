import 'package:shopping_list/models/category.dart';

class GroceryItem {
  const GroceryItem({
    required this.id,
    required this.name,
    required this.image,
    required this.quantity,
    required this.category,
  });

  final String id;
  final String name;
  final String image;
  final int quantity;
  final Category category;
}