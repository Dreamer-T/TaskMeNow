import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // 示例用户数据
  String avatarUrl =
      'https://storage.googleapis.com/tmn_company_logo_images/%E7%99%BD%E9%87%912.jpg'; // 替换为实际的头像URL
  final String name = '用户姓名';
  final String email = '用户邮箱';
  final String group = '所属Group';
  final String role = '用户角色';
  final DateTime createdAt = DateTime.now(); // 用户创建时间
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    avatarUrl = arguments['avatar'];
    print("object:" + avatarUrl);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Screen'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(10)),
          // 可缩放的用户头像
          CircleAvatar(
            radius: 60, // 基础头像大小
            backgroundImage: NetworkImage(avatarUrl), // 替换为实际的头像URL
          ),
          Center(
            child: SingleChildScrollView(
              // 允许内容滚动
              child: Column(
                children: [
                  SizedBox(height: 20), // 添加间距

                  // 用户信息
                  Text(
                    name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(email, style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Group: $group', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Role: $role', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text(
                      'Created at: ${createdAt.toLocal().toString().split(' ')[0]}',
                      style: TextStyle(fontSize: 16)), // 格式化日期

                  SizedBox(height: 20), // 添加间距

                  // 修改密码按钮
                  ElevatedButton(
                    onPressed: () {
                      // 处理修改密码逻辑
                      _showChangePasswordDialog(context);
                    },
                    child: Text('Change Password'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'New Password'),
                obscureText: true,
              ),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // 处理修改密码逻辑
                if (passwordController.text == confirmPasswordController.text) {
                  // 进行密码修改
                  // 例如，调用API修改密码
                  Navigator.of(context).pop(); // 关闭对话框
                } else {
                  // 显示错误信息
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Passwords do not match.')),
                  );
                }
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
