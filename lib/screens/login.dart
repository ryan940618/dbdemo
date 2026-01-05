import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isLoading = false; 
  bool _isLoggedIn = false; 

  List<Map<dynamic, dynamic>> _searchResults = [];
  String _displayTitle = "";

  Future<void> _checkLogin() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) return;

    setState(() { _isLoading = true; _isLoggedIn = false; _searchResults.clear(); _displayTitle = ""; });

    final String searchKey = "${_nameController.text}_${_phoneController.text}";

    try {
      final ref = FirebaseDatabase.instance.ref("orders");
      final snapshot = await ref.orderByKey().startAt(searchKey).endAt("$searchKey\uf8ff").limitToFirst(1).get();

      if (snapshot.exists) {
        setState(() { _isLoggedIn = true; });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("登入成功")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("查無此人資料")));
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() { _isLoading = false; });
    }
  }
Future<void> _queryOrders(String prefix, String title) async {
    setState(() {
      _isLoading = true;
      _displayTitle = title;
      _searchResults.clear();
    });

    try {
      final ref = FirebaseDatabase.instance.ref("orders");
      final snapshot = await ref.orderByKey().startAt(prefix).endAt("$prefix\uf8ff").get();

      if (snapshot.exists) {
        List<Map<dynamic, dynamic>> tempResults = [];
        
        for (final child in snapshot.children) {
          if (child.value is Map) {
            Map<dynamic, dynamic> data = child.value as Map<dynamic, dynamic>;
            data['key'] = child.key; 
            tempResults.add(data);
          }
        }

        setState(() {
          _searchResults = tempResults;
        });
      } else {
        setState(() {
          _searchResults = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("查無 $title 資料")));
      }
    } catch (e) {
      print("Query Error: $e");
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  void _goToTodayOrder() {
    final String name = _nameController.text;
    final String phone = _phoneController.text;
    final String today = DateFormat('yyyyMMdd').format(DateTime.now());
    
    final String prefix = "${name}_${phone}_${today}_";
    
    _queryOrders(prefix, "今日點餐內容");
  }

  void _goToHistory() {
    final String name = _nameController.text;
    final String phone = _phoneController.text;

    final String prefix = "${name}_${phone}_";
    
    _queryOrders(prefix, "歷史總紀錄");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("會員查詢系統")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: "姓名", prefixIcon: Icon(Icons.person))),
            SizedBox(height: 10),
            TextField(controller: _phoneController, decoration: InputDecoration(labelText: "電話", prefixIcon: Icon(Icons.phone)), keyboardType: TextInputType.phone),
            SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _checkLogin,
                child: Text("登入查詢"),
              ),
            ),
            SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoggedIn ? _goToTodayOrder : null,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    child: Text("今日點餐"),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoggedIn ? _goToHistory : null,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Text("點餐紀錄"),
                  ),
                ),
              ],
            ),
            
            Divider(height: 30, thickness: 2),

            if (_displayTitle.isNotEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: Text("$_displayTitle (${_searchResults.length} 筆)", 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            
            SizedBox(height: 10),

            Expanded(
              child: _isLoading 
                ? Center(child: CircularProgressIndicator()) 
                : _searchResults.isEmpty 
                  ? Center(child: Text(_isLoggedIn ? "請點選上方按鈕查詢" : "請先登入"))
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final item = _searchResults[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Text("${item['items']} (\$${item['totalPrice']})"),
                            subtitle: Text("時間: ${item['timestamp']}"),
                            leading: CircleAvatar(
                              child: Text((index + 1).toString()),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}