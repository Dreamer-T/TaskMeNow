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
  bool _isModified = false; // 用于检测是否有修改
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
            _isModified = true; // 多选框被修改
          });
        },
      ),
      CheckboxListTile(
        title: Text('Manager'),
        value: _checkboxValues[1],
        onChanged: (bool? value) {
          setState(() {
            _checkboxValues[1] = value ?? false;
            _isModified = true;
          });
        },
      ),
      CheckboxListTile(
        title: Text('Painter'),
        value: _checkboxValues[2],
        onChanged: (bool? value) {
          setState(() {
            _checkboxValues[2] = value ?? false;
            _isModified = true;
          });
        },
      ),
      CheckboxListTile(
        title: Text('Plummer'),
        value: _checkboxValues[3],
        onChanged: (bool? value) {
          setState(() {
            _checkboxValues[3] = value ?? false;
            _isModified = true;
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
            _onWillPop(); // 检测用户是否即将放弃修改
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
                    _isModified = true; // 任务描述被修改
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
                      _onWillPop(); // 放弃修改，检测是否有修改
                    },
                    child: Text('Discard'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // 保存任务逻辑
                      setState(() {
                        _isModified = false; // 保存后，修改标志重置
                      });

                      Navigator.pop(context, NewTask()); // 返回上一页面
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
                      _isModified = true; // 图片被修改
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
                      _isModified = true; // 图片被修改
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
  void _onWillPop() {
    if (_isModified) {
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
    } else {
      Navigator.of(context).pop(); // 没有修改时直接返回
    }
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
    final task = widget.task; // 假设 task 是 Task 类型

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
        title: Text("#${task.id}"),
        centerTitle: true,
      ),
      body: Column(children: [
        Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.all(15),
          child: Text(
            task.description,
            style: TextStyle(fontSize: 20),
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.all(15),
          child: Text(
            task.time.toString(),
            style: TextStyle(fontSize: 20),
          ),
        ),
      ]),
    );
  }
}
