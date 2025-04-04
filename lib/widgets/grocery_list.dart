import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  var isRemoving = false;
  String? _error;

  @override
  void initState() {
    super.initState(); // คล้ายๆ เหมือน useEffect
    _loadItems();
  }

  void _showModal(BuildContext context, GroceryItem item) {
    final index = _groceryItems.indexOf(item);
    final name = item.name;
    final quantity = item.quantity;

    showDialog(
      context: context,
      barrierDismissible: false, // ไม่ให้ปิดเมื่อคลิกที่ด้านนอกโมดอล
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Do you want to delete',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Name : ${name} \nQuantity : ${quantity}',
            style: const TextStyle(fontSize: 20),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _removeItem(_groceryItems[index]);
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  backgroundColor: Colors.green),
              child: const Text(
                'Yes',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิดโมดอล
              },
              style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                  backgroundColor: Colors.red),
              child: const Text(
                'No',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _loadItems() async {
    final url = Uri.https(
        'flutter-shopping-list-56d69-default-rtdb.firebaseio.com',
        'shopping-list.json');
    try {
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        setState(() {
          _error = 'Failed to fetch data. Please try again later!';
        });
      }

      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      final Map<String, dynamic> listData = json.decode(response
          .body); //ถอดรหัสหลังจากที่เรา encode มา และ map ค่า key คู่กับ object นั้นๆ
      final List<GroceryItem> loadedItems = [];
      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere(
                (catItem) => catItem.value.title == item.value['category'])
            .value; // รายการแรกที่ตรงกับที่เลือก category
        loadedItems.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category,
          ),
        );
      }

      setState(() {
        _groceryItems = loadedItems;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = 'Something went wrong! Please try again later.';
      });
    }
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) async {
    // ฟังก์ชันลบสินค้า
    final index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });

    final url = Uri.https(
        'flutter-shopping-list-56d69-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json');

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      // optional : show error message
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text(
        'No items added yet.',
        style: TextStyle(fontSize: 18),
      ),
    );

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
            _removeItem(_groceryItems[index]);
          },
          key: ValueKey(_groceryItems[index].id),
          direction: DismissDirection.endToStart, // ปัดจากขวาไปซ้าย

          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                InkWell(
                  onTap: () => _showModal(context, _groceryItems[index]),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20), // มุมโค้งของการ์ด
                    ),
                    color: const Color.fromARGB(255, 238, 231, 231),
                    elevation: 4,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: ListTile(
                        title: Text(
                          _groceryItems[index].name,
                          style: const TextStyle(fontSize: 26),
                        ),
                        leading: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: _groceryItems[index].category.color,
                            borderRadius: BorderRadius.circular(
                                20), 
                          ),
                        ),
                        trailing: Text(
                          _groceryItems[index].quantity.toString(),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 90, 90, 90),
                              fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_error != null) {
      content = Center(child: Text(_error!));
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Your Groceries',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: _addItem,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: content);
  }
}
