import 'package:flutter/material.dart';
import 'manager.dart';
import 'supervisor.dart';
import 'staff.dart';
import 'task.dart';
import 'dart:convert';
import 'register.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(GroupToDo());
}

/// 应用的root，不可变
class GroupToDo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login Demo',

      /// 设置主界面
      initialRoute: '/home',
      routes: {
        '/home': (BuildContext context) => LoginScreen(),
        '/home/manager': (BuildContext context) => ManagerScreen(),
        '/home/register/user': (BuildContext context) => UserRegisterScreen(),
        '/home/supervisor': (BuildContext context) => SupervisorScreen(),
        '/home/staff': (BuildContext context) => StaffScreen(),
        '/home/staff/taskCreate': (BuildContext context) => TaskCreateScreen(),
        '/home/staff/taskCheck': (BuildContext context) => TaskCheckScreen(
            task: ModalRoute.of(context)!.settings.arguments as Task),
      },
    );
  }
}

/// 第一个界面：登录界面，可变
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    // API URL for login authentication
    final url = Uri.parse(
        'https://taskmenow-backend-678769546650.us-central1.run.app/login');

    // Prepare the request payload
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': username,
        'password': password,
      }),
    );

    // print("看这里" + response.body);
    if (!mounted) {
      return; // Ensure widget is still mounted before accessing context
    }

    // Check the API response
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      print(result['user']['role']);
      if (result['user']['role'] == 'Manager') {
        Navigator.pushNamed(context, "/home/manager");
      } else if (result['user']['role'] == 'Supervisor') {
        Navigator.pushNamed(context, "/home/supervisor");
      } else if (result['user']['role'] == 'Staff') {
        Navigator.pushNamed(context, "/home/staff");
      }
    } else {
      // Handle server or API errors
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Login Failed.'),
            );
          });
    }
  }

  void _register() {
    Navigator.pushNamed(context, "/home/register/user");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Login')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
