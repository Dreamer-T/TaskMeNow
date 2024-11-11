import 'package:flutter/material.dart';

/// 定义成员类
class Member {
  final int id;
  final String name;
  final String role;

  Member({required this.id, required this.name, this.role = 'Staff'});
}

/// Manager Screen which allows manager to modify group members
class ManagerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {
  // 当前选中的页面索引
  int _currentIndex = 0;

  // 成员列表
  List<Member> _members = [];

  // Page list with styles
  List<Widget> get _pages {
    return [
      _buildMemberPage(), // 成员页面
      _buildGroupPage(),
      Center(
          child: Text('Ongoing Task Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
      Center(
          child: Text('Completed Task Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
    ];
  }

  // Member 页面构建
  Widget _buildMemberPage() {
    return Scaffold(
      body: Container(
        color: Colors.deepPurple[50],
        child: ListView.builder(
          itemCount: _members.length,
          itemBuilder: (context, index) {
            final member = _members[index];
            return ListTile(
              leading: Icon(Icons.person),
              title: Text('${member.name} (ID: ${member.id})'),
              subtitle: Text('Group: ${member.role}'),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Function unfinish'),
                  content: Text('I want to add a member!!!'),
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildGroupPage() {
    return Scaffold(
      body: Container(
        color: Colors.deepPurple[50],
        // child: ListView.builder(
        //   itemCount: _members.length,
        //   itemBuilder: (context, index) {
        //     final member = _members[index];
        //     return ListTile(
        //       leading: Icon(Icons.person),
        //       title: Text('${member.name} (ID: ${member.id})'),
        //       subtitle: Text('Group: ${member.role}'),
        //     );
        // },
        // ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Function unfinish'),
                  content: Text('I want to modify a group!!!'),
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> _arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String avatarUrl = _arguments['avatar']; // 替换为实际的头像URL
    final String name = _arguments['userName'];
    final String email = _arguments['email'];
    // final String group = arguments['ID'];
    final String role = _arguments['role'];
    // final DateTime createdAt = arguments['createdTime']; // 用户创建时间
    print("头像地址为" +
        _arguments['avatar'] +
        ";名字是：" +
        name +
        ";邮箱是：" +
        email +
        ";角色是：" +
        role);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            GestureDetector(
              onTap: () {
                // 在这里处理头像点击事件
                // 比如导航到用户个人信息页面
                Navigator.pushNamed(
                  context,
                  "/profile",
                  arguments: _arguments,
                );
              },
              child: CircleAvatar(
                radius: 20, // 调整头像大小
                backgroundImage:
                    NetworkImage(avatarUrl), // 替换为用户头像的URL或AssetImage
              ),
            ),
          ],
        ),
        centerTitle: true, // 标题居中
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Member',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: 'Group',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Ongoing Task',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done),
            label: 'Completed Task',
          ),
        ],
      ),
    );
  }
}
