import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController _pwdController = TextEditingController();

  final String _adminPassword = "1234"; 

  bool _isLoading = false;
  bool _isLoggedIn = false;

  List<Map<dynamic, dynamic>> _searchResults = [];
  String _displayTitle = "";

  void _checkLogin() {
    if (_pwdController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (_pwdController.text == _adminPassword) {
        setState(() {
          _isLoggedIn = true;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("管理員登入成功")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("密碼錯誤")));
        Navigator.pop(context); 
      }
    });
  }

  Future<void> _fetchOrders({required bool onlyToday}) async {
    setState(() {
      _isLoading = true;
      _displayTitle = onlyToday ? "今日所有訂單" : "歷史總訂單";
      _searchResults.clear();
    });

    try {
      final ref = FirebaseDatabase.instance.ref("orders");
      
      final snapshot = await ref.get();

      if (snapshot.exists) {
        List<Map<dynamic, dynamic>> tempResults = [];
        
        final String todayStr = DateFormat('yyyyMMdd').format(DateTime.now());

        for (final child in snapshot.children) {
          if (child.value is Map) {
            Map<dynamic, dynamic> data = child.value as Map<dynamic, dynamic>;
            data['key'] = child.key;
            
            if (onlyToday) {
              String timestamp = data['timestamp'] ?? "";
              if (timestamp.startsWith(todayStr)) {
                tempResults.add(data);
              }
            } else {
              tempResults.add(data);
            }
          }
        }

        tempResults.sort((a, b) => (b['key']).compareTo(a['key']));

        setState(() {
          _searchResults = tempResults;
        });
      } else {
        setState(() {
          _searchResults = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("目前資料庫無任何記錄")));
      }
    } catch (e) {
      print("Query Error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("管理員後台")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!_isLoggedIn) ...[
              TextField(
                controller: _pwdController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "管理員密碼",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _checkLogin,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  child: const Text("驗證身分", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],

            if (_isLoggedIn) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.today),
                      label: const Text("今日全部訂單"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      onPressed: () => _fetchOrders(onlyToday: true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.history),
                      label: const Text("歷史所有紀錄"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                      onPressed: () => _fetchOrders(onlyToday: false),
                    ),
                  ),
                ],
              ),
              const Divider(height: 30, thickness: 2),
            ],

            if (_isLoggedIn)
              Expanded(
                child: Column(
                  children: [
                    if (_displayTitle.isNotEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("$_displayTitle (${_searchResults.length} 筆)",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _searchResults.isEmpty
                              ? const Center(child: Text("無資料"))
                              : ListView.builder(
                                  itemCount: _searchResults.length,
                                  itemBuilder: (context, index) {
                                    final item = _searchResults[index];
                                    return Card(
                                      color: Colors.grey[100],
                                      margin: const EdgeInsets.symmetric(vertical: 5),
                                      child: ListTile(
                                        title: Text("${item['items']} (\$${item['totalPrice']})", 
                                            style: const TextStyle(fontWeight: FontWeight.bold)),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("客戶: ${item['name']} (${item['phone']})"),
                                            Text("時間: ${item['timestamp']}"),
                                          ],
                                        ),
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.redAccent,
                                          child: Text((_searchResults.length - index).toString(), style: const TextStyle(color: Colors.white)),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}