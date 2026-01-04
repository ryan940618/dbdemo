import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class CheckoutPage extends StatefulWidget {
  final String name;
  final List<Map<String, dynamic>> foods;
  final Map<String, int> quantities;
  double totalPrice;
  final String phone;

  CheckoutPage({
    required this.name,
    required this.foods,
    required this.quantities,
    required this.totalPrice,
    required this.phone
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

    final String orderString = checkedFoods.map((f) {
      final name = f['name'];
      final qty = widget.quantities[name] ?? 0;
      return "$name*$qty";
    }).join(", ");


    final int totalQuantity = checkedFoods.fold(0, (previousValue, f) {
      final qty = widget.quantities[f['name']] ?? 0;
      return previousValue + qty;
    });

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
                      sendPostRequest(orderString, totalQuantity);
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

  Future<void> sendPostRequest(String orderString, int totalQuantity)async {
  final String url = 'https://docs.google.com/forms/d/e/1FAIpQLScV21EL4-M1-NAtCMTJehtv1Vzq4BM_JcWVPKFELOIN3yKZ0Q/formResponse?entry.1138631297=${widget.name}&entry.328078314=${orderString}&entry.1276189948=${totalQuantity}&entry.1499561205=${widget.totalPrice.toStringAsFixed(0)}&entry.1958327602=${widget.phone}&submit=Submit';

  try {
    final response = await http.post(Uri.parse(url));

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('成功');
    } else {
      print('請求失敗: ${response.statusCode}');
      print('錯誤訊息: ${response.body}');
    }
  } catch (e) {
    print('發生錯誤: $e');
  }
}
}
