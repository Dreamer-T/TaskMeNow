import 'package:flutter/material.dart';
import 'admin.dart';
import 'staff.dart';
import 'task.dart';

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
        '/home/admin': (BuildContext context) => AdminScreen(),
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

  void _login() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    // Perform login logic here
    print('Username: $username');
    print('Password: $password');
    if (username == "Admin") {
      Navigator.pushNamed(context, "/home/admin");
    } else if (username == "staff") {
      Navigator.pushNamed(context, "/home/staff");
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Not a member'),
              content: Text('The entered username is not recognized.'),
            );
          });
      _usernameController.text = "";
      _passwordController.text = "";
    }
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
                  hintText: 'Username',
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
