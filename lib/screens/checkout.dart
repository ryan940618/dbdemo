import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  final String name;
  final List<Map<String, dynamic>> foods;
  final Map<String, int> quantities;
  double totalPrice;

  CheckoutPage({
    required this.name,
    required this.foods,
    required this.quantities,
    required this.totalPrice,
  });

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool orderSent = false;

  @override
  Widget build(BuildContext context) {
    if (widget.totalPrice > 100){
      widget.totalPrice  = widget.totalPrice * 0.9;
    }

    if (orderSent) {
      return Scaffold(
        appBar: AppBar(title: Text('訂單已送出')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('感謝您的選購！'),
              Text('餐點將於稍後送達。'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('返回主畫面'),
              )
            ],
          ),
        ),
      );
    }

    final checkedFoods = widget.foods
        .where((f) => widget.quantities[f['name']]! > 0)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('確認訂單')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.name} 您好：', style: TextStyle(fontSize: 18)),
            SizedBox(height: 5),
            Text('您的點餐項目，共${checkedFoods.length}種：'),
            Divider(),
            ...checkedFoods.asMap().entries.map((entry) {
              final i = entry.key + 1;
              final f = entry.value;
              final qty = widget.quantities[f['name']] ?? 0;
              final total = f['price'] * qty;
              return Text('$i. ${f['name']} [\$${f['price']}] x $qty = \$${total}');
            }),
            Divider(),
            if (widget.totalPrice > 100) ...[
              const Text(
                '消費滿100元-9折優惠',
                style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Divider(),
            ],
            Text('總金額：\$${widget.totalPrice.toStringAsFixed(0)}',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('回上頁'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      orderSent = true;
                    });
                  },
                  child: Text('送出訂單'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
