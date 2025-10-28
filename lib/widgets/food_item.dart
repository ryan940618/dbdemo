import 'package:flutter/material.dart';

class FoodItem extends StatefulWidget {
  final String name;
  final int price;
  final String image;

  FoodItem({required this.name, required this.price, required this.image});

  @override
  _FoodItemState createState() => _FoodItemState();
}

class _FoodItemState extends State<FoodItem> {
  bool isChecked = false;
  int quantity = 1;

  void _showImageDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Image.asset(widget.image),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (value) {
            setState(() {
              isChecked = value!;
            });
          },
        ),
        SizedBox(width: 10),
        Text(widget.name),
        SizedBox(width: 10),
        Text('\$${widget.price}'),
        SizedBox(width: 10),
        GestureDetector(
          onTap: _showImageDialog,
          child: Image.asset(widget.image, width: 50, height: 50),
        ),
        SizedBox(width: 10),
        DropdownButton<int>(
          value: quantity,
          items: List.generate(10, (i) => i + 1)
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text('$e'),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              quantity = value!;
            });
          },
        ),
      ],
    );
  }
}
