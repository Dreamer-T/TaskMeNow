import 'package:flutter/material.dart';

/// 定义成员类
class Member {
  final int id;
  final String name;
  final String role;

  Member({required this.id, required this.name, this.role = 'staff'});
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
