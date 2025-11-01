import 'package:flutter/material.dart';
import '../widgets/food_item.dart';
import 'checkout.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int selectedCategory = 0;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

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

  Map<String, bool> selected = {};
  Map<String, int> quantities = {};

  double totalPrice = 0;

  void initState() {
    super.initState();
    _initializeFoodStates();
  }

  void _initializeFoodStates() {
    foodMenu.forEach((_, list) {
      for (var food in list) {
        selected[food['name']] = false;
        quantities[food['name']] = 0;
      }
    });
  }

  void _updateTotalPrice() {
    double sum = 0;
    foodMenu.forEach((_, list) {
      for (var food in list) {
        if (selected[food['name']] == true) {
          sum += food['price'] * (quantities[food['name']] ?? 0);
        }
      }
    });
    setState(() {
      totalPrice = sum;
    });
  }

  void _resetSelection() {
    setState(() {
      for (var key in selected.keys) {
        selected[key] = false;
      }
      for (var key in quantities.keys) {
        quantities[key] = 0;
      }
      totalPrice = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentCategory = categories[selectedCategory];
    final foods = foodMenu[currentCategory]!;

    return Scaffold(
      appBar: AppBar(title: const Text('點餐')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: '姓名',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: '電話',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(categories.length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
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
                  foregroundColor: Colors.white,
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
                final name = food['name'];
                final isChecked = selected[name] ?? false;
                final qty = quantities[name] ?? 0;

                return FoodItem(
                  name: name,
                  price: food['price'],
                  image: food['image'],
                  isChecked: isChecked,
                  quantity: qty,
                  onCheckChanged: (value) {
                    setState(() {
                      selected[name] = value;
                      if (!value) quantities[name] = 0;
                      _updateTotalPrice();
                    });
                  },
                  onQuantityChanged: (value) {
                    setState(() {
                      quantities[name] = value;
                      _updateTotalPrice();
                    });
                  },
                );
              },
            ),
          ),

          // 下方操作區
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text('總金額：\$${totalPrice.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _resetSelection,
                      child: const Text('重設'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final name = nameController.text.trim();
                        final phone = phoneController.text.trim();

                        if (name.isEmpty || phone.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('請輸入姓名與電話')),
                          );
                          return;
                        }

                        final checkedFoods = foodMenu.entries
                            .expand((e) => e.value)
                            .where((f) => selected[f['name']] == true)
                            .toList();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutPage(
                              name: name,
                              foods: checkedFoods,
                              quantities: quantities,
                              totalPrice: totalPrice,
                            ),
                          ),
                        );
                      },
                      child: const Text('結帳'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
