import 'package:flutter/material.dart';
import 'admin.dart';

void main() {
  runApp(GroupToDo());
}

/// 应用的root，不可变
class GroupToDo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// 没懂为啥是 MaterialApp
    return MaterialApp(
      title: 'Flutter Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      /// 设置主界面
      home: LoginScreen(),
      routes: {
        '/home': (BuildContext context) => LoginScreen(),
        '/home/admin': (BuildContext context) => AdminScreen(),
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

  void _login() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    // Perform login logic here
    print('Username: $username');
    print('Password: $password');
    Navigator.pushNamed(context, "/home/admin");
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
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Password',
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
