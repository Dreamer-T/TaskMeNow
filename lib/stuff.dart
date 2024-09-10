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
      _buildTaskPage(), // Task 页面
      _buildArchivePage(), // Archive 页面
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

  /// 构建新的任务页面
  Widget _buildNewTaskPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Task'),
      ),
      body: Column(),
    );
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 导航到新的任务页面
          Navigator.pushNamed(
            context,
            '/home/stuff/task',
          );
        },
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(), // 留出FAB的凹槽
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.task),
              onPressed: () {
                _onItemTapped(0); // 切换到Task页面
              },
            ),
            IconButton(
              icon: Icon(Icons.archive),
              onPressed: () {
                _onItemTapped(1); // 切换到Archive页面
              },
            ),
          ],
        ),
      ),
    );
  }
}
