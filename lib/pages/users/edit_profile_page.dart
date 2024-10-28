// lib/page/edit_profile_page.dart
import 'package:flutter/material.dart';
import 'package:hanlei_is_app/Local_Storage/shared_preferences.dart';
import 'package:hanlei_is_app/pages/login/login.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = '韩磊';
    _emailController.text = '153@163.com';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('编辑个人信息'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: '用户名'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: '邮箱'),
            ),
            TextField(
              controller: _passController,
              obscureText: true,
              decoration: InputDecoration(labelText: '密码'),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  String username = _nameController.text;
                  String email = _emailController.text;
                  String password = _passController.text;
                  await LocalStorageManager().setString('username', username);
                  await LocalStorageManager().setString('email', email);
                  if (password.isEmpty) {
                    Navigator.pop(context);
                  } else {
                    await LocalStorageManager().setString('password', password);
                    await LocalStorageManager().setBool('isFirstLogin', true);
                    await LocalStorageManager().setBool('isLoggedIn', false);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  }
                },
                child: Text('保存'))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
