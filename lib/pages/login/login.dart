import 'package:flutter/material.dart';
import 'package:hanlei_is_app/main.dart';
import 'package:hanlei_is_app/Local_Storage/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登录'),
      ),
      body: Padding(
        padding: EdgeInsets.all(80.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: '用户名'),
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: '密码'),
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
                onPressed: () async {
                  String Input_username = _usernameController.text;
                  String Input_password = _passwordController.text;
                  String true_password =
                      await LocalStorageManager().getString('password');
                  if (Input_username == 'admin' &&
                      Input_password == true_password) {
                    await LocalStorageManager().setBool('isLoggedIn', true);
                    await LocalStorageManager()
                        .setString('username', Input_username);
                    await LocalStorageManager()
                        .setString('email', '15303100813@163.com');
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MyHomePage()));
                  } else if (Input_username == 'admin' &&
                      Input_password.isEmpty &&
                      true_password == 'null') {
                    await LocalStorageManager().setBool('isLoggedIn', true);
                    await LocalStorageManager()
                        .setString('username', Input_username);
                    await LocalStorageManager()
                        .setString('email', '15303100813@163.com');
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MyHomePage()));
                  }
                },
                child: Text('登陆'))
          ],
        ),
      ),
    );
  }
}
