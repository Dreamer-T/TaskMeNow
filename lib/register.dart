import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserRegisterScreen extends StatefulWidget {
  @override
  _UserRegisterScreenState createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // For company selection
  String? _selectedCompany;
  List<Map<String, dynamic>> _companies = [];

  @override
  void initState() {
    super.initState();
    _fetchCompanies();
  }

  Future<void> _fetchCompanies() async {
    final response = await http.get(Uri.parse(
        'https://taskmenow-backend-678769546650.us-central1.run.app/search_company')); // 替换为你的 API URL

    if (response.statusCode == 200) {
      // 解析 JSON 数据
      List<dynamic> data = json.decode(response.body);

      // 将 JSON 转换为 List<Map<String, dynamic>>
      setState(() {
        _companies = List<Map<String, dynamic>>.from(data.map((company) => {
              'companyname': company['companyname'],
              'logo': company['logo'],
              'uniqueName': company['uniqueName']
              // 添加其他字段
            }));
      });
    } else {
      throw Exception('Failed to load companies');
    }
  }

  // Function to handle registration
  void _register() {
    if (_formKey.currentState!.validate()) {
      // Handle registration logic here
      // You can send the email, username, password, and selected company data to your backend
      print("need to add backend api here");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Email field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Username field
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Password field
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              DropdownButtonFormField<String>(
                value: _selectedCompany,
                decoration: InputDecoration(
                  hintText: 'Select Company (Optional)',
                  border: OutlineInputBorder(),
                ),
                items: _companies.map((company) {
                  return DropdownMenuItem<String>(
                    value: company['uniqueName'], // 使用公司名称作为值
                    child: Row(
                      children: [
                        Image.network(
                          company['logo'], // 使用网络图片
                          width: 24,
                          height: 24,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.error), // 图片加载失败处理
                        ),
                        SizedBox(width: 8.0),
                        Text(company['companyname']), // 显示公司名称
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCompany = value;
                  });
                },
              ),

              SizedBox(height: 16.0),

              // Register button
              ElevatedButton(
                onPressed: _register,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
