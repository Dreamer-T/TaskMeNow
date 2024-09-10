import 'package:flutter/material.dart';

/// 定义成员类
class Task {
  final int id;
  final String description;
  final Image role;

  // 使用默认的图片
  Task({
    required this.id,
    required this.description,
    this.role =
        const Image(image: AssetImage('assets/default_role.png')), // 这里提供一个默认图片
  });
}

/// Admin Screen which allows admin to modify group members
class StuffScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StuffScreenState();
}

class _StuffScreenState extends State<StuffScreen> {
  // 当前选中的页面索引
  int _currentIndex = 0;

  // 成员列表
  List<Task> _members = [];

  // Page list with styles
  List<Widget> get _pages {
    return [
      _buildTaskPage(), // 成员页面
      _buildNewTaskPage(),
      Center(
          child: Text('Completed Task Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
      _buildArchivePage(),
    ];
  }

  // Task 页面构建
  Widget _buildTaskPage() {
    return Scaffold(
      body: Container(
        color: Color(0x103237E4),
        child: ListView.builder(
          itemCount: _members.length,
          itemBuilder: (context, index) {
            final member = _members[index];
            return ListTile(
              leading: Icon(Icons.person),
              title: Text('${member.description} (ID: ${member.id})'),
              subtitle: Text('Group: ${member.role}'),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNewTaskPage() {
    return Scaffold(
        appBar: AppBar(
      title: Center(child: Text('Login')),
    ));
  }

  /// 已经完成的任务界面
  Widget _buildArchivePage() {
    return Center(
        child: Text('Completed Task Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)));
  }

  /// 换内嵌子界面
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stuff Screen'),
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
            icon: Icon(Icons.task),
            label: 'Task',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Ongoing Task',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive),
            label: 'Archive',
          ),
        ],
      ),
    );
  }
}
