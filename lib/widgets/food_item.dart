import 'package:flutter/material.dart';

class FoodItem extends StatelessWidget {
  final String name;
  final int price;
  final String image;
  final bool isChecked;
  final int quantity;
  final ValueChanged<bool> onCheckChanged;
  final ValueChanged<int> onQuantityChanged;

  FoodItem({
    required this.name,
    required this.price,
    required this.image,
    required this.isChecked,
    required this.quantity,
    required this.onCheckChanged,
    required this.onQuantityChanged,
  });

  void _showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(child: Image.asset(image)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (value) => onCheckChanged(value!),
        ),
        Expanded(child: Text(name)),
        Text('\$$price'),
        SizedBox(width: 10),
        GestureDetector(
          onTap: () => _showImageDialog(context),
          child: Image.asset(image, width: 50, height: 50),
        ),
        SizedBox(width: 10),
        DropdownButton<int>(
          value: quantity,
          onChanged: isChecked ? (v) => onQuantityChanged(v!) : null,
          items: List.generate(10, (i) => i)
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text('$e'),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
