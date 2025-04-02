import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';

import 'package:http/http.dart' as http; //เปลี่ยนที่ import มา ให้เป็นชื่อ http

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}




class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();  // สามารถเข้าถึงได้หมด
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;

  void _saveItem () {
    if (_formKey.currentState!.validate()) {
       _formKey.currentState!.save();  // ถ้า validate แล้วจริง จะบันทึกค่า
       final url = Uri.https('flutter-shopping-list-56d69-default-rtdb.firebaseio.com', 'shopping-list.json');
       http.post(
        url, 
        headers: {
        'Content-Type' : 'application/json',
       }, 
       body: json.encode(
        {
          'name': _enteredName, 
       'quantity': _enteredQuantity, 
       'category': _selectedCategory.title
       },
       ),
       );
      //  Navigator.of(context).pop(GroceryItem(id: DateTime.now().toString(), 
      //  name: _enteredName, 
      //  quantity: _enteredQuantity, 
      //  category: _selectedCategory));
    }
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.trim().length == 1 || value.trim().length > 50) {
                           return 'Must be between  1 and 50 characters.';
                  } // trim ลบข้อความที่ user กรอกทั้งหน้าและหลัง
                  return null;
                },
                onSaved: (value) {
                  // if (value == null) {
                  //   return;
                  // }
                  _enteredName = value!;
                },
              ), // instead of TextField()
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: _enteredQuantity.toString(),
                       validator: (value) {
                  if (value == null || value.isEmpty || int.tryParse(value) == null || int.tryParse(value) ! <= 0) { // ถ้าผู้ใช้ไม่กรอกตัวเลข จะ Error , try parse แปลงค่าที่ผู้ใช้กรอก
                           return 'Must be a valid, positive number.';
                  } // trim ลบข้อความที่ user กรอกทั้งหน้าและหลัง
                  return null;
                },
                onSaved: (value) {
                  _enteredQuantity = int.parse(value!);
                },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color,
                                ),
                                const SizedBox(width: 6),
                                Text(category.value.title),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() {
                           _selectedCategory = value!;  // ค่าต้องไม่เป็น null
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12 ,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {_formKey.currentState!.reset();},
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _saveItem,
                    child: const Text('Add Item'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
