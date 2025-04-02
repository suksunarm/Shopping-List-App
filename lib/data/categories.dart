import 'package:flutter/material.dart';

import 'package:shopping_list/models/category.dart';

const categories = {
  Categories.vegetables: Category(
    'Skincare',
    Color.fromARGB(255, 0, 255, 128),
  ),
  Categories.fruit: Category(
    'Hair Care',
    Color.fromARGB(255, 145, 255, 0),
  ),
  Categories.meat: Category(
    'Makeup',
    Color.fromARGB(255, 255, 102, 0),
  ),
  Categories.dairy: Category(
    'Nail Care',
    Color.fromARGB(255, 0, 208, 255),
  ),
  Categories.carbs: Category(
    'Body Ca re',
    Color.fromARGB(255, 0, 60, 255),
  ),
  Categories.sweets: Category(
    'Oral Care',
    Color.fromARGB(255, 255, 149, 0),
  ),
  Categories.spices: Category(
    'Anti-Aging',
    Color.fromARGB(255, 255, 187, 0),
  ),
  Categories.convenience: Category(
    'Sun Care',
    Color.fromARGB(255, 191, 0, 255),
  ),
  Categories.other: Category(
    'Other',
    Color.fromARGB(255, 0, 225, 255),
  ),
};