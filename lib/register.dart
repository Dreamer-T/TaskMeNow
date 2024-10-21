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

  // For company selection
  String _role = "Staff";

  @override
  void initState() {
    super.initState();
  }

  // Function to handle registration
  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      // Handle registration logic here
      // You can send the email, username, password, and selected company data to your backend
      print("need to add backend api here");
      final String email = _emailController.text;
      final String username = _usernameController.text;
      const String password = "12345678";
      final String role = _role; // 可选的公司字段

      // 构建 API 请求
      const String apiUrl =
          'https://taskmenow-backend-678769546650.us-central1.run.app/register_user'; // 替换为您的后端 API 地址
      final Map<String, dynamic> data = {
        'email': email,
        'userName': username,
        'password': password,
        'userRole': role,
      };
      try {
        // 发送 POST 请求
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data),
        );

        // 检查响应状态码
        if (response.statusCode == 201) {
          // 注册成功，处理响应数据
          final responseBody = jsonDecode(response.body);
          print('Registration successful: ${responseBody['message']}');
          // 在此处处理成功的逻辑（比如导航到登录页面或显示提示）
        } else {
          // 注册失败，处理错误
          final errorBody = jsonDecode(response.body);
          print('Registration failed: ${errorBody['error']}');
          // 在此处处理失败的逻辑（比如显示错误提示）
        }
      } catch (error) {
        // 捕获网络或其他错误
        print('Error during registration: $error');
        // 在此处处理错误
      }
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

              DropdownButtonFormField<String>(
                value: _role,
                decoration: InputDecoration(
                  hintText: 'Select Role',
                  border: OutlineInputBorder(),
                ),
                items: ['Manager', 'Supervisor', 'Staff'].map((role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role), // 显示角色名称
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _role = value!; // 更新选中的角色
                  });
                },
              ),

              SizedBox(height: 16.0),

              // Register button
              ElevatedButton(
                onPressed: _registerUser,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
