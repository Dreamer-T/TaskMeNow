import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grouptodo/staff.dart';
import 'package:image_picker/image_picker.dart';

/// 任务创建界面
class TaskCreateScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TaskCreateScreenState();
}

class _TaskCreateScreenState extends State<TaskCreateScreen> {
  bool _isDescriptionOrImageEdited = false; // 用于检测任务描述是否有修改
  bool _isCheckboxChosen = false; // 用于检测任务描述是否有修改
  String _taskDescription = '';
  Image? _selectedImage;
  List<bool> _checkboxValues = [false, false, false, false]; // 4个多选框的值
  final ImagePicker _picker = ImagePicker();
  List<CheckboxListTile> get grouplists {
    return [
      // 多选框
      CheckboxListTile(
        title: Text('Cleaning'),
        value: _checkboxValues[0],
        onChanged: (bool? value) {
          setState(() {
            _checkboxValues[0] = value ?? false;
            _isCheckboxChosen = true; // 多选框被修改
          });
        },
      ),
      CheckboxListTile(
        title: Text('Manager'),
        value: _checkboxValues[1],
        onChanged: (bool? value) {
          setState(() {
            _checkboxValues[1] = value ?? false;
            _isCheckboxChosen = true;
          });
        },
      ),
      CheckboxListTile(
        title: Text('Painter'),
        value: _checkboxValues[2],
        onChanged: (bool? value) {
          setState(() {
            _checkboxValues[2] = value ?? false;
            _isCheckboxChosen = true;
          });
        },
      ),
      CheckboxListTile(
        title: Text('Plummer'),
        value: _checkboxValues[3],
        onChanged: (bool? value) {
          setState(() {
            _checkboxValues[3] = value ?? false;
            _isCheckboxChosen = true;
          });
        },
      ),
    ];
  }

  Task NewTask() {
    List<AuthorityGroup> authorityGroup = List.empty(growable: true);
    if (_checkboxValues[0]) {
      authorityGroup.add(AuthorityGroup.cleaning);
    }
    if (_checkboxValues[1]) {
      authorityGroup.add(AuthorityGroup.manager);
    }
    if (_checkboxValues[2]) {
      authorityGroup.add(AuthorityGroup.painter);
    }
    if (_checkboxValues[3]) {
      authorityGroup.add(AuthorityGroup.plumber);
    }

    return Task(
        id: ID++,
        description: _taskDescription,
        groupAuthority: authorityGroup,
        image: _selectedImage,
        time: DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Task'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _onDiscard(); // 检测用户是否即将放弃修改
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 任务描述输入框
              TextField(
                decoration: InputDecoration(labelText: 'Task Description'),
                onChanged: (value) {
                  setState(() {
                    _taskDescription = value;
                    _isDescriptionOrImageEdited = true; // 任务描述被修改
                  });
                },
              ),
              SizedBox(height: 20),

              // 图片选择按钮
              GestureDetector(
                onTap: _selectImage,
                child: _selectedImage ??
                    Container(
                      color: Colors.grey[200],
                      height: 150,
                      width: double.infinity,
                      child: Center(child: Text('Select an Image')),
                    ),
              ),
              SizedBox(height: 20),
              grouplists[0],
              grouplists[1],
              grouplists[2],
              grouplists[3],
              SizedBox(height: 20),

              // 保存和放弃按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _onDiscard(); // 放弃修改，检测是否有修改
                    },
                    child: Text('Discard'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // 保存任务逻辑
                      if (_isDescriptionOrImageEdited & _isCheckboxChosen) {
                        _isDescriptionOrImageEdited = false;
                        _isCheckboxChosen = false;
                        Navigator.pop(context, NewTask()); // 返回上一页面
                      } else {
                        _onUnableSave();
                        // print("Here");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white),
                    child: Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 选择图片的方法
  Future<void> _selectImage() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Select from album'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? pickedFile = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      _selectedImage = Image.file(File(pickedFile.path));
                      _isDescriptionOrImageEdited = true; // 图片被修改
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a photo now'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? pickedFile = await _picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      _selectedImage = Image.file(File(pickedFile.path));
                      _isDescriptionOrImageEdited = true; // 图片被修改
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // 用户点击返回或放弃时的提示
  void _onDiscard() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Unsaved Changes'),
          content: Text(
              'You have unsaved changes. Do you really want to discard them?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
                Navigator.of(context).pop(); // 返回上一页面
              },
              child: Text('Discard'),
            ),
          ],
        );
      },
    );
  }

  /// 没有达到保存标准：1. 有描述或者有图片 2.没有选择任务负责组
  void _onUnableSave() {
    print(_isDescriptionOrImageEdited);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Unable to Save'),
          content: !_isDescriptionOrImageEdited & !_isCheckboxChosen
              ? Text(
                  'Try to describe the situation or upload an image\nMust refer to a group to be responsible for the task.')
              : _isDescriptionOrImageEdited & !_isCheckboxChosen
                  ? Text(
                      'Must refer to a group to be responsible for the task.')
                  : !_isDescriptionOrImageEdited & _isCheckboxChosen
                      ? Text(
                          'Try to describe the situation or upload an image.')
                      : null,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
              },
              child: Text('Got it'),
            )
          ],
        );
      },
    );
  }
}

/// 任务查看界面
class TaskCheckScreen extends StatefulWidget {
  final Task task;
  TaskCheckScreen({required this.task});
  @override
  State<StatefulWidget> createState() => _TaskCheckScreenState();
}

class _TaskCheckScreenState extends State<TaskCheckScreen> {
  @override
  Widget build(BuildContext context) {
    var task = widget.task;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0), // AppBar 的高度
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor, // AppBar 的背景色
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // 阴影颜色
                blurRadius: 10, // 模糊半径
                offset: Offset(0, 2), // 阴影偏移
              ),
            ],
          ),
          child: AppBar(
            title: Text('#${task.id}'),
            centerTitle: true,
            elevation: 0, // 去掉默认的阴影
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 任务时间
            Text(
              'Created on: ${task.time.toString().split('.')[0]}', // 显示日期部分
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            if (task.description != null) _buildDescription(task),
            if (task.image != null) _buildImage(task),
          ],
        ),
      ),
    );
  }

// 构建描述显示
  Widget _buildDescription(Task task) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // 气泡背景颜色
          borderRadius: BorderRadius.circular(16), // 圆角
          // border: Border.all(color: Colors.blue), // 设置边框颜色
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: TextFormField(
          initialValue: task.description!, // 显示任务描述
          enabled: false, // 禁止编辑
          maxLines: null, // 自动换行显示长文本
          decoration: InputDecoration(
            labelText: 'Description', // 左上角的标签
            labelStyle: TextStyle(
              fontSize: 14,
              color: Color(0xFF8A44BB), // 标签颜色
            ),
            filled: true, // 背景填充
            fillColor: Colors.white24, // 设置填充颜色
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16), // 圆角边框
              borderSide: BorderSide(
                color: Color(0xFF8A44BB), // 边框颜色
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Color(0xFF8A44BB), // 禁用状态下的边框颜色
              ),
            ),
            contentPadding: EdgeInsets.all(12), // 内边距
          ),
          style: TextStyle(fontSize: 16, color: Colors.black87), // 文本样式
        ),
      ),
    );
  }

  // 构建图片显示
  Widget _buildImage(Task task) {
    return Center(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: task.image ??
              Container(
                color: Colors.grey[200], // 没有图片时显示的占位符颜色
                child: Center(
                  child: Text(
                    'No Image Available', // 没有图片时显示的文本
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
