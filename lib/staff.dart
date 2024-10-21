import 'package:flutter/material.dart';
import 'package:grouptodo/task.dart';

enum AuthorityGroup { cleaning, manager, painter, plumber }

int ID = 1;

/// 定义成员类
class Task {
  final int id;
  final String? description;
  final Image? image;
  final List<AuthorityGroup> groupAuthority;
  final DateTime time;

  // 使用默认的图片
  Task({
    required this.id,
    this.description,
    required this.groupAuthority,
    required this.time,
    this.image,
  });
  @override
  String toString() {
    return "id: $id description: $description image: ${image!}";
  }
}

class StaffScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  // 当前选中的页面索引
  int _currentIndex = 0;

  final Map<int, GlobalKey> _itemKeys = {};
  // 成员列表
  List<Task> _tasks = [];
  late Task _taskResult;
  Future<void> _navigateToTaskScreen() async {
    // 等待 TaskScreen 返回的结果
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskCreateScreen()),
    );
    // 检查是否返回了数据
    if (result != null) {
      setState(() {
        _taskResult = result;
        print(result);
        _tasks.add(_taskResult);
      });
    }
  }

  // Page list with styles
  List<Widget> get _pages {
    return [
      _buildTaskListPage(), // Task List 页面
      _buildArchiveListPage(), // Archive List 页面
    ];
  }

  // Task 页面构建
  Widget _buildTaskListPage() {
    return Scaffold(
      body: Container(
        color: Color(0x103237E4),
        child: ReorderableListView.builder(
          itemCount: _tasks.length,
          padding: EdgeInsets.symmetric(vertical: 8.0), // 设置整体的 padding
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              final Task movedTask = _tasks.removeAt(oldIndex);
              _tasks.insert(newIndex, movedTask);
            });
          },

          // 避免白底
          proxyDecorator:
              (Widget child, int index, Animation<double> animation) {
            return child;
          },
          itemBuilder: (context, index) {
            final task = _tasks[index];
            // 为每个任务创建一个 GlobalKey
            _itemKeys[task.id] = GlobalKey();
            print(_itemKeys[task.id]);
            return Container(
              key: ValueKey(task.id), // 为 ReorderableListView 提供唯一 key
              margin: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 4.0), // 设置项目之间的间隔
              child: Material(
                color: Colors.transparent,
                elevation: 4.0, // 设置阴影的高度
                shadowColor: Colors.deepPurple,
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.white, // 设置为统一的背景色
                  ), // 设置项目之间的间隔,

                  child: InkWell(
                    child: ListTile(
                      leading: Icon(Icons.drag_handle),
                      title: Text('ID: ${task.id}'),
                      subtitle: Text('Specified: ${task.description}'),
                      onTap: () {
                        print(task.time);
                        // _getPosition(task.id); // 获取相对位置
                        Navigator.push(
                            context, _createScaleTransitionPageRoute(task));
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  PageRouteBuilder _createScaleTransitionPageRoute(Task task) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
      return TaskCheckScreen(task: task);
    }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); // Starting point (slide from right)
      const end = Offset.zero; // Ending point (slide to the current position)
      const curve = Curves.easeInOut; // Curve for the animation

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    });
  }

  /// 已经完成的任务界面
  Widget _buildArchiveListPage() {
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
        title: Text('Staff Screen'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      body: _pages[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToTaskScreen,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.deepPurple[50],
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(), // 留出FAB的凹槽
        notchMargin: 6,
        color: Color(0xFFE0DBEE),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.task,
                  color: _currentIndex == 0 ? Colors.deepPurple : null),
              tooltip: "Ongoing Task",
              onPressed: () {
                _onItemTapped(0); // 切换到Task页面
              },
            ),
            // Spacer(),
            IconButton(
              icon: Icon(Icons.archive,
                  color: _currentIndex == 1 ? Colors.deepPurple : null),
              tooltip: "Completed Task",
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
