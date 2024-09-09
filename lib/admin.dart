import 'package:flutter/material.dart';
import 'dart:math'; // 用于生成随机 ID

/// 定义成员类
class Member {
  final int id;
  final String name;
  final String role;

  Member({required this.id, required this.name, this.role = 'stuff'});
}

/// Admin Screen which allows admin to modify group members
class AdminScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  // 当前选中的页面索引
  int _currentIndex = 0;

  // 成员列表
  List<Member> _members = [];

  // Page list with styles
  List<Widget> get _pages {
    return [
      _buildMemberPage(), // 成员页面
      Center(
          child: Text('Ongoing Task Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
      Center(
          child: Text('Completed Task Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
    ];
  }

  // 添加成员
  void _addMember(String name, String role) {
    setState(() {
      // 生成随机ID
      int id = Random().nextInt(10000);
      _members.add(Member(id: id, name: name, role: role));
    });
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
          _showAddMemberDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // 弹出对话框用于输入名字和选择权限
  void _showAddMemberDialog() {
    final TextEditingController _nameController = TextEditingController();
    String _selectedRole = 'stuff';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Member'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Enter Name'),
              ),
              DropdownButton<String>(
                value: _selectedRole,
                items: <String>['stuff', 'admin'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRole = newValue!;
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  _addMember(_nameController.text, _selectedRole);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Screen'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Member',
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
