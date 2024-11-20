import 'package:flutter/material.dart';
import 'package:my_app/main.dart';
import 'package:my_app/Local_Storage/shared_preferences.dart';

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
                  String inputUsername = _usernameController.text;
                  String inputPassword = _passwordController.text;
                  String truePassword =
                      await LocalStorageManager().getString('password');
                  if (inputUsername == 'admin' &&
                      inputPassword == truePassword) {
                    await LocalStorageManager().setBool('isLoggedIn', true);
                    await LocalStorageManager()
                        .setString('username', inputUsername);
                    await LocalStorageManager()
                        .setString('email', '15303100813@163.com');
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MyHomePage()));
                  } else if (inputUsername == 'admin' &&
                      inputPassword.isEmpty &&
                      truePassword == 'null') {
                    await LocalStorageManager().setBool('isLoggedIn', true);
                    await LocalStorageManager()
                        .setString('username', inputUsername);
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
