import 'package:flutter/material.dart';
import '../widgets/food_item.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int selectedCategory = 0;

  final List<String> categories = ['蛋餅', '鍋燒', '總匯'];

  final Map<String, List<Map<String, dynamic>>> foodMenu = {
    '蛋餅': [
      {'name': '火腿蛋餅', 'price': 50, 'image': 'assets/images/food1.png'},
      {'name': '起司蛋餅', 'price': 60, 'image': 'assets/images/food2.png'},
      {'name': '原味蛋餅', 'price': 40, 'image': 'assets/images/food3.png'},
    ],
    '鍋燒': [
      {'name': '鍋燒意麵', 'price': 80, 'image': 'assets/images/food4.png'},
      {'name': '鍋燒冬粉', 'price': 85, 'image': 'assets/images/food5.png'},
      {'name': '鍋燒烏龍', 'price': 90, 'image': 'assets/images/food6.png'},
    ],
    '總匯': [
      {'name': '火腿總匯', 'price': 70, 'image': 'assets/images/food7.png'},
      {'name': '鮪魚總匯', 'price': 75, 'image': 'assets/images/food8.png'},
      {'name': '燻雞總匯', 'price': 80, 'image': 'assets/images/food9.png'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final currentCategory = categories[selectedCategory];
    final foods = foodMenu[currentCategory]!;

    return Scaffold(
      appBar: AppBar(title: Text('點餐')),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(categories.length, (index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                width: 60,
                height: 10,
                decoration: BoxDecoration(
                  color: selectedCategory == index ? Colors.green : Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
              );
            }),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(categories.length, (index) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedCategory == index
                      ? Colors.green
                      : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    selectedCategory = index;
                  });
                },
                child: Text(categories[index]),
              );
            }),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: foods.length,
              itemBuilder: (context, index) {
                final food = foods[index];
                return FoodItem(
                  name: food['name'],
                  price: food['price'],
                  image: food['image'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
