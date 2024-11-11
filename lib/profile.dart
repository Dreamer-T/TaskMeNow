import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // 示例用户数据
  late String avatarUrl;
  late String name = '用户姓名';
  late String email = '用户邮箱';
  late String group = '所属Group';
  late String role = '用户角色';
  late DateTime createdAt = DateTime.now(); // 用户创建时间

  // 选择图片
  File? _image;

  // 使用 ImagePicker 选择本地图片
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    avatarUrl = arguments['avatar'];
    name = arguments['userName'];
    email = arguments['email'];
    role = arguments['role'];

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
          GestureDetector(
            onTap: () => {_pickImage(arguments)}, // 点击头像时选择图片
            child: CircleAvatar(
              radius: 60, // 基础头像大小
              backgroundImage: _image != null
                  ? FileImage(_image!)
                      as ImageProvider<Object>? // 强制转换为 ImageProvider<Object>
                  : NetworkImage(avatarUrl)
                      as ImageProvider<Object>?, // 否则显示默认头像
            ),
          ),
          Center(
            child: SingleChildScrollView(
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
                  ElevatedButton(
                    onPressed: () {
                      // 退出登陆
                      _logout();
                    },
                    child: Text('Log out'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(Map<String, dynamic> arguments) async {
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
                    File? croppedFile = await _cropImage(pickedFile.path);
                    if (croppedFile != null) {
                      setState(() {
                        _image = croppedFile;
                      });
                      await _uploadImageToServer(_image!, arguments);
                    }
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
                    File? croppedFile = await _cropImage(pickedFile.path);
                    if (croppedFile != null) {
                      setState(() {
                        _image = croppedFile;
                      });
                      await _uploadImageToServer(_image!, arguments);
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<File?> _cropImage(String imagePath) async {
    // 使用 ImageCropper 裁剪图片
    CroppedFile? croppedFile = await ImageCropper()
        .cropImage(sourcePath: imagePath, aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9,
    ], uiSettings: [
      AndroidUiSettings(
        toolbarColor: const Color(0xFF8A44BB),
        statusBarColor: const Color(0xFF8A44BB),
        toolbarWidgetColor: Colors.white,
        activeControlsWidgetColor: const Color(0xFF8A44BB),
        dimmedLayerColor: Colors.black.withOpacity(0.5),
        cropFrameColor: Colors.white,
        cropGridColor: Colors.grey,
        cropFrameStrokeWidth: 3,
        cropGridRowCount: 2,
        cropGridColumnCount: 2,
        cropGridStrokeWidth: 1,
        showCropGrid: true,
        lockAspectRatio: false,
        hideBottomControls: false,
        initAspectRatio: CropAspectRatioPreset.square,
      )
    ]);

    if (croppedFile != null) {
      // 获取应用的文档目录路径
      final directory = await getApplicationDocumentsDirectory();
      String fileName =
          'cropped_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final localPath = '${directory.path}/$fileName';

      // 将裁剪后的图片保存到本地
      File croppedImage = File(croppedFile.path);
      File localImage = await croppedImage.copy(localPath);

      print("裁剪后的图片保存到本地: $localPath");

      return localImage;
    } else {
      print("裁剪失败");
      return null;
    }
  }

  Future<void> _uploadImageToServer(
      File imageFile, Map<String, dynamic> arguments) async {
    final Uri uploadUrl = Uri.parse(
        'https://taskmenow-backend-678769546650.us-central1.run.app/images/uploadAvatar');

    // Create a multipart request to send the file to the server
    var request = http.MultipartRequest('POST', uploadUrl);
    // Add the Authorization header with the token
    request.headers['Authorization'] =
        'Bearer ' + arguments['token']; // Add token to the header

    // Attach the image to the request as a 'file' field
    request.files.add(await http.MultipartFile.fromPath(
      'Avatar', // The field name expected by the server (from your API code)
      imageFile.path,
      contentType: MediaType('image',
          'jpeg'), // Adjust the contentType based on the file format (e.g., 'image/png' for PNG)
    ));

    // Send the request
    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        // Capture the response body
        final responseBody = await response.stream.bytesToString();

        // Decode the response JSON
        final Map<String, dynamic> responseJson = jsonDecode(responseBody);

        // Check if 'message' field exists in the response
        if (responseJson.containsKey('message')) {
          final String message = responseJson['message'];
          print(
              'Server Message: $message'); // Print the message from the server
        } else {
          print('No message field in response.');
        }
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // 清除所有本地存储的数据
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
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
